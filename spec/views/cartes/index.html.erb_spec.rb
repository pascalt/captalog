# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "cartes/index.html.erb" do
  before(:each) do
    assign(:cartes, [
      stub_model(Carte,
        :nom => "Nom",
        :info => "Info",
        :village_id => 1,
        :url_originale => "Url Originale"
      ),
      stub_model(Carte,
        :nom => "Nom",
        :info => "Info",
        :village_id => 1,
        :url_originale => "Url Originale"
      )
    ])
  end

  it "renders a list of cartes" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Nom".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Info".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url Originale".to_s, :count => 2
  end
end
