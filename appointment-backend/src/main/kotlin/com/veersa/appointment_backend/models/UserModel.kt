package com.veersa.appointment_backend.models



import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.index.Indexed
import org.springframework.data.mongodb.core.mapping.Document

@Document(collection = "users")
data class User(
    @Id
    val id: String? = null,

    val name: String,

    @Indexed(unique = true)
    val email: String,

    @Indexed(unique = true)
    val phoneNumber: String,

    val password: String?,

    val role: UserRole,

    val tokenVersion: Long = 0,

    val verified: Boolean = false
)

enum class UserRole {
    PATIENT,
    DOCTOR,
    ADMIN
}

data class GeoLocation(
    val type: String = "Point",
    val coordinates: List<Double> // [longitude, latitude]
)

