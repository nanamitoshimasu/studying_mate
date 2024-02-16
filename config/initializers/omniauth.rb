Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV.fetch('GITHUB_ID'), ENV.fetch('GITHUB_SECRET'), scope: 'user:email'
end
