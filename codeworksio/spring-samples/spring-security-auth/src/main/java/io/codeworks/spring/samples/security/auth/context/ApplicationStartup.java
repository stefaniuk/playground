package io.codeworks.spring.samples.security.auth.context;

import io.codeworks.spring.samples.security.auth.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

@Component
public class ApplicationStartup implements ApplicationListener<ContextRefreshedEvent> {

    @Autowired
    UserService userService;

    @Override
    public void onApplicationEvent(final ContextRefreshedEvent event) {

        userService.encodePasswords();
    }

}
