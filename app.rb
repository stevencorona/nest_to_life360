require './nest.rb'

NEST = NestThermostat::Nest.new({email: ENV["NEST_EMAIL"], password: ENV["NEST_PASSWORD"]})
DEVICES = NEST.find_devices
TOKEN = ENV["LIFE360_TOKEN"]
CIRCLE_ID = ENV["LIFE360_CIRCLE"]
PLACE_ID  = ENV["LIFE360_PLACE"]

class NestTo360App < Sinatra::Application

  get '/' do
    erb :index
  end

  post '/webhook' do

    @life360 = Life360.new
    status = @life360.members_in_place?

    set_away = true

    status.each do |user, is_home|
      if is_home == true
        set_away = false
      end
    end

    NEST.away = set_away

    "Setting NEST to Away? #{set_away}"    

  end

end

# a poor excuse for a life360 api ruby wrapper
class Life360

  def endpoint(url)
    request = HTTParty.get("https://api.life360.com/v3#{url}.json", headers: {"Authorization" => "Bearer #{TOKEN}"}) rescue nil
    result = JSON.parse(request.body) rescue nil

    result
  end

  def members

    endpoint("/circles/#{CIRCLE_ID}/members")

  end

  def place

    endpoint("/circles/#{CIRCLE_ID}/places/#{PLACE_ID}")

  end

  def members_in_place?()

    members = self.members
    place = self.place

    result = {}

    members["members"].each do |member|

      in_place = false

      distance_from_place = haversine(member["location"]["latitude"].to_f, member["location"]["longitude"].to_f,
        place["latitude"].to_f, place["longitude"].to_f)

      if (distance_from_place <= place["radius"].to_i)
        in_place = true
      end

      result[member["id"]] = in_place

    end

    result

  end

end

# Grabbed this from here:
# http://codingandweb.blogspot.com/2012/04/calculating-distance-between-two-points.html

def haversine(lat1, long1, lat2, long2)
  dtor = Math::PI/180
  r = 6378.14*1000
 
  rlat1 = lat1 * dtor 
  rlong1 = long1 * dtor 
  rlat2 = lat2 * dtor 
  rlong2 = long2 * dtor 
 
  dlon = rlong1 - rlong2
  dlat = rlat1 - rlat2
 
  a = power(Math::sin(dlat/2), 2) + Math::cos(rlat1) * Math::cos(rlat2) * power(Math::sin(dlon/2), 2)
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  d = r * c
 
  return d
end

def power(num, pow)
num ** pow
end
