# -*- encoding : utf-8 -*-

class Village < ActiveRecord::Base
  
  belongs_to :departement
  has_many :photos, :dependent => :destroy
  
  validates :nom_sa, :presence => true, :uniqueness => true
  
  validates :nc, {:uniqueness => true, :if => :nc_non_blank }
  
  validates :type_village, :inclusion => %w(mer campagne montagne)
  
  validate  :doit_creer_des_repertoires,
            :ne_peut_pas_etre_non_actif_sans_date_de_sortie, 
            :ne_peut_pas_etre_actif_avec_une_date_de_sortie
  
  def nc_non_blank
    !nc.blank?
  end
  
  def doit_creer_des_repertoires
    if (!nc.blank? || !new_record?)  && (Rails.env.development? || Rails.env.production?)
      errors.add(:nc, "n'est pas valide") if !nc_est_valide?
      errors.add(:nc, "le répertoire existe déjà") if dir_existe?
      cree_repertoires if errors.empty?
    end
  end
  
  def ne_peut_pas_etre_non_actif_sans_date_de_sortie
    errors.add(:date_sortie, "doit être saisie si désactivé") if !actif && date_sortie.blank?
  end
  
  def ne_peut_pas_etre_actif_avec_une_date_de_sortie
    errors.add(:date_sortie, "ne peut pas etre rentrée si village actif") if actif && !date_sortie.blank?
  end

  scope :actifs, where("actif = ?", true).order("nom_sa")
  scope :non_actifs, where("actif = ?", false).order("nom_sa")
  
  
  # reconstruction du nom avec l'article
  def nom
   article.blank? ? nom_sa : article + " " + nom_sa
  end
    
  # valdité du nom court ? (non vide et pas caractère autre que a-z)
  def nc_est_valide?
    !nc.blank? && !(nc  =~ /[^a-z\-]/)
  end
  
  # proposition d'un non court valide
  def init_nc
    unless nc_est_valide?
       self.nc = nom_sa.downcase.
                 gsub(/[àâãäå]/,'a').gsub(/æ/,'ae').
                 gsub(/ç/, 'c').gsub(/[èéêë]/,'e').
                 gsub(/[ïî]/,'i').gsub(/[öô]/,'o').
                 gsub(/[üùû]/,'u').gsub(/[ñ]/,'n').gsub(/[^a-z\-]/,'')
    end
  end
  
  # existence du répertoire ?
  def dir_existe?
    Dir.entries(ELEMENTS_DIR).include?(dir_nom)
  end
  
  # construction du nom du répertoire racine du village
  def dir_nom
    nc
  end
  
  # création des répertoires
  def cree_repertoires
    Dir.chdir(ELEMENTS_DIR)
    Dir.mkdir(dir_nom)
    Dir.mkdir(dir_nom + PHOTOS_DIR)
    Dir.mkdir(dir_nom + CARTES_DIR)
    Dir.mkdir(dir_nom + PHOTOS_ORIGINALES_DIR)
    Dir.mkdir(dir_nom + PHOTOS_DEFINITIVES_DIR)
    Dir.mkdir(dir_nom + PHOTOS_VIGNETTES_DIR)
    Dir.mkdir(dir_nom + PHOTOS_WEB_DIR)
    Dir.chdir(RAILS_ROOT)
 end
  
  def reactive_et_enregistre
    self.actif = true
    self.date_sortie = nil
    self.save
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

