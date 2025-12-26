package com.veersa.appointment_backend.repoistory



import com.veersa.appointment_backend.models.EmailOtp
import org.springframework.data.mongodb.repository.MongoRepository

interface EmailOtpRepository : MongoRepository<EmailOtp, String> {
    fun deleteAllByEmail(email: String)
    fun findTopByEmailAndUsedFalseOrderByExpiresAtDesc(email: String): EmailOtp?
}
