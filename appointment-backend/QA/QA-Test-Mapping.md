# QA Requirement to Test Mapping

This document maps functional requirements from the problem statement
to the corresponding tests implemented in the system.

| Requirement ID | Description | Test Type | Test Reference |
|---------------|------------|----------|----------------|
| FR-1 | Book appointment | Automated Service Test | BookingServiceTest |
| FR-2 | Prevent doctor appointment conflicts | Automated Service Test | BookingServiceTest |
| FR-3 | Prevent patient overlapping appointments | Automated Service Test | BookingServiceTest |
| FR-4 | Validate booking time range | Automated Service Test | BookingServiceTest |

---

## Notes
- Service-level tests focus on business rules rather than API behavior
- External dependencies are mocked to ensure test reliability
- Additional API and UI tests are planned using Postman and manual testing
