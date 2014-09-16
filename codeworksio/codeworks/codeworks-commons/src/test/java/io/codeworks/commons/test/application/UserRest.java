package io.codeworks.commons.test.application;

import io.codeworks.commons.rest.controller.Rest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/api/users")
public class UserRest implements Rest<User> {

    private Logger logger = Logger.getLogger(this.getClass());

    @Override
    @RequestMapping(value = "/{id}", method = RequestMethod.GET, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public User read(
        @PathVariable("id") Long id) {

        logger.debug("read" + tostr(id));

        return new User();
    }

    @Override
    @RequestMapping(value = "/search", method = RequestMethod.GET, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public List<User> read(
        @RequestParam(value = "query", required = false) String query) {

        logger.debug("read by query" + tostr(query));

        return new ArrayList<>();
    }

    @Override
    @RequestMapping(value = "", method = RequestMethod.POST, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public User create(
        @RequestBody User model) {

        logger.debug("create" + tostr(model));

        return new User();
    }

    @Override
    @RequestMapping(value = "/list", method = RequestMethod.POST, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public List<User> create(
        @RequestBody List<User> models) {

        logger.debug("create" + tostr(models));

        return new ArrayList<>();
    }

    @Override
    @RequestMapping(value = "/{id}", method = RequestMethod.PUT, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public User update(
        @PathVariable("id") Long id,
        @RequestBody User model) {

        logger.debug("update" + tostr(id, model));

        return new User();
    }

    @Override
    @RequestMapping(value = "/list", method = RequestMethod.PUT, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public List<User> update(
        @RequestBody List<User> models) {

        logger.debug("update" + tostr(models));

        return new ArrayList<>();
    }

    @Override
    @RequestMapping(value = "/search", method = RequestMethod.PUT, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public List<User> update(
        @RequestParam(value = "query", required = false) String query,
        @RequestBody User properties) {

        logger.debug("update by query" + tostr(query, properties));

        return new ArrayList<>();
    }

    @Override
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public void delete(
        @PathVariable("id") Long id) {

        logger.debug("delete" + tostr(id));
    }

    @Override
    @RequestMapping(value = "/search", method = RequestMethod.DELETE, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public void delete(
        @RequestParam(value = "query", required = false) String query) {

        logger.debug("delete by query" + tostr(query));
    }

    @Override
    @RequestMapping(value = "/count", method = RequestMethod.GET, produces = { MediaType.APPLICATION_JSON_VALUE })
    @ResponseBody
    public Map<String, Long> count(
        @RequestParam(value = "query", required = false) String query) {

        logger.debug("count by query" + tostr(query));

        return new HashMap<>();
    }

    private String tostr(Object... arr) {

        StringBuilder sb = new StringBuilder();

        for(Object obj: arr) {
            if(obj != null && obj instanceof List) {
                sb.append(" [ ");
                for(Object item: (List<?>) obj) {
                    sb.append("[");
                    sb.append(item.toString());
                    sb.append("],");
                }
                sb.deleteCharAt(sb.length() - 1);
                sb.append(" ]");
            }
            else if(obj != null && !obj.toString().equals("")) {
                sb.append(" [ ");
                sb.append(obj.toString());
                sb.append(" ]");
            }
            else {
                sb.append(" []");
            }
        }

        return sb.toString();
    }

}
