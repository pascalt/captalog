# -*- encoding : utf-8 -*-
class VillagesController < ApplicationController

  def index
    
    @titre = "Villages Cap France"
    @villages = Village.actifs
    
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
      @village.cree_dir if Rails.env.development? || Rails.env.production?
      redirect_to(@village, :notice => "Le village a bien été créé#{@village.dir_existe ? ", ainsi que ses répertoires" : "."}")
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
  # Actions pour la désactivation/réactivation du village
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
       redirect_to(@village, :notice => "#{@village.nom} a bien été désactivé.")
    else
      render :action => "desactive"
    end
    
  end
  
  def index_non_actifs
    @villages = Village.non_actifs
    @titre = "Villages désactivés"
  end
  
  def reactive
    @village = Village.find(params[:id])
    @village.actif = true
    @village.date_sortie = nil
    if @village.save
       redirect_to(@village, :notice => "#{@village.nom} a bien été réactivé.")
    else
      flash[:notice] = "#{@village.nom} n'a pas pu être réactivé."
      render :action => "index_non_actifs"
    end
    
  end
  
  def init_repertoires

    @village = Village.find(params[:id])
    
    # à mins que le répertoire 'nc' n'existe déjà, on initialise le nc
    unless @village.dir_existe
      @village.init_nc
      @titre = "Initialise les répertoires pour : " + @village.nom
    else
      flash[:notice] = "un répertoire existe déjà pour #{@village.nom}."
      render :action => "show"
    end
  end
  
  def update_init_repertoires
    
    # on récupère les paramètre de la vue, notamment le 'nc' qui sera le nom du répertoire
    @village = Village.find(params[:id])
    @titre = "Initialise les répertoires pour : " + @village.nom
    @village.nc = params[:village][:nc]
    
    # si le répertoire 'nc' n'existe pas, on l'enregistre et on crée le répertoire
    if !@village.dir_existe 
      if @village.save
        @village.cree_dir if Rails.env.development? || Rails.env.production?
        redirect_to(@village, :notice => "Les répertoires pour #{@village.nom} ont bien été créés.")
      else
        flash[:notice] = "Problème de mise à jour pour #{@village.nom}."
        render :action => "init_repertoires"
      end
    # sinon on retourne à la saise du 'nc'
    else
      flash[:notice] = "Le repertoire [#{@village.nc}] existe déjà pour #{@village.nom}."
      render :action => "init_repertoires"
    end
    
  end
  
end
