module WeatherService
  require "uri"
  require "net/http"

  BASE_URL = "https://api.weather.gov"

  def request(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req["User-Agent"] = user_agent
    req["Accept"] = "application/geo+json"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    return nil if response.is_a?(Net::HTTPError)

    JSON.parse(response&.body)
  end

  def url(path)
    "#{BASE_URL}/#{path}"
  end

  def user_agent
    "(apple.com, davidimoore@gmail.com)"
  end
end