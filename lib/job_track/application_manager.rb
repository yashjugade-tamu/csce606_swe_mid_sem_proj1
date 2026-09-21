
module JobTrack
  # Owns the in-memory application collection and application business actions.
  class ApplicationManager
    attr_reader :applications

    VALID_SEARCH_FIELDS = %w[company position status].freeze

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

    def update_application_status(application_id, new_status)
      normalized_id = Integer(application_id)
      application = applications.find { |candidate| candidate.id == normalized_id }
      raise ValidationError, "Application with ID #{application_id} was not found" unless application

      application.update_status(new_status)
    rescue ArgumentError, TypeError
      raise ValidationError, "Application with ID #{application_id} was not found"
    end

    def application_statistics
      status_counts = Application::STATUSES.to_h { |status| [status, 0] }
      applications.each { |application| status_counts[application.status] += 1 }

      {
        total: applications.length,
        status_counts: status_counts
      }
    end

    def read_all_applications
      @applications.map do |application|
        {
          id: application.id,
          company: application.company,
          position: application.position,
          application_date: application.application_date,
          status: application.status
        }
      end
    end

    def search_applications(query, field: 'company')
      search_field = field.to_s.strip
      search_value = query.to_s.strip

      raise ValidationError, 'Invalid search field.' unless VALID_SEARCH_FIELDS.include?(search_field)
      raise ValidationError, 'Search value cannot be empty.' if search_value.empty?

      matching_applications = @applications.select do |application|
        application_value = application.public_send(search_field).to_s.downcase
        application_value.include?(search_value.downcase)
      end

      results = matching_applications.map do |application|
        {
          id: application.id,
          company: application.company,
          position: application.position,
          application_date: application.application_date,
          status: application.status
        }
      end

      results
    end

    def print_applications(
      applications = read_all_applications,
      output: $stdout,
      empty_message: 'No applications found.'
    )
      if applications.empty?
        output.puts empty_message
        return
      end

      output.puts 'ID | Company | Position | Application Date | Status'
      applications.each do |application|
        date = application[:application_date].respond_to?(:strftime) ?
          application[:application_date].strftime('%Y-%m-%d') :
          application[:application_date]

        output.puts "#{application[:id]} | #{application[:company]} | #{application[:position]} | #{date} | #{application[:status]}"
      end
    end
  end
end
