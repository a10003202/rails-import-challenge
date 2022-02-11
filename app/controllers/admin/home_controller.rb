class Admin::HomeController < ApplicationController
  include Admin::HomeHelper
  def index
  end

  def import_purchases
    result = import_purchases_from_excel(params)
    if result[:success]
      render json: result, status: :ok
    else
      render json: result, status: :unprocessable_entity
    end
  end

  def download_import_example

    send_file(
      "#{Rails.root}/app/assets/example.tab.xlsx",
      filename: "example.tab.xlsx"
    )
  end

end
