# JobTrack

JobTrack is a Ruby terminal application for tracking job and internship applications.

The project is being built incrementally from the user stories in `docs/user_stories.md`. The current implementation covers the business logic for **User Story 1: Add a Job Application** using in-memory state.

## Requirements

- Ruby 3.0.2, matching the course Gradescope environment
- Bundler

## Install development dependencies

```sh
gem install bundler
bundle install
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

The CLI, terminal launcher, JSON persistence, and complete menu will be implemented in later user stories.
