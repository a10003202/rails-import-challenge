ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def logged_in?
    !current_user.nil?
  end

  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find_by(id: user_id)
  end
end
