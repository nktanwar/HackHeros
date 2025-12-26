package com.veersa.appointment_backend.repoistory


import com.veersa.appointment_backend.models.Appointment
import com.veersa.appointment_backend.models.AppointmentStatus
import org.springframework.data.mongodb.repository.MongoRepository
import java.time.Instant

interface AppointmentRepository : MongoRepository<Appointment, String> {

    fun existsByDoctorIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
        doctorId: String,
        status: String,
        startTime: Instant,
        endTime: Instant
    ): Boolean

    fun findByDoctorIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
        doctorId: String,
        status: AppointmentStatus,
        end: Instant,
        start: Instant
    ): List<Appointment>

    fun findByDoctorId(doctorId: String): List<Appointment>

    fun findByPatientId(patientId: String): List<Appointment>

    fun existsByDoctorIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
        doctorId: String,
        status: AppointmentStatus,
        endTime: Instant,
        startTime: Instant
    ): Boolean

    fun existsByPatientIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
        patientId: String,
        status: AppointmentStatus,
        endTime: Instant,
        startTime: Instant
    ): Boolean

}
