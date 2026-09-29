# JobTrack Retrospective

Date: 2026-09-28  
Participants: Varsha Goalla and Yash Jugade

## What Went Well

- Keeping validation in `Application` worked well. The same rules are used when an
  application is added, updated, or loaded from JSON. Invalid dates and statuses
  are rejected before they enter the collection.

- Keeping application operations in `ApplicationManager` made the CLI simpler. The
  CLI collects input and displays results, while the manager handles IDs, search,
  updates, deletion, statistics, and persistence.

- Assigning IDs in the manager prevented the user from choosing duplicate IDs.
  After loading JSON, the next ID continues after the highest saved ID, so deletion
  does not cause an old ID to be reused.

- Returning application information separately from printing it made View and
  Search easier to test. Both operations can reuse the same terminal formatting.

- Keeping CSV creation in `CSVExporter` prevented CSV formatting and path handling
  from making the manager or CLI more complicated.

- The test suite covered unit behavior and complete user workflows, including valid
  operations, invalid input, JSON reloads, empty collections, and CSV exports.

## What Was Difficult

- Loading JSON safely involves more than parsing the file. JobTrack handles invalid JSON syntax by starting with an empty collection, but valid JSON containing missing or invalid application fields can still fail model validation and the app won't start.

- Since we added JSON persistence interface later, so we had to update the tests for update/delete workflows.

- We planned to add multi column search with optional filters but was too complex with present UI worflow.

- Writing down test cases covering all kinds of scenarios was difficult.



## Design Tradeoffs We Noticed

- JobTrack does not have a separate data-access layer or database. Add, view,
  search, update, and delete operations work on the manager's in-memory collection,
  and the manager saves the resulting collection to JSON. This keeps the current
  application simple, but it combines collection management and persistence in one
  class, would not scale well for a much larger dataset, and does not support
  multiple users working with shared data.
 
- Add, Update, and Delete change memory before the JSON save completes. If a
  filesystem write fails, the current design has no transaction or rollback
  mechanism to guarantee that memory and disk remain consistent.

- Restricting statuses keeps stored data, search results, and statistics
  consistent, but users cannot add custom hiring stages such as Assessment or
  Withdrawn.

- The numbered menu is simple, but it may become crowded and harder to navigate if
  many more features are added.

- When an error occurs, the user must select the operation again and re-enter all
  inputs, including values that were already valid.

- Applications are displayed in fixed text columns. Long company names or position
  titles may reduce readability or cause uneven alignment in the terminal.

- View and Search do not paginate their results. A large collection or a broad
  search may produce crowded terminal output that is difficult to review.

- The current search workflow asks for one field and one value. Supporting
  multi-field searches with optional filters would require additional prompts and
  rules for combining the selected filters.

- JobTrack has no login interface. Every run uses the same local collection, so the
  UI cannot identify different users or provide separate user accounts.


## What We Would Improve Next Time

- We will not use in-memory collection and have a database. We will implement data layer for operations on database.
- We will implement pagination.
- We will have a login interface for user and support multiple users.
- We will use better UI interface and manage state, so that user doesn't have tp re-enter inputs on error.
- We will support multi column search and optional filters.
- We will strictly follow test before paradigm for all features.
- We need to manage test cases properly.


## Did the Final Application Meet the Original Goal?

Yes. JobTrack gives students one terminal application for adding, viewing,
searching, updating, and deleting job applications. It also displays statistics,
saves applications between runs with JSON, and exports data to CSV. This meets the
essential project goal and includes the optional CSV feature.