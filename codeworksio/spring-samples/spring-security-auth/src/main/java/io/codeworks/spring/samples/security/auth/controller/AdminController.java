package io.codeworks.spring.samples.security.auth.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class AdminController {

    @RequestMapping(method = RequestMethod.GET, value = "/admin")
    public String index() {

        return "admin";
    }

}
