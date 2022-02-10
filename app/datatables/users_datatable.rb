class UsersDatatable
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::OutputSafetyHelper
  delegate :h, :link_to, to: :@view
  attr_reader :params, :options, :model_options

  def initialize(params, options = {})
    @params    = params
    @options = options
    @view = options[:view_context]
    @model_options = options[:model_options]
  end

  def as_json(options = nil)
    {
        draw: params[:draw].to_i,
        recordsTotal: records_total_count,
        recordsFiltered: records_filtered_count,
        data: data
    }
  end

  private

  def data
    records.map do |record|
      data_object = record.as_json(model_options)
      data_object
    end
  end

  def records
    @records ||= retrieve_records
  end

  def retrieve_records
    records = fetch_records
    records = filter_records(records)
    records = sort_records(records)
    records = paginate_records(records) if paginate?
    records
  end

  def fetch_records
    query = User.select("users.*")
    query
  end

  def filter_records(records)
    if params[:search][:value].present?
      records = records.where("users.username LIKE :search OR
                           users.email LIKE :search",{search: "%#{params[:search][:value]}%"})
    end
    records
  end

  def paginate_records(records)
    #records.offset(offset).limit(per_page)
    records.page(page).per_page(per_page) # Wil-paginate
  end

  def sort_records(records)
    records.order("#{sort_column} #{sort_direction}")
  end

  def records_total_count
    fetch_records.count(:all)
  end

  def records_filtered_count
    filter_records(fetch_records).count(:all)
  end

  def paginate?
    per_page != -1
  end

  def page
    page_number = (offset/per_page + 1)
    if params[:page_index].present?
      page_number = params[:page_index].to_i + 1
    end
    if params[:page].present? && params[:page].to_i > 0
      page_number = params[:page].to_i
    end
    page_number
  end

  def offset
    params[:start].to_i
  end

  def per_page
    params.fetch(:length, 10).to_i
  end

  def sort_column
    columns = %w[users.id users.username users.email]
    column = columns[0]
    column_index = params[:order]["0"]["column"]
    if params[:columns].present? &&
      params[:columns][column_index].present? &&
      params[:columns][column_index]["data"].present?
      column_name = params[:columns][column_index]["data"]
      if columns.include? column_name
        column = column_name
      end
    elsif columns[column_index.to_i]
      column = columns[column_index.to_i]
    end
    column
  end

  def sort_direction
    params[:order]["0"]["dir"] == "desc" ? "desc" : "asc"
  end
end
