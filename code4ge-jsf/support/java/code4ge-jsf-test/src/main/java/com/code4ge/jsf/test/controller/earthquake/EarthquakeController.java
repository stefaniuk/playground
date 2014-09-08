package com.code4ge.jsf.test.controller.earthquake;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.code4ge.jsf.mvc.controller.AbstractController;
import com.code4ge.jsf.mvc.store.QueryStore;
import com.code4ge.jsf.test.model.earthquake.Earthquake;
import com.code4ge.jsf.test.model.earthquake.EarthquakeDao;
import com.code4ge.jsf.test.store.earthquake.EarthquakeStore;
import com.code4ge.jsf.test.util.earthquake.ProcessEarthquakeDatabase;

@Controller
@RequestMapping(value = "/earthquake/*")
public class EarthquakeController extends AbstractController {

    /** Process earthquake database bean. */
    @Autowired
    private ProcessEarthquakeDatabase processEarthquakeDatabase;

    /** Earthquake data access object. */
    @Autowired
    private EarthquakeDao earthquakeDao;

    @RequestMapping(value = "initialise")
    public void initialise(HttpServletRequest request, HttpServletResponse response) throws Exception {

        processEarthquakeDatabase.createDatabase();
    }

    @RequestMapping(value = "list")
    public ModelAndView list(HttpServletRequest request, HttpServletResponse response) throws Exception {

        ModelAndView mav = init(request, response, "screen", "EarthquakeList");
        mav.addObject("subtitle", "Earthquake List");

        List<Earthquake> earthquakeList = earthquakeDao.findAll();
        mav.addObject("earthquakes", earthquakeList);

        return mav;
    }

    @RequestMapping(value = "test-chart-earthquakes")
    public ModelAndView testChartEarthquakes(HttpServletRequest request, HttpServletResponse response) throws Exception {

        ModelAndView mav = init(request, response, "screen", "test-chart-earthquakes");
        mav.addObject("subtitle", "Earthquake Charts");

        List<Earthquake> earthquakes = earthquakeDao.findAll();
        mav.addObject("earthquakes", earthquakes);

        return mav;
    }

    @Override
    @RequestMapping(value = "service/{service}")
    public ResponseEntity<String> service(@PathVariable String service, HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        throw new UnsupportedOperationException("service");
    }

    @Override
    @RequestMapping(value = "store/{store}")
    public ResponseEntity<String> store(@PathVariable String store, HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        throw new UnsupportedOperationException("store");
    }

    @Override
    @RequestMapping(value = "json/{method}")
    public ResponseEntity<String> json(@PathVariable String method, HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        return handleJson(request, response, EarthquakeStore.class, "select", new QueryStore());
    }

}
