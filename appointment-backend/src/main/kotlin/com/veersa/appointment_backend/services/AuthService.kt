package com.veersa.appointment_backend.services

import com.veersa.appointment_backend.config.JwtProperties
import com.veersa.appointment_backend.dto.LoginRequest
import com.veersa.appointment_backend.dto.LoginResponse
import com.veersa.appointment_backend.dto.SignupRequest

import com.veersa.appointment_backend.models.User
import com.veersa.appointment_backend.models.UserRole
import com.veersa.appointment_backend.repoistory.UserRepository
import com.veersa.appointment_backend.utils.JwtUtils
import com.veersa.appointment_backend.utils.UserPrincipal
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service

@Service
class AuthService(
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder,
    private val jwtUtils: JwtUtils,
    private val jwtProperties: JwtProperties,
) {

    fun signup(request: SignupRequest) {
        if (userRepository.existsByEmail(request.email)) {
            throw IllegalArgumentException("Email already registered")
        }

        if (userRepository.existsByPhoneNumber(request.phoneNumber)) {
            throw IllegalArgumentException("Phone number already registered")
        }

        if (request.role == UserRole.ADMIN) {
            throw IllegalArgumentException("Admin registration is not allowed")
        }

        if (request.role == UserRole.DOCTOR) {
            requireNotNull(request.specialty) { "Specialty is required for doctors" }
        }

        val user = User(
            name = request.name,
            email = request.email,
            phoneNumber = request.phoneNumber,
            password = passwordEncoder.encode(request.password),
            role = request.role,
        )
        userRepository.save(user)
    }

    /**
     * LOGIN
     */
    fun login(request: LoginRequest): LoginResponse {

        val user = userRepository.findByEmail(request.email)
            ?: throw IllegalArgumentException("Invalid email or password")

        val passwordMatches = passwordEncoder.matches(
            request.password,
            user.password
        )

        if (!passwordMatches) {
            throw IllegalArgumentException("Invalid email or password")
        }


        val principal = UserPrincipal(
            userId = user.id!!,
            name = user.name,
            email = user.email,
            phoneNumber = user.phoneNumber,
            role = user.role.name,
            verified = user.verified
        )

        val token = jwtUtils.generateToken(principal)

        return LoginResponse(
            accessToken = token,
            expiresIn = jwtProperties.expirationMs
        )
    }
}
