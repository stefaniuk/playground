package io.codeworks.archetypes.web;

import java.util.Arrays;
import java.util.HashSet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.thymeleaf.dialect.IDialect;
import org.thymeleaf.extras.springsecurity3.dialect.SpringSecurityDialect;
import org.thymeleaf.spring4.SpringTemplateEngine;
import org.thymeleaf.spring4.view.ThymeleafViewResolver;
import org.thymeleaf.templateresolver.ServletContextTemplateResolver;

@Configuration
@EnableWebMvc
@ComponentScan(excludeFilters = @ComponentScan.Filter(value = Configuration.class, type = FilterType.ANNOTATION))
//@Import(?.class)
public class WebServletConfig extends WebMvcConfigurerAdapter {

    private static Logger logger = LoggerFactory.getLogger(WebServletConfig.class);

    public static void main(String[] args) throws Exception {

        logger.debug("Starting the application");

        SpringApplication.run(WebServletConfig.class, args);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        logger.debug("configure resource handler registry");

        registry
            .addResourceHandler("/resources/**")
            .addResourceLocations("/resources/");
    }

    @Bean
    public ServletContextTemplateResolver templateResolver() {

        logger.debug("configure template resolver");

        ServletContextTemplateResolver resolver = new ServletContextTemplateResolver();

        resolver.setPrefix("/WEB-INF/templates/");
        resolver.setTemplateMode("HTML5");
        resolver.setCharacterEncoding("UTF-8");
        resolver.setCacheable(false);

        return resolver;
    }

    @Bean
    public SpringTemplateEngine templateEngine() {

        logger.debug("configure template engine");

        SpringTemplateEngine engine = new SpringTemplateEngine();

        engine.setTemplateResolver(templateResolver());
        engine.setAdditionalDialects(new HashSet<IDialect>(Arrays.asList(
            new SpringSecurityDialect())));

        return engine;
    }

    @Bean
    public ThymeleafViewResolver viewResolver() {

        logger.debug("configure view resolver");

        ThymeleafViewResolver resolver = new ThymeleafViewResolver();

        resolver.setTemplateEngine(templateEngine());
        resolver.setCharacterEncoding("UTF-8");

        return resolver;
    }

}
