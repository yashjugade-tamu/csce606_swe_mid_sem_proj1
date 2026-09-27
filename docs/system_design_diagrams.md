# JobTrack System Design Diagrams

## High-level architecture

```mermaid
flowchart LR
    User[User] --> CLI[CLI Menu\nlib/job_track/cli.rb]
    CLI --> Manager[ApplicationManager\nbusiness logic + persistence]
    Manager --> App[Application\nvalidated job record]
    Manager --> JSON[(applications.json)]
    Manager --> CSV[CSVExporter]
    CSV --> CSVFile[(applications_export.csv)]
```

## Runtime flow: add application

```mermaid
sequenceDiagram
    actor User
    participant CLI as CLI
    participant Manager as ApplicationManager
    participant App as Application
    participant Store as applications.json

    User->>CLI: Select "Add Application"
    CLI->>User: Prompt for company, position, date, status
    User-->>CLI: Input values
    CLI->>Manager: add_application(...)
    Manager->>App: Application.new(...)
    App-->>Manager: Validated object
    Manager->>Store: save_to_json()
    Manager-->>CLI: Application instance
    CLI-->>User: Success message
```

## Class-level design

```mermaid
classDiagram
    class Application {
        +id
        +company
        +position
        +application_date
        +status
        +update_status(new_status)
        -validate_id()
        -validate_required_text()
        -validate_date()
        -validate_status()
    }

    class ApplicationManager {
        +applications
        +add_application(...)
        +update_application_status(...)
        +delete_application(...)
        +search_applications(...)
        +application_statistics()
        +load_from_json()
        +save_to_json()
        +export_to_csv()
        +print_applications(...)
    }

    class CLI {
        +run()
        +add_application()
        +view_applications()
        +search_applications()
        +update_application_status()
        +delete_application()
        +application_statistics()
        +export_applications_to_csv()
    }

    class CSVExporter {
        +export(applications, output_path)
        -resolve_output_path()
        -validate_output_path!()
        -extract_row()
    }

    ApplicationManager o-- Application
    CLI --> ApplicationManager
    ApplicationManager --> CSVExporter
```

## Major system design choices and justification

### 1. CLI-first architecture
The application is designed as a command-line interface instead of a graphical or web-based interface because the project is a terminal application and the user interaction model is menu-driven. This keeps the system simple, easy to test, and aligned with the assignment requirements.

### 2. Separation of responsibilities between CLI, manager, and domain model
The system divides responsibilities across three main layers:
- CLI handles user interaction and menu routing.
- ApplicationManager handles application collection logic and persistence.
- Application encapsulates domain validation and business rules.

This separation is justified because it keeps the code easier to understand, reduces coupling, and makes it easier to extend later with new features.

### 3. Validation inside the Application model
Each Application validates its own required fields, date format, and allowed status values before being accepted into the system. This is an important design choice because invalid data should not enter the system at all, which reduces downstream errors and keeps the state consistent.

### 4. JSON as the persistence mechanism
The application stores records in a local JSON file rather than a database. This is justified for a small project with limited scope because it is simple to implement, requires no external services, and works well for a terminal app that stores a manageable amount of data.

### 5. CSV export as a separate specialized component
CSV export is handled by a dedicated CSVExporter class instead of being embedded directly in the manager. This is a good design choice because exporting is a distinct concern from business logic and can be changed independently without affecting the core application behavior.

### 6. In-memory collection with load/save behavior
The manager keeps applications in memory while the system is running and saves them to disk after changes. This design is appropriate for a small CLI application because it is fast, simple, and easy to reason about while still preserving data between runs.

### 7. Restricted status enumeration
The application defines a closed set of accepted statuses: Applied, Interview, Offer, Rejected. This reduces inconsistent data, improves reporting accuracy, and makes filtering and statistics reliable.

## System design summary

- The CLI acts as the presentation layer and user entry point.
- The ApplicationManager is the core service object for business operations and persistence.
- The Application class encapsulates validation and status rules.
- Data is stored in JSON for local persistence and exported to CSV for reporting.
- This is a layered, lightweight architecture suitable for a small terminal application.
