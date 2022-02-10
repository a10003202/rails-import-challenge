require 'rails_helper'

RSpec.describe "galleries/show", type: :view do
  before(:each) do
    @gallery = assign(:gallery, Gallery.create!(
      name: "Name",
      file: "File",
      image_type: 2,
      order: 3,
      owner: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/File/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(//)
  end
end
