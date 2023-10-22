require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  STARSHIPIT_KEY = "8f8b79ececf743479d8610ee2584c539"
  STARSHIPIT_SUBSCRIPTION_KEY = "41e955ba024b41e4baf1c97b25941367"

  PRICE_TIER = [0.05,0.1,0.15,0.2]

  WEIGHT_RANGE = [
    {'low' => 0, 'high' => 0.5},
    {'low' => 0.501, 'high' => 1},
    {'low' => 1.01, 'high' => 2},
    {'low' => 2.501, 'high' => 3},
    {'low' => 3.501, 'high' => 4},
    {'low' => 4.501, 'high' => 5},
    {'low' => 5.501, 'high' => 7},
    {'low' => 7.501, 'high' => 10},
    {'low' => 10.501, 'high' => 15},
    {'low' => 15.501, 'high' => 22},
    {'low' => 22, 'high' => 9999}
  ]

  CARRIER_PRODUCT_CODES = [
    {'name' => 'AusPost eParcel', 'code' => '3D55'}
    #{'name' => 'AusPost Express Post', 'code' => ''}
  ]

  ORDER_STATUS = {
    'fetched' => 0,
    'calculated' => 1,
    'billed' => 2
  }

  POST_ZONE = [
    {'zone'=> 'Q0', 'postcodes'=> [*4000..4018,*4029..4068,*4072..4123,*4127..4129,*4131..4132,*4151..4164,*4169..4182,*4205..4206,*9000..9725]},             
    {'zone'=> 'S0', 'postcodes'=> [*5000..5113,*5115..5117,*5125..5130,*5158..5169,*5800..5999]},
    {'zone'=> 'W0', 'postcodes'=> [*6000..6030,6036,*6050..6066,6069,6076,*6090..6110,*6112..6120,*6147..6160,*6162..6175,6180,*6182..6206,6210,*6800..6990,*6992..6996]},             
    {'zone'=> 'T0', 'postcodes'=> [*7000..7019,*7050..7053,*7055..7108,7172,*7248..7254,*7258..7329,*7800..7999]},
    {'zone'=> 'N1', 'postcodes'=> [*2080..2084,2108,2157,2159,2173,*2230..2231,*2508..2514,*2555..2556,*2560..2563,*2568..2574,*2745..2746,*2752..2758,2765,2775,*2778..2786]},             
    {'zone'=> 'GF', 'postcodes'=> [*2250..2263]},             
    {'zone'=> 'WG', 'postcodes'=> [*2500..2507,*2515..2532]},              
    {'zone'=> 'NC', 'postcodes'=> [*2282..2310]},            
    {'zone'=> 'CB', 'postcodes'=> [*200..299,*2600..2620,*2900..2920]},            
    {'zone'=> 'N2', 'postcodes'=> [*2264..2281,*2311..2484,*2487..2499,*2533..2554,*2575..2599,*2621..2639,*2642..2647,*2649..2707,*2710..2714,2716,*2720..2730,*2787..2879]},            
    {'zone'=> 'N3', 'postcodes'=> [*1936..1999,*2640..2641,*2708..2709]},            
    {'zone'=> 'N4', 'postcodes'=> [*2485..2486]},           
    {'zone'=> 'V1', 'postcodes'=> [3063,*3099..3100,3139,*3335..3341,*3427..3443,*3750..3799,*3802..3811,*3910..3920,*3926..3944,*3975..3978,*3980..3983]},             
    {'zone'=> 'GL', 'postcodes'=> [*3211..3220]},            
    {'zone'=> 'BR', 'postcodes'=> [3350,*3353..3356]},             
    {'zone'=> 'V2', 'postcodes'=> [2648,2715,*2717..2719,*2731..2739,*3221..3334,*3342..3349,*3351..3352,*3357..3426,*3444..3688,*3691..3749,*3812..3909,*3921..3925,*3945..3974,3979,*3984..3999]},            
    {'zone'=> 'V3', 'postcodes'=> [*3689..3690]},            
    {'zone'=> 'Q1', 'postcodes'=> [*4019..4028,*4069..4071,*4124..4126,4130,*4133..4150,*4165..4168,*4183..4204,*4207..4209,*4270..4299,*4500..4549]},           
    {'zone'=> 'GC', 'postcodes'=> [*4210..4224,*4226..4269,*9726..9919]},            
    {'zone'=> 'SC', 'postcodes'=> [*4550..4579]},            
    {'zone'=> 'IP', 'postcodes'=> [*4300..4308]},            
    {'zone'=> 'Q2', 'postcodes'=> [*4309..4453,*4580..4693]},            
    {'zone'=> 'Q3', 'postcodes'=> [*4454..4499,*4694..4802,*4804..4805,*9920..9960]},              
    {'zone'=> 'Q4', 'postcodes'=> [4803,*4806..4999,*9961..9998]},             
    {'zone'=> 'Q5', 'postcodes'=> [4225]},             
    {'zone'=> 'S1', 'postcodes'=> [5114,*5118..5124,*5131..5157,*5170..5200]},             
    {'zone'=> 'S2', 'postcodes'=> [*2880..2889,*5201..5749]},              
    {'zone'=> 'W1', 'postcodes'=> [*6031..6035,*6037..6049,*6067..6068,*6070..6075,*6077..6089,6111,*6121..6146,6161,*6176..6179,6181,*6207..6209,*6211..6214,6991,*6997..6999]},            
    {'zone'=> 'W2', 'postcodes'=> [*6215..6700]},             
    {'zone'=> 'W3', 'postcodes'=> [*6701..6797]},             
    {'zone'=> 'W4', 'postcodes'=> [*6798..6799]},             
    {'zone'=> 'T1', 'postcodes'=> [*7020..7049,7054,*7109..7150,*7155..7171,*7173..7247,*7255..7257,*7330..7799]},             
    {'zone'=> 'NT1', 'postcodes'=> [*800..802,*804..821,*828..851,*853..853,*860..861,*870..871,*873..879,*906..999]},  
    {'zone'=> 'NT2', 'postcodes'=> [*803..803, *822..827, *852..852, *854..859, *862..869, *872..872, *880..905]},            
    {'zone'=> 'NF', 'postcodes'=> [*2898..2899]},             
    {'zone'=> 'AAT', 'postcodes'=>[*7151..7154]}
  ]           
      

end
