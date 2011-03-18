# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Inz::Application.initialize!
$countries = Carmen.countries
RCC_PUB = '6Ld_msISAAAAANjzH0673Gv1wCnnjqso5KKJ1-xA'
RCC_PRIV = '6Ld_msISAAAAAFHufpmBJeONxpk1B-T82NVE4EYe'
