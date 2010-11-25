# -*- encoding : utf-8 -*-
class PhotosController < ApplicationController

  def index
    @village = Village.find_by_id(params[:village_id])
    @photos = @village ? @village.photos : Photo.toutes_actives 
    @titre = @village ? "Photos actives pour : #{@village.nom}" : "Photos actives de la base"
  end

  def show
    @photo = Photo.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @titre = @photo.prefix
  end

  def new
    @photo = Photo.new
    @village = Village.find_by_id(params[:village_id])
    @photo.village_id = @village.id unless @village.blank?
    @titre = "Nouvelle photo pour : " + @village.nom
  end

  def edit
    @photo = Photo.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @titre = "Editer photo : " + @photo.prefix
  end

  def create
    @photo = Photo.new(params[:photo])
    @village = Village.find_by_id(params[:village_id])
    @titre = "Nouvelle photo pour : " + @village.nom

    if @photo.save
      redirect_to([@village, @photo], :notice => 'La photo a bien été créée.')
    else
      render :new
    end
    
  end

  def update
    @photo = Photo.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @titre = "Editer photo : " + @photo.prefix

    if @photo.update_attributes(params[:photo])
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
end