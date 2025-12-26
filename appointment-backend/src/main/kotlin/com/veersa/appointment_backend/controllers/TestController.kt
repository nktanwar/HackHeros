package com.veersa.appointment_backend.controllers



import com.veersa.appointment_backend.models.Notification
import com.veersa.appointment_backend.models.NotificationType
import com.veersa.appointment_backend.repoistory.NotificationRepository
import com.veersa.appointment_backend.services.PushNotificationService
import com.veersa.appointment_backend.utils.UserPrincipal
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*
import java.time.Instant

@RestController
@RequestMapping("/api/test")
class NotificationTestController(
    private val pushService: PushNotificationService,
    private val notificationRepository : NotificationRepository
) {

    @PostMapping("/push")
    fun sendTestPush(
        @AuthenticationPrincipal user: UserPrincipal
    ): ResponseEntity<String> {

        pushService.sendTest(
            userId = user.userId,
            title = "Test Notification",
            body = "Firebase is working 🎉"
        )

        return ResponseEntity.ok("Test push triggered")
    }

    @PostMapping("/reminder")
    fun testReminder(
        @AuthenticationPrincipal user: UserPrincipal
    ): ResponseEntity<String> {

        notificationRepository.save(
            Notification(
                appointmentId = "694e428b68704c595622ec0a",
                userId = user.userId,
                type = NotificationType.APPOINTMENT_REMINDER,
                scheduledAt = Instant.now().plusSeconds(30)
            )
        )

        return ResponseEntity.ok("Test notification scheduled")
    }

}
