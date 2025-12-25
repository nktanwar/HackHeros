package com.veersa.appointment_backend.services



import jakarta.mail.internet.MimeMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.stereotype.Service

@Service
class EmailService(
    private val mailSender: JavaMailSender
) {

    fun sendOtpEmail(to: String, otp: String) {

        val message: MimeMessage = mailSender.createMimeMessage()
        val helper = MimeMessageHelper(message, false)

        helper.setFrom("yourgmail@gmail.com")
        helper.setTo(to)
        helper.setSubject("Your OTP Code")
        helper.setText(
            """
            Your OTP is: $otp

            This code is valid for 2 minutes.
            Please do not share this code with anyone.
            """.trimIndent(),
            false
        )

        mailSender.send(message)
    }
}
