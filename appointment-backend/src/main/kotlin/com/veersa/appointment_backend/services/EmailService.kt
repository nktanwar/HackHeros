package com.veersa.appointment_backend.services

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.scheduling.annotation.Async
import org.springframework.stereotype.Service
import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse

@Service
class EmailService(

    @Value("\${resend.api.key}")
    private val resendApiKey: String,

    @Value("\${resend.from.email:onboarding@resend.dev}")
    private val fromEmail: String

) {

    private val log = LoggerFactory.getLogger(EmailService::class.java)

    private val httpClient = HttpClient.newHttpClient()

    @Async
    fun sendOtpEmail(to: String, otp: String) {

        log.info("📧 [RESEND] Preparing OTP email for {}", to)

        val body = """
            {
              "from": "$fromEmail",
              "to": ["$to"],
              "subject": "Your OTP Code",
              "html": "<p>Your OTP is <b>$otp</b><br/>Valid for 2 minutes.</p>"
            }
        """.trimIndent()

        val request = HttpRequest.newBuilder()
            .uri(URI.create("https://api.resend.com/emails"))
            .header("Authorization", "Bearer $resendApiKey")
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(body))
            .build()

        try {
            log.info("📤 [RESEND] Sending email request to Resend API")

            val response = httpClient.send(
                request,
                HttpResponse.BodyHandlers.ofString()
            )

            log.info(
                "📨 [RESEND] Response status={} body={}",
                response.statusCode(),
                response.body()
            )

            if (response.statusCode() !in 200..299) {
                log.error("❌ [RESEND] Email send failed for {}", to)
            } else {
                log.info("✅ [RESEND] OTP email sent successfully to {}", to)
            }

        } catch (ex: Exception) {
            log.error("🔥 [RESEND] Exception while sending email to {}", to, ex)
            throw ex
        }
    }
}
