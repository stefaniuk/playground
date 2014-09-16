package io.codeworks.archetypes.api;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebMvcApplicationInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    private static Logger logger = LoggerFactory.getLogger(WebMvcApplicationInitializer.class);

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {

        super.onStartup(servletContext);

        logger.debug("on startup");

        try {
            Class.forName("org.h2.server.web.WebServlet");
            ServletRegistration.Dynamic reg = servletContext.addServlet("H2Console", "org.h2.server.web.WebServlet");
            reg.setInitParameter("webAllowOthers", "true");
            reg.addMapping("/database/client/*");
        }
        catch(ClassNotFoundException e) {
            logger.warn("database client not found");
        }
    }

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
