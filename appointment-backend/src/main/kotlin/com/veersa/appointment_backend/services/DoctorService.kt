package com.veersa.appointment_backend.services


import com.veersa.appointment_backend.repoistory.DoctorProfileRepository
import org.springframework.scheduling.annotation.Async
import org.springframework.stereotype.Service
import java.time.Instant
import java.time.temporal.ChronoUnit

import com.veersa.appointment_backend.dto.CompleteDoctorProfileRequest
import com.veersa.appointment_backend.dto.DoctorAvailabilityRequest
import com.veersa.appointment_backend.dto.DoctorAvailabilityResponse
import com.veersa.appointment_backend.models.DoctorAvailability
import com.veersa.appointment_backend.models.DoctorProfile
import com.veersa.appointment_backend.models.GeoLocation
import com.veersa.appointment_backend.repoistory.DoctorAvailabilityRepository


@Service
class DoctorService(
    private val slotService: SlotService,
    private val doctorProfileRepository: DoctorProfileRepository,
    private val doctorAvailabilityRepository: DoctorAvailabilityRepository

) {

    /**
     * Recompute and update isCurrentlyBookable asynchronously
     */
    @Async
    fun recomputeBookableStatus(doctorId: String) {

        val profile = doctorProfileRepository.findByDoctorId(doctorId)
            ?: return

        // ✅ Correct logic: future availability, not slot window
        val hasFutureAvailability =
            doctorAvailabilityRepository.existsByDoctorIdAndActiveTrueAndEndTimeAfter(
                doctorId,
                Instant.now()
            )

        if (profile.isCurrentlyBookable != hasFutureAvailability) {
            doctorProfileRepository.save(
                profile.copy(isCurrentlyBookable = hasFutureAvailability)
            )
        }
    }


    fun markProfileComplete(doctorId: String) {

        val profile = doctorProfileRepository.findByDoctorId(doctorId)
            ?: throw IllegalStateException("Doctor profile not found")

        if (!profile.isComplete) {
            doctorProfileRepository.save(
                profile.copy(isComplete = true)
            )
        }
    }



    fun completeDoctorProfile(
        doctorId: String,
        request: CompleteDoctorProfileRequest
    ) {

        val existingProfile =
            doctorProfileRepository.findByDoctorId(doctorId)

        val profile = if (existingProfile == null) {
            DoctorProfile(
                doctorId = doctorId,
                specialty = request.specialty,
                clinicName = request.clinicName,
                clinicLocation = GeoLocation(
                    coordinates = listOf(
                        request.longitude,
                        request.latitude
                    )
                ),
                consultationDurationMinutes = request.consultationDurationMinutes,
                isComplete = true
            )
        } else {
            existingProfile.copy(
                specialty = request.specialty,
                clinicName = request.clinicName,
                clinicLocation = GeoLocation(
                    coordinates = listOf(
                        request.longitude,
                        request.latitude
                    )
                ),
                consultationDurationMinutes = request.consultationDurationMinutes,
                isComplete = true
            )
        }

        doctorProfileRepository.save(profile)
    }


    fun isProfileComplete(doctorId: String): Boolean {
        val profile = doctorProfileRepository.findByDoctorId(doctorId)
        return profile?.isComplete == true && profile.active
    }

    fun getDoctorProfile(doctorId: String): DoctorProfile {
        return doctorProfileRepository.findByDoctorId(doctorId)
            ?: throw IllegalStateException("Doctor profile not found")
    }

    fun deactivateDoctor(doctorId: String) {
        val profile = doctorProfileRepository.findByDoctorId(doctorId)
            ?: throw IllegalStateException("Doctor profile not found")

        if (!profile.active) return // idempotent

        doctorProfileRepository.save(
            profile.copy(
                active = false,
                isCurrentlyBookable = false
            )
        )
    }

    fun activateDoctor(doctorId: String) {
        val profile = doctorProfileRepository.findByDoctorId(doctorId)
            ?: throw IllegalStateException("Doctor profile not found")

        if (!profile.isComplete) {
            throw IllegalStateException("Doctor profile is not complete")
        }

        doctorProfileRepository.save(
            profile.copy(
                active = true,
                isCurrentlyBookable = true
            )
        )
    }


    fun addAvailability(
        doctorId: String,
        request: DoctorAvailabilityRequest
    ) {
        require(request.endTime.isAfter(request.startTime)) {
            "End time must be after start time"
        }

        doctorAvailabilityRepository.save(
            DoctorAvailability(
                doctorId = doctorId,
                startTime = request.startTime,
                endTime = request.endTime,
                slotDurationMinutes = request.slotDurationMinutes
            )
        )
    }

    fun getMyAvailability(doctorId: String): List<DoctorAvailabilityResponse> =
        doctorAvailabilityRepository.findByDoctorIdAndActiveTrue(doctorId)
            .map {
                DoctorAvailabilityResponse(
                    id = it.id!!,
                    startTime = it.startTime,
                    endTime = it.endTime,
                    slotDurationMinutes = it.slotDurationMinutes,
                    active = it.active
                )
            }

    fun deactivateAvailability(availabilityId: String, doctorId: String) {
        val availability =
            doctorAvailabilityRepository.findById(availabilityId)
                .orElseThrow { IllegalStateException("Availability not found") }

        require(availability.doctorId == doctorId) {
            "Unauthorized"
        }

        doctorAvailabilityRepository.save(
            availability.copy(active = false)
        )
    }


}




