# coding: utf-8
class DepartementsController < ApplicationController
  def index
    
    # Ajout de @region pour répondre à : GET /regions/:region_id/departements
    @region = Region.find_by_id(params[:region_id])
    
    #si la @région existe alors on prends les départements de la régions
    #sinon on prend tous les départements de la base
    @departements = @region ? @region.departements : Departement.all 

  end

  def show
    @departement = Departement.find(params[:id])
  end

  def edit
    @departement = Departement.find(params[:id])
  end

  def update
    @departement = Departement.find(params[:id])

    if @departement.update_attributes(params[:departement])
      redirect_to(@departement, :notice => "Le département a bien été mis à jour.")
    else
      render :action => "edit" 
    end
    
  end

end
