package com.veersa.appointment_backend.controllers


import com.veersa.appointment_backend.dto.TimeSlot
import com.veersa.appointment_backend.services.SlotService
import org.springframework.format.annotation.DateTimeFormat
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

        @RequestParam
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
        rangeStart: Instant,

        @RequestParam
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
        rangeEnd: Instant
    ): List<TimeSlot> {


        println("DEBUG rangeStart = $rangeStart")
        println("DEBUG rangeEnd   = $rangeEnd")

        return slotService.getAvailableSlots(
            doctorId = doctorId,
            rangeStart = rangeStart,
            rangeEnd = rangeEnd
        )
    }
}
