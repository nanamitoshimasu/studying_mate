Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV.fetch('GITHUB_ID', nil), ENV.fetch('GITHUB_SECRET', nil), scope: 'user:email'
end
