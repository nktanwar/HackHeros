package com.veersa.appointment_backend.services



import com.veersa.appointment_backend.dto.TimeSlot
import com.veersa.appointment_backend.models.AppointmentStatus
import com.veersa.appointment_backend.repoistory.AppointmentRepository
import com.veersa.appointment_backend.repoistory.DoctorAvailabilityRepository

import org.springframework.stereotype.Service
import java.time.Instant
import java.time.temporal.ChronoUnit

@Service
class SlotService(
    private val availabilityRepository: DoctorAvailabilityRepository,
    private val appointmentRepository: AppointmentRepository
) {

    fun getAvailableSlots(
        doctorId: String,
        rangeStart: Instant,
        rangeEnd: Instant
    ): List<TimeSlot> {

        // fetch availability windows
        val availabilities =
            availabilityRepository.findByDoctorIdAndActiveIsTrueAndEndTimeAfterAndStartTimeBefore(
                doctorId, rangeStart, rangeEnd
            )

        if (availabilities.isEmpty()) return emptyList()

        // 2️⃣ Fetch overlapping appointments
        val appointments =
            appointmentRepository.findByDoctorIdAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                doctorId,
                AppointmentStatus.BOOKED,
                rangeEnd,
                rangeStart
            )

        val bookedIntervals = appointments.map {
            it.startTime to it.endTime
        }

        // 3️⃣ Generate slots
        val slots = mutableListOf<TimeSlot>()

        for (availability in availabilities) {

            val slotDuration = availability.slotDurationMinutes.toLong()

            var cursor = maxOf(availability.startTime, rangeStart)
            val windowEnd = minOf(availability.endTime, rangeEnd)

            while (cursor.plus(slotDuration, ChronoUnit.MINUTES) <= windowEnd) {

                val slotEnd = cursor.plus(slotDuration, ChronoUnit.MINUTES)

                // 4️⃣ Conflict check
                val overlaps = bookedIntervals.any { (bookedStart, bookedEnd) ->
                    cursor < bookedEnd && slotEnd > bookedStart
                }

                if (!overlaps) {
                    slots.add(TimeSlot(cursor, slotEnd))
                }

                cursor = slotEnd
            }
        }

        return slots.sortedBy { it.startTime }
    }
}
