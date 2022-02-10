class Api::V1::UsersController < ApplicationController
  before_action -> { doorkeeper_authorize! :CITIZEN_APP }
  before_action :set_user
  let :all, :all

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  def search
    params[:length] = params[:page_size]
    params[:order] = {"0" => {column: params[:sort_column], dir: params[:sort_direction] }}
    params[:search] = {value: params[:search]}
    params[:filters] = {}
    result = UsersDatatable.new(view_context).as_json
    render json: result, status: :ok
  end
end
