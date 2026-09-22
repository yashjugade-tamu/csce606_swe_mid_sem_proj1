require_relative 'spec_helper'

describe JobTrack::CSVExporter do
  subject(:exporter) { described_class.new }

  let(:applications) do
    [
      JobTrack::Application.new(
        id: 1,
        company: 'Google',
        position: 'Software Engineer Intern',
        application_date: '2026-08-15',
        status: 'Applied'
      ),
      JobTrack::Application.new(
        id: 2,
        company: 'Netflix',
        position: 'Data Scientist',
        application_date: '2026-08-16',
        status: 'Interview'
      )
    ]
  end

  let(:output_path) { File.join(__dir__, 'applications_export_test.csv') }

  before do
    File.delete(output_path) if File.exist?(output_path)
  end

  after do
    File.delete(output_path) if File.exist?(output_path)
  end

  it 'exports applications with the required columns into a CSV file' do
    exported_path = exporter.export(applications, output_path: output_path)
    rows = CSV.read(exported_path)

    expect(exported_path).to eq(output_path)
    expect(rows[0]).to eq(['id', 'company', 'position', 'application_date', 'status'])
    expect(rows[1]).to include('1', 'Google', 'Software Engineer Intern', '2026-08-15', 'Applied')
    expect(rows[2]).to include('2', 'Netflix', 'Data Scientist', '2026-08-16', 'Interview')
  end

  it 'creates a valid header-only CSV file when no applications exist' do
    exported_path = exporter.export([], output_path: output_path)
    rows = CSV.read(exported_path)

    expect(exported_path).to eq(output_path)
    expect(rows).to eq([
      ['id', 'company', 'position', 'application_date', 'status']
    ])
  end
end
