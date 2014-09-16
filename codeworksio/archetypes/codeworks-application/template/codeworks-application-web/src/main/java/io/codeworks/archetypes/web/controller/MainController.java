package io.codeworks.archetypes.web.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {

    @RequestMapping("/")
    @Secured("ROLE_DEVELOPER")
    public String root(Locale locale) {

        return "redirect:/index.html";
    }

    @RequestMapping("/index.html")
    public String index() {

        return "index.html";
    }

    @RequestMapping("/user/index.html")
    public String userIndex() {

        return "user/index.html";
    }

    @RequestMapping("/admin/index.html")
    public String adminIndex() {

        return "admin/index.html";
    }

    @RequestMapping("/shared/index.html")
    public String sharedIndex() {

        return "shared/index.html";
    }

    @RequestMapping("/simulateError.html")
    public void simulateError() {

        throw new RuntimeException("This is a simulated error message");
    }

    @RequestMapping("/login")
    public String login() {

        return "login.html";
    }

    @RequestMapping("/login-error")
    public String loginError(Model model) {

        model.addAttribute("loginError", true);

        return "login.html";
    }

    @RequestMapping("/access-denied")
    public String accessDenied(Model model) {

        model.addAttribute("loginError", true);

        return "login.html";
    }

    @RequestMapping("/error")
    public String error(HttpServletRequest request, Model model) {

        model.addAttribute("errorCode", "Error " + request.getAttribute("javax.servlet.error.status_code"));
        Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
        StringBuilder errorMessage = new StringBuilder();
        errorMessage.append("<ul>");
        while(throwable != null) {
            errorMessage.append("<li>").append(escapeTags(throwable.getMessage())).append("</li>");
            throwable = throwable.getCause();
        }
        errorMessage.append("</ul>");
        model.addAttribute("errorMessage", errorMessage.toString());

        return "error.html";
    }

    private String escapeTags(String text) {

        if(text == null) {
            return null;
        }

        return text.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    }

}
