package com.veersa.appointment_backend.repoistory



import com.veersa.appointment_backend.models.DoctorProfile
import org.springframework.data.mongodb.repository.MongoRepository

interface DoctorProfileRepository : MongoRepository<DoctorProfile, String> {

    fun findByDoctorId(doctorId: String): DoctorProfile?
}
