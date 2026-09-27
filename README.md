# JobTrack

JobTrack is a Ruby terminal application for tracking job and internship applications.

The project follows the user stories in `docs/user_stories.md` and currently supports the core application-management workflow in the CLI: adding applications, viewing saved records, searching, updating status, deleting entries, viewing statistics, saving to JSON, and exporting to CSV.

## Requirements

- Ruby 3.0.2, matching the course Gradescope environment
- Bundler

## Install dependencies

```sh
gem install bundler
bundle install
```

## Run the application

Use the launcher script in the project root:

```sh
ruby bin/job_track
```

On Windows PowerShell, the equivalent command is:

```powershell
ruby .\bin\job_track
```

## Run the RSpec suite

```sh
bundle exec rspec -fd spec/
```

Run an individual spec file with:

```sh
bundle exec rspec -fd spec/application_spec.rb
```

## Run RSpec with statement coverage

```sh
COVERAGE=true bundle exec rspec -fd spec/
```

## Run tests automatically while developing

```sh
bin/autotest
```

The automatic test runner uses Guard to watch `lib/` and `spec/` and reruns relevant RSpec examples when files change. Stop it with `Ctrl-C`.

## Current features

- Add a job application
- View all saved applications
- Search by company, position, or status
- Update application status
- Delete an application
- View application statistics
- Persist data to JSON
- Export records to CSV

This README reflects the current implementation in the repository and the actual program entry point used by the project.
