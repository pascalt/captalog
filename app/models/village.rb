# -*- encoding : utf-8 -*-

class Village < ActiveRecord::Base
  
  belongs_to :departement
  
  validates :nom_sa,       :presence => true,
                           :uniqueness => true
  
  validates :type_village, :inclusion => %w(mer campagne montagne)
  
  def nom
    article.blank? ? nom_sa : article + " " + nom_sa
  end
    
  scope :reseau, where("id <> ? and actif = ?", 0, true).order("nom_sa")
  

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

