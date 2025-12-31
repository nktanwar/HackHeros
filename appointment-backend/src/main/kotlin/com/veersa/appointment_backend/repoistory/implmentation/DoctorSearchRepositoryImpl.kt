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
            .maxDistance(maxDistanceKm / earthRadiusKm)
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
            "distanceInKm"
        )

        val projectStage = project()
            .and("doctorId").`as`("doctorId")
            .and("clinicName").`as`("clinicName")
            .and("specialty").`as`("specialty")
            .and("distanceInKm").`as`("distanceInKm")
            .and("clinicLocation.coordinates").arrayElementAt(1).`as`("latitude")
            .and("clinicLocation.coordinates").arrayElementAt(0).`as`("longitude")

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

    override fun findAllDoctors(
        page: Int,
        size: Int
    ): List<DoctorSearchResult> {

        val skip = page * size

        val matchStage = Aggregation.match(
            Criteria.where("active").`is`(true)
                .and("isComplete").`is`(true)
        )

        val projectStage = project()
            .and("doctorId").`as`("doctorId")
            .and("clinicName").`as`("clinicName")
            .and("specialty").`as`("specialty")
            .and("clinicLocation.coordinates").arrayElementAt(1).`as`("latitude")
            .and("clinicLocation.coordinates").arrayElementAt(0).`as`("longitude")
            // distance is not applicable here
            .andExclude("_id")

        val aggregation = Aggregation.newAggregation(
            matchStage,
            Aggregation.skip(skip.toLong()),
            Aggregation.limit(size.toLong()),
            projectStage
        )

        return mongoTemplate.aggregate(
            aggregation,
            "doctor_profiles",
            DoctorSearchResult::class.java
        ).mappedResults
    }


}
