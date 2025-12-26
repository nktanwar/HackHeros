package com.veersa.appointment_backend.controllers

import com.veersa.appointment_backend.services.DoctorService
import com.veersa.appointment_backend.dto.DoctorAvailabilityRequest
import com.veersa.appointment_backend.dto.DoctorAvailabilityResponse
import com.veersa.appointment_backend.utils.UserPrincipal
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/doctors/availability")
@PreAuthorize("hasRole('DOCTOR')")
class DoctorAvailabilityController(
    private val service: DoctorService
) {

    @PostMapping
    fun addAvailability(
        @AuthenticationPrincipal doctor: UserPrincipal,
        @Valid @RequestBody request: DoctorAvailabilityRequest
    ): ResponseEntity<String> {

        service.addAvailability(doctor.userId, request)
        return ResponseEntity.ok("Availability added successfully")
    }

    @GetMapping("/my")
    fun myAvailability(
        @AuthenticationPrincipal doctor: UserPrincipal
    ): List<DoctorAvailabilityResponse> =
        service.getMyAvailability(doctor.userId)

    @PostMapping("/{availabilityId}/deactivate")
    fun deactivateAvailability(
        @AuthenticationPrincipal doctor: UserPrincipal,
        @PathVariable availabilityId: String
    ): ResponseEntity<String> {

        service.deactivateAvailability(availabilityId, doctor.userId)
        return ResponseEntity.ok("Availability deactivated")
    }
}
