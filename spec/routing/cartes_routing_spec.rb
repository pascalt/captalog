# -*- encoding : utf-8 -*-
require "spec_helper"

describe CartesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/cartes" }.should route_to(:controller => "cartes", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/cartes/1" }.should route_to(:controller => "cartes", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/cartes/1/edit" }.should route_to(:controller => "cartes", :action => "edit", :id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/cartes/1" }.should route_to(:controller => "cartes", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/cartes/1" }.should route_to(:controller => "cartes", :action => "destroy", :id => "1")
    end

  end
end
