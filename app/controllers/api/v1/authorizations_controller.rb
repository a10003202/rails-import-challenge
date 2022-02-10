class Api::V1::AuthorizationsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found_error
  skip_before_action :verify_authenticity_token

  def login
    user = User.authenticate(params[:username], params[:password])
    if user
      oauth_application = Doorkeeper::Application.find(OauthApplication::EVENT_APP_MOVIL)
      access_token = Doorkeeper::AccessToken.create!(
        application_id: oauth_application.id,
        resource_owner_id: user.id,
        scopes: oauth_application.scopes,
        use_refresh_token: false,
        expires_in: nil
      )
      render :json => {:user => user.as_json(:except => [:password, :password_salt]),
                       access_token: access_token.token }, status: :ok
    else
      render json: {
        message: 'No se ha encontrado el usuario o las credenciales son incorrectas'
      }, status: :unauthorized
    end
  end

  def logout
    access_token = Doorkeeper::AccessToken.find_by_token(params[:access_token])
    if access_token.present?
      access_token.destroy
      render json: { message: "Token deleted" }
    else
      render json: { message: "Token not found" }, status: :not_found
    end
  end

  def forgot_password
    email = params[:email]
    user = User.find_by(email: email)
    if user.present? && user.user.present?
      user.user.generate_password_token!
      notification = Notification.new
      notification.send_email_forgot_password(user.user)
      render json: {message: I18n.t('public.forgot_password.email_sent')}, status: :ok
    else
      render json: {message: I18n.t('public.forgot_password.email_not_found')}, status: :not_found
    end

  end

  # Override so API displays 401 status code with message rather than redirect to login screen
  def not_authorized!(*args)
    options = args.extract_options!
    message = options[:message] ||
      I18n.t('action_access.redirection_message', default: 'Not authorized.')
    return render json: {message: message}, status: :unauthorized
  end

  def handle_not_found_error(e)
    message = e.message
    message = I18n.t('activerecord.errors.messages.record_not_found', record: e.model.model_name.human) if e.model.present? && message.blank?
    render json: { message: message }, status: :not_found
  end
end
