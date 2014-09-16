package io.codeworks.archetypes.web.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

public class AccessDeniedHandlerImp implements AccessDeniedHandler {

    private String accessDeniedUrl;

    public AccessDeniedHandlerImp() {

    }

    public AccessDeniedHandlerImp(String accessDeniedUrl) {

        this.accessDeniedUrl = accessDeniedUrl;
    }

    public String getAccessDeniedUrl() {

        return accessDeniedUrl;
    }

    public void setAccessDeniedUrl(String accessDeniedUrl) {

        this.accessDeniedUrl = accessDeniedUrl;
    }

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response,
        AccessDeniedException accessDeniedException) throws IOException, ServletException {

        request.getSession().setAttribute("message", "You do not have permission to access this page!");
        // TODO

        response.sendRedirect(accessDeniedUrl);
    }

}
