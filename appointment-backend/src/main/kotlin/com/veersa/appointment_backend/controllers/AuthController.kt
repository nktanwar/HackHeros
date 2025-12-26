package com.veersa.appointment_backend.controllers
import com.veersa.appointment_backend.dto.LoginRequest
import com.veersa.appointment_backend.dto.LoginResponse
import com.veersa.appointment_backend.dto.SignupRequest
import com.veersa.appointment_backend.dto.sendOtpDto
import com.veersa.appointment_backend.dto.verifyOtpDto
import com.veersa.appointment_backend.services.AuthService
import com.veersa.appointment_backend.services.EmailOtpService
import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/auth")
class AuthController(
    private val authService: AuthService,
    private val emailOtpService: EmailOtpService
) {

    @PostMapping("/signup")
    fun signup(
        @Valid @RequestBody request: SignupRequest
    ): ResponseEntity<String> {

        authService.signup(request)

        return ResponseEntity
            .status(HttpStatus.CREATED)
            .body("User registered successfully")
    }

    @PostMapping("/login")
    fun login(
        @Valid @RequestBody request: LoginRequest
    ): ResponseEntity<LoginResponse> {

        val response = authService.login(request)

        return ResponseEntity.ok(response)
    }

    @PostMapping("/send-email-otp")
    fun sendEmailOtp(
        @Valid @RequestBody request: sendOtpDto
    ): ResponseEntity<String> {

        emailOtpService.sendOtp(request.email)

        return ResponseEntity
            .status(HttpStatus.OK)
            .body("OTP sent successfully to email")
    }

    @PostMapping("/verify-email-otp")
    fun verifyEmailOtp(
        @Valid @RequestBody request: verifyOtpDto
    ): ResponseEntity<String> {

        emailOtpService.verifyOtp(request.email, request.otp)

        return ResponseEntity
            .status(HttpStatus.OK)
            .body("Email verified successfully")
    }


}
