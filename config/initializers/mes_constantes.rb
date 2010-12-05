URL_VILLAGES          = "/#{"test/" if Rails.env.test?}villages"
DIR_VILLAGES          = "#{Rails.root.to_s}/public#{URL_VILLAGES}"
DIR_SUPPR             = "#{Rails.root.to_s}/public/#{"test/" if Rails.env.test?}_suppr"
FIC_EXT               = {:ori => '_ori', :def => '_def', :vig => '_vig', :web => '_web'}
DIR_TYPE_PHOTO        = {:ori => 'originale', :def => 'def', :vig => 'vignette', :web => 'web'}
DIR_PHOTOS            = 'photos'
DIR_PHOTOS_DESACTI    = '_desactivees'
DIR_VILLAGES_DESACTI  = '_desactives'
DIR_CARTES            = 'cartes'
LARGEUR               = {:vig => '100', :web => '320'}
