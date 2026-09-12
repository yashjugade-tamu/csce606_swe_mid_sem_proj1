# frozen_string_literal: true

guard :rspec, cmd: 'bundle exec rspec -fd' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/job_track/(.+)\.rb$}) { |match| "spec/#{match[1]}_spec.rb" }
  watch('lib/job_track.rb') { 'spec' }
  watch('spec/spec_helper.rb') { 'spec' }
end
