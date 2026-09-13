
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
