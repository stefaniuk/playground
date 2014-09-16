package io.codeworks.archetypes.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@Configuration
//@EnableJpaRepositories
//@EnableTransactionManagement
//@EnableWebMvc
@ComponentScan(excludeFilters = @ComponentScan.Filter(value = Configuration.class, type = FilterType.ANNOTATION))
//@Import(?.class)
public class WebServletConfig {

    private static Logger logger = LoggerFactory.getLogger(WebServletConfig.class);

    public static void main(String[] args) throws Exception {

        logger.debug("Starting the application");

        SpringApplication.run(WebServletConfig.class, args);
    }

    //@Bean
    public ViewResolver viewResolver() {

        logger.debug("configure view resolver");

        return null;
    }

}
