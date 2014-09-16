package io.codeworks.spring.samples.security.auth.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class IndexController {

    @RequestMapping(method = RequestMethod.GET, value = "/public")
    public ModelAndView publicIndex() {

        ModelAndView mv = new ModelAndView("index");

        mv.addObject("data", "public index");

        return mv;
    }

    @RequestMapping(method = RequestMethod.GET, value = "/private")
    public ModelAndView privateIndex() {

        ModelAndView mv = new ModelAndView("index");

        mv.addObject("data", "private index");

        return mv;
    }

}
