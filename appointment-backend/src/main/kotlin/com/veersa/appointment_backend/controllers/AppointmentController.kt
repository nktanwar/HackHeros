package com.veersa.appointment_backend.controllers



import com.veersa.appointment_backend.dto.AppointmentViewResponse
import com.veersa.appointment_backend.dto.BookAppointmentRequest
import com.veersa.appointment_backend.models.Appointment
import com.veersa.appointment_backend.services.BookingService
import com.veersa.appointment_backend.utils.UserPrincipal
import jakarta.validation.Valid
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*
import com.veersa.appointment_backend.repoistory.AppointmentRepository

@RestController
@RequestMapping("/api/appointments")
class AppointmentController(
    private val bookingService: BookingService,
    private val appointmentService: BookingService
) {

    @PreAuthorize("hasRole('PATIENT')")
    @PostMapping("/book")
    fun bookAppointment(
        @AuthenticationPrincipal patient: UserPrincipal,
        @Valid @RequestBody request: BookAppointmentRequest
    ): Appointment {

        return bookingService.bookAppointment(
            patientId = patient.userId,
            request = request
        )
    }

    @GetMapping("/my")
    fun myAppointments(
        @AuthenticationPrincipal user: UserPrincipal,
        @RequestParam(required = false) latitude: Double?,
        @RequestParam(required = false) longitude: Double?
    ): List<AppointmentViewResponse> {

        return appointmentService.getMyAppointments(
            user = user,
            latitude = latitude,
            longitude = longitude
        )
    }

}




