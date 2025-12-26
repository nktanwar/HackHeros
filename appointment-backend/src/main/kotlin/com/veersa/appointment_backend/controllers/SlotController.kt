package com.veersa.appointment_backend.controllers


import com.veersa.appointment_backend.dto.TimeSlot
import com.veersa.appointment_backend.services.SlotService
import org.springframework.web.bind.annotation.*
import java.time.Instant

@RestController
@RequestMapping("/api/doctors")
class SlotController(
    private val slotService: SlotService
) {

    @GetMapping("/{doctorId}/slots")
    fun getAvailableSlots(
        @PathVariable doctorId: String,
        @RequestParam rangeStart: Instant,
        @RequestParam rangeEnd: Instant
    ): List<TimeSlot> {

        return slotService.getAvailableSlots(
            doctorId = doctorId,
            rangeStart = rangeStart,
            rangeEnd = rangeEnd
        )
    }
}
