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
