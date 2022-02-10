require 'rails_helper'

RSpec.describe "galleries/index", type: :view do
  before(:each) do
    assign(:galleries, [
      Gallery.create!(
        name: "Name",
        file: "File",
        image_type: 2,
        order: 3,
        owner: nil
      ),
      Gallery.create!(
        name: "Name",
        file: "File",
        image_type: 2,
        order: 3,
        owner: nil
      )
    ])
  end

  it "renders a list of galleries" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "File".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
