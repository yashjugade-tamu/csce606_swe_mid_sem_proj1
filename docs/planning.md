# JobTrack Planning Discussion

Date: 2026-09-12  
Participants: Varsha Goalla and Yash Jugade

This document records the team's initial plan.

## What We Will Build

We will build JobTrack, a Ruby terminal application for students to organize job
and internship applications. Each record contains a company, position,
application date, and hiring status. The application will support the full
lifecycle of adding, viewing, searching, updating, and deleting records, followed
by statistics and persistent storage.

## Essential and Optional Features

Essential scope:

- Add a validated application with a unique ID.
- View one or many applications and handle an empty collection.
- Search by company, position, or status.
- Update an application's status by ID.
- Delete an application by ID.
- Navigate all operations through a clear terminal menu.
- Integrate prompts, results, and recoverable error handling into the CLI.
- Display application statistics.
- Persist application data in JSON between runs.

Optional scope:

- Export applications to CSV.

The CSV feature will begin only after the nine essential stories meet their
acceptance criteria. 

## Delivery Plan

### Sprint 1 — Basic application management

Implement the validated application model and in-memory manager first, followed by
viewing all applications. This establishes the data shape and collection behavior
needed by every later feature.

### Sprint 2 — Management operations and CLI

Add search, status updates, and deletion. Then build the menu and connect these
operations to terminal prompts and output. Keeping the operations in the manager
before integrating the CLI makes them easier to test independently.


### Sprint 3 — Statistics and storage

Add statistics after the manager supports the core operations. Add JSON storage
once the record format and update behavior are stable. Attempt CSV export only if
the essential stories are complete.

## Collaboration Plan

The team will use pair programming for implementation work:

- One partner is the driver and writes the code; the navigator reviews the logic,
  checks it against acceptance criteria, and suggests tests and edge cases.
- Both partners discuss design and implementation decisions before significant
  changes are made.
- Driver and navigator roles switch between stories or substantial tasks so both
  partners understand the complete codebase.
- The team runs relevant tests before switching roles and the full suite before a
  story is considered complete.
- Pairing sessions, roles, completed work, and decisions are recorded in
  docs/pairing_log.md.
- Commit authorship identifies the driver for a change. Both partners review the
  change together before it is treated as finished.

Small documentation or cleanup tasks may be completed individually, but changes
that affect behavior should be explained to the other partner and reviewed before
completion.

## Definition of Done

### Project done

The essential project is done when:

- User Stories 1–9 satisfy their documented acceptance criteria.
- A user can complete the core workflow from the terminal without an unexpected
  crash.
- Application data persists between runs.
- The full automated test suite passes in the required Ruby environment.
- The README explains installation, execution, and testing.
- The design, backlog, planning, user-story, and pairing documents reflect the
  delivered system.
- Both partners have reviewed the final behavior and understand the major classes.

User Story 10 is not required for the essential project definition of done.

### Feature or user story done

An individual story is done when:

- Its acceptance criteria are implemented.
- Normal behavior, boundary cases, and expected errors have automated tests.
- All existing tests still pass.
- User-facing errors are clear and allow continued use where required.
- The implementation follows the agreed class responsibilities and avoids adding
  unrelated story scope.
- The partner acting as navigator has reviewed the code and both partners can
  explain it.
- The backlog status and pairing log are updated.

## Initial Decisions and Risks

- Start with in-memory state to keep Sprint 1 focused; accept temporary data loss
  until JSON persistence is implemented.
- Keep validation in Application and collection operations in
  ApplicationManager; move terminal orchestration into a CLI component when the
  menu story begins.
- Use a fixed set of statuses—Applied, Interview, Offer, and Rejected—to keep
  searches, updates, and statistics consistent.
- Assign IDs only after successful validation so rejected input does not create
  gaps.
- Main risks are malformed input, persistence-file errors, and terminal code that
  is difficult to test. Address these with explicit validation, temporary-file
  tests, and injectable input/output streams for the future CLI.