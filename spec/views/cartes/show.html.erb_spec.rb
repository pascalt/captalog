# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "cartes/show.html.erb" do
  before(:each) do
    @carte = assign(:carte, stub_model(Carte,
      :nom => "Nom",
      :info => "Info",
      :village_id => 1,
      :url_originale => "Url Originale"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Nom/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Info/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Url Originale/)
  end
end
