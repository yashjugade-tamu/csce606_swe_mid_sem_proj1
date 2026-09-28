# frozen_string_literal: true

module JobTrack
  # Displays the terminal menu and routes the user's menu selections.
  class CLI
    # Menu actions available to the user in the main terminal interface.
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

    # Injectable streams support normal terminals and isolated acceptance tests.
    def initialize(manager:, input: $stdin, output: $stdout)
      @manager = manager
      @input = input
      @output = output
    end

    # Runs the interactive program loop until the user exits.
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

    # Displays every numbered option in the main menu.
    def display_main_menu
      @output.puts 'JobTrack Main Menu'
      MENU_OPTIONS.each do |number, (label, _action)|
        @output.puts "#{number}. #{label}"
      end
    end

    # Normalizes surrounding whitespace while preserving end-of-input as nil.
    def read_selection
      @output.print 'Choose an option: '
      @input.gets&.strip
    end

    # Confirms and dispatches valid choices while keeping expected errors in the loop.
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

    # Asks for application details and creates a new record in the manager.
    def add_application
      application = @manager.add_application(
        company: prompt('Company'),
        position: prompt('Position'),
        application_date: prompt('Application date (YYYY-MM-DD)'),
        status: prompt('Status (Applied/Interview/Offer/Rejected)')
      )
      @output.puts "Application ##{application.id} added successfully."
    end

    # Reuses manager formatting so View and Search display identical table columns.
    def view_applications
      @manager.print_applications(
        @manager.read_all_applications,
        output: @output,
        empty_message: 'No applications found.'
      )
    end

    # Prompts for a search field and value, then prints only matching records.
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

    #  Prompts for an ID and the new status, then updates an application's status using its unique ID.
    def update_application_status
      application = @manager.update_application_status(
        prompt('Application ID'),
        prompt('New status (Applied/Interview/Offer/Rejected)')
      )
      @output.puts "Application ##{application.id} status updated to #{application.status}."
    end

    # Prompts for an ID and confirms the record removed by the manager.
    def delete_application
      application = @manager.delete_application(prompt('Application ID'))
      @output.puts "Application ##{application.id} deleted successfully."
    end

    # Prints every status count along with the total number of applications.
    def application_statistics
      statistics = @manager.application_statistics
      @output.puts "Total Applications: #{statistics[:total]}"
      statistics[:status_counts].each do |status, count|
        @output.puts "#{status}: #{count}"
      end
    end

    # Prompts for an export path and saves all applications to a CSV file.
    def export_applications_to_csv
      custom_path = prompt('Export path (press Enter for default Downloads folder)')
      exported_path = @manager.export_to_csv(custom_path)
      @output.puts "CSV export saved to: #{exported_path}"
    end

    # Reads one line of input from the user after displaying a prompt.
    def prompt(label)
      @output.print "#{label}: "
      @input.gets&.chomp
    end
  end
end
