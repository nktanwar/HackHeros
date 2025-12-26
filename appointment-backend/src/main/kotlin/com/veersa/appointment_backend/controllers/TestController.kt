package com.veersa.appointment_backend.controllers



import com.veersa.appointment_backend.services.PushNotificationService
import com.veersa.appointment_backend.utils.UserPrincipal
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/test")
class NotificationTestController(
    private val pushService: PushNotificationService
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
}
