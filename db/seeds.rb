Project.create!([
  {name: "Trang Palm Oil Wastewater Treatment Project in Trang Province", short_description: "We have now made our third community climate offset, this time in Trang Palm Oil Wastewater Treatment Project in Trang Province, Thailand.", cdm_url: "https://offset.climateneutralnow.org/trang-palm-oil-wastewater-treatment-project-in-trang-province-thailand-3335-", image_url: "https://www.goclimate.com/blog/wp-content/uploads/2017/05/0000213_trang-palm-oil-wastewater-treatment-project-in-trang-province-thailand_550.jpeg", blog_url: "https://www.goclimate.com/blog/carbon-offset-investment-in-trang-palm-oil-wastewater-treatment-project/", longitude: "99.438056", latitude: "7.555", co2e: 50000, country: "Thailand", offset_type: "CDM", cost_in_sek: 228, date_bought: "2017-05-21 00:00:00", invoice_url: "https://www.goclimate.com/blog/wp-content/uploads/2017/05/invoice_1491461_2048.pdf", certificate_url: "https://www.goclimate.com/blog/wp-content/uploads/2017/05/1491461_2048.pdf"}
])

LifestyleCalculator.create!(
  countries: %w[SE],
  version: 1,
  home_options: [{"key"=> "house", "formula"=> "4314"}, {"key"=> "apartment", "formula"=> "4891"}],
  heating_options: [{"key"=> "electricity", "formula"=> "home * green_electricity"}, {"key"=> "district", "formula"=> "home * 0.0701"}, {"key"=> "airpump", "formula"=> "home * 0.28 * green_electricity + home * 0.72 * 0.5 * green_electricity"}, {"key"=> "geothermal", "formula"=> "home * 0.3 * green_electricity"}, {"key"=> "dont_know", "formula"=> "900"}],
  green_electricity_options: [{"key"=> "yes", "formula"=> "0.010"}, {"key"=> "no", "formula"=> "0.25076"}, {"key"=> "dont_know", "formula"=> "0.25076"}],
  food_options: [{"key"=> "vegan", "formula"=> "1054"}, {"key"=> "vegetarian", "formula"=> "1390"}, {"key"=> "pescetarian", "formula"=> "1427"}, {"key"=> "meat_low", "formula"=> "1704"}, {"key"=> "meat_medium", "formula"=> "2054"}, {"key"=> "meat_high", "formula"=> "2624"}],
  shopping_options: [{"key"=> "low", "formula"=> "505"}, {"key"=> "average", "formula"=> "1010"}, {"key"=> "high", "formula"=> "2010"}],
  car_type_options: [{"key"=> "petrol", "formula"=> "0.186"}, {"key"=> "diesel", "formula"=> "0.147"}, {"key"=> "etanol", "formula"=> "0.113"}, {"key"=> "biofuel", "formula"=> "0.039"}, {"key"=> "hvo_electric", "formula"=> "0.005"}, {"key"=> "no_car", "formula"=> "0"}],
  car_distance_unit: 'km',
  housing_formula: 'heating + if(heating_answer = "dont_know", 0, switch(home_answer, "house", 1852, "apartment", 1053) * green_electricity)',
  food_formula: 'food',
  car_formula: 'car_type*car_distance',
  flights_formula: '200*flight_hours',
  consumption_formula: 'shopping',
  public_formula: '980+2600'
)

LifestyleCalculator.create!(
  countries: nil,
  version: 1,
  region_options: nil,
  home_area_options: [{"key"=>"fifteen_sqm", "formula"=>"15*170"}, {"key"=>"twentyfive_sqm", "formula"=>"25*170"}, {"key"=>"fortytwo_sqm", "formula"=>"42*170"}, {"key"=>"sixty_sqm", "formula"=>"60*170"}, {"key"=>"eighty_sqm", "formula"=>"80*170"}],
  heating_options: [{"key"=>"heating_oil", "formula"=>"0.306"}, {"key"=>"natural_gas", "formula"=>"0.240"}, {"key"=>"electricity", "formula"=>"0.2958"}, {"key"=>"district", "formula"=>"0.295"}, {"key"=>"coal", "formula"=>"0.370"}, {"key"=>"biomass", "formula"=>"0.018"}, {"key"=>"dont_know", "formula"=>"0.240"}],
  green_electricity_options: [{"key"=>"yes", "formula"=>"0.010"}, {"key"=>"fifty_percent", "formula"=>"0.1529"}, {"key"=>"no", "formula"=>"0.2958"}, {"key"=>"dont_know", "formula"=>"0.2958"}],
  food_options: [{"key"=>"vegan", "formula"=>"1054"}, {"key"=>"vegetarian", "formula"=>"1390"}, {"key"=>"pescetarian", "formula"=>"1427"}, {"key"=>"meat_low", "formula"=>"1704"}, {"key"=>"meat_medium", "formula"=>"2054"}, {"key"=>"meat_high", "formula"=>"2624"}],
  shopping_options: [{"key"=> "low", "formula"=> "1498"}, {"key"=> "average", "formula"=> "2995"}, {"key"=> "high", "formula"=> "3995"}],
  car_type_options: [{"key"=>"petrol", "formula"=>"0.148"}, {"key"=>"diesel", "formula"=>"0.145"}, {"key"=>"hybrid_plugin", "formula"=>"0.049"}, {"key"=>"electric", "formula"=>"0.005"}, {"key"=>"no_car", "formula"=>"0"}], "car_distance_unit"=>"km",
  housing_formula: 'if(heating_answer = "electricity", green_electricity*home_area, home_area*0.8*heating+home_area*0.2*green_electricity)',
  food_formula: "food",
  car_formula: "car_type * car_distance",
  flights_formula: "200 * flight_hours",
  consumption_formula: "shopping",
  public_formula: "1240"
)

User.create!(
  id: 2,
  email: 'admin@example.com',
  password: 'adminadmin',
  admin: true
)

ActiveRecord::Base.connection.set_pk_sequence!(:users, 2)

Subscriptions::ReferralCode.create!(
  code: 'gofriends'
)
