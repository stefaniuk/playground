package com.host4ge.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/test/*")
public class TestController {

    @RequestMapping(value = "*.json")
    public void json(HttpServletRequest request, HttpServletResponse response) throws Exception {

        System.out.println("...");
    }

}
