# Automated Testing – Appointment Backend

## Overview

Automated testing was implemented to validate **critical backend business rules**
of the Doctor Appointment Booking System.

Unlike manual API testing (which validates API behavior and user workflows),
automated tests focus on **core service-level logic** such as conflict prevention,
time validation, and booking correctness.

This layered testing strategy ensures:
- High confidence in business rules
- Faster regression detection
- Deterministic and repeatable test execution

---

## Scope of Automated Testing

Automated tests were intentionally scoped to **service-level testing** rather than
controller-level or UI-level testing.

| Layer | Testing Method | Status |
|-----|---------------|--------|
| Service Layer | Automated (JUnit + Mockito) | ✅ Implemented |
| Controller Layer | Manual (Postman) | ✅ Implemented |
| UI Layer | Manual | ✅ Implemented |

Controller behavior, authentication flow, and API responses are covered
through **manual Postman testing**, while automated tests ensure
**business logic correctness**.

---

## Tools & Frameworks Used

- **Spring Boot Test**
- **JUnit 5**
- **Mockito**
- **Gradle Test Runner**

All external dependencies (repositories, notification services, schedulers)
are mocked to ensure tests remain fast and isolated.

---

## Service-Level Tests Implemented

### BookingServiceTest

This test suite validates the **core appointment booking engine**.

#### Business Rules Covered

✅ **Doctor Conflict Prevention**
- Prevents booking if the doctor already has an overlapping appointment

✅ **Patient Conflict Prevention**
- Prevents patients from booking overlapping appointments

✅ **Time Range Validation**
- Rejects invalid bookings where end time is before start time

✅ **Happy Path Booking**
- Successfully books appointment when no conflicts exist

✅ **Side Effects Validation**
- Creates reminder notification for booked appointment
- Triggers recomputation of doctor availability

---

### Example Test Scenarios

#### 1. Doctor Overlapping Appointment (Rejected)
- Existing doctor appointment overlaps requested time
- Booking request fails with conflict exception

#### 2. Patient Overlapping Appointment (Rejected)
- Patient already has an appointment during requested time
- Booking request is rejected

#### 3. Valid Booking (Success)
- No doctor conflict
- No patient conflict
- Appointment is saved successfully
- Notifications and availability updates are triggered

---

## Testing Strategy Rationale

### Why Service-Level Tests?

- Focuses on **business correctness**, not HTTP wiring
- Avoids dependency on:
    - MongoDB
    - Firebase
    - Email providers
- Faster execution than integration tests
- Easier to maintain as APIs evolve

### Why Not Controller-Level Automation?

Controller logic is intentionally kept thin and primarily:
- Handles authentication
- Validates request payloads
- Delegates to services

These behaviors are better validated through:
- **Manual API testing (Postman)**
- **End-to-end functional verification**

This prevents duplicated effort and keeps tests meaningful.

---

## Test Isolation & Reliability

- All repositories are mocked
- No external services are called
- No database setup required
- Tests are deterministic and repeatable

This ensures:
- Tests run consistently across environments
- CI/CD friendliness
- Faster feedback during development

---

## Test Execution Evidence

Below screenshots demonstrate successful execution of automated tests:

- Booking service test execution
- Conflict prevention validation
- Successful booking scenario

![Booking Service Test Result](screenshots/booking-service-test.png)

![Patient Conflict Test](screenshots/booking-service-patient-conflict.png)

![Happy Path Booking Test](screenshots/booking-service-happy-path.png)

![Reject invalid time ranges.png](screenshots/Reject%20invalid%20time%20ranges.png)

![Handle race conditions.png](screenshots/Handle%20race%20conditions.png)

---

## Relationship with Manual Testing

Automated testing **does not replace** manual testing — both work together.

| Manual Testing | Automated Testing |
|---------------|------------------|
| Validates API responses | Validates business rules |
| Verifies user flows | Verifies internal logic |
| Covers authentication | Covers conflict handling |
| Uses real data | Uses mocked dependencies |

This combined approach ensures **maximum coverage with minimal redundancy**.

---

## Conclusion

Automated testing ensures that the most critical rules of the appointment
booking system are always enforced.

By validating conflict prevention, time correctness, and booking integrity
at the service layer, the system remains robust, scalable, and resistant
to regressions as new features are introduced.

Controller behavior and end-user flows are comprehensively validated
through manual API testing, completing a full QA strategy aligned
with the Veersa Hackathon guidelines.
