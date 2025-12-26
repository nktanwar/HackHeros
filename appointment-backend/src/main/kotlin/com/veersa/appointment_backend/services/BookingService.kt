package com.veersa.appointment_backend.services

import com.veersa.appointment_backend.dto.BookAppointmentRequest
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
    private val doctorAvailabilityStatusService: DoctorAvailabilityStatusService,
    private val notificationRepository: NotificationRepository

) {

    fun bookAppointment(
        patientId: String,
        request: BookAppointmentRequest
    ): Appointment {

        // defensive sanity check
        require(request.endTime.isAfter(request.startTime)) {
            "End time must be after start time"
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
            // 2️⃣ Critical operation (source of truth)
            val savedAppointment = appointmentRepository.save(appointment)

            notificationRepository.save(
                Notification(
                    appointmentId = savedAppointment.id!!,
                    userId = patientId,
                    type = NotificationType.APPOINTMENT_REMINDER,
                    scheduledAt = request.startTime.minus(1, ChronoUnit.HOURS)
                )
            )


            // 3️⃣ NON-CRITICAL async update (fire-and-forget)
            doctorAvailabilityStatusService
                .recomputeBookableStatus(request.doctorId)

            savedAppointment


        } catch (ex: DuplicateKeyException) {
            throw IllegalStateException("This time slot is already booked")
        }
    }
}
