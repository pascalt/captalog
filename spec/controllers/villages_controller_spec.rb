# -*- encoding : utf-8 -*-
require 'spec_helper'

describe VillagesController do
  
  render_views
  
  before(:each) do
    @titre_de_base = "Captalog"
  end
  describe "le INDEX" do
    it "devrait réussir index" do
      get 'index'
      response.should be_success
    end
    it "devrait avoir le bon titre pour index" do
      get 'index'
      response.should have_selector("title", :content => @titre_de_base + " | Villages Cap France")
    end
  end
  
  describe "le EDIT'" do
    
    before(:each) do
      @village = Factory(:village)
    end
    
    it "devrait réussir" do
      get :edit, :id => @village
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :edit, :id => @village
      response.should have_selector("title", :content =>  @titre_de_base + " | Editer " + @village.nom)
    end
    
  end
  
  describe "le UPDATE" do
    
    before(:each) do
      @village = Factory(:village)
    end
    
    describe "échoué" do
      
      before(:each) do
        @attr = { :nom_sa => ""}
      end
      
      it "devrait retourner sur la page 'edit'" do
        put :update, :id => @village, :village => @attr
        response.should render_template('edit')
      end
      
      it "devrait avoir le bon titre" do
        put :update, :id => @village, :village => @attr
        response.should have_selector("title", :content =>  @titre_de_base + " | Editer " + @village.nom)
      end
    end
    
    describe "réussi" do
      
      before(:each) do
        @attr = { :nom_sa => "Village Zouzou", :article => "Le", :type_village => "campagne", 
                  :nc => "a", :latitude => "0.12", :longitude => "0.14", :rue => "33bis rue pluf", :ville => "Saint-Charmant",
                  :cp => "30987", :actif => true, :departement_id => 1, :date_entree => "12/07/1998"}
      end
      
      it "devrait changer les attributs du village" do
        put :update, :id => @village, :village => @attr
        @village.reload
        @village.nom_sa.should == @attr[:nom_sa]
        @village.article.should == @attr[:article]
        @village.nc.should ==  @attr[:nc]
        @village.longitude.to_s.should ==  @attr[:longitude]
        @village.latitude.to_s.should ==  @attr[:latitude]
        @village.rue.should ==  @attr[:rue]
        @village.ville.should ==  @attr[:ville]
        @village.cp.should ==  @attr[:cp]
        @village.departement_id.should ==  @attr[:departement_id]
        @village.actif.should ==  @attr[:actif]
        @village.date_entree.strftime('%d/%m/%Y').should ==  @attr[:date_entree]
      end
      
      it "devrait etre redirigé sur le 'show'" do
        put :update, :id => @village, :village => @attr
        response.should redirect_to(village_path(@village))
      end
      
      it "devrais avoir un message flash" do
        put :update, :id => @village, :village => @attr
        flash[:notice].should =~ /modif/
      end
      
    end

  end
  
  describe "le DESTROY" do
    
    before(:each) do
      @village = Factory(:village)
    end
    
    it "décrémenter le compte des village" do
      lambda do
        delete :destroy, :id => @village
      end.should change(Village, :count).by(-1)
    end
    
    it "devrait éliminer le village de la liste" do
      delete :destroy, :id => @village
      Village.find_by_id(@village.id).should be_nil
    end
    
    
    it "devrait rediriger sur la liste des villages" do
      delete :destroy, :id => @village
      response.should redirect_to(villages_path)
    end
    
  end
  
  describe "le DESACTIVE" do
    
    before(:each) do
      @village = Factory(:village)
    end
    
    it "devrait réussir" do
      get :desactive, :id => @village
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :desactive, :id => @village
      response.should have_selector("title", :content =>  @titre_de_base + " | Désactiver " + @village.nom)
    end

        
  end

  describe "le UPDATE_DESACTIVE" do
    
      before(:each) do
        @village = Factory(:village)
      end

      before(:each) do
        @attr = { :actif => false, :date_sortie => "11/09/2010"}
      end

      it "devrait avoir une date de sortie et avoir actif à faux" do
        put :update_desactive, :id => @village, :village => @attr
        @village.reload
        @village.actif.should be_false
        @village.date_sortie.strftime('%d/%m/%Y').should ==  @attr[:date_sortie]
      end

      it "devrait etre redirigé sur le 'show'" do
        put :update_desactive, :id => @village, :village => @attr
        response.should redirect_to(village_path(@village))
      end

      it "devrais avoir un message flash" do
        put :update_desactive, :id => @village, :village => @attr
        flash[:notice].should =~ /désactivé/
      end

  end

  describe "le DESTROY" do

    before(:each) do
      @village = Factory(:village)
    end

    it "décrémenter le compte des village" do
      lambda do
        delete :destroy, :id => @village
      end.should change(Village, :count).by(-1)
    end

    it "devrait éliminer le village de la liste" do
      delete :destroy, :id => @village
      Village.find_by_id(@village.id).should be_nil
    end


    it "devrait rediriger sur la liste des villages" do
      delete :destroy, :id => @village
      response.should redirect_to(villages_path)
    end

  end

  
end
