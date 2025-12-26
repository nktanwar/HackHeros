package com.veersa.appointment_backend.dto


import jakarta.validation.constraints.NotBlank

data class RegisterDeviceTokenRequest(
    @field:NotBlank
    val token: String
)
