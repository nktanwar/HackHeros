package com.veersa.appointment_backend.repoistory


import com.veersa.appointment_backend.models.Notification
import org.springframework.data.mongodb.repository.MongoRepository
import java.time.Instant

interface NotificationRepository :
    MongoRepository<Notification, String> {

    fun findBySentFalseAndScheduledAtLessThanEqual(
        time: Instant
    ): List<Notification>

    fun findByUserId(userId: String): List<Notification>
}
