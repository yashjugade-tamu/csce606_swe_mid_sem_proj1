# frozen_string_literal: true

if ENV['COVERAGE'] == 'true'
  require 'coverage'
  Coverage.start(lines: true)
end

require 'stringio'
require_relative '../lib/job_track'

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed

  config.after(:suite) do
    next unless ENV['COVERAGE'] == 'true'

    project_lib = File.expand_path('../lib/', __dir__)
    files = Coverage.result.select { |path, _data| path.start_with?(project_lib) }
    executable = files.sum { |_path, data| data[:lines].count { |line| !line.nil? } }
    covered = files.sum { |_path, data| data[:lines].count { |line| line&.positive? } }
    percentage = executable.zero? ? 100.0 : covered.fdiv(executable) * 100

    puts format(
      'Statement coverage: %<percentage>.2f%% (%<covered>d/%<executable>d)',
      percentage: percentage, covered: covered, executable: executable
    )
    raise "Statement coverage is below 80%: #{percentage.round(2)}%" if percentage < 80
  end
end
