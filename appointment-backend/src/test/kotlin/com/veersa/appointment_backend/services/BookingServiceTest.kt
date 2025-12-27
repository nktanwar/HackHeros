package com.veersa.appointment_backend.services

import com.veersa.appointment_backend.dto.BookAppointmentRequest
import com.veersa.appointment_backend.exception.SlotAlreadyBookedException
import com.veersa.appointment_backend.models.AppointmentStatus
import com.veersa.appointment_backend.repoistory.*
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.Test
import org.mockito.Mockito
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.test.context.ActiveProfiles
import java.time.Instant

@SpringBootTest(
    classes = [BookingService::class]
)
@ActiveProfiles("test")
class BookingServiceTest {

    @Autowired
    lateinit var bookingService: BookingService

    @MockBean
    lateinit var appointmentRepository: AppointmentRepository

    @MockBean
    lateinit var doctorService: DoctorService

    @MockBean
    lateinit var notificationRepository: NotificationRepository

    @MockBean
    lateinit var doctorProfileRepository: DoctorProfileRepository

    @MockBean
    lateinit var userRepository: UserRepository

    @Test
    fun `should NOT allow booking if doctor already has an overlapping appointment`() {

        val doctorId = "doctor-1"
        val patientId = "patient-1"

        val start = Instant.parse("2025-01-01T10:00:00Z")
        val end   = Instant.parse("2025-01-01T10:30:00Z")

        val request = BookAppointmentRequest(
            doctorId = doctorId,
            startTime = start,
            endTime = end
        )

        Mockito.`when`(
            appointmentRepository
                .existsByDoctorIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                    doctorId,
                    AppointmentStatus.BOOKED,
                    end,
                    start
                )
        ).thenReturn(true)

        assertThrows(SlotAlreadyBookedException::class.java) {
            bookingService.bookAppointment(patientId, request)
        }
    }


    @Test
    fun `should NOT allow booking if patient already has an overlapping appointment`() {

        // GIVEN
        val doctorId = "doctor-2"
        val patientId = "patient-1"

        val start = Instant.parse("2025-01-01T11:00:00Z")
        val end   = Instant.parse("2025-01-01T11:30:00Z")

        val request = BookAppointmentRequest(
            doctorId = doctorId,
            startTime = start,
            endTime = end
        )

        // Doctor is free
        Mockito.`when`(
            appointmentRepository
                .existsByDoctorIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                    doctorId,
                    AppointmentStatus.BOOKED,
                    end,
                    start
                )
        ).thenReturn(false)

        // Patient already has a booking
        Mockito.`when`(
            appointmentRepository
                .existsByPatientIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                    patientId,
                    AppointmentStatus.BOOKED,
                    end,
                    start
                )
        ).thenReturn(true)

        // WHEN + THEN
        assertThrows(SlotAlreadyBookedException::class.java) {
            bookingService.bookAppointment(patientId, request)
        }
    }

}
