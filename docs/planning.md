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


