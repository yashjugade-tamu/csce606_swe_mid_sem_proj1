require_relative 'spec_helper'

describe JobTrack::CLI do
  subject(:cli) do
    described_class.new(
      manager: manager,
      input: input,
      output: output
    )
  end

  let(:manager) { JobTrack::ApplicationManager.new }
  let(:output) { StringIO.new }
  let(:input) { StringIO.new(input_text) }

  context 'when Exit is selected' do
    let(:input_text) { "7\n" }

    it 'displays every required main-menu operation' do
      cli.run

      expect(output.string).to include(
        'Add Application',
        'View Applications',
        'Search Applications',
        'Update Application Status',
        'Delete Application',
        'Application Statistics',
        'Exit'
      )
    end
  end

  context 'when an invalid selection is followed by Exit' do
    let(:input_text) { "invalid\n7\n" }

    it 'displays an error and returns to the main menu' do
      cli.run

      expect(output.string).to include('Invalid menu selection')
      expect(output.string.scan('JobTrack Main Menu').length).to eq(2)
    end
  end

  {
    '1' => {
      input: "1\nGoogle\nSoftware Engineer\n2026-09-20\nApplied\n7\n",
      messages: ['Add Application selected.', 'Company:', 'Position:',
                 'Application date (YYYY-MM-DD):',
                 'Status (Applied/Interview/Offer/Rejected):',
                 'Add Application completed.']
    },
    '2' => {
      input: "2\n7\n",
      messages: ['View Applications selected.', 'View Applications completed.']
    },
    '3' => {
      input: "3\ncompany\nGoogle\n7\n",
      messages: ['Search Applications selected.',
                 'Search field (company/position/status):', 'Search value:',
                 'Search Applications completed.']
    },
    '4' => {
      input: "4\n1\nInterview\n7\n",
      messages: ['Update Application Status selected.', 'Application ID:',
                 'New status (Applied/Interview/Offer/Rejected):',
                 'Update Application Status completed.']
    },
    '5' => {
      input: "5\n1\n7\n",
      messages: ['Delete Application selected.', 'Application ID:',
                 'Delete Application completed.']
    },
    '6' => {
      input: "6\n7\n",
      messages: ['Application Statistics selected.',
                 'Application Statistics completed.']
    }
  }.each do |selection, example|
    context "when option #{selection} is selected" do
      let(:input_text) { example[:input] }

      before do
        next unless %w[4 5].include?(selection)

        manager.add_application(
          company: 'Google',
          position: 'Software Engineer',
          application_date: '2026-09-20',
          status: 'Applied'
        )
      end

      it 'accepts the selection and returns to the main menu' do
        cli.run

        expect(output.string).to include(*example[:messages])
        expect(output.string).not_to include('not available')
        message_positions = example[:messages].map { |message| output.string.index(message) }
        expect(message_positions).to eq(message_positions.sort)
        expect(output.string.scan('JobTrack Main Menu').length).to eq(2)
      end
    end
  end

  context 'when several operations are selected before Exit' do
    let(:input_text) do
      "1\nGoogle\nSoftware Engineer\n2026-09-20\nApplied\n" \
        "2\n4\n1\nInterview\n7\n"
    end

    it 'continues running until Exit is selected' do
      cli.run

      expect(output.string).to include(
        'Add Application completed.',
        'View Applications selected.',
        'Update Application Status completed.'
      )
      expect(output.string.scan('JobTrack Main Menu').length).to eq(4)
      expect(output.string).to end_with("Goodbye!\n")
    end
  end

  context 'when a selection contains surrounding whitespace' do
    let(:input_text) do
      "  1  \nGoogle\nSoftware Engineer\n2026-09-20\nApplied\n7\n"
    end

    it 'recognizes the selection' do
      cli.run

      expect(output.string).to include('Add Application completed.')
      expect(output.string).not_to include('Invalid menu selection')
    end
  end

  context 'when the input stream closes' do
    let(:input_text) { '' }

    it 'terminates normally' do
      expect { cli.run }.not_to raise_error
      expect(output.string).to end_with("Goodbye!\n")
    end
  end

  describe 'application-operation integration' do
    context 'when an application is added and then viewed' do
      let(:input_text) do
        "1\nGoogle\nSoftware Engineer\n2026-09-20\nApplied\n2\n7\n"
      end

      it 'delegates creation and displays the saved application' do
        cli.run

        expect(output.string).to match(/Google.*Software Engineer.*Applied/)
        expect(manager.applications.length).to eq(1)
        expect(output.string).to include('Application #1 added successfully.')
      end
    end

    context 'when applications are searched' do
      let(:input_text) { "3\ncompany\nGoogle\n7\n" }

      before do
        manager.add_application(
          company: 'Google',
          position: 'Software Engineer',
          application_date: '2026-09-20',
          status: 'Applied'
        )
      end

      it 'delegates the search and displays matching applications' do
        cli.run

        expect(output.string).to match(/Google.*Software Engineer.*Applied/)
      end
    end

    context 'when an application status is updated' do
      let(:input_text) { "4\n1\nInterview\n7\n" }

      before do
        manager.add_application(
          company: 'Google',
          position: 'Software Engineer',
          application_date: '2026-09-20',
          status: 'Applied'
        )
      end

      it 'delegates the update and displays the updated application' do
        cli.run

        expect(manager.applications.first.status).to eq('Interview')
        expect(output.string).to include('Application #1 status updated to Interview.')
      end
    end

    context 'when View is selected with an empty collection' do
      let(:input_text) { "2\n7\n" }

      it 'displays the empty-collection result' do
        cli.run

        expect(output.string).to include('No applications found.')
      end
    end

    context 'when an operation receives invalid input' do
      let(:input_text) do
        "1\nGoogle\nSoftware Engineer\n2026-02-30\nApplied\n7\n"
      end

      it 'displays the manager error and returns to the menu' do
        expect { cli.run }.not_to raise_error
        expect(output.string).to include('Error: Application date must be a valid date')
        expect(output.string).not_to include('Add Application completed.')
        expect(output.string.scan('JobTrack Main Menu').length).to eq(2)
      end
    end

    context 'when a search value is empty' do
      let(:input_text) { "3\ncompany\n\n7\n" }

      it 'displays the validation error without completing the operation' do
        cli.run

        expect(output.string).to include('Error: Search value cannot be empty.')
        expect(output.string).not_to include('Search Applications completed.')
        expect(output.string.scan('JobTrack Main Menu').length).to eq(2)
      end
    end

    context 'when a search has no matching applications' do
      let(:input_text) { "3\ncompany\nAmazon\n7\n" }

      it 'displays the no-results message and completes normally' do
        cli.run

        expect(output.string).to include('No matching applications found.')
        expect(output.string).to include('Search Applications completed.')
      end
    end

    context 'when an update uses an unknown application ID' do
      let(:input_text) { "4\n999\nInterview\n7\n" }

      it 'displays the manager error without completing the operation' do
        cli.run

        expect(output.string).to include('Error: Application with ID 999 was not found')
        expect(output.string).not_to include('Update Application Status completed.')
        expect(output.string.scan('JobTrack Main Menu').length).to eq(2)
      end
    end
  end

  describe 'application statistics' do
    let(:input_text) { "6\n7\n" }

    context 'when applications exist in every status' do
      before do
        ['Applied', 'Applied', 'Interview', 'Offer', 'Rejected'].each_with_index do |status, index|
          manager.add_application(
            company: "Company #{index + 1}",
            position: 'Software Engineer',
            application_date: '2026-09-20',
            status: status
          )
        end
      end

      it 'displays the total and exact status breakdown' do
        cli.run

        expect(output.string).to include(
          'Total Applications: 5',
          'Applied: 2',
          'Interview: 1',
          'Offer: 1',
          'Rejected: 1'
        )
      end
    end

    context 'when the application collection is empty' do
      it 'displays zero for the total and every status' do
        cli.run

        expect(output.string).to include(
          'Total Applications: 0',
          'Applied: 0',
          'Interview: 0',
          'Offer: 0',
          'Rejected: 0'
        )
      end
    end
  end
end
