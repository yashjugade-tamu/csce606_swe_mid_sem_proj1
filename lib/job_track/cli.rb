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
      '7' => ['Exit', :exit]
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
    end

    def add_application
      prompt('Company')
      prompt('Position')
      prompt('Application date (YYYY-MM-DD)')
      prompt('Status (Applied/Interview/Offer/Rejected)')
    end

    def view_applications
      nil
    end

    def search_applications
      prompt('Search field (company/position/status)')
      prompt('Search value')
    end

    def update_application_status
      prompt('Application ID')
      prompt('New status (Applied/Interview/Offer/Rejected)')
    end

    def delete_application
      prompt('Application ID')
    end

    def application_statistics
      nil
    end

    def prompt(label)
      @output.print "#{label}: "
      @input.gets&.chomp
    end
  end
end
