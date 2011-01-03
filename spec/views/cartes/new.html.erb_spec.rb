# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "cartes/new.html.erb" do
  before(:each) do
    assign(:carte, stub_model(Carte,
      :nom => "MyString",
      :info => "MyString",
      :village_id => 1,
      :url_originale => "MyString"
    ).as_new_record)
  end

  it "renders new carte form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => cartes_path, :method => "post" do
      assert_select "input#carte_nom", :name => "carte[nom]"
      assert_select "input#carte_info", :name => "carte[info]"
      assert_select "input#carte_village_id", :name => "carte[village_id]"
      assert_select "input#carte_url_originale", :name => "carte[url_originale]"
    end
  end
end
