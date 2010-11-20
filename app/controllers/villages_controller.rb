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
    
    @village = Village.new(params[:village])

    if @village.save
      redirect_to(@village, :notice => 'Le village a bien été créé.')
    else
      render :action => "new"
    end
    
  end

  def update(desactivation=false)
    
    @village = Village.find(params[:id])
    @titre = "Editer " + @village.nom

    if @village.update_attributes(params[:village])
       redirect_to(@village, :notice => "Le village a bien été #{desactivation ? 'désactivé' : 'modifié'}.")
    else
      render :action => "edit"
    end
    
  end

  def destroy
    
    @village = Village.find(params[:id])
    @village.destroy

    redirect_to(villages_url)
    
  end
  
  def desactive
    @village = Village.find(params[:id])
    @village.actif = false
    @titre = "Désactiver " + @village.nom
  end
  
  def update_desactive
   update true 
  end
  
  
end
