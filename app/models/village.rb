# -*- encoding : utf-8 -*-

class Village < ActiveRecord::Base
  
  belongs_to :departement
  has_many :photos, :dependent => :destroy
  has_many :cartes, :dependent => :destroy
  
  validates :nom_sa, :presence => true, :uniqueness => true
  
  validates :nc, {:uniqueness => true, :if => :nc_non_blank }
  
  validates :type_village, :inclusion => %w(mer campagne montagne)
  
  validate  :doit_avoir_un_nc_valide,
            :ne_peut_pas_etre_non_actif_sans_date_de_sortie, 
            :ne_peut_pas_etre_actif_avec_une_date_de_sortie
            
  after_destroy :supprime_repertoires_villages
  
  
  def nc_non_blank
    !nc.blank?
  end
  
  def doit_avoir_un_nc_valide
    errors.add(:nc, "n'est pas valide") if !nc_est_valide?
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
    !(nc  =~ /[^a-z\-]/)
  end
  
  # proposition d'un non court valide
  def init_nc
    self.nc = nom_sa.downcase.gsub(/[àâãäå]/,'a').gsub(/æ/,'ae').
                              gsub(/ç/, 'c').gsub(/[èéêë]/,'e').
                              gsub(/[ïî]/,'i').gsub(/[öô]/,'o').
                              gsub(/[üùû]/,'u').gsub(/[ñ]/,'n').
                              gsub(/[^a-z\-]/,'')
  end
  
  # existence du répertoire ?
  def dir_existe?
    Dir.entries(DIR_VILLAGES).include?(dir_nom)
  end
  
  # construction des nom des répertoires 
  def dir_nom
    nc
  end
  
  def racine_village
    "#{DIR_VILLAGES}/#{dir_nom}"
  end
  
  def liste_des_repertoires
    
    liste = [DIR_SUPPR, DIR_SUPPR_CARTE, "#{DIR_VILLAGES}/#{DIR_VILLAGES_DESACTI}", "#{racine_village}/#{DIR_PHOTOS}", "#{racine_village}/#{DIR_CARTES}", 
             "#{racine_village}/#{DIR_PHOTOS}/#{DIR_PHOTOS_DESACTI}"]
  
    DIR_TYPE_PHOTO.each do |cle, rep| 
      liste << "#{racine_village}/#{DIR_PHOTOS}/#{rep}" << "#{racine_village}/#{DIR_PHOTOS}/#{DIR_PHOTOS_DESACTI}/#{rep}"
    end
      
    DIR_TYPE_CARTE.each do |cle, rep| 
      liste << "#{racine_village}/#{DIR_CARTES}/#{rep}" << "#{racine_village}/#{DIR_CARTES}/#{DIR_CARTES_DESACTI}/#{rep}"
    end
  
    return liste
  
  end
  
  # création des répertoires
  def cree_repertoires
    
    liste_des_repertoires.each { |rep| FileUtils.mkdir_p(rep)}
    
  end
 
  def repertoires_existent?
    
    liste_des_repertoires.each {|rep| @reponse &&= File.directory?(rep)} if (@reponse = !nc.blank?) #l'affectation est voulue
    return @reponse
    
  end
  
  def supprime_repertoires_villages
    FileUtils.remove_dir(racine_village) if File.directory?(racine_village)
    FileUtils.remove_dir("#{DIR_VILLAGES}/#{DIR_VILLAGES_DESACTI}") if File.directory?("#{DIR_VILLAGES}/#{DIR_VILLAGES_DESACTI}")
  end
 
  def deseactive_et_enregistre(params)
    update_attributes(params[:village])
    deplace_fichier_village_desactive
    return errors.empty?
  end

  def reactive_et_enregistre
    self.actif = true
    self.date_sortie = nil
    self.save
    deplace_fichier_village_desactive :envers
    return errors.empty?
  end
  
  def deplace_fichier_village_desactive(sens=nil)
    
    if repertoires_existent?
    
      if sens.nil?
        source      = "#{DIR_VILLAGES}/#{dir_nom}"
        destination = "#{DIR_VILLAGES}/#{DIR_VILLAGES_DESACTI}"
      else
        source      = "#{DIR_VILLAGES}/#{DIR_VILLAGES_DESACTI}/#{dir_nom}"
        destination = "#{DIR_VILLAGES}"
      end
    
      if File.directory?(source) && File.directory?(destination)
        FileUtils.cp_r source, destination
        FileUtils.rm_r source
      end
      
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

