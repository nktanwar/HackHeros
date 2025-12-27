package com.veersa.appointment_backend.services

import com.veersa.appointment_backend.repoistory.EmailOtpRepository
import com.veersa.appointment_backend.models.EmailOtp
import com.veersa.appointment_backend.repoistory.UserRepository
import org.slf4j.LoggerFactory
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import java.time.Instant

@Service
class EmailOtpService(
    private val emailOtpRepository: EmailOtpRepository,
    private val emailService: EmailService,
    private val passwordEncoder: PasswordEncoder,
    private val userRepository: UserRepository,
) {

    companion object {
        private const val OTP_EXPIRY_SECONDS = 120L // 2 minutes
    }

    /**
     * Generate & send OTP
     */
    private val log = LoggerFactory.getLogger(EmailOtpService::class.java)

    fun sendOtp(email: String) {

        log.info("🔐 [OTP] Send OTP requested for {}", email)

        val otp = (100000..999999).random().toString()
        log.debug("🔐 [OTP] Generated OTP {} for {}", otp, email)

        val otpHash = passwordEncoder.encode(otp)

        emailOtpRepository.save(
            EmailOtp(
                email = email,
                otpHash = otpHash,
                expiresAt = Instant.now(),
                used = false
            )
        )

        log.info("🗄️ [OTP] OTP saved in database for {}", email)

        emailService.sendOtpEmail(email, otp)

        log.info("📤 [OTP] OTP email send triggered for {}", email)
    }


    /**
     * Verify OTP
     */
    fun verifyOtp(email: String, otp: String) {
        val user = userRepository.findByEmail(email)
            ?: throw IllegalArgumentException("User not found")

        if(user.verified){
            throw IllegalArgumentException("User already verified")
        }


        // 1️⃣ Get latest unused OTP
        val otpEntry = emailOtpRepository
            .findTopByEmailAndUsedFalseOrderByExpiresAtDesc(email)
            ?: throw IllegalArgumentException("OTP not found")

        // 2️⃣ Check expiry
        val expiryTime = otpEntry.expiresAt.plusSeconds(OTP_EXPIRY_SECONDS)
        if (expiryTime.isBefore(Instant.now())) {
            throw IllegalArgumentException("OTP expired")
        }

        // 3️⃣ Validate OTP
        if (!passwordEncoder.matches(otp, otpEntry.otpHash)) {
            throw IllegalArgumentException("Invalid OTP")
        }


        // delete all OTPs for this email after successful verification
        emailOtpRepository.deleteAllByEmail(email)

        val updatedUser = user.copy(
            verified = true
        )
        userRepository.save(updatedUser)


    }


    fun verifyOtpForPasswordReset(email: String, otp: String) {

        val otpEntry = emailOtpRepository
            .findTopByEmailAndUsedFalseOrderByExpiresAtDesc(email)
            ?: throw IllegalArgumentException("OTP not found")

        val expiryTime = otpEntry.expiresAt.plusSeconds(OTP_EXPIRY_SECONDS)
        if (expiryTime.isBefore(Instant.now())) {
            throw IllegalArgumentException("OTP expired")
        }

        if (!passwordEncoder.matches(otp, otpEntry.otpHash)) {
            throw IllegalArgumentException("Invalid OTP")
        }

        emailOtpRepository.save(
            otpEntry.copy(used = true)
        )
    }

}
