
module JobTrack
  # Owns the in-memory application collection and application business actions.
  class ApplicationManager
    attr_reader :applications

    def initialize
      @applications = []
      @next_id = 1
    end

    def add_application(company:, position:, application_date:, status:)
      application = Application.new(
        id: @next_id,
        company: company,
        position: position,
        application_date: application_date,
        status: status
      )
      applications << application
      @next_id += 1
      application
    end
  end
end
