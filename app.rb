require 'sinatra'
require 'omniauth'
require 'omniauth-fitbit'
require 'multi_json'
require 'haml'
require 'fitgem'
require 'date'
require 'json'
require_relative 'app/models/user'
require_relative 'app/helpers/view_helpers'

class QuantifyMeApp < Sinatra::Base
  enable :sessions

  use OmniAuth::Builder do
    provider :fitbit, ENV['FITBIT_CONSUMER_KEY'], ENV['FITBIT_CONSUMER_SECRET']
  end

  get '/' do
    haml :index
  end

  get '/macros/:from_date/:to_date' do
    from_date = Date.parse(params['from_date'])
    to_date = Date.parse(params['to_date'])

    food_log = []
    until from_date > to_date do
      food_log << session[:user].fitbit_data.foods_on_date(from_date)['summary'].merge({'date' => from_date})
      from_date+=1
    end
    food_log.to_json
  end

  get '/body/:from_date/:to_date' do
    from_date = Date.parse(params['from_date'])
    to_date = Date.parse(params['to_date'])

    fat = session[:user].fitbit_data.data_by_time_range('/body/fat', base_date: from_date, end_date: to_date)
    weight = session[:user].fitbit_data.data_by_time_range('/body/weight', base_date: from_date, end_date: to_date)

    fat['body-fat'].zip(weight['body-weight']).map do |fat_percentage, body_weight|
      date = fat_percentage['dateTime']
      fat_weight = body_weight['value'].to_f/100 * fat_percentage['value'].to_f
      lean_weight = body_weight['value'].to_f - fat_weight
      { date: date, fat_weight: fat_weight, lean_weight: lean_weight }
    end.to_json
  end

  get '/logout' do
    session.delete :user
    redirect to('/')
  end

  get '/auth/fitbit/callback' do
    user = User.from_omniauth(request.env['omniauth.auth'])
    session[:user] = user
    redirect to('/')
  end

  helpers do
    include ViewHelpers
  end
end
