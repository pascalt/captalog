# -*- encoding : utf-8 -*-
require "spec_helper"

describe PhotosController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/photos" }.should route_to(:controller => "photos", :action => "index")
    end
    it "recognizes and generates #index pour un village" do
      { :get => "villages/1/photos" }.should route_to(:controller => "photos", :action => "index", :village_id => "1")
    end
    
    it "recognizes and generates #new pour un village" do
      { :get => "villages/1/photos/new" }.should route_to(:controller => "photos", :action => "new", :village_id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "/photos/1" }.should route_to(:controller => "photos", :action => "show", :id => "1")
    end

    it "recognizes and generates #show pour un village" do
      { :get => "villages/1/photos/1" }.should route_to(:controller => "photos", :action => "show", :id => "1", :village_id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/photos/1/edit" }.should route_to(:controller => "photos", :action => "edit", :id => "1")
    end

    it "recognizes and generates #edit pour un village" do
      { :get => "villages/1/photos/1/edit" }.should route_to(:controller => "photos", :action => "edit", :id => "1", :village_id => "1")
    end

    it "recognizes and generates #create pour un village" do
      { :post => "villages/1/photos" }.should route_to(:controller => "photos", :action => "create", :village_id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/photos/1" }.should route_to(:controller => "photos", :action => "update", :id => "1")
    end

    it "recognizes and generates #update pour un village" do
      { :put => "villages/1/photos/1" }.should route_to(:controller => "photos", :action => "update", :id => "1", :village_id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/photos/1" }.should route_to(:controller => "photos", :action => "destroy", :id => "1")
    end

    it "recognizes and generates #destroy pour un village" do
      { :delete => "villages/1/photos/1" }.should route_to(:controller => "photos", :action => "destroy", :id => "1", :village_id => "1")
    end

  end
end
