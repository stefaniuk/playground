package io.codeworks.archetypes.web;

import io.codeworks.archetypes.web.handler.AccessDeniedHandlerImp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.servlet.configuration.EnableWebMvcSecurity;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebMvcSecurity
@EnableGlobalMethodSecurity(securedEnabled = true, jsr250Enabled = true, prePostEnabled = true)
//@Import(?.class)
public class WebRootConfig extends WebSecurityConfigurerAdapter {

    private static Logger logger = LoggerFactory.getLogger(WebRootConfig.class);

    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {

        logger.debug("configure authentication manager builder");

        // @formatter:off
        auth
            .inMemoryAuthentication()
                .withUser("user").password("user").roles("USER").and()
                .withUser("admin").password("admin").roles("ADMIN").and()
                .withUser("dev").password("dev").roles("DEVELOPER").and()
                .withUser("super").password("super").roles("USER", "ADMIN", "DEVELOPER");
        // @formatter:on
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {

        logger.debug("configure http security");

        // @formatter:off
        http
            .authorizeRequests()
                // web application
                .antMatchers("/user/**").hasAnyRole("USER")
                .antMatchers("/admin/**").hasAnyRole("ADMIN")
                .antMatchers("/shared/**").hasAnyRole("USER", "ADMIN")
                // spring boot
                .antMatchers("/autoconfig**").hasAnyRole("DEVELOPER")
                .antMatchers("/beans**").hasAnyRole("DEVELOPER")
                .antMatchers("/configprops**").hasAnyRole("DEVELOPER")
                .antMatchers("/dump**").hasAnyRole("DEVELOPER")
                .antMatchers("/env**").hasAnyRole("DEVELOPER")
                .antMatchers("/health**").hasAnyRole("DEVELOPER")
                .antMatchers("/info**").hasAnyRole("DEVELOPER")
                .antMatchers("/metrics**").hasAnyRole("DEVELOPER")
                .antMatchers("/trace**").hasAnyRole("DEVELOPER")
                .and()
            .formLogin()
                .loginPage("/login").permitAll()
                .failureUrl("/login-error").permitAll()
                .and()
            .logout()
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout")).permitAll()
                .logoutSuccessUrl("/")
                .and()
            .exceptionHandling()
                .accessDeniedHandler(accessDeniedHandler());
        // @formatter:on
    }

    @Override
    public void configure(WebSecurity web) throws Exception {

        logger.debug("configure web security");

        // @formatter:off
        web
            .debug(false)
            .ignoring()
                .antMatchers("/resources/**");
        // @formatter:on
    }

    @Bean
    public AccessDeniedHandler accessDeniedHandler() {

        logger.debug("configure access denied handler");

        AccessDeniedHandlerImp handler = new AccessDeniedHandlerImp();
        handler.setAccessDeniedUrl("/access-denied");

        return handler;
    }

}
