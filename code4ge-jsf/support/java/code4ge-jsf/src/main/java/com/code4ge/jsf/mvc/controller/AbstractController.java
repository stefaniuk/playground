package com.code4ge.jsf.mvc.controller;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tiles.Attribute;
import org.apache.tiles.AttributeContext;
import org.apache.tiles.TilesContainer;
import org.apache.tiles.servlet.context.ServletUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.code4ge.jsf.ui.Bootstrap;
import com.code4ge.jsf.ui.Bootstrap.Dojo;
import com.code4ge.jsf.util.Configuration;
import com.code4ge.json.service.JsonServiceServer;
import com.code4ge.json.service.JsonServiceUtil;

/**
 * Spring MVC abstract controller.
 * 
 * @author Daniel Stefaniuk
 */
@Controller
public abstract class AbstractController implements InitializingBean {

    protected final Logger logger = LoggerFactory.getLogger(AbstractController.class);

    protected Bootstrap ui;

    /** JSON service server. */
    @Autowired
    private JsonServiceServer service;

    /** Configuration */
    @Autowired
    private Configuration configuration;

    public AbstractController() {

    }

    public void afterPropertiesSet() {

        // URL address
        String dojoUrl = "/dojo";
        if(configuration.containsKey("ui.bootstrap.dojo.url")) {
            dojoUrl = configuration.getProperty("ui.bootstrap.dojo.url");
            dojoUrl = dojoUrl.replaceAll("/$", "");
        }

        //locale
        String locale = "en-gb";
        if(configuration.containsKey("ui.bootstrap.dojo.locale")) {
            locale = configuration.getProperty("ui.bootstrap.dojo.locale");
        }

        ui = new Bootstrap();
        ui.setDojo(new Dojo()
            .setDojoUrl(dojoUrl)
            .setVersion(Dojo.Version.VER_1_7_0)
            .setEnvironment(Dojo.Environment.BUILD)
            .setBaseTheme(Dojo.Theme.CODE4GE)
            .addDojoConfig("parseOnLoad", "true")
            .addDojoConfig("locale", "'" + locale + "'")
            .requireModule("code4ge/main", "code4ge"));
    }

    /**
     * JSON-RPC service.
     * 
     * @param service
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "service/{service}")
    public abstract ResponseEntity<String> service(@PathVariable String service, HttpServletRequest request,
            HttpServletResponse response) throws Exception;

    /**
     * JSON-RPC default service.
     * 
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "service")
    public ResponseEntity<String> service(HttpServletRequest request, HttpServletResponse response) throws Exception {

        return service("default", request, response);
    }

    /**
     * JSON-RPC store.
     * 
     * @param store
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "store/{store}")
    public abstract ResponseEntity<String> store(@PathVariable String store, HttpServletRequest request,
            HttpServletResponse response) throws Exception;

    /**
     * JSON-RPC default store.
     * 
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "store")
    public ResponseEntity<String> store(HttpServletRequest request, HttpServletResponse response) throws Exception {

        return store("default", request, response);
    }

    /**
     * Returns raw JSON object.
     * 
     * @param method
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "json/{method}")
    public abstract ResponseEntity<String> json(@PathVariable String method, HttpServletRequest request,
            HttpServletResponse response) throws Exception;

    /**
     * Returns raw JSON object.
     * 
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "json")
    public ResponseEntity<String> json(HttpServletRequest request, HttpServletResponse response) throws Exception {

        return json("data", request, response);
    }

    /**
     * Initializes content to render and returns ModelAndView object without any
     * view.
     * 
     * @param request
     * @param response
     * @param name
     * @param layout
     * @return
     */
    protected ModelAndView init(HttpServletRequest request, HttpServletResponse response, String layout) {

        // render "layout"
        ModelAndView mav = new ModelAndView();
        mav.setViewName("layout." + layout);

        // set user interface bootstrap object
        ui.setRequest(request);
        request.setAttribute("Bootstrap", ui);

        return mav;
    }

    /**
     * Initializes content to render and returns ModelAndView object with a
     * single "content-view" view.
     * 
     * @param request
     * @param response
     * @param name
     * @param layout
     * @param view
     * @return
     */
    protected ModelAndView init(HttpServletRequest request, HttpServletResponse response, String layout, String view) {

        // render "layout"
        ModelAndView mav = new ModelAndView();
        mav.setViewName("layout." + layout);

        // render "view"
        String viewsDir = "/WEB-INF/views";
        if(configuration.containsKey("mvc.views.dir")) {
            viewsDir = configuration.getProperty("mvc.views.dir");
            viewsDir = viewsDir.replaceAll("/$", "");
        }
        TilesContainer tc = ServletUtil.getCurrentContainer(request, request.getSession().getServletContext());
        AttributeContext ac = tc.getAttributeContext(request, response);
        ac.putAttribute("content-view", new Attribute(viewsDir + "/" + view + ".jsp"), true);

        // set user interface bootstrap object
        ui.setRequest(request);
        request.setAttribute("Bootstrap", ui);

        return mav;
    }

    /**
     * Initializes content to render and returns ModelAndView object with
     * multiple views.
     * 
     * @param request
     * @param response
     * @param name
     * @param layout
     * @param views
     * @return
     */
    protected ModelAndView init(HttpServletRequest request, HttpServletResponse response, String layout,
            Map<String, String> views) {

        // render "layout"
        ModelAndView mav = new ModelAndView();
        mav.setViewName("layout." + layout);

        // render "view"
        String viewsDir = "/WEB-INF/views";
        if(configuration.containsKey("mvc.views.dir")) {
            viewsDir = configuration.getProperty("mvc.views.dir");
            viewsDir = viewsDir.replaceAll("/$", "");
        }
        TilesContainer tc = ServletUtil.getCurrentContainer(request, request.getSession().getServletContext());
        AttributeContext ac = tc.getAttributeContext(request, response);
        Set<String> keys = views.keySet();
        for(String key: keys) {
            ac.putAttribute(key, new Attribute(viewsDir + "/" + views.get(key) + ".jsp"), true);
        }

        // set user interface bootstrap object
        ui.setRequest(request);
        request.setAttribute("Bootstrap", ui);

        return mav;
    }

    /**
     * Handles JSON-RPC communication.
     * 
     * @param request
     * @param response
     * @param clazz method from a given class will be invoked
     * @return
     * @throws IOException
     */
    protected ResponseEntity<String> handleJsonRpc(HttpServletRequest request, HttpServletResponse response,
            Class<?> clazz) throws IOException {

        BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
        String method = request.getMethod();
        if(method.equals("GET")) {
            service.getServiceMap(clazz, bos);
            ResponseEntity<String> re = JsonServiceUtil.getResponseEntityForServiceMap(bos);

            return re;
        }
        else {
            service.handle(request, bos, clazz);
            ResponseEntity<String> re = JsonServiceUtil.getResponseEntityForMethodCall(bos);

            return re;
        }
    }

    /**
     * Handles raw JSON communication.
     * 
     * @param request
     * @param response
     * @param clazz method from a given class will be invoked
     * @param method method name to invoke
     * @return
     * @throws IOException
     */
    protected ResponseEntity<String> handleJson(HttpServletRequest request, HttpServletResponse response,
            Class<?> clazz, String method, Object... args) throws IOException {

        BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
        service.handle(request, bos, clazz, method, args);
        ResponseEntity<String> re = JsonServiceUtil.getResponseEntityForMethodCall(bos);

        return re;
    }

}
