class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      log_in(@user)
      redirect_home(@user)
    else
      flash[:notice] = 'Correo electrónico o contraseña incorrectos'
      redirect_to '/login'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:notice] = nil
    redirect_to login_path
  end
end
