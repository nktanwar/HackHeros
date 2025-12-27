# Automated Testing – Appointment Backend

## Overview
Automated tests were implemented to validate critical business rules
of the appointment booking system. The focus was on ensuring reliability,
correctness, and prevention of invalid operations such as conflicting
appointments.

Service-level tests were chosen to validate core business logic in
isolation, without dependency on external infrastructure.

---

## Testing Approach Used
- Automated Unit / Service Tests using Spring Boot
- JUnit 5 for test execution
- Mockito for mocking dependencies

This approach aligns with the QA Guidelines provided for the hackathon.

---

## Service-Level Tests Implemented

### BookingServiceTest
The following business rules were validated:

- Prevents booking if a doctor already has an overlapping appointment
- Ensures conflict detection logic works correctly before persisting data
- Ensures invalid booking requests are rejected with proper exceptions
- Prevents patient from booking overlapping appointments


These tests load only the required service and mock its dependencies,
ensuring fast and deterministic test execution.

---

## Test Execution Evidence

The screenshot below shows successful execution of automated Spring Boot
tests using Gradle.

![Booking Service Test Result](screenshots/booking-service-test.png)

![Patient Conflict Test](screenshots/booking-service-patient-conflict.png)


---

## Why Service-Level Tests?
- Validates business rules independently of API and UI layers
- Avoids dependency on external services such as databases or messaging
- Faster execution compared to full integration tests
- Easier to maintain and extend

---

## Conclusion
Automated testing ensures that critical appointment booking rules
are consistently enforced and reduces the risk of regressions as the
application evolves.
