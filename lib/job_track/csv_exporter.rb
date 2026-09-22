require 'csv'

module JobTrack
  class CSVExporter
    HEADERS = %w[id company position application_date status].freeze

    def export(applications, output_path: nil)
      resolved_path = resolve_output_path(output_path)
      directory = File.dirname(resolved_path)
      Dir.mkdir(directory) unless directory == '.' || Dir.exist?(directory)

      rows = [HEADERS]
      applications.each do |application|
        rows << extract_row(application)
      end

      CSV.open(resolved_path, 'w') do |csv|
        rows.each { |row| csv << row }
      end

      resolved_path
    end

    private

    def resolve_output_path(output_path)
      candidate = output_path.to_s.strip
      candidate = default_path if candidate.empty?
      validate_output_path!(candidate)
      candidate
    end

    def default_path
      downloads_dir = if Gem.win_platform?
                        ENV['USERPROFILE'] || Dir.home
                      else
                        ENV['HOME'] || Dir.home
                      end

      File.join(downloads_dir, 'Downloads', 'applications_export.csv')
    end

    def validate_output_path!(path)
      raise ValidationError, 'Export path cannot be empty.' if path.to_s.strip.empty?

      resolved_path = path.to_s.strip
      directory = File.dirname(resolved_path)

      if directory == '.'
        return resolved_path
      end

      raise ValidationError, "Export directory does not exist: #{directory}" unless Dir.exist?(directory)
      raise ValidationError, 'Export path must point to a file, not a directory.' if File.directory?(resolved_path)

      resolved_path
    end

    def extract_row(application)
      if application.respond_to?(:to_h)
        details = application.to_h
      elsif application.is_a?(Hash)
        details = application
      else
        details = {
          id: application.id,
          company: application.company,
          position: application.position,
          application_date: application.application_date,
          status: application.status
        }
      end

      [
        details[:id] || details['id'],
        details[:company] || details['company'],
        details[:position] || details['position'],
        details[:application_date] || details['application_date'],
        details[:status] || details['status']
      ].map do |value|
        value.respond_to?(:strftime) ? value.strftime('%Y-%m-%d') : value
      end
    end
  end
end
