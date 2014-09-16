package io.codeworks.commons.test.application;

import io.codeworks.commons.data.model.Model;

import java.util.List;

import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class MockRestApiServiceUtil {

    // get

    public static MockHttpServletRequestBuilder get(String uri) throws Exception {

        MockHttpServletRequestBuilder request = MockMvcRequestBuilders.get(uri)
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON);

        return request;
    }

    // post

    public static MockHttpServletRequestBuilder post(String uri) throws Exception {

        MockHttpServletRequestBuilder request = MockMvcRequestBuilders.post(uri)
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON);

        return request;
    }

    public static MockHttpServletRequestBuilder post(String uri, Model model) throws Exception {

        ObjectMapper mapper = new ObjectMapper();
        JsonNode node = mapper.valueToTree(model);

        MockHttpServletRequestBuilder request = MockMvcRequestBuilders.post(uri)
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON)
            .content(node.toString());

        return request;
    }

    public static MockHttpServletRequestBuilder post(String uri, List<? extends Model> models) throws Exception {

        ObjectMapper mapper = new ObjectMapper();
        JsonNode node = mapper.valueToTree(models);

        MockHttpServletRequestBuilder request = MockMvcRequestBuilders.post(uri)
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON)
            .content(node.toString());

        return request;
    }

    // put

    public static MockHttpServletRequestBuilder put(String uri) throws Exception {

        MockHttpServletRequestBuilder request = MockMvcRequestBuilders.post(uri)
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON);

        return request;
    }

    public static MockHttpServletRequestBuilder put(String uri, Model model) throws Exception {

        ObjectMapper mapper = new ObjectMapper();
        JsonNode node = mapper.valueToTree(model);

        MockHttpServletRequestBuilder request = MockMvcRequestBuilders.put(uri)
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON)
            .content(node.toString());

        return request;
    }

    public static MockHttpServletRequestBuilder put(String uri, List<? extends Model> models) throws Exception {

        ObjectMapper mapper = new ObjectMapper();
        JsonNode node = mapper.valueToTree(models);

        MockHttpServletRequestBuilder request = MockMvcRequestBuilders.put(uri)
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON)
            .content(node.toString());

        return request;
    }

    // delete

    public static MockHttpServletRequestBuilder delete(String uri) throws Exception {

        MockHttpServletRequestBuilder request = MockMvcRequestBuilders.delete(uri)
            .accept(MediaType.APPLICATION_JSON)
            .contentType(MediaType.APPLICATION_JSON);

        return request;
    }

}
