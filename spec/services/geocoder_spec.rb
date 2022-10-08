describe Geocoder do
  subject { described_class.new(address: address).perform }

  context "with valid request" do
    let(:address) { "1600 Pennsylvania Ave NW, Washington DC" }

    it "returns the postal code, longitude and latitude for the address" do
      VCR.use_cassette("geocoder valid request", record: :once) do
        expect(subject).to eq({ latitude: 38.8987, longitude: -77.0353, postal_code: "20500" })
      end
    end
  end

  context "with an invalid request" do
    let(:address) { "asdf" }

    it "returns an error response" do
      VCR.use_cassette("geocoder invalid request", record: :once) do
        expect { subject }.to raise_exception(described_class::GeocoderError)
      end
    end
  end
end