class User
  attr_accessor :provider, :uid, :username, :full_name, :oauth_token, :oauth_secret, :remember_me

  def self.from_omniauth(auth)
    user = User.new
    user.provider     = auth.provider
    user.uid          = auth.uid
    user.username     = auth.info.nickname
    user.full_name     = auth.info.full_name
    user.oauth_token  = auth['credentials']['token']
    user.oauth_secret = auth['credentials']['secret']
    user.remember_me  = true

    user
  end

  def fitbit_data
    @client ||= Fitgem::Client.new(
                :consumer_key => ENV['FITBIT_CONSUMER_KEY'],
                :consumer_secret => ENV['FITBIT_CONSUMER_SECRET'],
                :token => oauth_token,
                :secret => oauth_secret,
                :user_id => uid,
                :ssl => true
              )
  end
end
