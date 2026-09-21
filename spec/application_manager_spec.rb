require_relative 'spec_helper'

describe JobTrack::ApplicationManager do
  subject(:manager) { described_class.new }

  let(:valid_attributes) do
    {
      company: 'Google',
      position: 'Software Engineer Intern',
      application_date: '2026-08-15',
      status: 'Applied'
    }
  end

  def add_application(**changes)
    manager.add_application(**valid_attributes, **changes)
  end

  it 'adds an application to the collection' do
    application = add_application

    expect(manager.applications).to contain_exactly(application)
  end

  it 'assigns unique sequential IDs' do
    first = add_application
    second = add_application(company: 'Netflix')

    expect(first.id).to eq(1)
    expect(second.id).to eq(2)
  end

  it 'returns every existing application as a structured array of details' do
    add_application
    add_application(company: 'Netflix')

    applications = manager.read_all_applications

    expect(applications).to be_an(Array)
    expect(applications.length).to eq(manager.applications.length)
    expect(applications).to all(include(:id, :company, :position, :application_date, :status))
    expect(applications.map { |app| app[:company] }).to eq(manager.applications.map(&:company))
  end

  it 'returns an empty structured result when no applications exist' do
    expect(manager.read_all_applications).to eq([])
    expect { manager.print_applications }.not_to raise_error
  end

  it 'prints all applications in a terminal-friendly format' do
    add_application
    add_application(company: 'Netflix')

    expect { manager.print_applications }.not_to raise_error
  end

  it 'prints to a supplied output stream with a custom empty message' do
    output = StringIO.new

    manager.print_applications([], output: output, empty_message: 'Nothing matched.')

    expect(output.string).to eq("Nothing matched.\n")
  end

  it 'searches applications by company and only returns matching applications' do
    add_application
    add_application(company: 'Netflix', position: 'Data Scientist', status: 'Interview')

    results = manager.search_applications('Netflix', field: 'company')

    expect(results.length).to eq(1)
    expect(results.first[:company]).to eq('Netflix')
    expect(results.first[:position]).to eq('Data Scientist')
  end

  it 'searches applications by position and only returns matching applications' do
    add_application
    add_application(company: 'Netflix', position: 'Data Scientist', status: 'Interview')

    results = manager.search_applications('Data Scientist', field: 'position')

    expect(results.length).to eq(1)
    expect(results.first[:position]).to eq('Data Scientist')
    expect(results.first[:company]).to eq('Netflix')
  end

  it 'searches applications by status and only returns matching applications' do
    add_application
    add_application(company: 'Netflix', position: 'Data Scientist', status: 'Interview')

    results = manager.search_applications('Interview', field: 'status')

    expect(results.length).to eq(1)
    expect(results.first[:status]).to eq('Interview')
    expect(results.first[:company]).to eq('Netflix')
  end

  it 'returns an empty result when a search has no matches' do
    add_application

    expect(manager.search_applications('Amazon', field: 'company')).to eq([])
  end

  it 'rejects invalid or empty search values' do
    add_application

    expect { manager.search_applications('', field: 'company') }
      .to raise_error(JobTrack::ValidationError, 'Search value cannot be empty.')

    expect { manager.search_applications('   ', field: 'company') }
      .to raise_error(JobTrack::ValidationError, 'Search value cannot be empty.')

    expect { manager.search_applications('Google', field: 'unknown') }
      .to raise_error(JobTrack::ValidationError, 'Invalid search field.')
  end

  it 'does not add or consume an ID for an invalid application' do
    expect { add_application(application_date: '2026-02-30') }
      .to raise_error(JobTrack::ValidationError)

    expect(add_application.id).to eq(1)
    expect(manager.applications.length).to eq(1)
  end

  it 'keeps the collection unchanged after each kind of invalid input' do
    invalid_changes = [
      { company: ' ' },
      { position: nil },
      { application_date: '2026-02-30' },
      { status: 'Waiting' }
    ]

    invalid_changes.each do |changes|
      expect { add_application(**changes) }
        .to raise_error(JobTrack::ValidationError)
    end

    expect(manager.applications).to be_empty
    expect(add_application.id).to eq(1)
  end

  describe '#update_application_status' do
    it 'updates the application identified by ID' do
      application = add_application

      updated_application = manager.update_application_status(application.id, 'Interview')

      expect(updated_application).to equal(application)
      expect(application.status).to eq('Interview')
    end

    it 'accepts a numeric ID entered as a string' do
      application = add_application

      manager.update_application_status(application.id.to_s, 'Offer')

      expect(application.status).to eq('Offer')
    end

    it 'accepts every permitted status' do
      application = add_application

      JobTrack::Application::STATUSES.each do |status|
        expect(manager.update_application_status(application.id, status).status).to eq(status)
      end
    end

    it 'preserves other fields and does not modify another application' do
      application = add_application
      other_application = add_application(company: 'Netflix', status: 'Offer')
      original_information = [
        application.company,
        application.position,
        application.application_date
      ]

      manager.update_application_status(application.id, 'Rejected')

      expect([
        application.company,
        application.position,
        application.application_date
      ]).to eq(original_information)
      expect(other_application.status).to eq('Offer')
    end

    it 'rejects an unsupported status and keeps the original status' do
      application = add_application

      expect { manager.update_application_status(application.id, 'Waiting') }
        .to raise_error(JobTrack::ValidationError, /Applied, Interview, Offer, Rejected/)
      expect(application.status).to eq('Applied')
    end

    it 'rejects an unknown ID without modifying any application' do
      first = add_application
      second = add_application(company: 'Netflix', status: 'Interview')

      expect { manager.update_application_status(999, 'Offer') }
        .to raise_error(JobTrack::ValidationError, 'Application with ID 999 was not found')
      expect([first.status, second.status]).to eq(['Applied', 'Interview'])
    end

    it 'rejects malformed or missing IDs without modifying the collection' do
      application = add_application

      ['unknown', '', nil].each do |invalid_id|
        expect { manager.update_application_status(invalid_id, 'Offer') }
          .to raise_error(JobTrack::ValidationError, /was not found/)
        expect(application.status).to eq('Applied')
      end
    end
  end

  describe '#application_statistics' do
    it 'returns the total and a count for every application status' do
      add_application
      add_application(company: 'Netflix', status: 'Applied')
      add_application(company: 'Amazon', status: 'Interview')
      add_application(company: 'Apple', status: 'Offer')
      add_application(company: 'Microsoft', status: 'Rejected')

      expect(manager.application_statistics).to eq(
        total: 5,
        status_counts: {
          'Applied' => 2,
          'Interview' => 1,
          'Offer' => 1,
          'Rejected' => 1
        }
      )
    end

    it 'returns zero for the total and every status when the collection is empty' do
      expect(manager.application_statistics).to eq(
        total: 0,
        status_counts: {
          'Applied' => 0,
          'Interview' => 0,
          'Offer' => 0,
          'Rejected' => 0
        }
      )
    end

    it 'reflects the current status after an application is updated' do
      application = add_application

      manager.update_application_status(application.id, 'Interview')

      expect(manager.application_statistics).to eq(
        total: 1,
        status_counts: {
          'Applied' => 0,
          'Interview' => 1,
          'Offer' => 0,
          'Rejected' => 0
        }
      )
    end
  end
end
