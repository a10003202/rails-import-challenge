require 'rails_helper'

RSpec.describe "galleries/new", type: :view do
  before(:each) do
    assign(:gallery, Gallery.new(
      name: "MyString",
      file: "MyString",
      image_type: 1,
      order: 1,
      owner: nil
    ))
  end

  it "renders new gallery form" do
    render

    assert_select "form[action=?][method=?]", galleries_path, "post" do

      assert_select "input[name=?]", "gallery[name]"

      assert_select "input[name=?]", "gallery[file]"

      assert_select "input[name=?]", "gallery[image_type]"

      assert_select "input[name=?]", "gallery[order]"

      assert_select "input[name=?]", "gallery[owner_id]"
    end
  end
end
