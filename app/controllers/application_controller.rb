class ApplicationController < ActionController::Base
  before_action :set_locale
  layout :get_layout

  include SessionsHelper

  private
  def get_layout
    my_class_name = self.class.name
    if my_class_name.index("::").nil?
      layout = "application"
    else
      layout = my_class_name.split("::").first.downcase
    end
    layout
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
