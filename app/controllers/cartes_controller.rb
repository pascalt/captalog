# -*- encoding : utf-8 -*-
class CartesController < ApplicationController
 
   def index
    @village = Village.find_by_id(params[:village_id])
    @cartes = @village ? @village.cartes.actives : Carte.actives_de_villages_actifs 
    @titre = @village ? "Cartes actives pour : #{@village.nom}" : "Cartes actives de la base"
    @existe_cartes_non_actives = @village ? @village.cartes.non_actives.any? : Carte.non_actives_de_villages_actifs.any?
  end

  def index_non_actives
    @village = Village.find_by_id(params[:village_id])
    @cartes = @village ? @village.cartes.non_actives : Carte.non_actives_de_villages_actifs 
    @titre = @village ? "Cartes désactivées pour : #{@village.nom}" : "Cartes désactivées de la base"
  end

  def show
    
    @carte = Carte.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @titre = "Carte "+ @carte.prefix
    
  end

  # GET /cartes/new
  # GET /cartes/new.xml
  def new
    
    @carte = Carte.new
    @village = Village.find_by_id(params[:village_id])
    @carte.village_id = @village.id unless @village.blank?
    @titre = "Nouvelle carte pour : " + @village.nom
    
    redirect_to(init_repertoires_village_path(@village), :notice => 'répertoires absents.') unless @village.repertoires_existent?
    
  end

  def edit

    @carte = Carte.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @titre = "Editer carte : " + @carte.prefix
    
    # redirection sur l'initialisation des répertoires si les répertoires n'existent pas
    village = @village ? @village : @carte.village
    redirect_to(init_repertoires_village_path(village), :notice => 'répertoires absents.') unless (village.repertoires_existent?)

  end

  def create
    
    @carte = Carte.new(params[:carte])
    @village = Village.find_by_id(params[:village_id])
    
    @titre = "Nouvelle carte pour : " + @village.nom
    
    if @carte.sauve_enregistrement_carte_et_cree_fichiers
      redirect_to([@village, @carte], :notice => 'La carte a bien été créée.')
    else
      render :new
    end
    
  end

  def update
    
    @carte = Carte.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @titre = "Editer carte : " + @carte.prefix
    
    ecrase_fichier = (@carte.url_originale != params[:carte][:url_originale]) && !params[:carte][:url_originale].blank?
    
    if @carte.update_enregistrement_carte_et_update_fichiers(params, ecrase_fichier)
      redirect_to([@village, @carte], :notice => 'La carte a bien été modifiée.')
    else
      render :edit 
    end
    
  end

  def destroy
    
    @carte = Carte.find(params[:id])
    @village = Village.find_by_id(params[:village_id])
    @carte.destroy
    redirect_to(@village ? village_cartes_path(@village) : cartes_path)
    
  end
  
  # ========================================
  # Action pour la désactivation/réactivation (active_bascule) de la carte
  # ========================================
  
  def active_bascule
    
    @carte = Carte.find(params[:id])
    @village = Village.find_by_id(params[:village_id])

    if @carte.active_bascule_et_enregistre
       redirect_to(@village ? village_cartes_path(@village) : cartes_path, 
                   :notice => "La carte #{@carte.prefix} a bien été #{@carte.actif ? "ré" : "dés"}activée.")
    else
      render :action => :index
    end
    
  end
  
end
