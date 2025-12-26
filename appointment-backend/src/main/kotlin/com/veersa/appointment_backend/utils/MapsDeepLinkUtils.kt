package com.veersa.appointment_backend.utils

import java.net.URLEncoder
import java.nio.charset.StandardCharsets

object MapsDeepLinkUtil {

    fun drivingDirections(
        latitude: Double,
        longitude: Double
    ): String {
        return "https://www.google.com/maps/dir/?api=1" +
                "&destination=$latitude,$longitude" +
                "&travelmode=driving"
    }

    fun searchByClinicName(name: String): String {
        val encoded =
            URLEncoder.encode(name, StandardCharsets.UTF_8)
        return "https://www.google.com/maps/search/?api=1&query=$encoded"
    }
}
