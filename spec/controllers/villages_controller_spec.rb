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
    it "devrait avoir un lien sur le menu" do
      get :index
      response.should have_selector("a", :href => menu_path, :content => "Menu")
    end
    it "ne devrait pas faire apparaitre de village désactivée" do
      @village = Factory(:village)
      @village.actif = false
      @village.date_sortie = Time.now
      @village.save!
      get :index
      response.should_not have_selector("td", :content => @village.nom_sa)
    end
    it "s'il existe au moins un village non actif, alors doit avoir un lien vers la liste des villages désactivés" do
      @village = Factory(:village)
      @village.actif = false
      @village.date_sortie = Time.now
      @village.save!
      get :index
      response.should have_selector("a", :href => index_non_actifs_villages_path, :content => "Villages désactivés")
    end
    it "s'il n'existe pas de village non actif, alors ne doit pas avoir un lien vers la liste des villages désactivés" do
      @village = Factory(:village)
      get :index
      response.should_not have_selector("a", :href => index_non_actifs_villages_path, :content => "Villages désactivés")
    end
    
  end
  
  describe "le INDEX_NON_ACTIFS" do
    
    it "devrait réussir" do
      get :index_non_actifs
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get :index_non_actifs
      response.should have_selector("title", :content => @titre_de_base + " | Villages désactivés")
    end
    it "devrait avoir un retour vers la liste des villages actifs" do
      @village = Factory(:village) #il existe au moins un village actif
      get :index_non_actifs
      response.should have_selector("a", :href => villages_path, :content => "actifs")
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
                  :nc => "villagezouzou", :latitude => "0.12", :longitude => "0.14", :rue => "33bis rue pluf", :ville => "Saint-Charmant",
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
        FileUtils.remove_dir(DIR_VILLAGES)
        FileUtils.remove_dir(DIR_SUPPR)
        Dir.mkdir(DIR_VILLAGES)
        @attr = { :nom_sa => "Village Zouzou", :article => "Le", :type_village => "campagne", 
                  :nc => "villagezouzou", :latitude => "0.12", :longitude => "0.14", :rue => "33bis rue pluf", :ville => "Saint-Charmant",
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
    
    it "doit éliminer le répertoire du village avec ses photos" do
      FileUtils.remove_dir(DIR_VILLAGES)
      FileUtils.remove_dir(DIR_SUPPR)      
      Dir.mkdir(DIR_VILLAGES)
      FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", "#{DIR_VILLAGES}/Zouzou.jpg"
      FileUtils.cp "#{Rails.root.to_s}/public/test/zizi.jpg", "#{DIR_VILLAGES}/zizi.jpg"
      @village.cree_repertoires
      tmp_repertoire_village = DIR_VILLAGES + "/" + @village.dir_nom
      photo = []
      photo[1] = Photo.create!(:url_originale => "#{DIR_VILLAGES}/Zouzou.jpg", :village_id => @village.id)
      photo[2] = Photo.create!(:url_originale => "#{DIR_VILLAGES}/zizi.jpg", :village_id => @village.id)
      tmp_village_id = @village.id
      tmp_fichier_photo_supprimee = []
      [1,2].each {|i| tmp_fichier_photo_supprimee[i] = {}}
      [1,2].each {|i| FIC_EXT.keys.each {|type| tmp_fichier_photo_supprimee[i][type] = photo[i].fichier_photo(type)}}
      delete :destroy, :id => @village
      Photo.find_by_village_id(tmp_village_id).should be_nil
      [1,2].each {|i| FIC_EXT.keys.each {|type| File.file?(tmp_fichier_photo_supprimee[i][type]).should be_false}}
      File.directory?(tmp_repertoire_village).should be_false
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
        FileUtils.remove_dir(DIR_VILLAGES)
        FileUtils.remove_dir(DIR_SUPPR)
        Dir.mkdir(DIR_VILLAGES)
        Photo.create!(:url_originale => 'bidon.jpg', :village_id => @village.id)
        @village.cree_repertoires
        FIC_EXT.keys.each do |type_photo|
          FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", @village.photos.first.fichier_photo(type_photo)
        end
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
      
      it "devrait déplacer toutes les photos" do
        put :update_desactive, :id => @village, :village => @attr
        @village.reload
        @village.actif.should be_false
        FIC_EXT.keys.each do |type_photo|
          File.file?(@village.photos.first.fichier_photo(type_photo)).should be_true
        end
      end

  end

  
end
