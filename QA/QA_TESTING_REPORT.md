# Quality Assurance & Testing Report

**Project Name:** Veersa Health \
**Team Name:** HackHeros\
**Platform:** Android (Flutter)\
**Date:** December 27, 2025\
**Status:** PASSED (100%)

---

## 1. Executive Summary
This document outlines the testing strategy, execution, and results for the Veersa Health mobile application. The testing phase focused on ensuring critical user flows—including Authentication, Appointment Scheduling, Geolocation Services, and Smart Notifications—function seamlessly under hackathon constraints.

* **Total Test Cases Executed:** 18
* **Pass Rate:** 100%
* **Critical Defects:** 0 (All resolved)
* **Testing Scope:** Functional UI, API Integration, Geolocation Logic, Authentication Flows.

---

## 2. Test Environment
Testing was conducted using industry-standard tools compatible with the Flutter ecosystem.

* **Framework:** Flutter (Dart)
* **Primary Device:** Android Emulator (Pixel 6, API Level 33)
* **Secondary Device:** Physical Android Device (Android 15)

---

## 3. Comprehensive Manual Test Cases

### Module A: Onboarding & Authentication
**Focus:** Verifying secure user entry, sign-up flows, and OTP validation.

| ID | Feature | Test Scenario | Expected Result | Status |
| :--- | :--- | :--- | :--- | :--- |
| TC01 | Onboarding | Launch app and navigate through intro slides to "Get Started". | App navigates to Login Screen. | PASS |
| TC02 | Navigation | Tap "Create Account" on Login Screen. | Navigates to "Create Your Account" form. | PASS |
| TC03 | Sign Up | Fill valid Name, Email, Mobile, Password, and agree to Terms. Tap "Next". | System accepts data and navigates to OTP Verification screen. | PASS |
| TC04 | Form Validation | Attempt Sign Up with mismatched "Confirm Password" field. | Error message displayed; User remains on screen. | PASS |
| TC05 | OTP Verification | Enter valid 6-digit code on "Verify Email" screen and tap "Validate". | Account verified; User redirected to Success/Loading screen. | PASS |
| TC06 | Login | Enter valid credentials (shashikantyadav9718@gmail.com) and tap Login. | Authentication successful; Redirects to Home Dashboard. | PASS |

### Module B: Location & Discovery
**Focus:** Verifying geolocation permissions and "Smart Sorting" of doctors.

| ID | Feature | Test Scenario | Expected Result | Status |
| :--- | :--- | :--- | :--- | :--- |
| TC07 | Permissions | Trigger Location Permission dialog and select "While using the app". | App detects and displays current location (e.g., "Paniyala..."). | PASS |
| TC08 | Search | Enter "Cardiologist" in the Home Screen search bar. | List filters to show only Cardiologists. | PASS |
| TC09 | Smart Sort | Scroll to "Nearby Doctors" section. | Doctors are displayed sorted by shortest distance (e.g., 12271.4 km). | PASS |
| TC10 | Categories | Tap on the "Gynecologist" category icon. | Dashboard updates to show relevant specialists. | PASS |

### Module C: Appointment Management
**Focus:** Verifying the core booking loop and data persistence.

| ID | Feature | Test Scenario | Expected Result | Status |
| :--- | :--- | :--- | :--- | :--- |
| TC11 | Booking | Select Doctor -> Choose Date/Time -> Confirm Booking. | "Appointment Confirmed" success message appears. | PASS |
| TC12 | My Appointments | Navigate to "My Appointments" tab. | Newly booked appointment appears under "Upcoming" list. | PASS |
| TC13 | Details View | Tap on an appointment card (e.g., "Dr. Pankaj Rana"). | Opens detailed view with Clinic Name, Time, and Map. | PASS |
| TC14 | Navigation | Tap "Get Directions" on the details screen. | Opens external Maps app with route to the clinic. | PASS |

### Module D: Notifications & Profile
**Focus:** Verifying "Smart Reminders" and user settings.

| ID | Feature | Test Scenario | Expected Result | Status |
| :--- | :--- | :--- | :--- | :--- |
| TC15 | Smart Reminder | Schedule appointment for 10 mins from now. Wait for trigger. | Notification appears: "Upcoming Appointment... Arrive 10 mins early". | PASS |
| TC16 | Notification Action | Tap "Get Directions" directly from the Notification card. | Deep links directly to map navigation. | PASS |
| TC17 | Profile Data | Check Profile screen after Sign Up. | Displays correct Name ("Shashi Kant") and Phone ("9718..."). | PASS |
| TC18 | Logout | Tap "Logout" button in Settings. | Session clears; App returns to Login Screen. | PASS |

---

## 4. Resolved Issues (Bug Report)
During the development and testing phase, the following critical issues were identified and successfully resolved:

### **Issue:** Animation LateInitializationError on Success Screen
* **Description:** The app encountered a runtime crash during the "Booking Successful" animation due to a controller variable not being initialized in time.
* **Resolution:** Optimized the UX by removing the heavy interstitial Success Screen and replacing it with a lightweight Snackbar notification. This resolved the crash and improved app responsiveness.
* **Status:** ✅ Fixed

### **Issue:** Account Creation Failure (Status 500)
* **Description:** The "Create Account" API returned a 500 Internal Server Error.
* **Root Cause:** Data mismatch between the Frontend JSON payload (Snake Case) and Backend DTO expectations (Camel Case).
* **Resolution:** Refactored the User Model in Flutter to align perfectly with the Backend API schema.
* **Status:** ✅ Fixed

### **Issue:** External Map Launching Error
* **Description:** Tapping "Get Directions" failed to open Google Maps, throwing a "Could not launch URL" exception.
* **Resolution:** updated the url_launcher configuration and fixed the URI scheme format to correctly parse coordinates for external navigation apps.
* **Status:** ✅ Fixed

### **Issue:** Notification Trigger Failure
* **Description:** Scheduled "Smart Reminders" were not appearing in the system tray.
* **Resolution:** Debugged the notification channel settings and added runtime permission requests for Android 13+ (POST_NOTIFICATIONS).
* **Status:** ✅ Fixed

---

## 5. Conclusion
The Veersa Health application has successfully passed all planned test cases. The application meets the hackathon requirements for a digital scheduling solution, including:

* ✅ Finding availability by specialty.
* ✅ Sorting doctors by shortest distance.
* ✅ Conflict-free booking logic.
* ✅ Smart notifications with driving directions.

The build is stable and ready for the final demo.