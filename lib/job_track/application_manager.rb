
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

      unless VALID_SEARCH_FIELDS.include?(search_field)
        puts 'Invalid search field.'
        return []
      end

      if search_value.empty?
        puts 'Invalid search input. Please provide a non-empty search value.'
        return []
      end

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

      if results.empty?
        puts 'No matching applications found.'
        return []
      end

      print_applications(results)
      results
    end

    def print_applications(applications = read_all_applications)
      if applications.empty?
        puts 'No applications found.'
        return
      end

      puts 'ID | Company | Position | Application Date | Status'
      applications.each do |application|
        date = application[:application_date].respond_to?(:strftime) ?
          application[:application_date].strftime('%Y-%m-%d') :
          application[:application_date]

        puts "#{application[:id]} | #{application[:company]} | #{application[:position]} | #{date} | #{application[:status]}"
      end
    end
  end
end
