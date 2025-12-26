package com.veersa.appointment_backend.services

import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.Message
import com.veersa.appointment_backend.models.Notification
import com.veersa.appointment_backend.repoistory.AppointmentRepository
import com.veersa.appointment_backend.repoistory.DeviceTokenRepository
import com.veersa.appointment_backend.repoistory.DoctorProfileRepository
import com.veersa.appointment_backend.utils.MapsDeepLinkUtil
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service

@Service
class PushNotificationService(
    private val deviceTokenRepository: DeviceTokenRepository,
    private val appointmentRepository: AppointmentRepository,
    private val doctorProfileRepository: DoctorProfileRepository
) {

    private val log = LoggerFactory.getLogger(PushNotificationService::class.java)

    fun send(notification: Notification) {

        println("📨 Push send started for notification ${notification.id}")

        val tokens = deviceTokenRepository.findByUserId(notification.userId)
        println("📱 Device tokens found = ${tokens.size}")
        if (tokens.isEmpty()) {
            log.warn("No device tokens found for user {}", notification.userId)
            return
        }

        val appointment = appointmentRepository.findById(notification.appointmentId)
            .orElseThrow {
                IllegalStateException("Appointment not found for notification ${notification.id}")
            }

        val doctor = doctorProfileRepository.findByDoctorId(appointment.doctorId)
        if (doctor == null || doctor.clinicLocation.coordinates.size < 2) {
            log.error(
                "Doctor or clinic location missing for appointment {}",
                appointment.id
            )
            return
        }

        // GeoJSON order: [longitude, latitude]
        val clinicLng = doctor.clinicLocation.coordinates[0]
        val clinicLat = doctor.clinicLocation.coordinates[1]

        val mapUrl = MapsDeepLinkUtil.drivingDirections(
            clinicLat,
            clinicLng
        )

        tokens.forEach { device ->
            try {
                val message = Message.builder()
                    .setToken(device.token)
                    .putData("type", notification.type.name)
                    .putData("appointmentId", notification.appointmentId)
                    .putData("mapUrl", mapUrl)
                    .build()

                log.info("📍 Map deep link = {}", mapUrl)

                FirebaseMessaging.getInstance().send(message)
                log.info(
                    "Notification {} sent to token {}",
                    notification.id,
                    device.token
                )

            } catch (ex: Exception) {
                log.error(
                    "Failed to send notification {} to token {}",
                    notification.id,
                    device.token,
                    ex
                )
                // Let scheduler retry next run
            }
        }
    }



    fun sendTest(
        userId: String,
        title: String,
        body: String
    ) {
        val tokens = deviceTokenRepository.findByUserId(userId)
        if (tokens.isEmpty()) {
            log.warn("No device tokens found for user {}", userId)
            return
        }

        tokens.forEach { device ->
            try {
                val message = Message.builder()
                    .setToken(device.token)
                    .putData("title", title)
                    .putData("body", body)
                    .putData("type", "TEST")
                    .build()

                FirebaseMessaging.getInstance().send(message)

                log.info(
                    "Test notification sent to user {} token {}",
                    userId,
                    device.token
                )

            } catch (ex: Exception) {
                log.error(
                    "Failed to send test notification to token {}",
                    device.token,
                    ex
                )
            }
        }
    }

}
