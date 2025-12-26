package com.veersa.appointment_backend.controllers



import com.veersa.appointment_backend.models.Notification
import com.veersa.appointment_backend.repoistory.NotificationRepository
import com.veersa.appointment_backend.utils.UserPrincipal
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/notifications")
class NotificationController(
    private val notificationRepository: NotificationRepository
) {

    @GetMapping("/my")
    fun myNotifications(
        @AuthenticationPrincipal user: UserPrincipal
    ): List<Notification> {

        return notificationRepository.findByUserId(user.userId)
    }
}
