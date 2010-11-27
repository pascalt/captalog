# -*- encoding : utf-8 -*-

class Village < ActiveRecord::Base
  belongs_to :departement
  has_many :photos, :dependent => :destroy
  
  validates :nom_sa, :presence => true, :uniqueness => true
  
  validates :type_village, :inclusion => %w(mer campagne montagne)
  validate  :ne_peut_pas_etre_non_actif_sans_date_de_sortie, :ne_peut_pas_etre_actif_avec_une_date_de_sortie
  
  def ne_peut_pas_etre_non_actif_sans_date_de_sortie
    errors.add(:date_sortie, "doit être saisie si désactivé") if !actif && date_sortie.blank?
  end
  
  def ne_peut_pas_etre_actif_avec_une_date_de_sortie
    errors.add(:date_sortie, "ne peut pas etre rentrée si village actif") if actif && !date_sortie.blank?
  end

  scope :actifs, where("actif = ?", true).order("nom_sa")
  scope :non_actifs, where("actif = ?", false).order("nom_sa")
  
  def nom
    # le nom du village est formé par l'article et son nom sans article
    article.blank? ? nom_sa : article + " " + nom_sa
  end
    
  def nc_est_valide
    # le nom court est valide s'il n'est pas blanc 
    # et qu'il ne contient rien d'autre que des lettre minuscules (a-z) ou des tirets
    !nc.blank? && !(nc  =~ /[^a-z\-]/)
  end
  
  def init_nc
    # à moins que le nom court soit valide, on crée un nom court valide
    # en mettant tout en minuscule, en retirant les accents et retirant les caractères non alphabétiques (sauf le tiret)
    unless nc_est_valide
       self.nc = nom_sa.downcase.
            gsub(/[àâãäå]/,'a').gsub(/æ/,'ae').
            gsub(/ç/, 'c').gsub(/[èéêë]/,'e').
            gsub(/[ïî]/,'i').gsub(/[öô]/,'o').
            gsub(/[üùû]/,'u').gsub(/[ñ]/,'n').gsub(/[^a-z\-]/,'')
    end
  end
  
  def dir_existe
    # y-a-t'il déjà un répertoire relatif au village
    Dir.entries(ELEMENTS_DIR).include?(dir_nom)
  end
  
  def dir_nom
    nc
  end
  
  def cree_dir
    # si le nom court est valide et que le répertoire n'existe pas, on crée un répertoire dans public/elements/.
    if nc_est_valide && !dir_existe
      Dir.chdir(ELEMENTS_DIR)
      Dir.mkdir(dir_nom)
      Dir.chdir(dir_nom)
      Dir.mkdir("photos")
      Dir.mkdir("cartes")
      Dir.chdir("photos")
      Dir.mkdir("originale")
      Dir.mkdir("def")
      Dir.mkdir("vignette")
      Dir.mkdir("web")
      Dir.chdir(RAILS_ROOT)
    end
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

