module CouncillorPopolo
  class CSVValidator
    STANDARD_HEADERS = [
      "name",
      "start_date",
      "end_date",
      "executive",
      "council",
      "council website",
      "id",
      "email",
      "image",
      "party",
      "source",
      "ward"
    ]

    def self.validate(csv)
      if csv.headers.eql? STANDARD_HEADERS
        true
      else
        error_message = "CSV has non standard headers #{csv.headers}, should be #{STANDARD_HEADERS}"
        raise NonStandardHeadersError, error_message
      end
    end
  end
end
