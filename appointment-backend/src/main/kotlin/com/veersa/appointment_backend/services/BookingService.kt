package com.veersa.appointment_backend.services

import com.veersa.appointment_backend.dto.BookAppointmentRequest
import com.veersa.appointment_backend.exception.SlotAlreadyBookedException
import com.veersa.appointment_backend.models.Appointment
import com.veersa.appointment_backend.models.AppointmentStatus
import com.veersa.appointment_backend.models.Notification
import com.veersa.appointment_backend.models.NotificationType
import com.veersa.appointment_backend.repoistory.AppointmentRepository
import com.veersa.appointment_backend.repoistory.NotificationRepository
import org.springframework.dao.DuplicateKeyException
import org.springframework.stereotype.Service
import java.time.Instant
import java.time.temporal.ChronoUnit
@Service
class BookingService(
    private val appointmentRepository: AppointmentRepository,
    private val doctorAvailabilityStatusService: DoctorService,
    private val notificationRepository: NotificationRepository
) {

    fun bookAppointment(
        patientId: String,
        request: BookAppointmentRequest
    ): Appointment {

        // 0️⃣ Defensive sanity check
        require(request.endTime.isAfter(request.startTime)) {
            "End time must be after start time"
        }

        // 1️⃣ Doctor overlap check
        val doctorConflict =
            appointmentRepository
                .existsByDoctorIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                    request.doctorId,
                    AppointmentStatus.BOOKED,
                    request.endTime,
                    request.startTime
                )

        if (doctorConflict) {
            throw SlotAlreadyBookedException(
                "Doctor is already booked for this time slot"
            )
        }

        // 2️⃣ Patient overlap check
        val patientConflict =
            appointmentRepository
                .existsByPatientIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                    patientId,
                    AppointmentStatus.BOOKED,
                    request.endTime,
                    request.startTime
                )

        if (patientConflict) {
            throw SlotAlreadyBookedException(
                "You already have another appointment during this time"
            )
        }

        val appointment = Appointment(
            doctorId = request.doctorId,
            patientId = patientId,
            startTime = request.startTime,
            endTime = request.endTime,
            status = AppointmentStatus.BOOKED,
            createdAt = Instant.now()
        )

        return try {
            // 3️⃣ Source of truth write
            val savedAppointment = appointmentRepository.save(appointment)

            // 4️⃣ Notification (non-blocking business logic)
            notificationRepository.save(
                Notification(
                    appointmentId = savedAppointment.id!!,
                    userId = patientId,
                    type = NotificationType.APPOINTMENT_REMINDER,
                    scheduledAt = request.startTime.minus(1, ChronoUnit.HOURS)
                )
            )

            // 5️⃣ Async availability recompute
            doctorAvailabilityStatusService
                .recomputeBookableStatus(request.doctorId)

            savedAppointment

        } catch (ex: DuplicateKeyException) {
            // 6️⃣ Race-condition safety net
            throw SlotAlreadyBookedException(
                "This time slot was just booked by someone else"
            )
        }
    }
}
