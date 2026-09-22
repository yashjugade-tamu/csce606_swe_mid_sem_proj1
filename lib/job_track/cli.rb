# frozen_string_literal: true

module JobTrack
  # Displays the terminal menu and routes the user's menu selections.
  class CLI
    MENU_OPTIONS = {
      '1' => ['Add Application', :add_application],
      '2' => ['View Applications', :view_applications],
      '3' => ['Search Applications', :search_applications],
      '4' => ['Update Application Status', :update_application_status],
      '5' => ['Delete Application', :delete_application],
      '6' => ['Application Statistics', :application_statistics],
      '7' => ['Exit', :exit],
      '8' => ['Export Applications to CSV', :export_applications_to_csv]
    }.freeze

    def initialize(manager:, input: $stdin, output: $stdout)
      @manager = manager
      @input = input
      @output = output
    end

    def run
      loop do
        display_main_menu
        selection = read_selection
        break if selection.nil? || selection == '7'

        route(selection)
      end

      @output.puts 'Goodbye!'
    end

    private

    def display_main_menu
      @output.puts 'JobTrack Main Menu'
      MENU_OPTIONS.each do |number, (label, _action)|
        @output.puts "#{number}. #{label}"
      end
    end

    def read_selection
      @output.print 'Choose an option: '
      @input.gets&.strip
    end

    def route(selection)
      option = MENU_OPTIONS[selection]
      return @output.puts('Invalid menu selection. Please try again.') unless option

      label, action = option
      @output.puts "#{label} selected."
      send(action)
      @output.puts "#{label} completed."
    rescue ValidationError => e
      @output.puts "Error: #{e.message}"
    end

    def add_application
      application = @manager.add_application(
        company: prompt('Company'),
        position: prompt('Position'),
        application_date: prompt('Application date (YYYY-MM-DD)'),
        status: prompt('Status (Applied/Interview/Offer/Rejected)')
      )
      @output.puts "Application ##{application.id} added successfully."
    end

    def view_applications
      @manager.print_applications(
        @manager.read_all_applications,
        output: @output,
        empty_message: 'No applications found.'
      )
    end

    def search_applications
      field = prompt('Search field (company/position/status)')
      query = prompt('Search value')
      results = @manager.search_applications(query, field: field)
      @manager.print_applications(
        results,
        output: @output,
        empty_message: 'No matching applications found.'
      )
    end

    def update_application_status
      application = @manager.update_application_status(
        prompt('Application ID'),
        prompt('New status (Applied/Interview/Offer/Rejected)')
      )
      @output.puts "Application ##{application.id} status updated to #{application.status}."
    end

    def delete_application
      application = @manager.delete_application(prompt('Application ID'))
      @output.puts "Application ##{application.id} deleted successfully."
    end

    def application_statistics
      statistics = @manager.application_statistics
      @output.puts "Total Applications: #{statistics[:total]}"
      statistics[:status_counts].each do |status, count|
        @output.puts "#{status}: #{count}"
      end
    end

    def export_applications_to_csv
      custom_path = prompt('Export path (press Enter for default Downloads folder)')
      exported_path = @manager.export_to_csv(custom_path)
      @output.puts "CSV export saved to: #{exported_path}"
    end

    def prompt(label)
      @output.print "#{label}: "
      @input.gets&.chomp
    end
  end
end
