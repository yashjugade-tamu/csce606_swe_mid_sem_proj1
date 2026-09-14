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
- Kept the story In Progress because commit 3eb59a8 remains on US3-YJ and has
  not been merged into main; CLI search prompts will be completed with the CLI
  integration stories.