# JobTrack

JobTrack is a Ruby terminal application for tracking job and internship applications.

## Team

- Varsha Goalla
- Yash Jugade

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

JobTrack loads application records from `data/applications.json`. Successful add,
update, and delete operations save the collection automatically. CSV exports use
the path entered in the menu or the user's Downloads directory when the path is
left blank.

## Run the RSpec suite

The suite includes unit tests, complete CLI acceptance tests, happy and sad paths,
and isolated JSON and CSV tests. See [`docs/testing.md`](docs/testing.md) for the
testing strategy and the exact test-only file locations.

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

## Known limitations

- JobTrack is a single-user local terminal application; it has no accounts,
  synchronization, database, or REST API.
- Applications can be searched only by company, position, or status.
- Only an application's status can be edited after creation.
- A malformed JSON data file is treated as an empty collection; automatic backup
  and recovery are not currently provided.
- CSV export requires an existing destination directory.

This README reflects the current implementation in the repository and the actual
program entry point used by the project.
