require 'rails_helper'

RSpec.describe CsvUploaderService, type: :service do
  describe '#process' do
    let(:valid_users) { fixture_file_upload('valid_users.csv', 'text/csv') }
    let(:invalid_users) { fixture_file_upload('invalid_users.csv', 'text/csv') }
    let(:invalid_csv) { fixture_file_upload('invalid_csv.csv', 'text/csv') }

    it "processes valid CSV file" do
      service = CsvUploaderService.new(valid_users)
      results = service.process

      expect(results.count).to eq(2)
      expect(results.first[:result]).to eq("Success")
      expect(results.second[:result]).to eq("Success")
    end

    it "processes invalid CSV file" do
      service = CsvUploaderService.new(invalid_users)
      results = service.process

      expect(results.count).to eq(4)
      expect(results.first[:result]).to match(/Error:/)
      expect(results.second[:result]).to match(/Error:/)
      expect(results.third[:result]).to match(/Error:/)
      expect(results.last[:result]).to match(/Error:/)
    end

    it "rescue if MalformedCSVError" do
      service = CsvUploaderService.new(invalid_csv)
      results = service.process

      expect(results.count).to eq(2)
      expect(results.first[:result]).to match(/Error: Name can't be blank, Password can't be blank/)
      expect(results.second[:result]).to match(/Error parsing CSV file: : New line must be <\"\\r\"> not <\"\\n\"> in line 3./)
    end
  end
end
