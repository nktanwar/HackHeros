package com.veersa.appointment_backend.repoistory

import com.veersa.appointment_backend.models.DeviceToken
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository

@Repository
interface DeviceTokenRepository :
    MongoRepository<DeviceToken, String> {

    fun findByUserId(userId: String): List<DeviceToken>
}
