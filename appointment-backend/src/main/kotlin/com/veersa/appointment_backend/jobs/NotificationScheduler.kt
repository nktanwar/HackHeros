package com.veersa.appointment_backend.jobs




import com.veersa.appointment_backend.repoistory.NotificationRepository
import com.veersa.appointment_backend.services.PushNotificationService
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import java.time.Instant

@Component
class NotificationScheduler(
    private val notificationRepository: NotificationRepository,
    private val pushService: PushNotificationService
) {

    @Scheduled(fixedDelay = 60_000) // every minute
    fun sendDueNotifications() {

        val now = Instant.now()

        val pendingNotifications =
            notificationRepository.findBySentFalseAndScheduledAtLessThanEqual(now)

        for (notification in pendingNotifications) {
            try {
                pushService.send(notification)
                notificationRepository.save(
                    notification.copy(sent = true)
                )
            } catch (ex: Exception) {
                // DO NOT mark sent
                // Will retry next run
            }
        }
    }
}
