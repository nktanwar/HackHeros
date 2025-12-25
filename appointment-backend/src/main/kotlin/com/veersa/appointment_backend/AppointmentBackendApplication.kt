package com.veersa.appointment_backend

import com.veersa.appointment_backend.config.JwtProperties
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.data.mongodb.core.MongoTemplate
import com.mongodb.client.MongoClients
import org.springframework.beans.factory.annotation.Value

@EnableConfigurationProperties(JwtProperties::class)
@SpringBootApplication
class AppointmentBackendApplication {

	@Value("\${spring.data.mongodb.uri:mongodb://localhost:27017/test}")
	private lateinit var mongoUri: String

	@Bean
	fun mongoTemplate(): MongoTemplate {
		// If URI is found, it uses Atlas; otherwise, it falls back to a default to prevent crash
		val mongoClient = MongoClients.create(mongoUri)
		return MongoTemplate(mongoClient, "healthApp")
	}
}

fun main(args: Array<String>) {
	runApplication<AppointmentBackendApplication>(*args)
}