# JobTrack Design

## Overview

JobTrack is a Ruby terminal application that helps students record and manage job
and internship applications. 

## System Architecture

### Current components

```text
Caller / future CLI
        |
        v
ApplicationManager --------> Application
  collection and IDs          data and validation
        |
        v
 terminal-formatted output
```

### Responsibilities

- `JobTrack::Application` represents one application. It stores the ID, company,
  position, application date, and status. It validates required text, positive
  integer IDs, ISO dates, and the permitted statuses.
- `JobTrack::ApplicationManager` owns the in-memory collection. It assigns
  sequential IDs, creates applications, returns structured application details,
  and prints the collection for terminal use.
- `JobTrack::ValidationError` reports invalid user-supplied values using messages
  that can later be displayed by the CLI without exposing Ruby's lower-level
  exceptions.
- `lib/job_track.rb` is the library entry point that loads the application classes.



### Planned components

- A CLI/controller will display the main menu, collect input, call manager methods,
  show results, handle `ValidationError`, and return the user to the menu.
- JSON storage will load applications at startup and save changes so data survives
  between runs.
- CSV export will be an optional adapter that writes the current collection without
  changing the core application model.

## User Interface Design

The final interface is menu-driven. After each operation, the user returns to the
main menu unless they choose Exit.

### Main menu mock-up

```text
JobTrack
1. Add Application
2. View All Applications
3. Search Applications
4. Update Application Status
5. Delete Application
6. View Statistics
7. Export Applications to CSV
0. Exit
Choose an option:
```

The export option is included only if the optional User Story 10 is completed.

### Add workflow

```text
Company: Google
Position: Software Engineer Intern
Application date (YYYY-MM-DD): 2026-09-12
Status (Applied/Interview/Offer/Rejected): Applied

Application added with ID 1.
```

If input is invalid, JobTrack displays the validation message, saves nothing, and
allows the user to try again or return to the menu.

### View workflow

```text
ID | Company | Position | Application Date | Status
1 | Google | Software Engineer Intern | 2026-09-12 | Applied
2 | Netflix | Backend Intern | 2026-09-13 | Interview
```

With no saved applications:

```text
No applications found.
```

### Expected interaction flow

```text
Start -> Main menu -> Select operation -> Enter requested input
                         |                     |
                         |                     v
                         |              Validate and execute
                         |                 /          \
                         |             success       error
                         |                |             |
                         +<------- Show result/message-+
                         |
                      Exit -> End
```

## Design Decisions and Tradeoffs

### Validate in the model

`Application` validates its own state, so invalid records cannot be created through
the manager or another future interface. This centralizes the rules, although it
makes the model responsible for both data storage and validation.

### Assign IDs in the manager

The manager owns sequential ID assignment because IDs belong to the collection,
not to user input. The counter advances only after successful validation. This is
simple for in-memory use; JSON loading will later need to restore or calculate the
next available ID.

### Use in-memory storage first

In-memory storage keeps the early stories small and testable. The tradeoff is that
data is lost when the process exits. User Story 9 adds JSON persistence after the
core operations are stable.

### Keep structured reads separate from printing

`read_all_applications` returns hashes while `print_applications` handles terminal
formatting. Structured results are easier to test and can support other interfaces.
As the CLI grows, display logic may move from the manager into a dedicated CLI or
presenter to keep business logic independent of terminal output.

### Use constrained, case-insensitive partial search

The in-progress search implementation accepts only company, position, and status
as search fields. It uses case-insensitive substring matching, which is forgiving
for terminal users and supports incomplete terms. The tradeoff is that short
queries may return broader results. Invalid fields and blank queries return an
empty result instead of raising an exception so a future CLI can continue running.

### Restrict and normalize statuses

The four statuses are defined in one list. Case-insensitive matching makes input
more forgiving while storing one consistent spelling. Adding a new hiring stage
requires updating the list and its tests.

### Deliver the CSV feature last

CSV export is useful but does not affect core tracking. It is therefore an optional
stretch story so it cannot delay essential add, view, management, CLI, statistics,
or persistence behavior.
