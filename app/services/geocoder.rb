class Geocoder
  require "uri"
  require "net/http"

  class GeocoderError < StandardError
    def initialize(msg="There was an error with the provided address")
      super(msg)
    end
  end

  BASE_URL = "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress"

  def initialize(address:)
    @address = address
  end

  def perform
    begin
      response = fetch_geocode_data
    rescue StandardError
      raise GeocoderError
    end

    parse_response(response)
  end

  private

  def fetch_geocode_data
    uri = URI(BASE_URL)
    params = { address: @address, benchmark: "2020", format: "json" }
    uri.query = URI.encode_www_form(params)
    Net::HTTP.get_response(uri)
  end

  def parse_response(response)
    raise GeocoderError if response.is_a?(Net::HTTPError)

    response_body = JSON.parse(response.body)
    address_match = response_body&.dig("result", "addressMatches", 0)

    raise GeocoderError if address_match.nil?

    coordinates = address_match.dig("coordinates")
    {
      postal_code: address_match.dig("addressComponents", "zip"),
      longitude: parse_coordinate(coordinates.dig("x")),
      latitude: parse_coordinate(coordinates.dig("y"))
    }
  end

  private

  def parse_coordinate(coordinate)
    truncation_amount = 4
    coordinate.truncate(truncation_amount)
  end
end