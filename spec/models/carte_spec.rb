# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Carte do
  before(:each) do
    @village = Factory(:village)
    @attr = {:url_originale => "carte.jpg", :village_id => @village.id }
  end
  it "devrait créer une carte avec des attribut valide" do
    Carte.create!(@attr)
  end
  it "doit avoir une url originale" do
    carte_sans_url = Carte.new(@attr.merge(:url_originale => ""))
    carte_sans_url.should_not be_valid
  end
  it "doit etre créé 'actif' par défaut" do
    carte = Carte.create!(@attr)
    carte.actif.should be_true
  end
  it "ne doit pas etre sans village" do
    carte = Carte.new(@attr.merge(:village_id => nil))
    carte.should_not be_valid
  end
  it "doit etre reliée à un village existant" do
    village_id_inexistant = @village.id
    @village.destroy
    carte = Carte.new(@attr.merge(:village_id => village_id_inexistant))
    carte.should_not be_valid
  end
end


# == Schema Information
#
# Table name: cartes
#
#  id            :integer(4)      not null, primary key
#  nom           :string(255)
#  info          :string(255)
#  village_id    :integer(4)
#  url_originale :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  actif         :boolean(1)      default(TRUE)
#

