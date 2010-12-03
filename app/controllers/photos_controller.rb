# -*- encoding : utf-8 -*-
class PhotosController < ApplicationController

  def index
    
    @village = Village.find_by_id(params[:village_id])
    @photos = @village ? @village.photos.actives : Photo.actives_de_villages_actifs 
    @titre = @village ? "Photos actives pour : #{@village.nom}" : "Photos actives de la base"
    @existe_photos_non_actives = @village ? @village.photos.non_actives.any? : Photo.non_actives_de_villages_actifs.any?
    
  end

  def show
    
    @photo = Photo.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @titre = "Photo "+ @photo.prefix
    
  end

  def new
    
    @photo = Photo.new
    @village = Village.find_by_id(params[:village_id])
    @photo.village_id = @village.id unless @village.blank?
    @titre = "Nouvelle photo pour : " + @village.nom
    
    redirect_to(init_repertoires_village_path(@village), :notice => 'répertoires absents.') unless @village.repertoires_existent?
    
  end
  
  def edit
    
    @photo = Photo.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @titre = "Editer photo : " + @photo.prefix
    
    # redirection sur l'initialisation des répertoires si les répertoires n'existent pas
    village = @village ? @village : @photo.village
    redirect_to(init_repertoires_village_path(village), :notice => 'répertoires absents.') unless (village.repertoires_existent?)
    
  end

  def create
    
    @photo = Photo.new(params[:photo])
    @village = Village.find_by_id(params[:village_id])
    
    @titre = "Nouvelle photo pour : " + @village.nom
    
    if @photo.sauve_enregistrement_photo_et_cree_fichiers
      redirect_to([@village, @photo], :notice => 'La photo a bien été créée.')
    else
      render :new
    end
    
  end

  def update
    
    @photo = Photo.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @titre = "Editer photo : " + @photo.prefix
    
    ecrase_fichier = {:ori => (@photo.url_originale != params[:photo][:url_originale]) && !params[:photo][:url_originale].blank?,
                      :def => (@photo.url_definitive != params[:photo][:url_definitive]) && !params[:photo][:url_definitive].blank?}
    
    if @photo.update_enregistrement_photo_et_update_fichiers(params, ecrase_fichier)
      redirect_to([@village, @photo], :notice => 'La photo a bien été modifiée.')
    else
      render :edit 
    end
    
  end

  def destroy
    
    @photo = Photo.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @photo.destroy
    redirect_to(@village ? village_photos_path(@village) : photos_path)
    
  end
  
  
  # ========================================
  # Action pour la désactivation/réactivation (active_bascule) de la photo
  # ========================================
  
  def active_bascule
    
    @photo = Photo.find(params[:id])
    @village = Village.find_by_id(params[:village_id])

    if @photo.active_bascule_et_enregistre
       redirect_to(@village ? village_photos_path(@village) : photos_path, 
                   :notice => "La photo #{@photo.prefix} a bien été #{@photo.actif ? "ré" : "dés"}activée.")
    else
      render :action => :index
    end
    
  end
  
  def index_non_actives
    @village = Village.find_by_id(params[:village_id])
    @photos = @village ? @village.photos.non_actives : Photo.non_actives_de_villages_actifs 
    @titre = @village ? "Photos désactivées pour : #{@village.nom}" : "Photos désactivées de la base"
  end
end
