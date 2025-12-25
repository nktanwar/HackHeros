package com.veersa.appointment_backend.controllers

import com.veersa.appointment_backend.dto.RegisterDeviceTokenRequest
import com.veersa.appointment_backend.services.DeviceTokenService
import com.veersa.appointment_backend.utils.UserPrincipal

import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/devices")
class DeviceTokenController(
    private val deviceTokenService: DeviceTokenService
) {

    @PostMapping("/register")
    fun register(
        @AuthenticationPrincipal user: UserPrincipal,
        @Valid @RequestBody request: RegisterDeviceTokenRequest
    ): ResponseEntity<Void> {

        deviceTokenService.register(user.userId, request.token)

        return ResponseEntity.ok().build()
    }
}
