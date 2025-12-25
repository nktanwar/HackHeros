package com.veersa.appointment_backend.services


import com.veersa.appointment_backend.models.DeviceToken
import com.veersa.appointment_backend.repoistory.DeviceTokenRepository
import org.springframework.dao.DuplicateKeyException
import org.springframework.stereotype.Service

@Service
class DeviceTokenService(
    private val repository: DeviceTokenRepository
) {

    fun register(userId: String, token: String) {
        try {
            repository.save(
                DeviceToken(
                    userId = userId,
                    token = token
                )
            )
        } catch (ex: DuplicateKeyException) {
            // token already exists → ignore
        }
    }
}
