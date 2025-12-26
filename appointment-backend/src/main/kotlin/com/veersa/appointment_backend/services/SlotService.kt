package com.veersa.appointment_backend.services



import com.veersa.appointment_backend.dto.TimeSlot
import com.veersa.appointment_backend.models.AppointmentStatus
import com.veersa.appointment_backend.models.DoctorAvailability
import com.veersa.appointment_backend.repoistory.AppointmentRepository
import com.veersa.appointment_backend.repoistory.DoctorAvailabilityRepository
import org.springframework.data.mongodb.core.MongoTemplate
import org.springframework.data.mongodb.core.query.Query
import org.springframework.data.mongodb.core.query.Criteria

import org.springframework.stereotype.Service
import java.time.Instant
import java.time.temporal.ChronoUnit

@Service
class SlotService(
    private val availabilityRepository: DoctorAvailabilityRepository,
    private val appointmentRepository: AppointmentRepository,
    private val mongoTemplate: MongoTemplate   // 👈 ADD THIS
) {

    fun getAvailableSlots(
        doctorId: String,
        rangeStart: Instant,
        rangeEnd: Instant
    ): List<TimeSlot> {


        println("=== RAW AVAILABILITY CHECK ===")
        val raw = availabilityRepository.findAllByDoctorId(doctorId)
        println("RAW AVAILABILITY COUNT = ${raw.size}")
        raw.forEach {
            println("RAW -> ${it.startTime} (${it.startTime.epochSecond}) -> ${it.endTime} (${it.endTime.epochSecond}) active=${it.active}")
        }

        val active = availabilityRepository.findByDoctorIdAndActiveTrue(doctorId)
        println("ACTIVE AVAILABILITIES = ${active.size}")
        active.forEach {
            println("ACTIVE -> ${it.startTime} -> ${it.endTime}")
        }


        val manualQuery = Query().addCriteria(
            Criteria.where("doctorId").`is`(doctorId)
                .and("active").`is`(true)
                .and("startTime").lt(rangeEnd)
                .and("endTime").gt(rangeStart)
        )

        val manual = mongoTemplate.find(manualQuery, DoctorAvailability::class.java)
        println("MANUAL QUERY COUNT = ${manual.size}")
        manual.forEach {
            println("MANUAL -> ${it.startTime} -> ${it.endTime}")
        }



        // fetch availability windows
        val availabilities =
            availabilityRepository
                .findByDoctorIdAndActiveTrueAndStartTimeLessThanAndEndTimeGreaterThan(
                    doctorId,
                    rangeEnd,    // startTime < rangeEnd
                    rangeStart   // endTime   > rangeStart
                )



        availabilities.forEach {
            println("AVAILABILITY FROM DB:")
            println("startTime = ${it.startTime} (${it.startTime.epochSecond})")
            println("endTime   = ${it.endTime} (${it.endTime.epochSecond})")
        }

        println("QUERY RANGE:")
        println("rangeStart = $rangeStart (${rangeStart.epochSecond})")
        println("rangeEnd   = $rangeEnd (${rangeEnd.epochSecond})")

        println("AVAILABILITIES FOUND = ${availabilities.size}")
        availabilities.forEach {
            println("AVAILABILITY: ${it.startTime} -> ${it.endTime}")
        }



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
