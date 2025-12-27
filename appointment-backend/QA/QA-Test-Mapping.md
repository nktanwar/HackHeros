# QA Requirement to Test Mapping

This document maps functional and non-functional requirements from the
problem statement to the corresponding tests implemented in the system.

---

## Functional Requirement Mapping

| Requirement ID | Description | Test Type | Test Reference |
|---------------|------------|----------|----------------|
| FR-1 | Book appointment successfully | Automated Service Test | BookingServiceTest |
| FR-2 | Prevent doctor appointment conflicts | Automated Service Test | BookingServiceTest |
| FR-3 | Prevent patient overlapping appointments | Automated Service Test | BookingServiceTest |
| FR-4 | Validate booking time range | Automated Service Test | BookingServiceTest |
| FR-5 | Handle concurrent booking race conditions | Automated Service Test | BookingServiceTest |


---

## Supporting Quality Checks

| Quality Aspect | Validation Method | Test Type |
|---------------|------------------|----------|
| Business rule enforcement | Service-level validation | Automated |
| Conflict prevention | Pre-save conflict checks | Automated |
| Data integrity under concurrency | DB constraint safety | Automated |
| API behavior & workflows | Endpoint validation | Manual (Postman) |
| Authentication & authorization | JWT-based testing | Manual |

---

## Notes

- Automated tests focus on **business rules and data integrity**
- External dependencies (DB, notifications, async jobs) are mocked
- Manual API testing validates controller behavior and user workflows
- Combined testing approach ensures **maximum coverage with minimal redundancy**
