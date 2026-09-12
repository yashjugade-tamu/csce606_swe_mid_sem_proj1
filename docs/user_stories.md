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

### User Story 6 - CLI Navigation and Menu

- *Type:* Essential
- *Story points:* 2
- *Primary owner:* Varsha Goalla
- *Sprint:* 2

*As a* student,  
*I want to* use a clear command-line menu,  
*so that I can* easily navigate between JobTrack's functions.

#### Acceptance Criterion 1 - Display the main menu

*Given* I start JobTrack  
*When* the application starts  
*Then* JobTrack displays the available operations  
*And* includes Add, View, Search, Update, Delete, Statistics, and Exit

#### Acceptance Criterion 2 - Select an operation

*Given* the main menu is displayed  
*When* I select a valid menu option  
*Then* JobTrack starts the corresponding operation  
*And* displays the prompts needed for that operation

#### Acceptance Criterion 3 - Reject an invalid menu selection

*Given* the main menu is displayed  
*When* I enter an invalid option  
*Then* JobTrack displays an appropriate error message  
*And* returns to the main menu

#### Acceptance Criterion 4 - Continue using JobTrack

*Given* an operation has completed  
*When* the operation finishes  
*Then* JobTrack returns to the main menu  
*And* terminates only when I select Exit

### User Story 7 - CLI Integration for Application Operations

- *Type:* Essential
- *Story points:* 3
- *Primary owner:* Varsha Goalla
- *Sprint:* 2

*As a* student,  
*I want to* have the CLI guide me through application-management operations,  
*so that I can* use JobTrack without interacting directly with its internal classes.

#### Acceptance Criterion 1 - Complete application operations through the CLI

*Given* JobTrack's main menu is displayed  
*When* I select Add, View, Search, Update, or Delete  
*Then* the CLI collects the required input  
*And* calls the appropriate ApplicationManager method  
*And* displays the result of the operation

#### Acceptance Criterion 2 - Keep business logic outside the CLI

*Given* an application-management operation is requested  
*When* the CLI receives the user's input  
*Then* the CLI delegates the operation to ApplicationManager  
*And* does not implement application business rules itself

#### Acceptance Criterion 3 - Handle operation errors through the CLI

*Given* an operation receives invalid input  
*When* ApplicationManager reports the error  
*Then* the CLI displays an understandable error message  
*And* allows me to continue using JobTrack

## Sprint 3 - Statistics, Persistence, and Export

### User Story 8 - View Application Statistics

- *Type:* Essential
- *Story points:* 2
- *Primary owner:* Varsha Goalla
- *Sprint:* 3

*As a* student,  
*I want to* view the total number of applications and a breakdown by status,  
*so that I can* understand the progress of my job search.

#### Acceptance Criterion 1 - Display total applications and status breakdown

*Given* applications exist  
*When* I select Application Statistics  
*Then* JobTrack displays the total number of applications  
*And* displays counts for Applied, Interview, Offer, and Rejected

#### Acceptance Criterion 2 - Calculate statistics correctly

*Given* there are 2 Applied, 1 Interview, 1 Offer, and 1 Rejected application  
*When* I view statistics  
*Then* JobTrack displays a total of 5  
*And* displays counts of 2, 1, 1, and 1 for the respective statuses

#### Acceptance Criterion 3 - Display statistics for an empty collection

*Given* there are no applications  
*When* I view statistics  
*Then* JobTrack displays a total of 0  
*And* displays 0 for every status

### User Story 9 - Persistent JSON Storage

- *Type:* Essential
- *Story points:* 4
- *Primary owner:* Yash Jugade
- *Sprint:* 3

*As a* student,  
*I want to* have my application data saved to and loaded from a JSON file,  
*so that I can* preserve my applications when I exit and restart JobTrack.

#### Acceptance Criterion 1 - Save applications

*Given* applications exist  
*When* JobTrack saves the application data  
*Then* the applications are stored in a JSON file  
*And* all required application fields are included

#### Acceptance Criterion 2 - Load applications at startup

*Given* a JSON file containing applications exists  
*When* JobTrack starts  
*Then* it loads the applications into the collection  
*And* makes them available to application operations

#### Acceptance Criterion 3 - Preserve application data

*Given* an application was saved  
*When* JobTrack loads the application  
*Then* its ID, company, position, application date, and status remain unchanged  
*And* the restored application behaves like a newly created application

#### Acceptance Criterion 4 - Handle first-time use

*Given* no JSON file exists  
*When* JobTrack starts  
*Then* it starts with an empty collection  
*And* does not terminate unexpectedly

#### Acceptance Criterion 5 - Save before exit

*Given* applications exist in the collection  
*When* I select Exit  
*Then* JobTrack saves the current application data  
*And* terminates after the save completes

### User Story 10 - Export Applications to CSV

- *Type:* Optional stretch feature
- *Story points:* 3
- *Primary owner:* Yash Jugade
- *Sprint:* 3

*As a* student,  
*I want to* export my application data to a CSV file,  
*so that I can* use my JobTrack data in spreadsheet or data-analysis applications.

#### Acceptance Criterion 1 - Export applications

*Given* applications exist  
*When* I select Export to CSV  
*Then* JobTrack creates a CSV file containing the application data  
*And* reports where the file was saved

#### Acceptance Criterion 2 - Export all required fields

*Given* an application is included in an export  
*When* JobTrack writes the CSV file  
*Then* the row contains ID, company, position, application date, and status  
*And* the file contains an appropriate header row

#### Acceptance Criterion 3 - Handle an empty collection

*Given* there are no applications  
*When* I select Export to CSV  
*Then* JobTrack handles the operation gracefully  
*And* displays an appropriate message or creates a valid empty CSV

#### Acceptance Criterion 4 - Initiate export through the CLI

*Given* the JobTrack menu is displayed  
*When* I select Export to CSV  
*Then* the CLI delegates the export to Storage  
*And* displays the result of the export

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