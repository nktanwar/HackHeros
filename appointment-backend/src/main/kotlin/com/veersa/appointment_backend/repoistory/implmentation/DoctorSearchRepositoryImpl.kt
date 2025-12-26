package com.veersa.appointment_backend.repoistory.implmentation

import com.veersa.appointment_backend.dto.DoctorSearchResult
import com.veersa.appointment_backend.repoistory.DoctorSearchRepository
import org.springframework.data.mongodb.core.MongoTemplate
import org.springframework.data.mongodb.core.aggregation.Aggregation
import org.springframework.data.mongodb.core.aggregation.Aggregation.project
import org.springframework.data.mongodb.core.aggregation.AggregationResults
import org.springframework.data.mongodb.core.query.Criteria
import org.springframework.data.mongodb.core.geo.GeoJsonPoint
import org.springframework.data.mongodb.core.query.NearQuery
import org.springframework.data.mongodb.core.query.Query
import org.springframework.stereotype.Repository

@Repository
class DoctorSearchRepositoryImpl(
    private val mongoTemplate: MongoTemplate
) : DoctorSearchRepository {

    override fun findNearbyDoctors(
        longitude: Double,
        latitude: Double,
        specialty: String,
        maxDistanceKm: Double
    ): List<DoctorSearchResult> {

        val earthRadiusKm = 6371.0

        val nearQuery = NearQuery.near(
            GeoJsonPoint(longitude, latitude)
        )
            // maxDistance must be in RADIANS
            .maxDistance(maxDistanceKm / earthRadiusKm)
            // 🔥 THIS is where distance is converted
            .distanceMultiplier(earthRadiusKm)
            .query(
                Query(
                    Criteria.where("specialty").`is`(specialty)
                        .and("isCurrentlyBookable").`is`(true)
                        .and("active").`is`(true)
                )
            )
            .spherical(true)

        val geoNearStage = Aggregation.geoNear(
            nearQuery,
            "distanceInKm"   // already in KM
        )

        val projectStage = project()
            .and("doctorId").`as`("doctorId")
            .and("clinicName").`as`("clinicName")
            .and("specialty").`as`("specialty")
            .and("distanceInKm").`as`("distanceInKm")

        val aggregation = Aggregation.newAggregation(
            geoNearStage,
            projectStage
        )

        return mongoTemplate.aggregate(
            aggregation,
            "doctor_profiles",
            DoctorSearchResult::class.java
        ).mappedResults
    }
}
