package com.veersa.appointment_backend

import com.veersa.appointment_backend.config.JwtProperties
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication
import jakarta.annotation.PostConstruct
import org.springframework.data.mongodb.core.MongoTemplate
import org.springframework.stereotype.Component


@EnableConfigurationProperties(JwtProperties::class)
@SpringBootApplication
class AppointmentBackendApplication

fun main(args: Array<String>) {
	runApplication<AppointmentBackendApplication>(*args)
}

/**
 * Debug helper — KEEP THIS
 * This proves which DB you are connected to
 */
@Component
class MongoDebug(
	private val mongoTemplate: MongoTemplate
) {
	@PostConstruct
	fun debug() {
		println("CONNECTED DB = ${mongoTemplate.db.name}")
		println("COLLECTIONS = ${mongoTemplate.db.listCollectionNames().toList()}")
	}
}
