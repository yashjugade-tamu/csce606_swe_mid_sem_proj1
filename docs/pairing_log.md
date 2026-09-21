# Pairing Log


## Session 1 — 2026-09-12

Driver: Varsha Goalla  
Navigator: Yash Jugade 

Work completed:

- Added the Ruby project structure, dependencies, RSpec configuration, and
  automatic test runner.
- Implemented User Story 1's `Application` model and validation for IDs, required
  text, dates, and statuses.
- Implemented `ApplicationManager#add_application` with in-memory storage and
  sequential IDs.
- Added tests for successful creation and all User Story 1 validation cases.

Notes:

- Decided that `Application` should validate and clean its own fields, while
  `ApplicationManager` should create applications, assign IDs, and maintain the
  in-memory collection.
- Added an application to the collection and incremented `@next_id` only after
  `Application.new` succeeds. This prevents invalid input from being saved or
  consuming an ID.
- Used one `JobTrack::ValidationError` type with field-specific messages so callers
  can handle all invalid input consistently.
- Parsed application dates with `Date.iso8601` so the stored value is a `Date` and
  impossible dates such as `2026-02-30` are rejected.
- Stored the four permitted statuses in `STATUSES` and used a case-insensitive
  comparison so input such as `interview` is normalized to `Interview`.
- Split tests between `Application` validation and `ApplicationManager` collection
  behavior.


## Session 2 — 2026-09-13

Driver: Yash Jugade  
Navigator: Varsha Goalla 

Work completed:

- Implemented the application-listing behavior for User Story 2.
- Added tests for reading and displaying saved applications.

Notes:

- Added `read_all_applications` to transform each saved `Application` into a hash
  containing its ID, company, position, application date, and status.
- Added `print_applications` separately from `read_all_applications` so retrieving
  structured application data and printing terminal output are distinct actions.
- Made `print_applications` use all saved applications by default while also
  accepting an application list as an argument.
- Displayed a clear `No applications found.` message and returned normally when
  the collection is empty.
- Formatted `Date` values as `YYYY-MM-DD` for terminal output and printed a header
  followed by one row per application.
- Added tests for multiple saved applications, the empty collection, and terminal
  printing without errors.

## Session 3 — 2026-09-13

Driver: Yash Jugade
Navigator: Varsha Goalla

Work completed:

- Implemented User Story 3 on the US3-YJ branch.
- Added search by company, position, and application status.
- Added tests for matching results, no results, empty queries, and invalid search
  fields.

Notes:

- Limited searchable fields to company, position, and status through
  VALID_SEARCH_FIELDS.
- Used case-insensitive partial matching so users can search without entering the
  complete value or matching capitalization exactly.
- Returned search results as hashes with the same five fields used by
  read_all_applications, then reused print_applications for display.
- Returned an empty array and displayed an explanatory message for blank input,
  invalid fields, or no matching applications so the program can continue safely.
- Completed and merged the User Story 3 search functionality. CLI search prompts
  will be completed with the later CLI integration stories.

## Session 4 — 2026-09-20

Driver: Varsha Goalla

Navigator: Yash Jugade

Work completed:

- Implemented the application-status update behavior for User Story 4 on the
  `US4` branch.
- Added `Application#update_status` and
  `ApplicationManager#update_application_status`.
- Added tests for successful updates, all permitted statuses, invalid statuses,
  invalid IDs, and preservation of existing application information.

Notes:

- Followed a test-first workflow by adding basic status-update examples before
  implementing the two update methods.
- Reused the existing status validation so updates accept only Applied,
  Interview, Offer, or Rejected and normalize capitalization consistently.
- Validated a new status before assigning it, ensuring an invalid update leaves
  the application's original status unchanged.
- Allowed numeric IDs supplied as strings so the manager can support future
  terminal input while continuing to store IDs as integers.
- Raised `JobTrack::ValidationError` for unsupported statuses and missing,
  malformed, or unknown application IDs.
- Confirmed that a successful update changes only the selected application's
  status and preserves its ID, company, position, and application date.

## Session 5 — 2026-09-21

Driver: Varsha Goalla

Navigator: Yash Jugade

Work completed:

- Implemented the command-line menu and navigation behavior for User Story 6.
- Integrated Add, View, Search, and Update CLI workflows with
  `ApplicationManager` for User Story 7.
- Added operation prompts, selected/completed messages, validation-error
  handling, and automatic return to the main menu.
- Reused `ApplicationManager#print_applications` for View and Search output and
  added support for injected output streams and custom empty-result messages.
- Added CLI workflow and error-handling tests.

Notes:

- Add, View, Search, and Update are connected to their corresponding
  `ApplicationManager` methods.
- Delete currently collects an application ID and completes its menu flow, but
  it is not connected to deletion business logic because the manager delete
  method has not been implemented or merged yet.
- Application Statistics completes its menu flow but is not connected to
  statistics business logic yet.
- The Delete and Application Statistics integrations will be completed after
  their corresponding manager functionality is available.

## Session 6 — 2026-09-21

Driver: Varsha Goalla

Navigator: Yash Jugade

Work completed:

- Implemented User Story 8 on the `US8` branch.
- Added `ApplicationManager#application_statistics` to calculate the total
  number of applications and counts for Applied, Interview, Offer, and Rejected.
- Connected the Application Statistics menu option to the manager calculation
  and displayed the resulting breakdown through the CLI.
- Added manager and CLI tests for populated and empty application collections.

Notes:

- Followed a test-first workflow by adding two manager examples and two CLI
  examples before implementation, covering populated and empty collections.
- Added the manager example for recalculating statistics after a status update
  after the initial statistics implementation was complete.
- Initialized every permitted status count to zero so the summary always shows
  Applied, Interview, Offer, and Rejected, even when no applications exist in a
  category.
- Calculated statistics from the manager's current in-memory collection, so the
  counts automatically reflect applications added or statuses updated earlier
  in the same session.
- Verified the required five-application example with 2 Applied, 1 Interview,
  1 Offer, and 1 Rejected application, plus an all-zero empty state.
- Confirmed the full project suite passes with 59 examples and 100% statement
  coverage.

## Session 7 — 2026-09-21

Driver: Yash Jugade

Navigator: Varsha Goalla

Work completed:

- Implemented User Story 5's delete-application behavior for the `US5` branch.
- Added `ApplicationManager#delete_application` to remove a matching application
  by ID while raising `JobTrack::ValidationError` for unknown or malformed IDs.
- Connected the Delete Application menu option to the manager and added success
  output for a deleted record.
- Added manager tests for successful deletion, numeric-string IDs, and preserving
  other applications when an invalid ID is rejected.
- Updated the CLI spec to seed an application before deleting it and verified the
  delete flow behaves correctly in the menu interface.

Notes:

- Followed the same pattern as update status: validate the ID, find the matching
  object, and raise a consistent `ValidationError` when the ID does not exist.
- Kept the delete operation atomic by removing only the selected application and
  leaving every other application untouched.
- Validated deletion through the manager and CLI flows, then confirmed the focused
  RSpec run passes with 47 examples and 0 failures.
