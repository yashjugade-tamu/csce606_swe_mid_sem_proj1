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

# JobTrack Testing Strategy

JobTrack uses RSpec for automated unit and acceptance testing.

## Test Types

### Unit tests

- `spec/application_spec.rb` tests application validation and status updates.
- `spec/application_manager_spec.rb` tests collection operations, search,
  statistics, and JSON persistence.
- `spec/csv_exporter_spec.rb` tests populated and empty CSV exports.

### Acceptance tests

`spec/cli_spec.rb` supplies simulated terminal input and verifies the resulting
output. These tests cover complete workflows through the menu, including Add,
View, Search, Update, Delete, Statistics, JSON persistence, CSV export, errors,
menu return behavior, and Exit.

## Happy and Sad Paths

Happy-path examples use valid input and verify successful creation, searching,
updates, deletion, loading, statistics, and export. Sad-path examples cover invalid
dates, missing fields, unsupported statuses, invalid or unknown IDs, invalid menu
selections, empty or invalid searches, empty collections, and invalid export paths.

## Test Isolation and Test Files

JSON and CSV tests use temporary or test-only files rather than the real
`data/applications.json` file.

- ApplicationManager persistence tests create `applications.json` inside a
  dynamically generated directory from `Dir.mktmpdir`. 
- CLI tests use `spec/job_track_test_applications.json`. The file is deleted before
  and after each example, so it normally does not exist when tests are not running.
- CSV exporter tests use `spec/applications_export_test.csv`. The file is also
  deleted before and after each example.
- CLI input and output use `StringIO`, allowing complete terminal workflows to run
  automatically without reading from the real keyboard or printing to the real
  terminal.

RSpec randomizes example order to help reveal dependencies between tests. Each
example creates its required state and contains expectations that determine its
result automatically.

## Run the RSpec suite

The suite includes unit tests, complete CLI acceptance tests, happy and sad paths,
and isolated JSON and CSV tests. 
```sh
bundle exec rspec -fd spec/
```

Run an individual spec file with:

```sh
bundle exec rspec -fd spec/application_spec.rb
```

## Run RSpec with statement coverage

See the [coverage report and test-coverage mapping](docs/coverage.txt) for detailed
coverage information.

```sh
COVERAGE=true bundle exec rspec -fd spec/
```

## Run tests automatically while developing

```sh
bin/autotest
```

The automatic test runner uses Guard to watch `lib/` and `spec/` and reruns relevant RSpec examples when files change. Stop it with `Ctrl-C`.

