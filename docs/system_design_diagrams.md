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

## System design summary

- The CLI acts as the presentation layer and user entry point.
- The ApplicationManager is the core service object for business operations and persistence.
- The Application class encapsulates validation and status rules.
- Data is stored in JSON for local persistence and exported to CSV for reporting.
- This is a layered, lightweight architecture suitable for a small terminal application.
