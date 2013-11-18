require 'rubygems'
require 'httparty'
require 'json'
require 'uri'

require_relative "life360/version"
require_relative "life360/members"
require_relative "life360/places"

module Life360
  class Client

    attr_accessor :access_token

    def initialize(config={})

      @access_token = config[:access_token]
      @endpoint_url = config[:endpoint_url] || "https://api.life360.com/v3"

      @headers = { "Authorization" => "Bearer #{@access_token}" }

    end

    def request(url)
      request = HTTParty.get("#{@endpoint_url}/#{url}.json", headers: @headers) rescue nil
      result  = JSON.parse(request.body) rescue nil

      result
    end

  end
end
