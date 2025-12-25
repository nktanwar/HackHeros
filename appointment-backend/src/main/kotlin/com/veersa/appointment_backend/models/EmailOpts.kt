package com.veersa.appointment_backend.models

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.index.Indexed
import org.springframework.data.mongodb.core.mapping.Document
import java.time.Instant

@Document(collection = "email_otps")
data class EmailOtp(
    @Id
    val id: String? = null,

    val email: String,

    val otpHash: String?,

    @Indexed(expireAfter= "120s")
    val expiresAt: Instant,

    val used: Boolean = false
)
