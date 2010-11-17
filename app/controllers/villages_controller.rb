# -*- encoding : utf-8 -*-
class VillagesController < ApplicationController
  # GET /villages
  # GET /villages.xml
  def index
    @titre = "Villages Cap France"
    @villages = Village.reseau

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @villages }
    end
  end

  # GET /villages/1
  # GET /villages/1.xml
  def show
    @village = Village.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @village }
    end
  end

  # GET /villages/new
  # GET /villages/new.xml
  def new
    @village = Village.new
    @departements = Departement.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @village }
    end
  end

  # GET /villages/1/edit
  def edit
    @village = Village.find(params[:id])
    
    #Initialisation de l'attribut nom à partir des données de la base, 
    #il aurait mieux fallut l'initialiser par le callback after_find dans le model, mais ça plate (référencé dans les forum)
    @village.nom = @village.article.blank? ? @village.nom_sa : @village.article + " " + @village.nom_sa
    
    @departements = Departement.all
  end

  # POST /villages
  # POST /villages.xml
  def create
    @village = Village.new(params[:village])
    
    respond_to do |format|
      if @village.save
        format.html { redirect_to(@village, :notice => 'Village was successfully created.') }
        format.xml  { render :xml => @village, :status => :created, :location => @village }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @village.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /villages/1
  # PUT /villages/1.xml
  def update
    @village = Village.find(params[:id])

    respond_to do |format|
      if @village.update_attributes(params[:village])
        format.html { redirect_to(@village, :notice => 'Village was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @village.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /villages/1
  # DELETE /villages/1.xml
  def destroy
    @village = Village.find(params[:id])
    @village.destroy

    respond_to do |format|
      format.html { redirect_to(villages_url) }
      format.xml  { head :ok }
    end
  end
end
