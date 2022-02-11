module Admin::HomeHelper

  def import_purchases_from_excel(params)
    result = {success: false, total_revenue: 0, total_revenue_now: 0, message: ''}
    if params[:file].present?
      begin
        spreadsheet = open_spreadsheet(params[:file])
        Purchase.transaction do
          spreadsheet.sheets.each_with_index do |name_sheet, index_sheet|
            sheet = spreadsheet.sheet(name_sheet)
            header = sheet.row(1)
            (2..sheet.last_row).each_with_index do |i, index|
              row = sheet.row(i)
              row_hash = Hash[[header, row].transpose]
              buyer_name = row[0]
              item_description = row[1]
              item_price = row[2]
              total_items = row[3]
              seller_address = row[4]
              seller_name = row[5]

              buyer = Buyer.find_by(name: buyer_name)
              buyer = Buyer.new if buyer.blank?
              buyer.name = buyer_name
              buyer.save!

              item = Item.find_by(description: item_description)
              item = Item.new if item.blank?
              item.description = item_description
              item.price = item_price
              item.save!

              seller = Seller.find_by(name: seller_name)
              seller = Seller.new if seller.blank?
              seller.name = seller_name
              seller.address = seller_address
              seller.save!

              purchase = Purchase.new
              purchase.buyer = buyer
              purchase.seller = seller
              purchase.item = item
              purchase.total_items = total_items
              purchase.total_price = (purchase.total_items * item.price)
              purchase.save!
              result[:total_revenue] += purchase.total_price
            end
          end
          result[:total_revenue_now] = Purchase.all.sum(:total_price)
        end
        result[:success] = true
      rescue => e
        result[:message] = e.message
      end
    end
    result
  end

  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then
      Roo::Csv.new(file.path, packed: nil, file_warning: :ignore)
    when ".xls" then
      Roo::Excel.new(file.path, packed: nil, file_warning: :ignore)
    when ".xlsx" then
      Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
    else
      raise "Tipo de archivo no reconocido: #{file.original_filename}"
    end
  end
end
