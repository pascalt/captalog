# -*- encoding : utf-8 -*-
require 'spec_helper'
describe PhotosController do

  render_views
    
  before(:each) do
    @titre_de_base = "Captalog"
  end
  describe "le INDEX de toutes les photos de la base" do
    it "devrait réussir" do
      get :index
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get :index
      response.should have_selector("title", :content => @titre_de_base + " | Photos actives de la base")
    end
    it "devrait avoir un retour sur le menu" do
      get :index
      response.should have_selector("a", :href => menu_path, :content => "Retour")
    end
    it "ne devrait pas avoir un lien pour la création d'une photo" do
      get :index
      response.should_not have_selector("a", :content => "Nouvelle photo")
    end
    it "s'il existe au moins une photo non active, alors doit avoir un lien vers la liste des photos désactivées" do
      @village = Factory(:village)
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @photo.actif = false
      @photo.save!
      get :index
      response.should have_selector("a", :href => index_non_actives_photos_path, :content => "Photos désactivées")
    end
    it "s'il n'existe pas de photo non active, alors ne doit pas avoir un lien vers la liste des photos désactivées" do
      @village = Factory(:village)
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should_not have_selector("a", :href => index_non_actives_photos_path, :content => "Photos désactivées")
    end
    it "devrait, pour une photo, avoir un lien pour son édition" do
      @village = Factory(:village)
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should have_selector("a", :href => edit_photo_path(@photo), :content => "Editer")
    end
    it "devrait, pour une photo, avoir un lien pour la voir" do
      @village = Factory(:village)
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should have_selector("a", :href => photo_path(@photo), :content => "Voir")
    end
    it "devrait, pour une photo, avoir un lien pour la désactiver" do
      @village = Factory(:village)
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should have_selector("a", :href => active_bascule_photo_path(@photo), :content => "Désactiver")
    end
    
    it "ne devrait pas faire apparaitre de photo désactivée" do
      @village = Factory(:village)
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @photo.actif = false
      @photo.save!
      get :index
      response.should_not have_selector("td", :content => @photo.prefix)
    end
    
    it "ne devrait pas faire apparaitre de photos de village désactivé" do
      @village = Factory(:village)
      @village.actif = false
      @village.date_sortie = Time.now
      @village.save!
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index
      response.should_not have_selector("td", :content => @photo.prefix)
    end
    
  end

  describe "le INDEX des photos d'un village" do
    
    before(:each) do
      @village = Factory(:village)
    end
    it "devrait réussir index" do
      get :index, :village_id => @village
      response.should be_success
    end
    it "devrait avoir le bon titre pour index" do
      get :index, :village_id => @village
      response.should have_selector("title", :content => @titre_de_base + " | Photos actives pour : #{@village.nom}")
    end
    it "devrait avoir un retour sur le village" do
      get :index, :village_id => @village
      response.should have_selector("a", :href => village_path(@village), :content => "Retour")
    end
    it "devrait avoir un lien pour la création d'une photo" do
      get :index, :village_id => @village
      response.should have_selector("a", :href => new_village_photo_path(@village), :content => "Nouvelle photo")
    end
    it "s'il existe au moins une photo non active, alors doit avoir un lien vers la liste des photos désactivées" do
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @photo.actif = false
      @photo.save!
      get :index, :village_id => @village
      response.should have_selector("a", :href => index_non_actives_village_photos_path(@village), :content => "Photos désactivées")
    end
    it "s'il n'existe pas une photo non active, alors ne doit pas avoir un lien vers la liste des photos désactivées" do
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index, :village_id => @village
      response.should_not have_selector("a", :href => index_non_actives_village_photos_path(@village), :content => "Photos désactivées")
    end
    it "devrait, pour une photo, avoir un lien pour son édition" do
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index, :village_id => @village
      response.should have_selector("a", :href => edit_village_photo_path(@village, @photo), :content => "Editer")
    end
    it "devrait, pour une photo, avoir un lien pour la voir" do
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index, :village_id => @village
      response.should have_selector("a", :href => village_photo_path(@village, @photo), :content => "Voir")
    end
    it "devrait, pour une photo, avoir un lien pour la désactiver" do
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      get :index, :village_id => @village
      response.should have_selector("a", :href => active_bascule_village_photo_path(@village, @photo), :content => "Désactiver")
    end
    
    it "ne devrait pas faire apparaitre de photo désactivée" do
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @photo.actif = false
      @photo.save!
      get :index, :village_id => @village
      response.should_not have_selector("td", :content => @photo.prefix)
    end
    
  end

  describe "le SHOW" do
    
    before(:each) do
      @village = Factory(:village)
      attr = {:url_originale => "photo.jpg", :village_id => @village.id }
      @photo = Photo.create!(attr)
     end
    
    it "devrait réussir" do
      get :show, :id => @photo
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :show, :id => @photo
      response.should have_selector("title", :content =>  @titre_de_base + " | Photo " + @photo.prefix)
    end
    
    it "devrait avoir un retour sur la liste des photos si vu depuis un village" do
      get :show, :id => @photo, :village_id => @village
      response.should have_selector("a", :href => village_photos_path(@village), :content => "Retour")
    end

    it "devrait avoir un retour sur la liste de toutes les photos" do
      get :show, :id => @photo
      response.should have_selector("a", :href => photos_path, :content => "Retour")
    end
    
  end

  describe "le EDIT" do
    
    before(:each) do
      @village = Factory(:village)
      FileUtils.rm_r(ELEMENTS_DIR) #nettoyage du répertoire des éléments
      Dir.mkdir(ELEMENTS_DIR) #création du répertoire des éléments
      @village.cree_repertoires #création des répertoires du village
      attr = {:url_originale => "photo.jpg", :village_id => @village.id }
      @photo = Photo.create!(attr)
     end
    
    it "devrait réussir" do
      get :edit, :id => @photo
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :edit, :id => @photo
      response.should have_selector("title", :content =>  @titre_de_base + " | Editer photo : " + @photo.prefix)
    end
    
    it "devrait avoir un retour sur la liste des photos si éditée depuis un village" do
      get :edit, :id => @photo, :village_id => @village
      response.should have_selector("a", :href => village_photos_path(@village), :content => "Retour")
    end

    it "devrait avoir un retour sur la liste de toutes les photos" do
      get :edit, :id => @photo
      response.should have_selector("a", :href => photos_path, :content => "Retour")
    end
    
    it "devrait avoir un lien pour voir la photo depuis un village" do
      get :edit, :id => @photo, :village_id => @village
      response.should have_selector("a", :href => village_photo_path(@village, @photo), :content => "Voir")
    end

    it "devrait avoir un lien pour voir la photo" do
      get :edit, :id => @photo
      response.should have_selector("a", :href => photo_path(@photo), :content => "Voir")
    end
    
    it "devrait présenter le upload de fichier de photo originale si la photo définitive n'existe pas" do
      get :edit, :id => @photo
      response.should have_selector("input", :id =>  "photo_url_originale")
    end
    
    it "ne devrait pas  présenter le upload de fichier de photo originale si la photo définitive existe" do
      FileUtils.cp "#{Rails.root.to_s}/public/test/zizi.jpg", 
      "#{ELEMENTS_DIR}/#{@village.dir_nom}#{PHOTOS_DEFINITIVES_DIR}/#{@photo.prefix}_def.jpg"
      get :edit, :id => @photo
      response.should_not have_selector("input", :id =>  "photo_url_originale")
    end
    
  end
  describe "le NEW depuis un village" do
    
    before(:each) do
      @village = Factory(:village) # création de village de référence pour la photo
      FileUtils.rm_r(ELEMENTS_DIR) #nettoyage du répertoire des éléments
      Dir.mkdir(ELEMENTS_DIR) #création du répertoire des éléments
      FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", "#{ELEMENTS_DIR}/Zouzou.jpg" #copie du fichier tmp de simulation d'upload
      @village.cree_repertoires #création des répertoires du village
      
    end
    
    it "devrait réussir" do
      get :new, :village_id => @village.id
      response.should be_success
    end
    
    it "devrait avoir le bon titre" do
      get :new, :village_id => @village.id
      response.should have_selector("title", :content =>  @titre_de_base + " | Nouvelle photo pour : " + @village.nom)
    end
    
    it "devrait avoir un retour sur la liste des photos de ce village" do
      get :new, :village_id => @village
      response.should have_selector("a", :href => village_photos_path(@village), :content => "Retour")
    end
    
    it ",avec absence de répertoires pour les photos, devrait rediriger vers l'initialisation des répertoires" do 
      FileUtils.rm_r(ELEMENTS_DIR + "/" + @village.dir_nom + PHOTOS_DIR)
      get :new, :village_id => @village
      response.should redirect_to(init_repertoires_village_path(@village))
    end
    
    it "devrait proposer le upload d'une photo définitive" do
      get :new, :village_id => @village
      response.should have_selector("input", :id =>  "photo_url_definitive")
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
        post :create, :photo => @attr, :village_id => @village.id
        response.should render_template('new')
      end
      
      it "devrait avoir le bon titre" do
        post :create, :photo => @attr, :village_id => @village.id
        response.should have_selector("title", :content =>  @titre_de_base + " | Nouvelle photo pour : " + @village.nom)
      end
      
    end
    
    describe "réussi" do
      
      before(:each) do
        FileUtils.remove_dir(ELEMENTS_DIR)
        Dir.mkdir(ELEMENTS_DIR)
        FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", "#{ELEMENTS_DIR}/Zouzou.jpg"
        @attr = { :url_originale => "#{ELEMENTS_DIR}/Zouzou.jpg", :actif => true, :village_id => @village.id }
        @village.cree_repertoires
      end
      
      it "devrait avoir les attributs passés" do
        post :create, :photo => @attr, :village_id => @village.id
        @photo = Photo.find_by_url_originale(@attr[:url_originale])
        @attr.keys.each { |cle| @photo[cle].to_s.should == @attr[cle].to_s }
      end
      
      it "devrait etre redirigé sur le 'show'" do
        post :create, :photo => @attr, :village_id => @village.id
        @photo = Photo.find_by_url_originale(@attr[:url_originale])
        response.should redirect_to(village_photo_path(@village, @photo))
      end
      
      it "devrait avoir un message flash" do
        post :create, :photo => @attr, :village_id => @village.id
        @photo = Photo.find_by_url_originale(@attr[:url_originale])
        flash[:notice].should =~ /créé/
      end
      
      it "devrait créer et bien nommer le fichier photo originale" do
        post :create, :photo => @attr, :village_id => @village.id
        @photo = Photo.find_by_url_originale(@attr[:url_originale])
        File.file?(@photo.nom_fichier_photo_originale).should be_true
      end
      
      it "devrait créer et bien nommer les fichiers photo définitive, vignette et web" do
        FileUtils.cp "#{Rails.root.to_s}/public/test/zizi.jpg", "#{ELEMENTS_DIR}/zizi.jpg"
        @attr.merge!(:url_definitive => "#{ELEMENTS_DIR}/zizi.jpg")
        post :create, :photo => @attr, :village_id => @village.id
        @photo = Photo.find_by_url_originale(@attr[:url_originale])
        File.file?(@photo.nom_fichier_photo_definitive).should be_true
        File.file?(@photo.nom_fichier_photo_vignette).should be_true
        File.file?(@photo.nom_fichier_photo_web).should be_true
        
      end
        
    end

  end
  
  describe "le UPDATE" do
    
    before(:each) do
      @village = Factory(:village)
      attr = {:url_originale => "photo.jpg", :village_id => @village.id }
      @photo = Photo.create!(attr)
    end
    
    describe "échoué" do
      
      before(:each) do
        @attr = { :url_originale => ""}
      end
      
      it "devrait retourner sur la page 'edit'" do
        put :update, :id => @photo, :photo => @attr
        response.should render_template('edit')
      end
      
      it "devrait avoir le bon titre sur le retour au edit" do
        put :update, :id => @photo, :photo => @attr
        response.should have_selector("title", :content =>  @titre_de_base + " | Editer photo : " + @photo.prefix)
      end
    end
    
    describe "réussi" do
      
      before(:each) do
        FileUtils.remove_dir(ELEMENTS_DIR)
        Dir.mkdir(ELEMENTS_DIR)
        FileUtils.cp "#{Rails.root.to_s}/public/test/Zouzou.jpg", "#{ELEMENTS_DIR}/Zouzou.jpg"
        @village.cree_repertoires
        @attr = { :url_originale => "#{ELEMENTS_DIR}/Zouzou.jpg", :actif => true}
      end
      
      it "devrait changer les attributs de la photo" do
        put :update, :id => @photo, :photo => @attr
        @photo.reload
        @attr.keys.each { |cle| @photo[cle].to_s.should == @attr[cle].to_s }
      end
      
      it "devrait etre redirigé sur le 'show' du village si éditée d'un village" do
        put :update, :id => @photo, :village_id => @village.id, :photo => @attr
        response.should redirect_to(village_photo_path(@village, @photo))
      end
      
      it "devrait etre redirigé sur le 'show' si éditée depuis la liste de toutes les photos de la base " do
        put :update, :id => @photo, :photo => @attr
        response.should redirect_to(photo_path(@photo))
      end

      it "devrais avoir un message flash" do
        put :update, :id => @photo, :photo => @attr
        flash[:notice].should =~ /modif/
      end
      
      it "avec une photo originale à remplacer, devrait créer le nouveau fichier et bien le nommer" do
        #copie de fichier qui sera remplacé
        FileUtils.cp "#{Rails.root.to_s}/public/test/zizi.jpg", 
                     "#{ELEMENTS_DIR}/#{@village.dir_nom}#{PHOTOS_ORIGINALES_DIR}/#{@photo.prefix}_originale.jpg"
        put :update, :id => @photo, :photo => @attr
        FileUtils.compare_file("#{Rails.root.to_s}/public/test/Zouzou.jpg", @photo.nom_fichier_photo_originale).should be_true
      end
      
      it "avec une photo définitive à remplacer, devrait créer le nouveau fichier et bien le nommer" do
        #copie de fichier qui sera remplacé
        FileUtils.cp "#{Rails.root.to_s}/public/test/zizi.jpg", 
                     "#{ELEMENTS_DIR}/#{@village.dir_nom}#{PHOTOS_DEFINITIVES_DIR}/#{@photo.prefix}_def.jpg"
        @attr.merge!({ :url_originale => "photo.jpg", :url_definitive => "#{ELEMENTS_DIR}/Zouzou.jpg" })
        put :update, :id => @photo, :photo => @attr
        FileUtils.compare_file("#{Rails.root.to_s}/public/test/Zouzou.jpg", @photo.nom_fichier_photo_definitive).should be_true
       end
      
    end

  end
  
  describe "le DESTROY" do
    
    before(:each) do
      @village = Factory(:village)
      attr = {:url_originale => "photo.jpg", :village_id => @village.id }
      @photo = Photo.create!(attr)
    end
    
    it "doit décrémenter le compte des village" do
      lambda do
        delete :destroy, :id => @photo
      end.should change(Photo, :count).by(-1)
    end
    
    it "devrait éliminer la photo de la liste des photos" do
      delete :destroy, :id => @photo
      Photo.find_by_id(@photo.id).should be_nil
    end
    
    it "devrait rediriger sur la liste photos si pas appelée depuis un village" do
      delete :destroy, :id => @photo
      response.should redirect_to(photos_path)
    end

    it "devrait rediriger sur la liste photos si pas appelée depuis un village" do
      delete :destroy, :id => @photo, :village_id => @village.id
      response.should redirect_to(village_photos_path(@village))
    end
    
  end
  
  describe "la ACTIVE_BASCULE" do
  
    before(:each) do
      @village = Factory(:village)
      attr = {:url_originale => "photo.jpg", :village_id => @village.id }
      @photo = Photo.create!(attr)
    end
  
    describe "la désactivation" do
    
      it "devrait désactiver la photo de la liste des photos" do
        get :active_bascule, :id => @photo
        @photo.reload.actif.should be_false
      end
    
      it "devrait rediriger sur la liste photos si pas appelée depuis un village" do
        get :active_bascule, :id => @photo
        response.should redirect_to(photos_path)
      end

      it "devrait rediriger sur la liste photos si pas appelée depuis un village" do
        get :active_bascule, :id => @photo, :village_id => @village.id
        response.should redirect_to(village_photos_path(@village))
      end
      
    end

    describe "le réactivation" do

      it "devrait réactiver la photo de la liste des photos" do
        @photo.actif = false
        @photo.save!
        get :active_bascule, :id => @photo
        @photo.reload.actif.should be_true
      end
    
      it "devrait rediriger sur la liste photos si pas appelée depuis un village" do
        get :active_bascule, :id => @photo
        response.should redirect_to(photos_path)
      end

      it "devrait rediriger sur la liste photos si pas appelée depuis un village" do
        get :active_bascule, :id => @photo, :village_id => @village.id
        response.should redirect_to(village_photos_path(@village))
      end
      
    end
  end
  
  describe "le INDEX_NON_ACTIVES de toutes les photos de la base" do
    
    it "devrait réussir" do
      get :index_non_actives
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get :index_non_actives
      response.should have_selector("title", :content => @titre_de_base + " | Photos désactivées de la base")
    end
    it "devrait avoir un retour vers la liste des photos actives" do
      get :index_non_actives
      response.should have_selector("a", :href => photos_path, :content => "Retour")
    end
    it "devrait, pour une photo, avoir un lien pour la supprimer" do
      @village = Factory(:village)
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @photo.actif = false
      @photo.save!
      get :index_non_actives
      response.should have_selector("a", :href => photo_path(@photo), :content => "Suppr.")
    end
    
        
  end
  describe "le INDEX_NON_ACTIVES des photos d'un village" do
    
    before(:each) do
      @village = Factory(:village)
    end
    
    it "devrait réussir" do
      get :index_non_actives, :village_id => @village.id
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get :index_non_actives, :village_id => @village.id
      response.should have_selector("title", :content => @titre_de_base + " | Photos désactivées pour : #{@village.nom}")
    end
    it "devrait avoir un retour vers la liste des photos actives" do
      get :index_non_actives, :village_id => @village.id
      response.should have_selector("a", :href => village_photos_path(@village), :content => "Retour")
    end
    it "devrait, pour une photo, avoir un lien pour la supprimer" do
      @photo = Photo.create!(:url_originale => "exemple.jpg", :village_id => @village.id)
      @photo.actif = false
      @photo.save!
      get :index_non_actives, :village_id => @village
      response.should have_selector("a", :href => village_photo_path(@village, @photo), :content => "Suppr.")
    end
    
  end
  
  
end
