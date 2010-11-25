# -*- encoding : utf-8 -*-
class VillagesController < ApplicationController

  def index
    
    @titre = "Villages Cap France"
    @villages = Village.reseau
    
  end

  def show
    
    @village = Village.find(params[:id])
    @titre = @village.nom
    
  end

  def new
    
    @titre = "Nouveau village"
    @village = Village.new
    
   end

  def edit
    
    @village = Village.find(params[:id])
    @titre = "Editer " + @village.nom
    
  end

  def create
    
    @titre = "Nouveau village"
    @village = Village.new(params[:village])

    if @village.save
      redirect_to(@village, :notice => 'Le village a bien été créé.')
    else
      render :action => "new"
    end
    
  end

  def update
    
    @village = Village.find(params[:id])
    @titre = "Editer " + @village.nom

    if @village.update_attributes(params[:village])
       redirect_to(@village, :notice => "Le village a bien été modifié.")
    else
      render :action => "edit"
    end
    
  end

  def destroy
    
    @village = Village.find(params[:id])
    @village.destroy

    redirect_to(villages_url)
    
  end
  
  # ========================================
  # Actions pour la désactivation du village
  # ========================================
  
  def desactive
    @village = Village.find(params[:id])
    @village.actif = false
    @titre = "Désactiver " + @village.nom
  end
  
  def update_desactive
    
    @village = Village.find(params[:id])
    @titre = "Désactiver " + @village.nom

    if @village.update_attributes(params[:village])
       redirect_to(@village, :notice => "Le village a bien été désactivé.")
    else
      render :action => "desactive"
    end
    
  end
  
end
