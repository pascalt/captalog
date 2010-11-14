# -*- encoding : utf-8 -*-
class CreateDepartements < ActiveRecord::Migration
  def self.up
    create_table :departements do |t|
      t.references :region
      t.string :nom
      t.string :code
      t.string :nc
      t.string :code_region

      t.timestamps
    end
      
    # Insertion des départements
    Departement.create :code_region=>"82", :code=>"01", :nom=>"Ain"
    Departement.create :code_region=>"22", :code=>"02", :nom=>"Aisne"
    Departement.create :code_region=>"83", :code=>"03", :nom=>"Allier"
    Departement.create :code_region=>"93", :code=>"04", :nom=>"Alpes-de-Haute-Provence"
    Departement.create :code_region=>"93", :code=>"05", :nom=>"Hautes-Alpes"
    Departement.create :code_region=>"93", :code=>"06", :nom=>"Alpes-Maritimes"
    Departement.create :code_region=>"82", :code=>"07", :nom=>"Ardèche"
    Departement.create :code_region=>"21", :code=>"08", :nom=>"Ardennes"
    Departement.create :code_region=>"73", :code=>"09", :nom=>"Ariège"
    Departement.create :code_region=>"21", :code=>"10", :nom=>"Aube"
    Departement.create :code_region=>"91", :code=>"11", :nom=>"Aude"
    Departement.create :code_region=>"73", :code=>"12", :nom=>"Aveyron"
    Departement.create :code_region=>"93", :code=>"13", :nom=>"Bouches-du-Rhône"
    Departement.create :code_region=>"25", :code=>"14", :nom=>"Calvados"
    Departement.create :code_region=>"83", :code=>"15", :nom=>"Cantal"
    Departement.create :code_region=>"54", :code=>"16", :nom=>"Charente"
    Departement.create :code_region=>"54", :code=>"17", :nom=>"Charente-Maritime"
    Departement.create :code_region=>"24", :code=>"18", :nom=>"Cher"
    Departement.create :code_region=>"74", :code=>"19", :nom=>"Corrèze"
    Departement.create :code_region=>"94", :code=>"2A", :nom=>"Corse-du-Sud"
    Departement.create :code_region=>"94", :code=>"2B", :nom=>"Haute-Corse"
    Departement.create :code_region=>"26", :code=>"21", :nom=>"Côte-d'Or"
    Departement.create :code_region=>"53", :code=>"22", :nom=>"Côtes-d'Armor"
    Departement.create :code_region=>"74", :code=>"23", :nom=>"Creuse"
    Departement.create :code_region=>"72", :code=>"24", :nom=>"Dordogne"
    Departement.create :code_region=>"43", :code=>"25", :nom=>"Doubs"
    Departement.create :code_region=>"82", :code=>"26", :nom=>"Drôme"
    Departement.create :code_region=>"23", :code=>"27", :nom=>"Eure"
    Departement.create :code_region=>"24", :code=>"28", :nom=>"Eure-et-Loir"
    Departement.create :code_region=>"53", :code=>"29", :nom=>"Finistère"
    Departement.create :code_region=>"91", :code=>"30", :nom=>"Gard"
    Departement.create :code_region=>"73", :code=>"31", :nom=>"Haute-Garonne"
    Departement.create :code_region=>"73", :code=>"32", :nom=>"Gers"
    Departement.create :code_region=>"72", :code=>"33", :nom=>"Gironde"
    Departement.create :code_region=>"91", :code=>"34", :nom=>"Hérault"
    Departement.create :code_region=>"53", :code=>"35", :nom=>"Ille-et-Vilaine"
    Departement.create :code_region=>"24", :code=>"36", :nom=>"Indre"
    Departement.create :code_region=>"24", :code=>"37", :nom=>"Indre-et-Loire"
    Departement.create :code_region=>"82", :code=>"38", :nom=>"Isère"
    Departement.create :code_region=>"43", :code=>"39", :nom=>"Jura"
    Departement.create :code_region=>"72", :code=>"40", :nom=>"Landes"
    Departement.create :code_region=>"24", :code=>"41", :nom=>"Loir-et-Cher"
    Departement.create :code_region=>"82", :code=>"42", :nom=>"Loire"
    Departement.create :code_region=>"83", :code=>"43", :nom=>"Haute-Loire"
    Departement.create :code_region=>"52", :code=>"44", :nom=>"Loire-Atlantique"
    Departement.create :code_region=>"24", :code=>"45", :nom=>"Loiret"
    Departement.create :code_region=>"73", :code=>"46", :nom=>"Lot"
    Departement.create :code_region=>"72", :code=>"47", :nom=>"Lot-et-Garonne"
    Departement.create :code_region=>"91", :code=>"48", :nom=>"Lozère"
    Departement.create :code_region=>"52", :code=>"49", :nom=>"Maine-et-Loire"
    Departement.create :code_region=>"25", :code=>"50", :nom=>"Manche"
    Departement.create :code_region=>"21", :code=>"51", :nom=>"Marne"
    Departement.create :code_region=>"21", :code=>"52", :nom=>"Haute-Marne"
    Departement.create :code_region=>"52", :code=>"53", :nom=>"Mayenne"
    Departement.create :code_region=>"41", :code=>"54", :nom=>"Meurthe-et-Moselle"
    Departement.create :code_region=>"41", :code=>"55", :nom=>"Meuse"
    Departement.create :code_region=>"53", :code=>"56", :nom=>"Morbihan"
    Departement.create :code_region=>"41", :code=>"57", :nom=>"Moselle"
    Departement.create :code_region=>"26", :code=>"58", :nom=>"Nièvre"
    Departement.create :code_region=>"31", :code=>"59", :nom=>"Nord"
    Departement.create :code_region=>"22", :code=>"60", :nom=>"Oise"
    Departement.create :code_region=>"25", :code=>"61", :nom=>"Orne"
    Departement.create :code_region=>"31", :code=>"62", :nom=>"Pas-de-Calais"
    Departement.create :code_region=>"83", :code=>"63", :nom=>"Puy-de-Dôme"
    Departement.create :code_region=>"72", :code=>"64", :nom=>"Pyrénées-Atlantiques"
    Departement.create :code_region=>"73", :code=>"65", :nom=>"Hautes-Pyrénées"
    Departement.create :code_region=>"91", :code=>"66", :nom=>"Pyrénées-Orientales"
    Departement.create :code_region=>"42", :code=>"67", :nom=>"Bas-Rhin"
    Departement.create :code_region=>"42", :code=>"68", :nom=>"Haut-Rhin"
    Departement.create :code_region=>"82", :code=>"69", :nom=>"Rhône"
    Departement.create :code_region=>"43", :code=>"70", :nom=>"Haute-Saône"
    Departement.create :code_region=>"26", :code=>"71", :nom=>"Saône-et-Loire"
    Departement.create :code_region=>"52", :code=>"72", :nom=>"Sarthe"
    Departement.create :code_region=>"82", :code=>"73", :nom=>"Savoie"
    Departement.create :code_region=>"82", :code=>"74", :nom=>"Haute-Savoie"
    Departement.create :code_region=>"11", :code=>"75", :nom=>"Paris"
    Departement.create :code_region=>"23", :code=>"76", :nom=>"Seine-Maritime"
    Departement.create :code_region=>"11", :code=>"77", :nom=>"Seine-et-Marne"
    Departement.create :code_region=>"11", :code=>"78", :nom=>"Yvelines"
    Departement.create :code_region=>"54", :code=>"79", :nom=>"Deux-Sèvres"
    Departement.create :code_region=>"22", :code=>"80", :nom=>"Somme"
    Departement.create :code_region=>"73", :code=>"81", :nom=>"Tarn"
    Departement.create :code_region=>"73", :code=>"82", :nom=>"Tarn-et-Garonne"
    Departement.create :code_region=>"93", :code=>"83", :nom=>"Var"
    Departement.create :code_region=>"93", :code=>"84", :nom=>"Vaucluse"
    Departement.create :code_region=>"52", :code=>"85", :nom=>"Vendée"
    Departement.create :code_region=>"54", :code=>"86", :nom=>"Vienne"
    Departement.create :code_region=>"74", :code=>"87", :nom=>"Haute-Vienne"
    Departement.create :code_region=>"41", :code=>"88", :nom=>"Vosges"
    Departement.create :code_region=>"26", :code=>"89", :nom=>"Yonne"
    Departement.create :code_region=>"43", :code=>"90", :nom=>"Territoire de Belfort"
    Departement.create :code_region=>"11", :code=>"91", :nom=>"Essonne"
    Departement.create :code_region=>"11", :code=>"92", :nom=>"Hauts-de-Seine"
    Departement.create :code_region=>"11", :code=>"93", :nom=>"Seine-Saint-Denis"
    Departement.create :code_region=>"11", :code=>"94", :nom=>"Val-de-Marne"
    Departement.create :code_region=>"11", :code=>"95", :nom=>"Val-d'Oise"

    #lien entre régions et departements par l'id en fonction de la chaîne code_region (temporaire)
    regions = Region.all
    regions.each do |region|
      Departement.update_all ['region_id = ?', region.id], ['code_region = ?', region.code]
    end
    #suppression du code_région temporaire
    remove_column :departements, :code_region
  end

  def self.down
    drop_table :departements
  end
end
