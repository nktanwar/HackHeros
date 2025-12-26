package com.veersa.appointment_backend.dto



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
    val name: String,
    val specialty: String,
    val clinicName: String,
    val distanceInKm: Double
)