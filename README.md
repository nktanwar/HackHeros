# 🩺 Veersa – Doctor Appointment Booking System

## 📌 Project Overview
**Veersa Health** is a robust, full-stack platform designed to bridge the gap between patients and healthcare providers. It enables users to discover local doctors, verify real-time availability, and secure appointments through a seamless digital workflow.

The system is engineered for **scalability and reliability**, mirroring real-world healthcare demands. This repository contains the complete frontend, backend, and QA documentation structured for hackathon evaluation.


***🎥 ***Project Demo Video (5 Minutes)***  ***
👉 https://drive.google.com/file/d/1mLfcZNTHX90YadbyT_h3lnuGKhd7zJ1z/view?usp=drivesdk


***APPlication Link : https://github.com/nktanwar/HackHeros/releases/download/v1.0/app-release.apk ***


---

## 📁 Repository Structure
```bash
repo-root/
│
├── appointment-backend/      # Spring Boot Service & Docker configs
│   ├── src/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── README.md
│
├── frontend/                 # Client-side application
│   └── veersa_health/
│
├── QA/                       # Testing artifacts & reports
│   ├── manual-api-testing.md
│   ├── Automated-Tests.md
│   ├── QA-Test-Mapping.md
│   └── screenshots/          # Evidence of successful test runs
│
└── README.md                 # Project entry point

```


💻 Modules
🔹 Frontend

Location: frontend/veersa_health

    Discovery: Dynamic search for nearby doctors.

    Booking: Interactive UI for selecting available time slots.

    UX: Responsive design tailored for patient accessibility.

⚙️ Backend

Location: appointment-backend/ The core engine handles authentication, scheduling logic, and notification triggers.

Environment Configuration (.env):

#Backend uses a .env file for runtime configuration.

```bash
SPRING_DATA_MONGODB_URI=mongodb://mongo:27017/appointment
JWT_SECRET=your-secret-key
JWT_EXPIRATION_MS=3600000
RESEND_API_KEY=your-resend-key
```

🧪 Quality Assurance & Testing

We have prioritized reliability through a structured testing suite. All artifacts required for evaluation are located in the /QA directory.
```bash
cd QA/
```

All testing artifacts required by the hackathon have been documented and included.

**QA Documents**
| File                    | Description                         |
| ----------------------- | ----------------------------------- |
| `manual-api-testing.md` | Manual API testing using Postman    |
| `Automated-Tests.md`    | Automated unit/service test summary |
| `QA-Test-Mapping.md`    | Requirement-to-test-case mapping    |



Testing Coverage

    User Management: Signup & Login (JWT Secured).

    Search Engine: Specialty & Geo-based doctor discovery.

    Slot Logic: Real-time availability retrieval.

    Transaction: Conflict-safe appointment booking.

    Security: Authentication & Authorization validation.

    [!TIP] 📸 Screenshot Evidence: Visual proof of successful testing and system functionality is available under QA/screenshots/.

***📸 Screenshot evidence is available under:***

QA/screenshots/



🛡️ Security & Reliability

    JWT-Based Authentication: Secure, stateless session management.

    Credential Safety: Automatic token invalidation on password reset.

    Access Control: Role-based API protection (RBAC).

    Data Integrity: Strict input validation using Jakarta Validation.

    Concurrency: Race-condition protection for appointment scheduling.

🏁 Hackathon Compliance Checklist

    [x] Backend: Fully implemented Spring Boot service.

    [x] Frontend: Structured and integrated UI components.

    [x] Manual Testing: API verification completed via Postman.

    [x] Automated Testing: Unit and service tests documented.

    [x] Deployment: Dockerized environment for easy setup.

    [x] Documentation: Clear, structured, and easy to navigate.


    
👥 Contributors

    Pankaj Rana – Backend & System Design

    Sachin – Frontend Development

    Shashi Kant – Frontend Development

    

📎 Notes for Reviewers: This README serves as the primary entry point for judges. For technical verification, please refer to the documents within the QA folder.
