require 'rails_helper'

RSpec.describe "galleries/edit", type: :view do
  before(:each) do
    @gallery = assign(:gallery, Gallery.create!(
      name: "MyString",
      file: "MyString",
      image_type: 1,
      order: 1,
      owner: nil
    ))
  end

  it "renders the edit gallery form" do
    render

    assert_select "form[action=?][method=?]", gallery_path(@gallery), "post" do

      assert_select "input[name=?]", "gallery[name]"

      assert_select "input[name=?]", "gallery[file]"

      assert_select "input[name=?]", "gallery[image_type]"

      assert_select "input[name=?]", "gallery[order]"

      assert_select "input[name=?]", "gallery[owner_id]"
    end
  end
end
