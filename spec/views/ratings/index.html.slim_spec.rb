require 'rails_helper'

RSpec.describe "ratings/index", type: :view do
  before(:each) do
    assign(:ratings, [
      Rating.create!(
        :value => "9.99"
      ),
      Rating.create!(
        :value => "9.99"
      )
    ])
  end

  it "renders a list of ratings" do
    render
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
