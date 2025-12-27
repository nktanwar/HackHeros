package com.veersa.appointment_backend.services

import com.veersa.appointment_backend.dto.BookAppointmentRequest
import com.veersa.appointment_backend.exception.SlotAlreadyBookedException
import com.veersa.appointment_backend.models.Appointment
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


    @Test
    fun `should successfully book appointment when no conflicts exist`() {

        // GIVEN
        val doctorId = "doctor-3"
        val patientId = "patient-2"

        val start = Instant.parse("2025-01-01T12:00:00Z")
        val end   = Instant.parse("2025-01-01T12:30:00Z")

        val request = BookAppointmentRequest(
            doctorId = doctorId,
            startTime = start,
            endTime = end
        )

        // No conflicts
        Mockito.`when`(
            appointmentRepository
                .existsByDoctorIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                    doctorId,
                    AppointmentStatus.BOOKED,
                    end,
                    start
                )
        ).thenReturn(false)

        Mockito.`when`(
            appointmentRepository
                .existsByPatientIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                    patientId,
                    AppointmentStatus.BOOKED,
                    end,
                    start
                )
        ).thenReturn(false)

        // Mock appointment save
        Mockito.`when`(
            appointmentRepository.save(Mockito.any())
        ).thenAnswer { invocation ->
            val appointment = invocation.arguments[0] as Appointment
            appointment.copy(id = "appointment-123")
        }

        // WHEN
        val appointment =
            bookingService.bookAppointment(patientId, request)

        // THEN
        assert(appointment.doctorId == doctorId)
        assert(appointment.patientId == patientId)
        assert(appointment.status == AppointmentStatus.BOOKED)

        // Verify side effects
        Mockito.verify(notificationRepository).save(Mockito.any())
        Mockito.verify(doctorService).recomputeBookableStatus(doctorId)
    }


    @Test
    fun `should reject booking when endTime is before or equal to startTime`() {

        val patientId = "patient-1"

        val start = Instant.parse("2025-01-01T10:30:00Z")
        val end   = Instant.parse("2025-01-01T10:00:00Z") // ❌ invalid

        val request = BookAppointmentRequest(
            doctorId = "doctor-1",
            startTime = start,
            endTime = end
        )

        assertThrows(IllegalArgumentException::class.java) {
            bookingService.bookAppointment(patientId, request)
        }
    }


    @Test
    fun `should handle race condition when slot is booked concurrently`() {

        val doctorId = "doctor-1"
        val patientId = "patient-1"

        val start = Instant.parse("2025-01-01T14:00:00Z")
        val end   = Instant.parse("2025-01-01T14:30:00Z")

        val request = BookAppointmentRequest(
            doctorId = doctorId,
            startTime = start,
            endTime = end
        )

        // No conflicts detected initially
        Mockito.`when`(
            appointmentRepository
                .existsByDoctorIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                    doctorId,
                    AppointmentStatus.BOOKED,
                    end,
                    start
                )
        ).thenReturn(false)

        Mockito.`when`(
            appointmentRepository
                .existsByPatientIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                    patientId,
                    AppointmentStatus.BOOKED,
                    end,
                    start
                )
        ).thenReturn(false)

        // Simulate DB-level race condition
        Mockito.`when`(
            appointmentRepository.save(Mockito.any())
        ).thenThrow(org.springframework.dao.DuplicateKeyException("Duplicate booking"))

        assertThrows(SlotAlreadyBookedException::class.java) {
            bookingService.bookAppointment(patientId, request)
        }
    }




}
