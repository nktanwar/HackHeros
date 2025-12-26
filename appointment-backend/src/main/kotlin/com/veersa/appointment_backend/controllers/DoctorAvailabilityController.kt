package com.veersa.appointment_backend.controllers


import com.veersa.appointment_backend.models.DoctorAvailability
import com.veersa.appointment_backend.repoistory.DoctorAvailabilityRepository
import com.veersa.appointment_backend.services.DoctorAvailabilityStatusService
import com.veersa.appointment_backend.utils.UserPrincipal
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/doctor/availability")
class DoctorAvailabilityController(
    private val repository: DoctorAvailabilityRepository,
    private val statusService: DoctorAvailabilityStatusService
) {

    @PreAuthorize("hasRole('DOCTOR')")
    @PostMapping
    fun createAvailability(
        @AuthenticationPrincipal doctor: UserPrincipal,
        @Valid @RequestBody availability: DoctorAvailability
    ): ResponseEntity<DoctorAvailability> {

        val saved = repository.save(
            availability.copy(doctorId = doctor.userId)
        )

        statusService.recomputeBookableStatus(doctor.userId)

        return ResponseEntity.ok(saved)
    }
}
