package com.veersa.appointment_backend.filter

import com.veersa.appointment_backend.utils.JwtUtils
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter

@Component
class JwtAuthenticationFilter(
    private val jwtUtils: JwtUtils
) : OncePerRequestFilter() {

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {

        val authHeader = request.getHeader("Authorization")

        if (
            authHeader != null &&
            authHeader.startsWith("Bearer ") &&
            SecurityContextHolder.getContext().authentication == null
        ) {
            val token = authHeader.substring(7)



            if (jwtUtils.validateToken(token)) {

                val userPrincipal = jwtUtils.extractUser(token)

                val authentication = UsernamePasswordAuthenticationToken(
                    userPrincipal,
                    null,
                    userPrincipal.authorities
                )

                SecurityContextHolder.getContext().authentication = authentication
            }
        }

        filterChain.doFilter(request, response)
    }
}
