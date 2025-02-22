module CouncillorPopolo
  class CSVValidator
    STANDARD_HEADERS = [
      "name",
      "start_date",
      "end_date",
      "executive",
      "council",
      "council_website",
      "id",
      "email",
      "phone",
      "image",
      "party",
      "source",
      "ward"
    ]

    attr_reader :csv
    attr_reader :path

    def initialize(path)
      @path = path
      @csv = CSV.read(path, headers: :true)
    end

    def validate
      has_unique_councillor_ids? && has_standard_headers?
    end

    def has_standard_headers?
      if csv.headers.eql? STANDARD_HEADERS
        true
      else
        error_message = "CSV #{path} has non standard headers #{csv.headers}, should be #{STANDARD_HEADERS}"
        raise NonStandardHeadersError, error_message
      end
    end

    def has_unique_councillor_ids?
      if duplicate_councillor_ids.none?
        true
      else
        error_message = duplicate_councillor_ids.map do |id|
          "There are multiple rows with the id #{id} in #{path}"
        end.join(", ")

        raise DuplicateCouncillorsError, error_message
      end
    end

    def duplicate_councillor_ids
      ids = []

      if csv.values_at("id").count != csv.values_at("id").uniq.count
        ids = csv.values_at("id").flatten.select do |id|
          id unless csv.values_at("id").flatten.one? {|id2| id.eql? id2}
        end.uniq
      end

      ids
    end
  end
end
