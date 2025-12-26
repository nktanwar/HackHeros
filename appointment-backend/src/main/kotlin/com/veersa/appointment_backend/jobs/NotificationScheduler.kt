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

    @Scheduled(fixedDelay = 60_000)
    fun sendDueNotifications() {

        val now = Instant.now()
        println("🔔 Scheduler running at $now")

        val pendingNotifications =
            notificationRepository.findBySentFalseAndScheduledAtLessThanEqual(now)

        println("🔔 Pending notifications count = ${pendingNotifications.size}")

        for (notification in pendingNotifications) {
            println("🔔 Sending notification ${notification.id}")
            try {
                pushService.send(notification)
                notificationRepository.save(notification.copy(sent = true))
                println("✅ Notification ${notification.id} marked as sent")
            } catch (ex: Exception) {
                println("❌ Failed to send notification ${notification.id}")
                ex.printStackTrace()
            }
        }
    }

}
