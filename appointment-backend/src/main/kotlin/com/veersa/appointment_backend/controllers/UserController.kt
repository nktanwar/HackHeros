package com.veersa.appointment_backend.controllers

import com.veersa.appointment_backend.dto.CompleteDoctorProfileRequest
import com.veersa.appointment_backend.dto.ForgotPasswordRequest
import com.veersa.appointment_backend.dto.ResetPasswordRequest
import com.veersa.appointment_backend.dto.UserProfileResponse
import com.veersa.appointment_backend.dto.VerifyResetOtpRequest
import com.veersa.appointment_backend.models.DoctorProfile
import com.veersa.appointment_backend.repoistory.UserRepository
import com.veersa.appointment_backend.services.AuthService
import com.veersa.appointment_backend.services.DoctorService
import com.veersa.appointment_backend.services.EmailOtpService
import com.veersa.appointment_backend.utils.UserPrincipal
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/users")
class UserController(

    private val userRepository: UserRepository,
    private val doctorProfileService: DoctorService

) {

    @GetMapping("/me")
    fun getMyProfile(
        @AuthenticationPrincipal user: UserPrincipal
    ): UserProfileResponse {

        val entity = userRepository.findById(user.userId)
            .orElseThrow { IllegalStateException("User not found") }

        return UserProfileResponse(
            id = entity.id!!,
            name = entity.name,
            email = entity.email,
            phoneNumber = entity.phoneNumber,
            role = entity.role.name,
            verified = entity.verified
        )
    }



    @PreAuthorize("hasRole('DOCTOR')")
    @PostMapping("/doctor-complete-profile")
    fun doctorCompleteProfile(
        @AuthenticationPrincipal doctor: UserPrincipal,
        @RequestBody request: CompleteDoctorProfileRequest
    ): ResponseEntity<String> {

        doctorProfileService.completeDoctorProfile(
            doctorId = doctor.userId,
            request = request
        )

        return ResponseEntity.ok("Doctor profile completed successfully")
    }

    @PreAuthorize("hasRole('DOCTOR')")
    @GetMapping("/doctor/profile-status")
    fun profileStatus(
        @AuthenticationPrincipal doctor: UserPrincipal
    ): Map<String, Boolean> {
        return mapOf(
            "profileComplete" to
                doctorProfileService.isProfileComplete(doctor.userId)
        )
    }

    /**
     * Profile screen (view/edit)
     */
    @PreAuthorize("hasRole('DOCTOR')")
    @GetMapping("/doctor/me")
    fun myProfile(
        @AuthenticationPrincipal doctor: UserPrincipal
    ): DoctorProfile {
        return doctorProfileService.getDoctorProfile(doctor.userId)
    }

    /**
     * Doctor goes offline
     */
    @PreAuthorize("hasRole('DOCTOR')")
    @PostMapping("/doctor/deactivate")
    fun deactivate(
        @AuthenticationPrincipal doctor: UserPrincipal
    ): ResponseEntity<String> {

        doctorProfileService.deactivateDoctor(doctor.userId)
        return ResponseEntity.ok("Doctor deactivated successfully")
    }

    /**
     * Doctor comes back online
     */
    @PreAuthorize("hasRole('DOCTOR')")
    @PostMapping("/doctor/activate")
    fun activate(
        @AuthenticationPrincipal doctor: UserPrincipal
    ): ResponseEntity<String> {

        doctorProfileService.activateDoctor(doctor.userId)
        return ResponseEntity.ok("Doctor activated successfully")
    }



}
