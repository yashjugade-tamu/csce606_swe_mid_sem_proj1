require 'date'

module JobTrack
  # Raised when user-supplied application data violates a business rule.
  class ValidationError < StandardError; end

  # Represents one validated job or internship application.
  class Application
    # Allowed lifecycle states for each job application.
    STATUSES = ["Applied", "Interview", "Offer", "Rejected"]

    attr_reader :id, :company, :position, :application_date, :status

    # Creates a fully validated application record from the provided fields and business rules.
    def initialize(id:, company:, position:, application_date:, status:)
      @id = validate_id(id)
      @company = validate_required_text(company, 'Company')
      @position = validate_required_text(position, 'Position')
      @application_date = validate_date(application_date)
      @status = validate_status(status)
    end

    # Updates the status only after validation, preserving the prior value if the new status is invalid.
    def update_status(new_status)
      @status = validate_status(new_status)
      self
    end

    private

    # Converts a string or numeric ID into a positive integer and rejects invalid input.
    def validate_id(value)
      id = Integer(value)
      raise ValidationError, 'Application ID must be positive' unless id.positive?

      id
    rescue ArgumentError, TypeError
      raise ValidationError, 'Application ID must be a whole number'
    end

    # Trims required text fields and rejects blank values before storing the record.
    def validate_required_text(value, field_name)
      text = value.to_s.strip
      raise ValidationError, "#{field_name} cannot be empty" if text.empty?

      text
    end

    # Uses strict ISO 8601 parsing to ensure the date is correctly formatted and valid.
    def validate_date(value)
      date = Date.iso8601(value.to_s)
      raise ValidationError, 'Application date cannot be in the future' if date > Date.today

      date
    rescue Date::Error
      raise ValidationError, 'Application date must be a valid date in YYYY-MM-DD format'
    end

    # Matches the input to the canonical status list without case sensitivity.
    def validate_status(value)
      status = STATUSES.find { |candidate| candidate.casecmp?(value.to_s.strip) }
      raise ValidationError, "Status must be one of: #{STATUSES.join(', ')}" unless status

      status
    end
  end
end
