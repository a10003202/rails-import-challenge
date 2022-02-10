class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /admin/users or /admin/users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json {render json: UserDatatable.new(params)}
    end
  end

  # GET /admin/users/1 or /admin/users/1.json
  def show
    respond_to do |format|
      format.html
      format.json {render json: @user.as_json}
    end
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users or /admin/users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render json: {success: true, model: @user}, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/1 or /admin/users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render json: {success: true, model: @user}, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1 or /admin/users/1.json
  def destroy
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to admin_users_url, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to admin_users_url, notice: 'User was not destroyed.' }
        format.json { render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  def search
    respond_to do |format|
      format.html
      format.json {render json: UsersDatatable.new(params, view_context: view_context)}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
