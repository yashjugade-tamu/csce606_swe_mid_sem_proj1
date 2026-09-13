# frozen_string_literal: true

require_relative 'job_track/application'
require_relative 'job_track/application_manager'

# Sample terminal usage:
#   bundle exec ruby -Ilib -e "require 'job_track'; manager = JobTrack::ApplicationManager.new; app = manager.add_application(company: 'Google', position: 'Software Engineer', application_date: '2026-08-15', status: 'Applied'); p app; manager.print_applications"
