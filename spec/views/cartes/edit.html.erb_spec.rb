# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "cartes/edit.html.erb" do
  before(:each) do
    @carte = assign(:carte, stub_model(Carte,
      :new_record? => false,
      :nom => "MyString",
      :info => "MyString",
      :village_id => 1,
      :url_originale => "MyString"
    ))
  end

  it "renders the edit carte form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => carte_path(@carte), :method => "post" do
      assert_select "input#carte_nom", :name => "carte[nom]"
      assert_select "input#carte_info", :name => "carte[info]"
      assert_select "input#carte_village_id", :name => "carte[village_id]"
      assert_select "input#carte_url_originale", :name => "carte[url_originale]"
    end
  end
end
