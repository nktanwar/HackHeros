package com.veersa.appointment_backend.repoistory


import com.veersa.appointment_backend.models.User
import org.springframework.data.mongodb.repository.MongoRepository

interface UserRepository : MongoRepository<User, String> {

    fun existsByEmail(email: String): Boolean

    fun existsByPhoneNumber(phoneNumber: String): Boolean

    fun findByEmail(email: String): User?
}
