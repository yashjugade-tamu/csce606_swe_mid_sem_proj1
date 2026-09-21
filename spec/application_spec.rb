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


  it 'rejects an empty company' do
    expect { build_application(company: '  ') }
      .to raise_error(JobTrack::ValidationError, 'Company cannot be empty')
  end

  it 'rejects an empty position' do
    expect { build_application(position: '') }
      .to raise_error(JobTrack::ValidationError, 'Position cannot be empty')
  end

  it 'rejects missing company and position values with field-specific errors' do
    expect { build_application(company: nil) }
      .to raise_error(JobTrack::ValidationError, 'Company cannot be empty')
    expect { build_application(position: nil) }
      .to raise_error(JobTrack::ValidationError, 'Position cannot be empty')
  end



  it 'rejects an invalid ID' do
    expect { build_application(id: 0) }
      .to raise_error(JobTrack::ValidationError, 'Application ID must be positive')
    expect { build_application(id: 'invalid') }
      .to raise_error(JobTrack::ValidationError, 'Application ID must be a whole number')
  end



  it 'accepts every permitted status' do
    JobTrack::Application::STATUSES.each do |status|
      expect(build_application(status: status).status).to eq(status)
    end
  end

  it 'normalizes the case of a permitted status' do
    expect(build_application(status: 'interview').status).to eq('Interview')
  end

  describe '#update_status' do
    it 'updates the application to a valid new status' do
      application = build_application

      application.update_status('Interview')

      expect(application.status).to eq('Interview')
    end

    it 'accepts every permitted status' do
      application = build_application

      described_class::STATUSES.each do |status|
        expect(application.update_status(status).status).to eq(status)
      end
    end

    it 'normalizes the case of a permitted status' do
      application = build_application

      expect(application.update_status('offer').status).to eq('Offer')
    end

    it 'preserves all non-status application information' do
      application = build_application
      original_information = [
        application.id,
        application.company,
        application.position,
        application.application_date
      ]

      application.update_status('Rejected')

      expect([
        application.id,
        application.company,
        application.position,
        application.application_date
      ]).to eq(original_information)
    end

    it 'rejects an unsupported status and keeps the original status' do
      application = build_application

      expect { application.update_status('Waiting') }
        .to raise_error(JobTrack::ValidationError, /Applied, Interview, Offer, Rejected/)
      expect(application.status).to eq('Applied')
    end

    it 'rejects blank or missing statuses without changing the application' do
      application = build_application

      ['', '   ', nil].each do |invalid_status|
        expect { application.update_status(invalid_status) }
          .to raise_error(JobTrack::ValidationError, /Applied, Interview, Offer, Rejected/)
        expect(application.status).to eq('Applied')
      end
    end
  end

end
