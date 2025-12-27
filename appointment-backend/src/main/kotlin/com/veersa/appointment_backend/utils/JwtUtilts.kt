package com.veersa.appointment_backend.utils
import com.veersa.appointment_backend.config.JwtProperties
import io.jsonwebtoken.ExpiredJwtException
import io.jsonwebtoken.JwtException
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.security.Keys
import org.springframework.stereotype.Component
import java.util.*

@Component
class JwtUtils(
    private val jwtProperties: JwtProperties
) {

    private val key = Keys.hmacShaKeyFor(jwtProperties.secret.toByteArray())

    fun generateToken(user: UserPrincipal): String {
        val claims = Jwts.claims().setSubject(user.userId.toString())

        claims["name"] = user.name
        claims["email"] = user.email
        claims["phoneNumber"] = user.phoneNumber
        claims["role"] = user.role
        claims["verified"] = user.verified
        claims["tokenVersion"] = user.tokenVersion


        val now = Date()
        val expiry = Date(now.time + jwtProperties.expirationMs)

        return Jwts.builder()
            .setClaims(claims)
            .setIssuedAt(now)
            .setExpiration(expiry)
            .signWith(key)
            .compact()
    }

    fun extractUser(token: String): UserPrincipal {
        val claims = Jwts.parserBuilder()
            .setSigningKey(key)
            .build()
            .parseClaimsJws(token)
            .body

        return UserPrincipal(
            userId = claims.subject,
            name = claims["name"] as String,
            email = claims["email"] as String,
            phoneNumber = claims["phoneNumber"] as String,
            role = claims["role"] as String,
            verified = claims["verified"] as Boolean,
            tokenVersion = (claims["tokenVersion"] as Number).toLong()
        )
    }

    fun validateToken(token: String): Boolean {
        return try {
            Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
            true
        } catch (ex: ExpiredJwtException) {
            false
        } catch (ex: JwtException) {
            false
        }

    }
}
