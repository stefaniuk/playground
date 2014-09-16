package io.codeworks.spring.samples.security.auth.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {

    @RequestMapping(method = RequestMethod.GET, value = "/login")
    public String login() {

        return "login";
    }

    @RequestMapping(method = RequestMethod.GET, value = "/logout")
    public ModelAndView logout() {

        ModelAndView mv = new ModelAndView("redirect:login");

        return mv;
    }

    @RequestMapping(method = RequestMethod.GET, value = "/access-denied")
    public ModelAndView accessDenied() {

        ModelAndView mv = new ModelAndView("redirect:login");

        return mv;
    }

}
