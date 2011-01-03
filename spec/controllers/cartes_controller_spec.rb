# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartesController do
  
  render_views
  
  before(:each) do
    @titre_de_base = "Captalog"
  end
  
  describe "le INDEX de toutes les cartes de la base" do
    it "devrait réussir" do
      get :index
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get :index
      response.should have_selector("title", :content => @titre_de_base + " | Cartes actives de la base")
    end
    it "devrait avoir un lien sur le menu" do
      get :index
      response.should have_selector("a", :href => menu_path, :content => "Menu")
    end
    it "ne devrait pas avoir un lien pour la création d'une carte" do
      get :index
      response.should_not have_selector("a", :content => "Nouvelle carte")
    end
    it "s'il existe au moins une carte non active, alors doit avoir un lien vers la liste des cartes désactivées" do
      @village = Factory(:village)
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @carte.actif = false
      @carte.save!
      get :index
      response.should have_selector("a", :href => index_non_actives_cartes_path, :content => "Cartes désactivées")
    end
    it "s'il n'existe pas de carte non active, alors ne doit pas avoir un lien vers la liste des cartes désactivées" do
      @village = Factory(:village)
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should_not have_selector("a", :href => index_non_actives_cartes_path, :content => "Cartes désactivées")
    end
    it "devrait, pour une carte, avoir un lien pour son édition" do
      @village = Factory(:village)
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should have_selector("a", :href => edit_carte_path(@carte), :content => "Editer")
    end
    it "devrait, pour une carte, avoir un lien pour la voir" do
      @village = Factory(:village)
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should have_selector("a", :href => carte_path(@carte), :content => "Voir")
    end
    it "devrait, pour une carte, avoir un lien pour la désactiver" do
      @village = Factory(:village)
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should have_selector("a", :href => active_bascule_carte_path(@carte), :content => "Désactiver")
    end
    it "ne devrait pas faire apparaitre de carte désactivée" do
      @village = Factory(:village)
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @carte.actif = false
      @carte.save!
      get :index
      response.should_not have_selector("td", :content => @carte.prefix)
    end
    
    it "ne devrait pas faire apparaitre de cartes de village désactivé" do
      @village = Factory(:village)
      @village.actif = false
      @village.date_sortie = Time.now
      @village.save!
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should_not have_selector("td", :content => @carte.prefix)
    end
    
  end
  describe "le INDEX des cartes d'un village" do
    
    before(:each) do
      @village = Factory(:village)
    end
    it "devrait réussir index" do
      get :index, :village_id => @village
      response.should be_success
    end
    it "devrait avoir le bon titre pour index" do
      get :index, :village_id => @village
      response.should have_selector("title", :content => @titre_de_base + " | Cartes actives pour : #{@village.nom}")
    end
    it "devrait avoir un retour sur le village" do
      get :index, :village_id => @village
      response.should have_selector("a", :href => village_path(@village), :content => @village.nom)
    end
    it "devrait avoir un lien pour la création d'une carte" do
      get :index, :village_id => @village
      response.should have_selector("a", :href => new_village_carte_path(@village), :content => "Nouvelle carte")
    end
    it "s'il existe au moins une carte non active, alors doit avoir un lien vers la liste des cartes désactivées" do
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @carte.actif = false
      @carte.save!
      get :index, :village_id => @village
      response.should have_selector("a", :href => index_non_actives_village_cartes_path(@village), :content => "Cartes désactivées")
    end
    it "s'il n'existe pas une carte non active, alors ne doit pas avoir un lien vers la liste des cartes désactivées" do
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index, :village_id => @village
      response.should_not have_selector("a", :href => index_non_actives_village_cartes_path(@village), :content => "Cartes désactivées")
    end
    it "devrait, pour une carte, avoir un lien pour son édition" do
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index, :village_id => @village
      response.should have_selector("a", :href => edit_village_carte_path(@village, @carte), :content => "Editer")
    end
    it "devrait, pour une carte, avoir un lien pour la voir" do
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index, :village_id => @village
      response.should have_selector("a", :href => village_carte_path(@village, @carte), :content => "Voir")
    end
    it "devrait, pour une carte, avoir un lien pour la désactiver" do
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index, :village_id => @village
      response.should have_selector("a", :href => active_bascule_village_carte_path(@village, @carte), :content => "Désactiver")
    end
    
    it "ne devrait pas faire apparaitre de carte désactivée" do
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @carte.actif = false
      @carte.save!
      get :index, :village_id => @village
      response.should_not have_selector("td", :content => @carte.prefix)
    end
    
  end
  
  describe "le SHOW" do
    
    before(:each) do
      @village = Factory(:village)
      attr = {:url_originale => "photo.jpg", :village_id => @village.id }
      @carte = Carte.create!(attr)
     end
    
    it "devrait réussir" do
      get :show, :id => @carte
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :show, :id => @carte
      response.should have_selector("title", :content =>  @titre_de_base + " | Carte " + @carte.prefix)
    end
    
    it "devrait avoir un lien sur la liste des cartes si vu depuis un village" do
      get :show, :id => @carte, :village_id => @village
      response.should have_selector("a", :href => village_cartes_path(@village), :content => "Cartes")
    end

    it "devrait avoir un retour sur la liste de toutes les cartes" do
      get :show, :id => @carte
      response.should have_selector("a", :href => cartes_path, :content => "Cartes")
    end
    
  end
 
  describe "le EDIT" do
    
    before(:each) do
      @village = Factory(:village)
      FileUtils.rm_r(DIR_VILLAGES) #nettoyage du répertoire des éléments
      FileUtils.remove_dir(DIR_SUPPR_CARTE)
      Dir.mkdir(DIR_VILLAGES) #création du répertoire des éléments
      @village.cree_repertoires #création des répertoires du village
      attr = {:url_originale => "carte.pdf", :village_id => @village.id }
      @carte = Carte.create!(attr)
    end
    
    it "devrait réussir" do
      get :edit, :id => @carte
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :edit, :id => @carte
      response.should have_selector("title", :content =>  @titre_de_base + " | Editer carte : " + @carte.prefix)
    end
    
    it "devrait avoir un lien vers la liste des cartes du village si éditée depuis un village" do
      get :edit, :id => @carte, :village_id => @village
      response.should have_selector("a", :href => village_cartes_path(@village), :content => "Cartes")
    end

    it "devrait avoir un lien vers la liste de toutes les cartes" do
      get :edit, :id => @carte
      response.should have_selector("a", :href => cartes_path, :content => "Cartes")
    end
    
    it "devrait avoir un lien pour voir la carte depuis un village" do
      get :edit, :id => @carte, :village_id => @village
      response.should have_selector("a", :href => village_carte_path(@village, @carte), :content => "Voir")
    end

    it "devrait avoir un lien pour voir la carte" do
      get :edit, :id => @carte
      response.should have_selector("a", :href => carte_path(@carte), :content => "Voir")
    end
    
    it "devrait présenter le upload de fichier de carte" do
      get :edit, :id => @carte
      response.should have_selector("input", :id =>  "carte_url_originale")
    end
    
  end
  
  describe "le NEW depuis un village" do
    
    before(:each) do
      @village = Factory(:village) # création de village de référence pour la photo
      FileUtils.rm_r(DIR_VILLAGES) #nettoyage du répertoire des éléments
      FileUtils.remove_dir(DIR_SUPPR_CARTE)
      Dir.mkdir(DIR_VILLAGES) #création du répertoire des éléments
      FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", "#{DIR_VILLAGES}/Zouzou.jpg" #copie du fichier tmp de simulation d'upload
      @village.cree_repertoires #création des répertoires du village
      
    end
    
    it "devrait réussir" do
      get :new, :village_id => @village.id
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :new, :village_id => @village.id
      response.should have_selector("title", :content =>  @titre_de_base + " | Nouvelle carte pour : " + @village.nom)
    end
    
    it "devrait avoir un retour sur la liste des cartes de ce village" do
      get :new, :village_id => @village
      response.should have_selector("a", :href => village_cartes_path(@village), :content => "Cartes")
    end
    
    it ",avec absence de répertoires pour les cartes, devrait rediriger vers l'initialisation des répertoires" do 
      FileUtils.rm_r(DIR_VILLAGES + "/" + @village.dir_nom + "/" + DIR_CARTES)
      get :new, :village_id => @village
      response.should redirect_to(init_repertoires_village_path(@village))
    end
    
    it "devrait proposer le upload d'une carte" do
      get :new, :village_id => @village
      response.should have_selector("input", :id =>  "carte_url_originale")
    end
    
  end
  
  describe "le CREATE depuis un village" do
    
    before(:each) do
      @village = Factory(:village)
    end
    
    describe "échoué" do
      
      before(:each) do
        @attr = { :url_originale => "", :actif => true, :village_id => @village.id }
      end
      
      it "devrait retourner sur la page 'new'" do
        post :create, :carte => @attr, :village_id => @village.id
        response.should render_template('new')
      end
      
      it "devrait avoir le bon titre" do
        post :create, :carte => @attr, :village_id => @village.id
        response.should have_selector("title", :content =>  @titre_de_base + " | Nouvelle carte pour : " + @village.nom)
      end
      
    end
    
    describe "réussi" do
      
      before(:each) do
        FileUtils.remove_dir(DIR_VILLAGES)
        Dir.mkdir(DIR_VILLAGES)
        FileUtils.remove_dir(DIR_SUPPR_CARTE)
        FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", "#{DIR_VILLAGES}/Zouzou.jpg"
        @attr = { :url_originale => "#{DIR_VILLAGES}/Zouzou.jpg", :actif => true, :village_id => @village.id }
        @village.cree_repertoires
      end
      
      it "devrait avoir les attributs passés" do
        post :create, :carte => @attr, :village_id => @village.id
        @carte = Carte.find_by_url_originale(@attr[:url_originale])
        @attr.keys.each { |cle| @carte[cle].to_s.should == @attr[cle].to_s }
      end
      
      it "devrait etre redirigé sur le 'show'" do
        post :create, :carte => @attr, :village_id => @village.id
        @carte = Carte.find_by_url_originale(@attr[:url_originale])
        response.should redirect_to(village_carte_path(@village, @carte))
      end
      
      it "devrait avoir un message flash" do
        post :create, :carte => @attr, :village_id => @village.id
        @carte = Carte.find_by_url_originale(@attr[:url_originale])
        flash[:notice].should =~ /créé/
      end
      
      it "devrait créer et bien nommer les fichiers carte" do
        post :create, :carte => @attr, :village_id => @village.id
        @carte = Carte.find_by_url_originale(@attr[:url_originale])
        [:ori, :vig, :web].each {|type| File.file?(@carte.fichier_carte(type)).should be_true}
      end
             
    end

  end
  
  describe "le UPDATE" do
    
    before(:each) do
      @village = Factory(:village)
      attr = {:url_originale => "carte.jpg", :village_id => @village.id }
      @carte = Carte.create!(attr)
    end
    
    describe "échoué" do
      
      before(:each) do
        @attr = { :url_originale => ""}
      end
      
      it "devrait retourner sur la page 'edit'" do
        put :update, :id => @carte, :carte => @attr
        response.should render_template('edit')
      end
      
      it "devrait avoir le bon titre sur le retour au edit" do
        put :update, :id => @carte, :carte => @attr
        response.should have_selector("title", :content =>  @titre_de_base + " | Editer carte : " + @carte.prefix)
      end
    end
    
    describe "réussi" do
      
      before(:each) do
        FileUtils.remove_dir(DIR_VILLAGES)
        Dir.mkdir(DIR_VILLAGES)
        FileUtils.remove_dir(DIR_SUPPR_CARTE)
        FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", "#{DIR_VILLAGES}/Zouzou.jpg"
        @village.cree_repertoires
        @attr = { :url_originale => "#{DIR_VILLAGES}/Zouzou.jpg", :actif => true}
      end
      
      it "devrait changer les attributs de la carte" do
        put :update, :id => @carte, :carte => @attr
        @carte.reload
        @attr.keys.each { |cle| @carte[cle].to_s.should == @attr[cle].to_s }
      end
      
      it "devrait etre redirigé sur le 'show' du village si éditée d'un village" do
        put :update, :id => @carte, :village_id => @village.id, :carte => @attr
        response.should redirect_to(village_carte_path(@village, @carte))
      end
      
      it "devrait etre redirigé sur le 'show' si éditée depuis la liste de toutes les cartes de la base " do
        put :update, :id => @carte, :carte => @attr
        response.should redirect_to(carte_path(@carte))
      end

      it "devrais avoir un message flash" do
        put :update, :id => @carte, :carte => @attr
        flash[:notice].should =~ /modif/
      end
      
      it "avec une carte  à remplacer, devrait créer le nouveau fichier et bien le nommer" do
        #copie de fichier qui sera remplacé
        FileUtils.cp "#{Rails.root.to_s}/public/test/zizi.jpg", 
                     "#{DIR_VILLAGES}/#{@village.dir_nom}/#{DIR_CARTES}/#{DIR_TYPE_CARTE[:ori]}/#{@carte.prefix}_originale.jpg"
        put :update, :id => @carte, :carte => @attr
        FileUtils.compare_file("#{Rails.root.to_s}/public/test/Zouzou.jpg", @carte.fichier_carte(:ori)).should be_true
      end
            
    end

  end
  
  describe "le DESTROY" do
    
    before(:each) do
      @village = Factory(:village)
      attr = {:url_originale => "#{DIR_VILLAGES}/Zouzou.jpg", :village_id => @village.id }
      FileUtils.remove_dir(DIR_VILLAGES)
      FileUtils.remove_dir(DIR_SUPPR_CARTE)      
      Dir.mkdir(DIR_VILLAGES)
      FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", "#{DIR_VILLAGES}/Zouzou.jpg"
      @village.cree_repertoires
      @carte = Carte.create!(attr)
      @carte.cree_fichier_carte
    end
    
    it "doit décrémenter le compte des cartes" do
      lambda do
        delete :destroy, :id => @carte
      end.should change(Carte, :count).by(-1)
    end
    
    it "devrait éliminer la carte de la liste des cartes" do
      delete :destroy, :id => @carte
      Carte.find_by_id(@carte.id).should be_nil
    end
    
    it "devrait rediriger sur la liste cartes si pas appelée depuis un village" do
      delete :destroy, :id => @carte
      response.should redirect_to(cartes_path)
    end

    it "devrait rediriger sur la liste cartes du village si appelée depuis un village" do
      delete :destroy, :id => @carte, :village_id => @village.id
      response.should redirect_to(village_cartes_path(@village))
    end
    
    it "devrait déplacer les fichiers cartes dans le répertoire de supression" do
      tmp_fichier_carte_supprimee = {}
      FIC_EXT_CARTE.keys.each {|type| tmp_fichier_carte_supprimee[type] = @carte.fichier_carte(type)}
      delete :destroy, :id => @carte
      FIC_EXT_CARTE.keys.each {|type| File.file?(tmp_fichier_carte_supprimee[type]).should be_false}
    end
    
  end
  
  describe "la ACTIVE_BASCULE" do
  
    before(:each) do
      @village = Factory(:village)
      attr = {:url_originale => "carte.jpg", :village_id => @village.id }
      @carte = Carte.create!(attr)
    end
  
    describe "la désactivation" do
    
      it "devrait désactiver la carte de la liste des cartes" do
        get :active_bascule, :id => @carte
        @carte.reload.actif.should be_false
      end

      it "devrait placer les cartes dans le répertoire desactivées" do
        
        FileUtils.remove_dir(DIR_VILLAGES)
        FileUtils.remove_dir(DIR_SUPPR_CARTE)
        Dir.mkdir(DIR_VILLAGES)
        @village.cree_repertoires
        FIC_EXT.keys.each do |type_carte|
          FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", @carte.fichier_carte(type_carte)
        end
        
        get :active_bascule, :id => @carte
        
        @carte.reload.actif.should be_false
        
        FIC_EXT_CARTE.keys.each do |type_carte|
          File.file?(@carte.fichier_carte(type_carte)).should be_true
        end

      end

    
      it "devrait rediriger sur la liste cartes si pas appelée depuis un village" do
        get :active_bascule, :id => @carte
        response.should redirect_to(cartes_path)
      end

      it "devrait rediriger sur la liste cartes si pas appelée depuis un village" do
        get :active_bascule, :id => @carte, :village_id => @village.id
        response.should redirect_to(village_cartes_path(@village))
      end
      
    end

    describe "le réactivation" do

      it "devrait réactiver la carte de la liste des cartes" do
        @carte.actif = false
        @carte.save!
        get :active_bascule, :id => @carte
        @carte.reload.actif.should be_true
      end
    
      it "devrait rediriger sur la liste cartes si pas appelée depuis un village" do
        get :active_bascule, :id => @carte
        response.should redirect_to(cartes_path)
      end

      it "devrait rediriger sur la liste cartes si pas appelée depuis un village" do
        get :active_bascule, :id => @carte, :village_id => @village.id
        response.should redirect_to(village_cartes_path(@village))
      end
      
    end
    
  end
  
  describe "le INDEX_NON_ACTIVES des cartes d'un village" do
    
    before(:each) do
      @village = Factory(:village)
    end
    
    it "devrait réussir" do
      get :index_non_actives, :village_id => @village.id
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :index_non_actives, :village_id => @village.id
      response.should have_selector("title", :content => @titre_de_base + " | Cartes désactivées pour : #{@village.nom}")
    end
    
    it "devrait avoir un retour vers la liste des cartes actives" do
      get :index_non_actives, :village_id => @village.id
      response.should have_selector("a", :href => village_cartes_path(@village), :content => "actives")
    end
    
    it "devrait, pour une carte, avoir un lien pour la supprimer" do
      @carte = Carte.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @carte.actif = false
      @carte.save!
      get :index_non_actives, :village_id => @village
      response.should have_selector("a", :href => village_carte_path(@village, @carte), :content => "Suppr.")
    end
    
  end
  
  
  
  
  
  

end
