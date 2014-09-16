package io.codeworks.archetypes.api;

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

@Configuration
//@EnableWebMvcSecurity
//@EnableGlobalMethodSecurity(securedEnabled = true, jsr250Enabled = true, prePostEnabled = true)
//@Import(?.class)
public class WebRootConfig /*extends WebSecurityConfigurerAdapter*/ {

    private static Logger logger = LoggerFactory.getLogger(WebRootConfig.class);

    //@Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {

        logger.debug("configure authentication manager builder");
    }

    //@Override
    protected void configure(HttpSecurity http) throws Exception {

        logger.debug("configure http security");
    }

    //@Override
    public void configure(WebSecurity web) throws Exception {

        logger.debug("configure web security");
    }

    //@Bean
    public AccessDeniedHandler accessDeniedHandler() {

        logger.debug("configure access denied handler");

        return null;
    }

}
