package com.veersa.appointment_backend.services


import com.veersa.appointment_backend.repoistory.DoctorProfileRepository
import org.springframework.scheduling.annotation.Async
import org.springframework.stereotype.Service
import java.time.Instant
import java.time.temporal.ChronoUnit

@Service
class DoctorAvailabilityStatusService(
    private val slotService: SlotService,
    private val doctorProfileRepository: DoctorProfileRepository
) {

    /**
     * Recompute and update isCurrentlyBookable asynchronously
     */
    @Async
    fun recomputeBookableStatus(doctorId: String) {

        val now = Instant.now()
        val endOfWindow = now.plus(1, ChronoUnit.DAYS) // configurable window

        val remainingSlots =
            slotService.getAvailableSlots(
                doctorId = doctorId,
                rangeStart = now,
                rangeEnd = endOfWindow
            )

        val profile = doctorProfileRepository.findByDoctorId(doctorId)
            ?: return

        val shouldBeBookable = remainingSlots.isNotEmpty()

        if (profile.isCurrentlyBookable != shouldBeBookable) {
            doctorProfileRepository.save(
                profile.copy(isCurrentlyBookable = shouldBeBookable)
            )
        }
    }
}
