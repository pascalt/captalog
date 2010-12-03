# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Photo do
  before(:each) do
    @village = Factory(:village)
    @attr = {:url_originale => "photo.jpg", :village_id => @village.id }
  end
  it "devrait créer une photo avec des attribut valide" do
    Photo.create!(@attr)
  end
  it "doit avoir une url originale" do
    photo_sans_url = Photo.new(@attr.merge(:url_originale => ""))
    photo_sans_url.should_not be_valid
  end
  # it "doit avoir une url originale unique" do
  #   Photo.create!(@attr)
  #   photo_duplique = Photo.new(@attr)
  #   photo_duplique.should_not be_valid
  # end
  it "doit etre créé 'actif' par défaut" do
    photo = Photo.create!(@attr)
    photo.actif.should be_true
  end
  it "ne doit pas etre sans village" do
    photo = Photo.new(@attr.merge(:village_id => nil))
    photo.should_not be_valid
  end
  it "doit etre reliée à un village existant" do
    village_id_inexistant = @village.id
    @village.destroy
    photo = Photo.new(@attr.merge(:village_id => village_id_inexistant))
    photo.should_not be_valid
  end
end




# == Schema Information
#
# Table name: photos
#
#  id             :integer(4)      not null, primary key
#  village_id     :integer(4)
#  legende        :string(255)
#  info           :string(255)
#  url_originale  :string(255)
#  actif          :boolean(1)      default(TRUE)
#  created_at     :datetime
#  updated_at     :datetime
#  url_definitive :string(255)
#

