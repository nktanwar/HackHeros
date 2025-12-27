package com.veersa.appointment_backend.exception



import java.time.LocalDateTime

data class ErrorResponse(
    val timestamp: LocalDateTime = LocalDateTime.now(),
    val status: Int,
    val error: String,
    val message: String,
    val path: String
)

class SlotAlreadyBookedException(
    message: String = "This time slot is already booked"
) : RuntimeException(message)
