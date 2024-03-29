require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  case Rails.env
  when 'development', 'test'
    config.storage = :file
    config.cache_storage = :file
  else
    config.storage :fog
    config.cache_storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory = 'yarumoribucket'
    config.asset_host = 'https://s3.ap-northeast-1.amazonaws.com/yarumoribucket'
    config.fog_public = false
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      region: 'ap-northeast-3',
      path_style: true
    }
  end
end
