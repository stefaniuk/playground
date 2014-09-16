package io.codeworks.archetypes.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebMvcApplicationInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    private static Logger logger = LoggerFactory.getLogger(WebMvcApplicationInitializer.class);

    @Override
    protected Class<?>[] getRootConfigClasses() {

        logger.debug("initialise root configuration");

        return new Class<?>[] {
            WebRootConfig.class
        };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {

        logger.debug("initialise servlet configuration");

        return new Class<?>[] {
            WebServletConfig.class
        };
    }

    @Override
    protected String[] getServletMappings() {

        logger.debug("initialise servlet mappings");

        return new String[] {
            "/"
        };
    }

}
