require_relative 'lib/nest.rb'
require_relative 'lib/life360'
require_relative 'lib/haversine'

class Nest360 < Sinatra::Application

  set :life360, Life360::Client.new(access_token: ENV["LIFE360_TOKEN"])
  set :nest,    NestThermostat::Nest.new({email: ENV["NEST_EMAIL"], password: ENV["NEST_PASSWORD"]})

  set :life360_circle, ENV["LIFE360_CIRCLE"]
  set :life360_place,  ENV["LIFE360_PLACE"]

  get '/' do

    @life360 = settings.life360
    @nest    = settings.nest

    erb :index
  end

  post '/webhook' do

    @life360 = settings.life360
    @nest    = settings.nest

    status = @life360.members_in_place?(settings.life360_circle, settings.life360_place)

    set_away = true

    status.each do |user, is_home|
      if is_home == true
        set_away = false
      end
    end

    @nest.away = set_away

    "Setting NEST to Away? #{set_away}"    

  end

end
