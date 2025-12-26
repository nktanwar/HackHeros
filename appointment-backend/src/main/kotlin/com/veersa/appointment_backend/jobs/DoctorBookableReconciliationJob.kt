package com.veersa.appointment_backend.jobs

import com.veersa.appointment_backend.repoistory.DoctorProfileRepository
import com.veersa.appointment_backend.services.DoctorService
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

@Component
class DoctorBookableReconciliationJob(
    private val doctorProfileRepository: DoctorProfileRepository,
    private val statusService: DoctorService
) {

    /**
     * Runs every 10 minutes (configurable)
     */
    @Scheduled(fixedDelay = 10 * 60 * 1000)
    fun reconcile() {
        doctorProfileRepository.findAll()
            .filter { it.active }
            .forEach { statusService.recomputeBookableStatus(it.doctorId) }
    }
}
