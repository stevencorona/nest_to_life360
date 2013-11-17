require 'nest_thermostat'
# Monkeypatch nest_thermostat gem to support multiple devices

module NestThermostat
  class Nest

    # This method is completely monkey patched. Sorry X_X
    def status
      request = HTTParty.get("#{self.transport_url}/v2/mobile/user.#{self.user_id}", headers: self.headers) rescue nil
      result = JSON.parse(request.body) rescue nil

      self.structure_id ||= result['user'][user_id]['structures'][0].split('.')[1]
      self.device_id    ||= result['structure'][structure_id]['devices'][0].split('.')[1]

      result
    end

    # Find the devices avaliable
    def find_devices
      request = HTTParty.get("#{self.transport_url}/v2/mobile/user.#{self.user_id}", headers: self.headers) rescue nil
      result = JSON.parse(request.body) rescue nil

      devices = []

      result['structure'][structure_id]['devices'].each do |d|
        devices << d.split('.')[1]
      end

      devices

    end

  end
end
