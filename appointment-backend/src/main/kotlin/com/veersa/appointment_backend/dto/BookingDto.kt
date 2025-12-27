package com.veersa.appointment_backend.dto



import jakarta.validation.constraints.Min
import java.time.Instant

data class BookAppointmentRequest(
    val doctorId: String,
    val startTime: Instant,
    val endTime: Instant
)


data class TimeSlot(
    val startTime: Instant,
    val endTime: Instant
)


data class DoctorSearchResult(
    val doctorId: String,
    val specialty: String,
    val clinicName: String,
    val distanceInKm: Double?=null,
    val latitude: Double?=null,
    val longitude: Double?=null
)


data class DoctorAvailabilityRequest(
    val startTime: Instant,
    val endTime: Instant,

    @Min(5)
    val slotDurationMinutes: Int
)

data class DoctorAvailabilityResponse(
    val id: String,
    val startTime: Instant,
    val endTime: Instant,
    val slotDurationMinutes: Int,
    val active: Boolean
)

data class AppointmentViewResponse(
    val appointmentId: String,
    val startTime: Instant,
    val endTime: Instant,
    val status: String,

    // doctor info
    val doctorId: String,
    val doctorName: String,
    val specialty: String,
    val clinicName: String,
    val mapUrl: String,
    val distanceInKm: Double?,

    // patient info (only for doctor view)
    val patientId: String?,
    val patientName: String?
)
