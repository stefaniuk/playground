package io.codeworks.commons.test.rest.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import io.codeworks.commons.test.Config;
import io.codeworks.commons.test.application.MockRestApiServiceUtil;
import io.codeworks.commons.test.application.User;
import io.codeworks.commons.test.application.Util;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = { Config.class })
public class RestTest {

    // SEE: http://www.javacodegeeks.com/2013/08/unit-testing-of-spring-mvc-controllers-rest-api.html

    @Autowired
    private WebApplicationContext wac;

    private MockMvc mockMvc;

    @Before
    public void setUp() {

        mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
    }

    @Test
    public void testReadById() throws Exception {

        mockMvc.perform(MockRestApiServiceUtil.get("/api/users/1"))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    public void testReadSearch() throws Exception {

        mockMvc.perform(MockRestApiServiceUtil.get("/api/users/search?query=&sort=&page="))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    public void testCreateObject() throws Exception {

        User user = Util.getUser("user", null, "role");

        mockMvc.perform(MockRestApiServiceUtil.post("/api/users", user))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    public void testCreateObjects() throws Exception {

        List<User> users = new ArrayList<>();
        users.add(Util.getUser("user1", null, "role"));
        users.add(Util.getUser("user2", null, "role"));
        users.add(Util.getUser("user3", null, "role"));

        mockMvc.perform(MockRestApiServiceUtil.post("/api/users/list", users))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    public void testUpdateObject() throws Exception {

        User user = Util.getUser("user", null, "role");

        mockMvc.perform(MockRestApiServiceUtil.put("/api/users/1", user))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    public void testUpdateObjects() throws Exception {

        List<User> users = new ArrayList<>();
        users.add(Util.getUser("user1", null, "role"));
        users.add(Util.getUser("user2", null, "role"));
        users.add(Util.getUser("user3", null, "role"));

        mockMvc.perform(MockRestApiServiceUtil.put("/api/users/list", users))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    public void testUpdateObjectsSearch() throws Exception {

        User properties = Util.getUser(null, null, "role");

        mockMvc.perform(MockRestApiServiceUtil.put("/api/users/search?query=", properties))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    public void testDeleteById() throws Exception {

        mockMvc.perform(MockRestApiServiceUtil.delete("/api/users/1"))
            .andExpect(status().isOk());
    }

    @Test
    public void testDeleteSearch() throws Exception {

        mockMvc.perform(MockRestApiServiceUtil.delete("/api/users/search?query="))
            .andExpect(status().isOk());
    }

    @Test
    public void testCount() throws Exception {

        mockMvc.perform(MockRestApiServiceUtil.get("/api/users/count?query="))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

}
