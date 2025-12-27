
### Backend Tech Stack
- **Spring Boot (Kotlin)**
- **MongoDB**
- **JWT Authentication**
- **Firebase Cloud Messaging**
- **Docker & Docker Compose**

### Core Backend Features
- User authentication (Signup / Login)
- Role-based access control (PATIENT / DOCTOR)
- Doctor profile & availability management
- Geo-based doctor search
- Slot availability computation
- Conflict-safe appointment booking
- Push notification scheduling

---

## 🚀 Running the Backend (Docker)

### Prerequisites
- Docker
- Docker Compose
- or
- Java 17+
- ideally IntelliJ IDEA


### Start Backend Services
```bash
cd appointment-backend
docker compose up -d
```

***🧪 QA & Testing***
📁QA/

All testing artifacts required by the hackathon have been documented and included.

| File                    | Description                         |
| ----------------------- | ----------------------------------- |
| `manual-api-testing.md` | Manual API testing using Postman    |
| `Automated-Tests.md`    | Automated unit/service test summary |
| `QA-Test-Mapping.md`    | Requirement-to-test-case mapping    |


***Testing Coverage***

---
User Signup & Login (JWT)

Doctor search (Specialty & Geo-based)

Slot availability retrieval

Appointment booking

Conflict handling (409)

Authentication & authorization validation

---

***📸 Screenshot evidence is available under:***
QA/screenshots/


