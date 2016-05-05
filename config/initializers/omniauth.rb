OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['BUNDLE_FACEBOOK_ID'], ENV['BUNDLE_FACEBOOK_SECRET'], scope: 'email', info_fields: 'name,email,image'
  provider :twitter, ENV['BUNDLE_TWITTER_KEY'], ENV['BUNDLE_TWITTER_SECRET']
end
