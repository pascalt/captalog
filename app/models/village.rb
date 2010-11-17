# -*- encoding : utf-8 -*-

class Village < ActiveRecord::Base
  
  attr_accessor :nom
  
  belongs_to :departement
  
  validates :nom_sa,       :presence => true,
                           :uniqueness => true
  
  validates :type_village, :inclusion => %w(mer campagne montagne fédé)
  #validates_inclusion_of :type_village, :in => %w(mer campagne montagne fédé)
  
  #Les lignes qui suivent crée un pb de 'missing attribute' problème référencé dans les forum mais difficile à corriger
  #after_find :reconstruit_nom
  
  #def reconstruit_nom
    #self.nom = self.article.blank? ? self.nom_sa : self.article + " " + self.nom_sa
  #end
  

  before_validation :separe_article_et_nom
  
  private
  def separe_article_et_nom
    #construction de l'article et du nom sans article (nom_sa)
     unless self.nom.blank?
      self.nom =~ /(la\s|le\s|les\s|l'\s*)?(.+.*)/i
      self.article = $1.blank? ? "" : $1.strip
      self.nom_sa = $2.strip
    end
    
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

