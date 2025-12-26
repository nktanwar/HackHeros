package com.veersa.appointment_backend.repoistory



import com.veersa.appointment_backend.dto.DoctorSearchResult

interface DoctorSearchRepository {

    fun findNearbyDoctors(
        longitude: Double,
        latitude: Double,
        specialty: String,
        maxDistanceKm: Double
    ): List<DoctorSearchResult>
}
