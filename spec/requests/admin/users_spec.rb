 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/admin/users", type: :request do
  # Admin::User. As you add validations to Admin::User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Admin::User.create! valid_attributes
      get admin_users_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      user = Admin::User.create! valid_attributes
      get admin_user_url(admin_user)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_admin_user_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      user = Admin::User.create! valid_attributes
      get edit_admin_user_url(admin_user)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Admin::User" do
        expect {
          post admin_users_url, params: { user: valid_attributes }
        }.to change(Admin::User, :count).by(1)
      end

      it "redirects to the created admin_user" do
        post admin_users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(admin_user_url(@user))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Admin::User" do
        expect {
          post admin_users_url, params: { user: invalid_attributes }
        }.to change(Admin::User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post admin_users_url, params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested admin_user" do
        user = Admin::User.create! valid_attributes
        patch admin_user_url(admin_user), params: { user: new_attributes }
        user.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the admin_user" do
        user = Admin::User.create! valid_attributes
        patch admin_user_url(admin_user), params: { user: new_attributes }
        user.reload
        expect(response).to redirect_to(admin_user_url(user))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        user = Admin::User.create! valid_attributes
        patch admin_user_url(admin_user), params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested admin_user" do
      user = Admin::User.create! valid_attributes
      expect {
        delete admin_user_url(admin_user)
      }.to change(Admin::User, :count).by(-1)
    end

    it "redirects to the admin_users list" do
      user = Admin::User.create! valid_attributes
      delete admin_user_url(admin_user)
      expect(response).to redirect_to(admin_users_url)
    end
  end
end
