# Retrospective

Date: 2026-09-28
Participants: Varsha Goalla and Yash Jugade

## Objectives

The team used this retrospective to reflect on how well the JobTrack project matched the original goal and how the pair programming workflow supported delivery. The overall objective was to build a Ruby command-line application that helps students track job and internship applications, including adding entries, viewing and searching saved applications, updating status, deleting records, calculating summary statistics, and persisting data between runs.

The project followed the planned user stories and core sprint structure in the planning and backlog documents. The retrospective focuses on what worked well, what was difficult, what the pair would improve next time, and whether the final app met the original goal.

## What went well

- The team had a clear plan early in the project. The design and planning documents defined the essential and optional features, which kept the implementation focused and prevented feature creep.
- Pair programming was effective for complex tasks. The driver/navigator model helped catch mistakes early, especially during the first application model and manager behaviors.
- The project was broken into manageable increments. The team implemented User Stories 1-10 in sequence, moving from data model to manager logic to CLI and persistence without overwhelming the pair.
- We utilized branch-based work and merge timing so each story's integration points were easier to track.
- Testing was a strong part of the workflow. The RSpec suite covered validation, collection behavior, menu flows, statistics, deletion, and JSON persistence, which gave confidence in the final app.
- Keeping validation in `Application` worked well. The same rules are used when an application is added, updated, or loaded from JSON. Invalid dates and statuses are rejected before they enter the collection.
- Keeping application operations in `ApplicationManager` made the CLI simpler. The CLI collects input and displays results, while the manager handles IDs, search, updates, deletion, statistics, and persistence.
- Assigning IDs in the manager prevented duplicate IDs and preserved the correct next ID after loading saved records from JSON.
- Returning application information separately from printing it made View and Search easier to test. Both operations could reuse the same terminal formatting.
- Keeping CSV creation in `CSVExporter` prevented CSV formatting and path handling from making the manager or CLI more complicated.
- The project had dependencies between features, and the sprint planning handled them well. For example, statistics, deletion, and persistence each needed the earlier application model and manager behavior to be stable before they could be added cleanly.
- Persistence was successfully implemented with JSON storage, which matched the planned essential functionality and made the app usable across runs.
- The project reached a stable end state with the complete core workflow functioning through the terminal interface and passing the automated test suite.

## What was difficult

- Keeping tests aligned with refactoring and feature work required discipline. The team had to revisit earlier assumptions as requirements became clearer during implementation.
- The project began with an in-memory collection. Adding JSON persistence later required loading records at startup, saving changes, and restoring the correct next ID.
- The test cases had to be modified for the CRUD operations because the application initially stored data only in non-persistent, run-time memory. Once persistent JSON storage was added, the tests needed to account for data surviving across runs and for the manager restoring saved records correctly rather than only validating transient in-memory state.
- Several user stories changed `ApplicationManager` and the CLI. We had to merge carefully because different features depended on the same files.
- The CLI had to return to the main menu after both successful and failed operations. A completion message should appear only when an operation succeeds.
- Some features had to be revisited after the persistence layer was introduced because earlier assumptions about the collection lifetime and data shape no longer matched the final behavior.
- File-based tests needed separate JSON and CSV paths so they did not overwrite real JobTrack data or depend on another test.
- Loading JSON safely involves more than parsing the file. JobTrack handles invalid JSON syntax by starting with an empty collection, but valid JSON containing missing or invalid application fields can still fail model validation.

## Design tradeoffs

- JobTrack does not have a separate data-access layer or database. Add, view, search, update, and delete operations work on the manager's in-memory collection, and the manager saves the resulting collection to JSON. This keeps the current application simple, but it combines collection management and persistence in one class, would not scale well for a much larger dataset, and does not support multiple users working with shared data.
- Add, update, and delete change memory before the JSON save completes. If a filesystem write fails, the current design has no transaction or rollback mechanism to guarantee that memory and disk remain consistent.
- Restricting statuses keeps stored data, search results, and statistics consistent, but users cannot add custom hiring stages such as Assessment or Withdrawn.
- The numbered menu is simple, but it may become crowded and harder to navigate if many more features are added.
- When an error occurs, the user must select the operation again and re-enter all inputs, including values that were already valid.
- Applications are displayed in fixed text columns. Long company names or position titles may reduce readability or cause uneven alignment in the terminal.
- View and Search do not paginate their results. A large collection or a broad search may produce crowded terminal output that is difficult to review.
- The current search workflow asks for one field and one value. Supporting multi-field searches with optional filters would require additional prompts and rules for combining the selected filters.
- JobTrack has no login interface. Every run uses the same local collection, so the UI cannot identify different users or provide separate user accounts.

## What the pair would improve next time

- The pair would leave more time for polish and edge-case review near the end of each sprint, especially for menu flows, validation messages, and user recovery behaviors.
- We would also consider documenting the rationale behind key design decisions sooner, because some design choices become harder to explain after several sessions of implementation.
- We would design a state-transition test plan earlier so CRUD features are validated both before and after persistence is introduced. This would have made it easier to catch the in-memory-versus-persistent mismatch sooner and would have reduced the need to revise older tests after the storage layer was added.
- We would plan to switch from JSON persistence to a proper database solution when handling multiple users or larger data sets, so records can scale beyond a simple local file and support concurrency more safely.
- We would add a dedicated User class to manage multiple users, separate their application records, and support user-specific authentication and data isolation.
- We would improve the statistics functionality to provide richer analytics, such as time-based tracking, trends by status, and more detailed reporting for individual users or departments.
- We would plan the persistence interface at the start instead of adding file operations directly to the manager later.
- We would define the exact CLI prompts and message order before writing the CLI workflows.
- We would add clearer recovery for damaged or invalid JSON data.
- We would update the README, backlog, design document, and pairing log when each story is completed.
- We would run the complete test suite before merging every feature branch.

## How we will apply these lessons

In future projects, we will define the responsibilities of the model, manager, interface, and storage components during planning. Each user story will be complete only after its behavior, error cases, tests, documentation, and partner review are finished.

## Did the final app meet the original goal?

Yes, the final app met the original goal for this project.

The application successfully supports the core workflow that was planned in the design documents: adding applications, viewing saved records, searching by company, position, or status, updating an application's status, deleting entries, calculating summary statistics, and persisting data between runs in JSON. The optional CSV export feature was also included in the repository's documented feature set, which aligned with the optional scope described in the planning document.

The final result is consistent with the actual development history in the project logs and the accepted user stories. The app is not only complete from a feature standpoint, but it is also validated by the project test suite and lives up to the core purpose described at the start of the project: helping students manage job and internship application tracking in a simple terminal-based tool.

## Conclusion

This project was successful because the team worked with a clear plan, used pair programming effectively, and delivered a functioning Ruby application within the expected scope. The retrospective shows that the project had a strong foundation, some meaningful challenges, and a good final product that met the original purpose.
