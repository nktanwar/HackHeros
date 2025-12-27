package com.veersa.appointment_backend.repoistory



import com.veersa.appointment_backend.models.DoctorAvailability
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository
import java.time.Instant

@Repository
interface DoctorAvailabilityRepository :
    MongoRepository<DoctorAvailability, String> {


    fun findByDoctorIdAndActiveTrue(doctorId: String): List<DoctorAvailability>

    fun existsByDoctorIdAndActiveTrueAndEndTimeAfter(
        doctorId: String,
        time: Instant
    ): Boolean

    fun findByDoctorIdAndActiveTrueAndStartTimeLessThanAndEndTimeGreaterThan(
        doctorId: String,
        rangeEnd: Instant,
        rangeStart: Instant
    ): List<DoctorAvailability>

    fun findAllByDoctorId(doctorId: String): List<DoctorAvailability>




}
