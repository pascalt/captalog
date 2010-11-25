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
  describe "GET 'administration'" do
    it "devrait réussir" do
      get 'admin'
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get 'admin'
      response.should have_selector("title", :content => @titre_de_base + " | Administration")
    end
  end
  
 
end
