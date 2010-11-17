# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Village do
  before(:each) do
    @attr = { :nom_sa => "Exemple de village", :type_village => "mer" }
  end
  it "devrait créer un village avec des attribut valide" do
    Village.create!(@attr)
  end
  it "doit avoir un nom (sans article)" do
    village_sans_nom = Village.new(@attr.merge(:nom_sa => ""))
    village_sans_nom.should_not be_valid
  end
  it "doit avoir un nom (sans article) unique" do
    Village.create!(@attr)
    village_duplique = Village.new(@attr.merge(:type_village => "campagne"))
    village_duplique.should_not be_valid
  end
  it "doit avoir un type compris dans  [mer, campagne, montagne, fédé]" do
    village = Village.new(@attr.merge(:type_village => "nimportnawak"))
    village.should_not be_valid
  end
  it "doit etre créé 'actif' par défaut" do
    village = Village.create!(@attr)
    village.actif.should be_true
  end
end

# == Schema Information
#
# Table name: villages
#
#  id             :integer(4)      not null, primary key
#  article        :string(255)
#  nom_sa         :string(255)
#  nc             :string(255)
#  longitude      :string(255)
#  latitude       :string(255)
#  region_id      :integer(4)
#  departement_id :integer(4)
#  type_village   :string(255)
#  rue            :string(255)
#  cp             :string(255)
#  ville          :string(255)
#  actif          :boolean(1)      default(TRUE)
#  date_entree    :datetime
#  date_sortie    :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

