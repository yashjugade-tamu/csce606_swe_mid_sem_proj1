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

  it 'prints a no matching applications message when a search has no results' do
    add_application

    expect { manager.search_applications('Amazon', field: 'company') }
      .to output(/No matching applications found/).to_stdout
  end

  it 'handles invalid or empty search values safely' do
    add_application

    expect { manager.search_applications('', field: 'company') }
      .to output(/Invalid search input/).to_stdout

    expect { manager.search_applications('   ', field: 'company') }
      .to output(/Invalid search input/).to_stdout

    expect { manager.search_applications('Google', field: 'unknown') }
      .to output(/Invalid search field/).to_stdout
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
end
