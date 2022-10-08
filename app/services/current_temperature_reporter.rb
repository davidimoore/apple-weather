class CurrentTemperatureReporter
  include WeatherService

  class CurrentTemperatureError < StandardError
    def initialize(msg = "There was an error when fetching the current temperature")
      super(msg)
    end
  end

  def initialize(url:)
    @url = url
  end

  def perform
    result = nil

    begin
      response = request(@url)
      observation_stations = response&.dig("features")
      observation_stations.each do |observation_station|
        observation_station_id = observation_station.dig("properties", "stationIdentifier")
        observation_response = request(url("stations/#{observation_station_id}/observations/latest"))
        temperature_celcius = observation_response&.dig("properties", "temperature", "value")
        if temperature_celcius.present?
          temperature_farenheit = temperature_celcius && (temperature_celcius * 9 / 5) + 32
          result = {
            farenheit: round_temp(temperature_farenheit)
          }
          break
        end
      end
    rescue StandardError
      raise CurrentTemperatureError.new
    end


    raise CurrentTemperatureError.new if result.nil?

    result.with_indifferent_access
  end

  private

  def round_temp(temp)
    temp.round(0)
  end
end