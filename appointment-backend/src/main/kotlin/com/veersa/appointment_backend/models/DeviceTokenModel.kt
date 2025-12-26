package com.veersa.appointment_backend.models

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document

@Document(collection = "device_tokens")
data class DeviceToken(
    @Id val id: String? = null,
    val userId: String,
    val token: String
)

