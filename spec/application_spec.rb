require_relative 'spec_helper'

describe JobTrack::Application do
  let(:valid_attributes) do
    {
      id: 1,
      company: 'Google',
      position: 'Software Engineer Intern',
      application_date: '2026-08-15',
      status: 'Applied'
    }
  end

  def build_application(**changes)
    described_class.new(**valid_attributes, **changes)
  end

  it 'creates an application with valid attributes' do
    application = build_application

    expect(application.id).to eq(1)
    expect(application.company).to eq('Google')
    expect(application.position).to eq('Software Engineer Intern')
    expect(application.application_date).to eq(Date.new(2026, 8, 15))
    expect(application.status).to eq('Applied')
  end
  
end