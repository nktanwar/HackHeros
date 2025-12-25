package com.veersa.appointment_backend.repoistory



import com.veersa.appointment_backend.models.DoctorAvailability
import org.springframework.data.mongodb.repository.MongoRepository
import java.time.Instant

interface DoctorAvailabilityRepository :
    MongoRepository<DoctorAvailability, String> {

    fun findByDoctorIdAndActiveIsTrueAndEndTimeAfterAndStartTimeBefore(
        doctorId: String,
        start: Instant,
        end: Instant
    ): List<DoctorAvailability>
}
