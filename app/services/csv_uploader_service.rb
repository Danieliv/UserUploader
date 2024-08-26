require 'csv'

class CsvUploaderService
  def initialize(file)
    @file = file
    @results = []
  end

  def process
    return @results unless @file.present?

    begin
      CSV.foreach(@file.path, headers: true, row_sep: :auto) do |row|
        user = User.new(name: row['name'], password: row['password'])

        if user.save
          @results << { name: row['name'], result: "Success" }
        else
          @results << { name: row['name'], result: "Error: #{user.errors.full_messages.join(', ')}" }
        end
      end
    rescue CSV::MalformedCSVError => e
      @results << { result: "Error parsing CSV file: : #{e.message}" }
    end

    @results
  end
end
