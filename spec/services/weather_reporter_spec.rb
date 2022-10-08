describe WeatherReporter do
  subject { described_class.new(address: address).perform }

  before do
    ENV["RAILS_ENV"] = "test"
  end

  context "with valid request" do
    let(:address) { "1600 Pennsylvania Ave NW, Washington DC" }

    it "returns the current temperature" do
      VCR.use_cassette("weather reporter valid request", record: :once) do
        expect(subject[:cached]).to eq(false)
        expect(subject[:current_temperature]).to eq({ "farenheit" => 58 })
        expect(subject[:forecast]).
          to eq(
               [{ "day" => "This Afternoon",
                  "date" => "10/08",
                  "icon" => "https://api.weather.gov/icons/land/day/sct?size=medium",
                  "temperature" => 61,
                  "detailed_forecast" => "Mostly sunny, with a high near 61. Northwest wind around 10 mph, with gusts as high as 20 mph." },
                { "day" => "Tonight", "date" => "10/08", "icon" => "https://api.weather.gov/icons/land/night/skc?size=medium", "temperature" => 41, "detailed_forecast" => "Clear, with a low around 41. West wind 1 to 8 mph." },
                { "day" => "Sunday", "date" => "10/09", "icon" => "https://api.weather.gov/icons/land/day/skc?size=medium", "temperature" => 65, "detailed_forecast" => "Sunny, with a high near 65. West wind 2 to 6 mph." },
                { "day" => "Sunday Night", "date" => "10/09", "icon" => "https://api.weather.gov/icons/land/night/skc?size=medium", "temperature" => 44, "detailed_forecast" => "Clear, with a low around 44. West wind around 2 mph." },
                { "day" => "Columbus Day", "date" => "10/10", "icon" => "https://api.weather.gov/icons/land/day/skc?size=medium", "temperature" => 68, "detailed_forecast" => "Sunny, with a high near 68. Northwest wind around 5 mph." },
                { "day" => "Monday Night", "date" => "10/10", "icon" => "https://api.weather.gov/icons/land/night/skc?size=medium", "temperature" => 46, "detailed_forecast" => "Clear, with a low around 46." },
                { "day" => "Tuesday", "date" => "10/11", "icon" => "https://api.weather.gov/icons/land/day/skc?size=medium", "temperature" => 70, "detailed_forecast" => "Sunny, with a high near 70." },
                { "day" => "Tuesday Night", "date" => "10/11", "icon" => "https://api.weather.gov/icons/land/night/sct?size=medium", "temperature" => 49, "detailed_forecast" => "Partly cloudy, with a low around 49." },
                { "day" => "Wednesday", "date" => "10/12", "icon" => "https://api.weather.gov/icons/land/day/sct?size=medium", "temperature" => 70, "detailed_forecast" => "Mostly sunny, with a high near 70." },
                { "day" => "Wednesday Night", "date" => "10/12", "icon" => "https://api.weather.gov/icons/land/night/sct?size=medium", "temperature" => 55, "detailed_forecast" => "Partly cloudy, with a low around 55." },
                { "day" => "Thursday",
                  "date" => "10/13",
                  "icon" => "https://api.weather.gov/icons/land/day/rain_showers/rain_showers,40?size=medium",
                  "temperature" => 72,
                  "detailed_forecast" => "A chance of rain showers after 8am. Partly sunny, with a high near 72. Chance of precipitation is 40%." },
                { "day" => "Thursday Night",
                  "date" => "10/13",
                  "icon" => "https://api.weather.gov/icons/land/night/rain_showers,50?size=medium",
                  "temperature" => 54,
                  "detailed_forecast" => "A chance of rain showers. Mostly cloudy, with a low around 54. Chance of precipitation is 50%." },
                { "day" => "Friday",
                  "date" => "10/14",
                  "icon" => "https://api.weather.gov/icons/land/day/rain_showers,30/rain_showers?size=medium",
                  "temperature" => 64,
                  "detailed_forecast" => "A chance of rain showers before 2pm. Mostly sunny, with a high near 64. Chance of precipitation is 30%." },
                { "day" => "Friday Night", "date" => "10/14", "icon" => "https://api.weather.gov/icons/land/night/few?size=medium", "temperature" => 47, "detailed_forecast" => "Mostly clear, with a low around 47." }]
             )
      end
    end
  end

  context "with an invalid request" do
    let(:address) { "asdf" }

    it "raises an error" do
      VCR.use_cassette("weather reporter invalid request", record: :once) do
        expect { subject }.to raise_exception(described_class::WeatherReporterError)
      end
    end
  end
end