package com.veersa.appointment_backend.controllers


import com.veersa.appointment_backend.dto.DoctorSearchResult
import com.veersa.appointment_backend.repoistory.DoctorSearchRepository
import jakarta.validation.constraints.NotNull
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/doctors")
class DoctorSearchController(
    private val doctorSearchRepository: DoctorSearchRepository
) {

    @GetMapping("/search")
    fun searchDoctors(
        @RequestParam latitude: Double,
        @RequestParam longitude: Double,
        @RequestParam specialty: String,
        @RequestParam(defaultValue = "10") maxDistanceKm: Double
    ): List<DoctorSearchResult> {

        return doctorSearchRepository.findNearbyDoctors(
            longitude = longitude,
            latitude = latitude,
            specialty = specialty,
            maxDistanceKm = maxDistanceKm
        )
    }
}
