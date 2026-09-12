require 'date'

module JobTrack
  # Raised when user-supplied application data violates a business rule.
  class ValidationError < StandardError; end

  # Represents one validated job or internship application.
  class Application
    STATUSES = ["Applied", "Interview", "Offer", "Rejected"]

    attr_reader :id, :company, :position, :application_date, :status

    def initialize(id:, company:, position:, application_date:, status:)
      @id = validate_id(id)
      @company = validate_required_text(company, 'Company')
      @position = validate_required_text(position, 'Position')
      @application_date = validate_date(application_date)
      @status = validate_status(status)
    end

    private

    def validate_id(value)
      id = Integer(value)
      raise ValidationError, 'Application ID must be positive' unless id.positive?

      id
    rescue ArgumentError, TypeError
      raise ValidationError, 'Application ID must be a whole number'
    end

  end
    
end
