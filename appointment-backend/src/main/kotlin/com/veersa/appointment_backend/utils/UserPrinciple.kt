package com.veersa.appointment_backend.utils


import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

class UserPrincipal(
    val userId: String,
    val name: String,
    val email: String,
    val phoneNumber: String,
    val role: String,
    val verified: Boolean
) : UserDetails {

    override fun getAuthorities(): Collection<GrantedAuthority> =
        listOf(SimpleGrantedAuthority("ROLE_$role"))

    override fun getPassword(): String? = null

    override fun getUsername(): String = email

    override fun isAccountNonExpired() = true
    override fun isAccountNonLocked() = true
    override fun isCredentialsNonExpired() = true
    override fun isEnabled() = true
}
