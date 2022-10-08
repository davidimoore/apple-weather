describe CurrentTemperatureReporter do
  subject { described_class.new(url: url).perform }

  context "with valid observation stations list url" do
    let(:url) { "https://api.weather.gov/gridpoints/MTR/85,106/stations" }

    it "returns the postal code, longitude and latitude for the address" do
      VCR.use_cassette("temperature reporter valid request", record: :once) do
        expect(subject).to eq({"farenheit"=>54})
      end
    end
  end

  context "with an invalid request" do
    let(:url) { "asdf" }

    it "returns an error response" do
      expect { subject }.to raise_exception(described_class::CurrentTemperatureError)
    end
  end
end