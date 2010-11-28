# -*- encoding : utf-8 -*-
class VillagesController < ApplicationController

  def index
    
    # liste tous les villages actifs
    @villages = Village.actifs
    @titre = "Villages Cap France"
    
  end

  def index_non_actifs
    
    # liste tous les villages actifs
    @villages = Village.non_actifs
    @titre = "Villages désactivés"
    
  end

  def show
    
    # montre un village donné
    @village = Village.find(params[:id])
    @titre = @village.nom
    
  end

  def new
    
    # propose de saisir un nouveau village
    @village = Village.new
    @titre = "Nouveau village"
    
   end

  def edit
    
    # propose d'éditer un village donné
    @village = Village.find(params[:id])
    @titre = "Editer " + @village.nom
    
  end

  def create
    
    # initialise les attributs d'un villages
    @village = Village.new(params[:village])
    @titre = "Nouveau village"
    
    # enregistre les attributs du village et crée ses répertoires
    if @village.save
      redirect_to(@village, :notice => "Le village a bien été créé#{@village.dir_existe? ? ", ainsi que ses répertoires" : "."}")
    else
      render :action => "new"
    end
    
  end

  def update
    
    # identifie le village à modifier
    @village = Village.find(params[:id])
    @titre = "Editer " + @village.nom

    # met à jour les attributs du village
    if @village.update_attributes(params[:village])
       redirect_to(@village, :notice => "Le village a bien été modifié.")
    else
      render :action => "edit"
    end
    
  end

  def destroy
    
    # déruit le village
    @village = Village.find(params[:id])
    @village.destroy

    redirect_to(villages_url)
    
  end
  
  # Actions pour la désactivation/réactivation d'un village
  # -------------------------------------------------------
  
  def desactive
    
    # propose de désactiver un village donné
    @village = Village.find(params[:id])
    @village.actif = false
    @titre = "Désactiver " + @village.nom
    
  end
  
  def update_desactive
    
    # identifie le un village a désactiver
    @village = Village.find(params[:id])
    @titre = "Désactiver " + @village.nom

    # enregistre la desactivation du village
    if @village.update_attributes(params[:village])
       redirect_to(@village, :notice => "#{@village.nom} a bien été désactivé.")
    else
      render :action => "desactive"
    end
    
  end
  
  
  def reactive
    
    # reactive et enregistre un village donné
    @village = Village.find(params[:id])
    if @village.reactive_et_enregistre
       redirect_to(@village, :notice => "#{@village.nom} a bien été réactivé.")
    else
      flash[:notice] = "#{@village.nom} n'a pas pu être réactivé."
      render :action => "index_non_actifs"
    end
    
  end
  
  # Actions pour la création des répertoires
  # -------------------------------------------------------
  
  def init_repertoires

    # identifie le village
    @village = Village.find(params[:id])
    @titre = "Initialise les répertoires pour : " + @village.nom
    
    # vérifie l'existance du répertoire et propose un nom court
    unless @village.dir_existe?
      @village.init_nc
    else
      flash[:notice] = "un répertoire existe déjà pour #{@village.nom}."
      render :action => "show"
    end
    
  end
  
  def update_init_repertoires
    
    # identifie le village et récupère le nom court
    @village = Village.find(params[:id])
    @village.nc = params[:village][:nc]
    @titre = "Initialise les répertoires pour : " + @village.nom
    
    # enregistre le nom court et crée des répertoires
    if @village.save 
      redirect_to(@village, :notice => "Les répertoires pour #{@village.nom} ont bien été créés.")
    else
      render :action => "init_repertoires"
    end
    
  end
  
end
