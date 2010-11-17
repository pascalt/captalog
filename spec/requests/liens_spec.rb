# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Liens" do
  before(:each) do
    @titre_de_base = "Captalog"
  end
  
  describe "GET 'menu'" do
    it "devrait réussir" do
      get 'menu'
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get 'menu'
      response.should have_selector("title", :content => @titre_de_base + " | Menu")
    end
  end
  describe "GET /villages" do
    it "devrait réussir" do
      get 'villages'
      response.should be_success
    end
  end
  it "devrait avoir le bon titre" do
    get 'villages'
    response.should have_selector("title", :content => @titre_de_base + " | Villages Cap France")
  end
  
 
end
