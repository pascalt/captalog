ELEMENTS_DIR            = "#{Rails.root.to_s}/public#{"/test" if Rails.env.test?}/elements"
ELEMENTS_URL            = "#{"/test" if Rails.env.test?}/elements"
CARTES_DIR              = "/cartes"
PHOTOS_DIR              = "/photos"
ORIGINALES_DIR          = "originale"
DEFINITIVES_DIR         = "def"
VIGNETTES_DIR           = "vignette"
WEB_DIR                 = "web"

PHOTOS_ORIGINALES_DIR   = "#{PHOTOS_DIR}/#{ORIGINALES_DIR} "
PHOTOS_DEFINITIVES_DIR  = "#{PHOTOS_DIR}/#{DEFINITIVES_DIR}"
PHOTOS_VIGNETTES_DIR    = "#{PHOTOS_DIR}/#{VIGNETTES_DIR}"
PHOTOS_WEB_DIR          = "#{PHOTOS_DIR}/#{WEB_DIR}"


