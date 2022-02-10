require 'rails_helper'

RSpec.describe "admin/users/edit", type: :view do
  before(:each) do
    @user = assign(:user, Admin::User.create!())
  end

  it "renders the edit admin_user form" do
    render

    assert_select "form[action=?][method=?]", admin_user_path(@user), "post" do
    end
  end
end
