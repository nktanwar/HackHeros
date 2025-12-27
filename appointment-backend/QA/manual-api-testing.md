# Manual API Testing – Appointment Backend

## Overview

Manual API testing was performed using **Postman** to validate all critical workflows of the **Doctor Appointment Booking System**.  
These tests ensure correctness, reliability, and a smooth user experience in accordance with the **Veersa Hackathon QA Guidelines**.

---

## Tools Used

- **Postman** – for API request execution and validation
- **JWT Authentication** – for secured API access
- **MongoDB (Test Environment)** – for data persistence during testing

---

## Test Case 1: Book Appointment (Success)

| Field | Description |
|------|------------|
| **API** | `POST /api/appointments/book` |
| **User Role** | PATIENT |
| **Authentication** | JWT Bearer Token |
| **Input** | Valid `doctorId`, `startTime`, `endTime` |
| **Expected Result** | Appointment booked successfully |
| **Actual Result** | Appointment booked |
| **Status** | ✅ Passed |

### Test Steps

1. Login as a **patient** and obtain a valid JWT token
2. Call the API endpoint `/api/appointments/book`
3. Provide a valid request body with doctor ID and time slot
4. Verify the response status is **HTTP 200 OK**
5. Confirm appointment is created successfully

### Screenshot Evidence

![Book Appointment Success Test](screenshots/book-appointment-success.png)

---

## Test Case 2: Search Doctors by Location & Specialty (Nearby Doctors)

| Field | Description |
|------|------------|
| **API** | `GET /api/doctors/search` |
| **User Role** | PATIENT |
| **Authentication** | Not Required |
| **Query Parameters** | `latitude`, `longitude`, `specialty`, `maxDistanceKm` |
| **Expected Result** | Doctors returned sorted by shortest distance |
| **Actual Result** | Doctors returned with correct distances |
| **Status** | ✅ Passed |

### Request Details

**Endpoint**


**Query Parameters**

latitude=29.013105
longitude=77.045868
specialty=Cardiologist
maxDistanceKm=100


### Response Validation

- HTTP Status Code: **200 OK**
- Doctors belong to requested **specialty**
- Each record includes:
    - `doctorId`
    - `clinicName`
    - `specialty`
    - `distanceInKm`
    - `latitude`
    - `longitude`
- Results are sorted by **distanceInKm (ascending)**

### Screenshot Evidence

![Doctor Search Test](screenshots/doctor-search.png)

---

## Conclusion

All tested APIs behaved as expected under real-world conditions.  
Manual testing successfully validated the **core problem statement requirements**, including appointment booking and nearby doctor discovery.

