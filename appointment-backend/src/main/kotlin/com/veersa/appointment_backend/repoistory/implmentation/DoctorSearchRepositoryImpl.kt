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

        // 1️⃣ Build NearQuery (THIS is what geoNear expects)
        val nearQuery = NearQuery.near(
            GeoJsonPoint(longitude, latitude)
        )
            .maxDistance(maxDistanceKm * 1000) // meters
            .query(
                Query(
                    Criteria.where("specialty").`is`(specialty)
                        .and("isCurrentlyBookable").`is`(true)
                        .and("active").`is`(true)
                )
            )
            .spherical(true)

        // 2️⃣ geoNear aggregation stage
        val geoNearStage = Aggregation.geoNear(
            nearQuery,
            "distanceInMeters"
        )

        // 3️⃣ Projection
        val projectStage = project()
            .and("doctorId").`as`("doctorId")
            .and("clinicName").`as`("clinicName")
            .and("specialty").`as`("specialty")
            .and("distanceInMeters").divide(1000).`as`("distanceInKm")

        val aggregation = Aggregation.newAggregation(
            geoNearStage,
            projectStage
        )

        val results: AggregationResults<DoctorSearchResult> =
            mongoTemplate.aggregate(
                aggregation,
                "doctor_profiles",
                DoctorSearchResult::class.java
            )

        return results.mappedResults
    }
}
