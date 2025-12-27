//package com.veersa.appointment_backend.controllers
//
//import com.fasterxml.jackson.databind.ObjectMapper
//import com.veersa.appointment_backend.dto.BookAppointmentRequest
//import com.veersa.appointment_backend.models.Appointment
//import com.veersa.appointment_backend.models.AppointmentStatus
//import com.veersa.appointment_backend.services.BookingService
//import com.veersa.appointment_backend.utils.UserPrincipal
//import org.junit.jupiter.api.Test
//import org.mockito.Mockito
//import org.springframework.beans.factory.annotation.Autowired
//import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
//import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
//import org.springframework.boot.test.context.SpringBootTest
//import org.springframework.boot.test.mock.mockito.MockBean
//import org.springframework.http.MediaType
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
//import org.springframework.test.context.ActiveProfiles
//import org.springframework.test.web.servlet.MockMvc
//import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
//import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
//import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.authentication
//import java.time.Instant
//
//@SpringBootTest
//@AutoConfigureMockMvc
//@ActiveProfiles("test")
//class AppointmentControllerTest {
//
//    @Autowired
//    lateinit var mockMvc: MockMvc
//
//    @Autowired
//    lateinit var objectMapper: ObjectMapper
//
//    @MockBean
//    lateinit var bookingService: BookingService
//
//    @Test
//    fun `POST book appointment returns 200 when successful`() {
//
//        val doctorId = "doctor-1"
//        val patientId = "patient-1"
//
//        val request = BookAppointmentRequest(
//            doctorId = doctorId,
//            startTime = Instant.parse("2025-01-02T10:00:00Z"),
//            endTime = Instant.parse("2025-01-02T10:30:00Z")
//        )
//
//        val appointment = Appointment(
//            id = "appointment-1",
//            doctorId = doctorId,
//            patientId = patientId,
//            startTime = request.startTime,
//            endTime = request.endTime,
//            status = AppointmentStatus.BOOKED,
//            createdAt = Instant.now()
//        )
//
//        Mockito.`when`(
//            bookingService.bookAppointment(
//                Mockito.eq(patientId),
//                Mockito.any()
//            )
//        ).thenReturn(appointment)
//
//        val principal = UserPrincipal(
//            userId = patientId,
//            name = "Test User",
//            email = "test@example.com",
//            phoneNumber = "9999999999",
//            role = "PATIENT",
//            verified = true,
//            tokenVersion = 1
//        )
//
//        val auth =
//            UsernamePasswordAuthenticationToken(principal, null, emptyList())
//
//        mockMvc.perform(
//            MockMvcRequestBuilders
//                .post("/api/appointments/book")
//                .with(authentication(auth))
//                .contentType(MediaType.APPLICATION_JSON)
//                .content(objectMapper.writeValueAsString(request))
//        )
//            .andExpect(status().isOk)
//    }
//}
