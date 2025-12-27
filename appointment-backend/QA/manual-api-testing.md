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

---

## Test Case 3: Get Available Appointment Slots for a Doctor

| Field | Description |
|------|------------|
| **API** | `GET /api/doctors/{doctorId}/slots` |
| **User Role** | PATIENT |
| **Authentication** | Not Required |
| **Query Parameters** | `rangeStart`, `rangeEnd` |
| **Expected Result** | List of available time slots |
| **Actual Result** | Slots returned successfully |
| **Status** | ✅ Passed |

---

### Request Details

**Endpoint**

GET /api/doctors/{doctorId}/slots


**Path Variable**


doctorId = 694d9500f0d7a87b68898acf


**Query Parameters**


rangeStart=2025-12-26T00:00:00Z
rangeEnd=2025-12-26T23:59:59Z



---

### Response Validation

- HTTP Status Code: **200 OK**
- Response contains a list of available slots
- Each slot includes:
    - `startTime`
    - `endTime`
- Slots are returned in **chronological order**
- Slot duration is consistent (30-minute intervals)

---

### Screenshot Evidence

![Slots_Availability_test.png](screenshots/Slots_Availability_test.png)

### Sample Response

```json
[
  {
    "startTime": "2025-12-26T00:00:00Z",
    "endTime": "2025-12-26T00:30:00Z"
  },
  {
    "startTime": "2025-12-26T00:30:00Z",
    "endTime": "2025-12-26T01:00:00Z"
  },
  {
    "startTime": "2025-12-26T01:00:00Z",
    "endTime": "2025-12-26T01:30:00Z"
  }
]


```
---

## Test Case 4: Book Appointment (Conflict – Slot Already Booked)

| Field | Description |
|------|------------|
| **API** | `POST /api/appointments/book` |
| **User Role** | PATIENT |
| **Authentication** | JWT Bearer Token |
| **Input** | Doctor ID and time slot already booked |
| **Expected Result** | Booking rejected with conflict error |
| **Actual Result** | Conflict error returned |
| **Status** | ✅ Passed |

---

### Request Details

**Endpoint**


**Request Body**
```json
{
  "doctorId": "694d9500f0d7a87b68898acf",
  "startTime": "2025-12-27T20:00:00Z",
  "endTime": "2025-12-27T20:30:00Z"
}

```


Sample Error Response
```json

{
  "timestamp": "2025-12-27T13:55:41.844484665",
  "status": 409,
  "error": "Conflict",
  "message": "Doctor is already booked for this time slot",
  "path": "/api/appointments/book"
}
```

### Screenshot Evidence


![confict_booking_test.png](screenshots/confict_booking_test.png)



---

## Test Case 5: User Signup (Patient Registration)

| Field | Description |
|------|------------|
| **API** | `POST /api/auth/signup` |
| **User Role** | PATIENT |
| **Authentication** | Not Required |
| **Input** | Valid user registration details |
| **Expected Result** | User registered successfully |
| **Actual Result** | User registered |
| **Status** | ✅ Passed |

---

### Request Details

**Endpoint**



**Request Body**
```json
{
  "name": "testing",
  "email": "test@gmail.com",
  "phoneNumber": "123456789",
  "password": "tester01",
  "role": "PATIENT",
  "latitude": 28.6139,
  "longitude": 77.2090
}
```

***Response Validation***
---
HTTP Status Code: 201 Created

User record created successfully

Response confirms successful registration
---
***Sample Response***
User registered successfully


### Screenshot Evidence

![signup_test.png](screenshots/signup_test.png)


---

## Test Case 6: User Login (JWT Authentication)

| Field | Description |
|------|------------|
| **API** | `POST /api/auth/login` |
| **User Role** | PATIENT |
| **Authentication** | Not Required |
| **Input** | Valid email and password |
| **Expected Result** | JWT access token issued |
| **Actual Result** | JWT token received |
| **Status** | ✅ Passed |

---

### Request Details

**Endpoint**



**Request Body**
```json
{
  "email": "pankajrana@duck.com",
  "password": "NewPassword@123"
}
```

***Response Validation***
---
HTTP Status Code: 200 OK

JWT access token returned successfully

Token metadata includes:

accessToken

tokenType

expiresIn

---

***Sample Response***
```json
{
"accessToken": "eyJhbGciOiJIUzI1NiJ9...",
"tokenType": "Bearer",
"expiresIn": 360000
}
```

### Screenshot Evidence

![login_test.png](screenshots/login_test.png)


## Conclusion

All tested APIs behaved as expected under real-world conditions.  
Manual testing successfully validated the **core problem statement requirements**, including appointment booking and nearby doctor discovery.

