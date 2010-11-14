# -*- encoding : utf-8 -*-
class RegionsController < ApplicationController

  def index
    @regions = Region.all
  end

  def show
    @region = Region.find(params[:id])
  end
  
  def edit
    @region = Region.find(params[:id])
  end

  def update
    @region = Region.find(params[:id])

    if @region.update_attributes(params[:region])
      redirect_to(@region, :notice => 'La région a bien été mise à jour.')
    else
      render :action => "edit"
    end
    
  end

end
