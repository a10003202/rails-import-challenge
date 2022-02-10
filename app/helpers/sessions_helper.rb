module SessionsHelper

  def logged_in?
    !current_user.nil?
  end

  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find_by(id: user_id)
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_home(user)
    if user.has_role? :admin
      redirect_to admin_home_path
    else
      redirect_to login_path
    end
  end
end
