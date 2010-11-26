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
    it "devrait avoir un retour sur le menu" do
      get :index
      response.should have_selector("a", :href => menu_path, :content => "Retour")
    end
    it "ne devrait pas faire apparaitre de village désactivée" do
      @village = Factory(:village)
      @village.actif = false
      @village.date_sortie = Time.now
      @village.save!
      get :index
      response.should_not have_selector("td", :content => @village.nom_sa)
    end
    
  end
  
  describe "le SHOW'" do
    
    before(:each) do
      @village = Factory(:village)
    end
    
    it "devrait réussir" do
      get :show, :id => @village
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :show, :id => @village
      response.should have_selector("title", :content =>  @titre_de_base + " | " + @village.nom)
    end
    
    it "devrait avoir un lien vers la liste de photo" do
      get :show, :id => @village
      response.should have_selector("a", :href => village_photos_path(@village), :content => "Photos")
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
  describe "le NEW" do
    
    it "devrait réussir" do
      get :new
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :new
      response.should have_selector("title", :content =>  @titre_de_base + " | Nouveau village")
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
                  :cp => "30987", :actif => true, :departement_id => 1, :date_entree => "1998-07-12 00:00:00 UTC"}
      end
      
      it "devrait changer les attributs du village" do
        put :update, :id => @village, :village => @attr
        @village.reload
        @attr.keys.each { |cle| @village[cle].to_s.should == @attr[cle].to_s }
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
  describe "le CREATE" do
    
    before(:each) do
      @village = Factory(:village)
    end
    
    describe "échoué" do
      
      before(:each) do
        @attr = { :nom_sa => ""}
      end
      
      it "devrait retourner sur la page 'new'" do
        post :create, :village => @attr
        response.should render_template('new')
      end
      
      it "devrait avoir le bon titre" do
        post :create, :village => @attr
        response.should have_selector("title", :content =>  @titre_de_base + " | Nouveau village")
      end
    end
    
    describe "réussi" do
      
      before(:each) do
        @attr = { :nom_sa => "Village Zouzou", :article => "Le", :type_village => "campagne", 
                  :nc => "a", :latitude => "0.12", :longitude => "0.14", :rue => "33bis rue pluf", :ville => "Saint-Charmant",
                  :cp => "30987", :actif => true, :departement_id => 1, :date_entree => "1998-07-12 00:00:00 UTC"}
      end

      it "devrait avoir les attributs passés" do
        post :create, :village => @attr
        @village = Village.find_by_nom_sa(@attr[:nom_sa])
        @attr.keys.each { |cle| @village[cle].to_s.should == @attr[cle].to_s }
      end
      
      it "devrait etre redirigé sur le 'show'" do
        post :create, :village => @attr
        @village = Village.find_by_nom_sa(@attr[:nom_sa])
        response.should redirect_to(village_path(@village))
      end
      
      it "devrais avoir un message flash" do
        post :create, :village => @attr
        @village = Village.find_by_nom_sa(@attr[:nom_sa])
        flash[:notice].should =~ /créé/
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
    
    it "doit éliminer le village avec ses photos" do
      Photo.create!(:url_originale => "photo1.jpg", :village_id => @village.id)
      Photo.create!(:url_originale => "photo2.jpg", :village_id => @village.id)
      delete :destroy, :id => @village
      Photo.find_by_village_id(@village.id).should be_nil
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

  describe "le INDEXNONACTIVE" do
    
    it "devrait réussir" do
      get :indexnonactif
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get :indexnonactif
      response.should have_selector("title", :content => @titre_de_base + " | Villages désactivés")
    end
    it "devrait avoir un retour vers la liste des villages actifs" do
      get :indexnonactif
      response.should have_selector("a", :href => villages_path, :content => "Retour")
    end
        
  end
  
end
