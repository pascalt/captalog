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
      redirect_to(@region, :notice => 'La region est bien mise a jour.')
    else
      render :action => "edit"
    end
    
  end

end
