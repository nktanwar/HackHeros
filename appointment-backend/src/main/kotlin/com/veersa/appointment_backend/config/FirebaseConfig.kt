package com.veersa.appointment_backend.config

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import jakarta.annotation.PostConstruct
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Configuration
import java.io.ByteArrayInputStream
import java.nio.charset.StandardCharsets

@Configuration
class FirebaseConfig(

    @Value("\${firebase.service.account}")
    private val firebaseServiceAccountJson: String

) {

    private val log = LoggerFactory.getLogger(FirebaseConfig::class.java)

    @PostConstruct
    fun init() {

        if (FirebaseApp.getApps().isNotEmpty()) {
            log.info("Firebase already initialized, skipping")
            return
        }

        require(firebaseServiceAccountJson.isNotBlank()) {
            "firebase.service.account property is empty"
        }

        try {
            /**
             * 🔑 CRITICAL FIX
             * Convert escaped \\n into real newlines
             * This is REQUIRED when loading Firebase credentials from env / properties
             */
            val fixedJson = firebaseServiceAccountJson
                .trim()
                .replace("\\n", "\n")

            val stream = ByteArrayInputStream(
                fixedJson.toByteArray(StandardCharsets.UTF_8)
            )

            val credentials = GoogleCredentials.fromStream(stream)

            val options = FirebaseOptions.builder()
                .setCredentials(credentials)
                .build()

            FirebaseApp.initializeApp(options)

            log.info("✅ Firebase initialized successfully")

        } catch (ex: Exception) {
            log.error("❌ Failed to initialize Firebase", ex)
            throw ex
        }
    }
}
