require_relative 'spec_helper'

describe JobTrack::CLI do
  subject(:cli) do
    described_class.new(
      manager: JobTrack::ApplicationManager.new,
      input: input,
      output: output
    )
  end

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
end
