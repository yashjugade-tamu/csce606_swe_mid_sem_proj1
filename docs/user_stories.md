# JobTrack User Stories

JobTrack is a terminal-based application for students to organize and track job and internship applications. These ten stories form three thin vertical sprints and total 30 story points. Stories User Story 1-User Story 9 are essential and User Story 10 is an optional stretch story.

## Sprint 1 - Basic Application Management

### User Story 1 - Add a Job Application

- **Type:** Essential
- **Story points:** 5
- **Primary owner:** Varsha Goalla
- **Sprint:** 1

**As a** student,  
**I want to** add a job or internship application with its company, position, application date, and status,  
**so that I can** keep track of the opportunities I have applied to.

#### Acceptance Criterion 1 - Successfully add an application

**Given** I am using JobTrack  
**And** there are no applications currently saved  
**When** I enter a company name, position, valid application date, and valid status  
**Then** JobTrack creates the application  
**And** assigns it a unique ID  
**And** adds it to the application collection

#### Acceptance Criterion 2 - Reject an invalid application date

**Given** I am adding an application  
**When** I enter an invalid date such as 2026-02-30  
**Then** JobTrack rejects the application  
**And** displays an appropriate error message  
**And** does not add the application to the collection

#### Acceptance Criterion 3 - Reject an invalid status

**Given** I am adding an application  
**When** I enter a status other than Applied, Interview, Offer, or Rejected  
**Then** JobTrack rejects the application  
**And** displays the permitted statuses  
**And** does not add the application to the collection

#### Acceptance Criterion 4 - Reject missing required fields

**Given** I am adding an application  
**When** I leave the company name or position empty  
**Then** JobTrack rejects the application  
**And** identifies the missing required field  
**And** allows me to continue using JobTrack

### User Story 2 - View All Applications

- **Type:** Essential
- **Story points:** 3
- **Primary owner:** Yash Jugade
- **Sprint:** 1

**As a** student,  
**I want to** view all of my saved job and internship applications,  
**so that I can** review my current applications in one place.

#### Acceptance Criterion 1 - Display one saved application

**Given** an application has been added  
**When** I select View All Applications  
**Then** JobTrack displays the saved application  
**And** shows its ID, company, position, application date, and status

#### Acceptance Criterion 2 - Display multiple applications

**Given** multiple applications have been added  
**When** I select View All Applications  
**Then** JobTrack displays every application separately  
**And** shows all required fields for each application

#### Acceptance Criterion 3 - Handle an empty collection

**Given** there are no applications  
**When** I select View All Applications  
**Then** JobTrack displays a message that there are no applications  
**And** returns to the main menu without terminating unexpectedly

## Sprint 2 - Application Management and CLI

### User Story 3 - Search Applications

- **Type:** Essential
- **Story points:** 3
- **Primary owner:** Yash Jugade
- **Sprint:** 2

**As a** student,  
**I want to** search for applications by company name, position, or application status,  
**so that I can** quickly find specific applications.

#### Acceptance Criterion 1 - Search by company

**Given** applications from multiple companies exist  
**When** I search by company name  
**Then** JobTrack displays the matching applications  
**And** does not display nonmatching applications

#### Acceptance Criterion 2 - Search by position

**Given** applications with different positions exist  
**When** I search by position  
**Then** JobTrack displays the matching applications  
**And** does not display applications with other positions

#### Acceptance Criterion 3 - Search by status

**Given** applications with different statuses exist  
**When** I search by status  
**Then** JobTrack displays the matching applications  
**And** does not display applications with other statuses

#### Acceptance Criterion 4 - Handle no matching results

**Given** applications exist  
**When** I search for a value that matches no application  
**Then** JobTrack reports that no matching applications were found  
**And** does not display unrelated applications

#### Acceptance Criterion 5 - Reject invalid search input

**Given** I am performing a search  
**When** I provide an invalid or empty search value  
**Then** JobTrack displays an appropriate message  
**And** does not terminate unexpectedly  
**And** allows me to search again or return to the menu

### User Story 4 - Update Application Status

- **Type:** Essential
- **Story points:** 3
- **Primary owner:** Varsha Goalla
- **Sprint:** 2

**As a** student,  
**I want to** update the hiring stage of an existing application,  
**so that I can** keep its status current as I progress through the hiring process.

#### Acceptance Criterion 1 - Successfully update a status

**Given** an application with a valid ID exists  
**When** I enter a valid new status  
**Then** JobTrack updates the application's status  
**And** displays the updated application

#### Acceptance Criterion 2 - Accept only permitted statuses

**Given** an application exists  
**When** I update it to Applied, Interview, Offer, or Rejected  
**Then** JobTrack accepts the new status  
**And** preserves the application's other information

#### Acceptance Criterion 3 - Reject an invalid status

**Given** an application exists  
**When** I enter an unsupported status  
**Then** JobTrack rejects the update  
**And** keeps the original status unchanged  
**And** displays an appropriate error message

#### Acceptance Criterion 4 - Reject an invalid application ID

**Given** no application exists with the specified ID  
**When** I attempt to update that application  
**Then** JobTrack displays an error message  
**And** does not modify any application

### User Story 5 - Delete an Application

- **Type:** Essential
- **Story points:** 2
- **Primary owner:** Yash Jugade
- **Sprint:** 2

**As a** student,  
**I want to** delete an application using its application ID,  
**so that I can** remove applications I no longer want to track.

#### Acceptance Criterion 1 - Successfully delete an application

**Given** an application with a valid ID exists  
**When** I choose to delete it  
**Then** JobTrack removes the application  
**And** the application no longer appears in the application list

#### Acceptance Criterion 2 - Reject an invalid ID

**Given** no application exists with the specified ID  
**When** I attempt to delete it  
**Then** JobTrack displays an error message  
**And** does not delete any other application

#### Acceptance Criterion 3 - Delete from an empty collection

**Given** there are no applications  
**When** I attempt to delete an application  
**Then** JobTrack reports that no matching application exists  
**And** continues running normally

### User Story 6 - Main Menu Navigation

- **Type:** Essential
- **Story points:** 2
- **Primary owner:** Varsha Goalla
- **Sprint:** 2

**As a** student,  
**I want to** use a clear main menu to select JobTrack functions,  
**so that I can** easily navigate the application without confusion.

#### Acceptance Criterion 1 - Display main menu

**Given** I start JobTrack  
**When** the application is ready  
**Then** JobTrack displays the main menu  
**And** shows the available application management options

#### Acceptance Criterion 2 - Select a valid menu option

**Given** the main menu is displayed  
**When** I select a valid menu option  
**Then** JobTrack opens the corresponding function

#### Acceptance Criterion 3 - Reject an invalid menu option

**Given** the main menu is displayed  
**When** I enter an invalid menu option  
**Then** JobTrack displays an appropriate error message  
**And** displays the main menu again  
**And** continues running normally

#### Acceptance Criterion 4 - Exit the application

**Given** the main menu is displayed  
**When** I select the exit option  
**Then** JobTrack terminates normally  
**And** does not display an unexpected error

### User Story 7 - Validate Application Input

- **Type:** Essential
- **Story points:** 3
- **Primary owner:** Yash Jugade
- **Sprint:** 3

**As a** student,  
**I want to** receive clear validation when I enter invalid application information,  
**so that I can** correct mistakes before saving or modifying an application.

#### Acceptance Criterion 1 - Validate company name

**Given** I am entering an application  
**When** I provide a valid company name  
**Then** JobTrack accepts the company name

#### Acceptance Criterion 2 - Reject empty company name

**Given** I am entering an application  
**When** I leave the company name empty  
**Then** JobTrack rejects the input  
**And** displays an appropriate error message  
**And** allows me to enter the company name again

#### Acceptance Criterion 3 - Validate position

**Given** I am entering an application  
**When** I provide a valid position  
**Then** JobTrack accepts the position

#### Acceptance Criterion 4 - Reject empty position

**Given** I am entering an application  
**When** I leave the position empty  
**Then** JobTrack rejects the input  
**And** displays an appropriate error message  
**And** allows me to enter the position again

### User Story 8 - Persist Applications

- **Type:** Essential
- **Story points:** 3
- **Primary owner:** Varsha Goalla
- **Sprint:** 3

**As a** student,  
**I want to** have my applications saved between JobTrack sessions,  
**so that I can** continue tracking my applications without losing previously entered information.

#### Acceptance Criterion 1 - Save an application

**Given** I have entered a valid application  
**When** I save the application  
**Then** JobTrack stores the application  
**And** preserves its ID, company, position, application date, and status

#### Acceptance Criterion 2 - Load saved applications

**Given** previously saved applications exist  
**When** I start JobTrack  
**Then** JobTrack loads the saved applications  
**And** makes them available through the application menu

#### Acceptance Criterion 3 - Preserve multiple applications

**Given** multiple applications have been saved  
**When** I restart JobTrack  
**Then** all previously saved applications are available  
**And** each application retains its original information

#### Acceptance Criterion 4 - Handle no saved data

**Given** no saved applications exist  
**When** I start JobTrack  
**Then** JobTrack starts normally  
**And** displays an empty application collection

### User Story 9 - Application Statistics

- **Type:** Essential
- **Story points:** 3
- **Primary owner:** Yash Jugade
- **Sprint:** 3

**As a** student,  
**I want to** view a summary of my applications by status,  
**so that I can** understand my progress through the hiring process.

#### Acceptance Criterion 1 - Display application totals

**Given** applications exist  
**When** I select Application Statistics  
**Then** JobTrack displays the total number of applications

#### Acceptance Criterion 2 - Display status counts

**Given** applications with different statuses exist  
**When** I select Application Statistics  
**Then** JobTrack displays the number of applications with each status  
**And** includes Applied, Interview, Offer, and Rejected

#### Acceptance Criterion 3 - Handle an empty collection

**Given** there are no applications  
**When** I select Application Statistics  
**Then** JobTrack displays zero applications  
**And** displays zero for each status  
**And** continues running normally

### User Story 10 - Export Applications

- **Type:** Optional Stretch
- **Story points:** 3
- **Primary owner:** Varsha Goalla
- **Sprint:** 3

**As a** student,  
**I want to** export my saved applications to a file,  
**so that I can** keep a backup or use my application information outside JobTrack.

#### Acceptance Criterion 1 - Successfully export applications

**Given** one or more applications are saved  
**When** I select the export option  
**Then** JobTrack creates an export file  
**And** includes each application's ID, company, position, application date, and status

#### Acceptance Criterion 2 - Export multiple applications

**Given** multiple applications exist  
**When** I export the applications  
**Then** every application is included in the export file  
**And** each application remains separately identifiable

#### Acceptance Criterion 3 - Handle an empty collection

**Given** there are no applications  
**When** I select the export option  
**Then** JobTrack displays a message that there are no applications to export  
**And** does not terminate unexpectedly

#### Acceptance Criterion 4 - Report export errors

**Given** JobTrack cannot create or write to the export file  
**When** I attempt to export applications  
**Then** JobTrack displays an appropriate error message  
**And** continues running normally

## Story-Point and Ownership Summary

| Sprint | Story | Feature | Owner | Type | Points |
| --- | --- | --- | --- | --- | ---: |
| 1 | User Story 1 | Add a Job Application | Varsha Goalla | Essential | 5 |
| 1 | User Story 2 | View All Applications | Yash Jugade | Essential | 3 |
| 2 | User Story 3 | Search Applications | Yash Jugade | Essential | 3 |
| 2 | User Story 4 | Update Application Status | Varsha Goalla | Essential | 3 |
| 2 | User Story 5 | Delete an Application | Yash Jugade | Essential | 2 |
| 2 | User Story 6 | CLI Navigation and Menu | Varsha Goalla | Essential | 2 |
| 2 | User Story 7 | CLI Integration for Application Operations | Varsha Goalla | Essential | 3 |
| 3 | User Story 8 | View Application Statistics | Varsha Goalla | Essential | 2 |
| 3 | User Story 9 | Persistent JSON Storage | Yash Jugade | Essential | 4 |
| 3 | User Story 10 | Export Applications to CSV | Yash Jugade | Optional | 3 |
|  |  | *Varsha total* |  |  | *15* |
|  |  | *Yash total* |  |  | *15* |
|  |  | *Team total* |  |  | *30* |

## Sprint Summary

| Sprint | Varsha | Yash | Total |
| --- | --- | --- | ---: |
| 1 | User Story 1 (5) | User Story 2 (3) | 8 |
| 2 | User Story 4 (3), User Story 6 (2), User Story 7 (3) | User Story 3 (3), User Story 5 (2) | 13 |
| 3 | User Story 8 (2) | User Story 9 (4), User Story 10 (3) | 9 |
|  | *15 points* | *15 points* | *30* |