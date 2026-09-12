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

  it 'rejects an impossible date' do
    expect { build_application(application_date: '2026-02-30') }
      .to raise_error(JobTrack::ValidationError, /valid date/)
  end

  it 'rejects an invalid status' do
    expect { build_application(status: 'Waiting') }
      .to raise_error(JobTrack::ValidationError, /Applied, Interview, Offer, Rejected/)
  end


  
end