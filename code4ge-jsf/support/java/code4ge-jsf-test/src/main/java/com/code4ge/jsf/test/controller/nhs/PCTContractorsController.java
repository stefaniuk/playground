package com.code4ge.jsf.test.controller.nhs;

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
import com.code4ge.jsf.test.model.nhs.PCTContractors;
import com.code4ge.jsf.test.model.nhs.PCTContractorsDao;
import com.code4ge.jsf.test.store.nhs.PCTContractorsStore;
import com.code4ge.jsf.test.util.nhs.ProcessPCTContractorsDatabase;

@Controller
@RequestMapping(value = "/pctcontractors/*")
public class PCTContractorsController extends AbstractController {

    /** Process PCT contractors database bean. */
    @Autowired
    private ProcessPCTContractorsDatabase processPCTContractorsDatabase;

    /** PCT contractors data access object. */
    @Autowired
    private PCTContractorsDao pctContractorsDao;

    @RequestMapping(value = "initialise")
    public void initialise(HttpServletRequest request, HttpServletResponse response) throws Exception {

        processPCTContractorsDatabase.createDatabase();
    }

    @RequestMapping(value = "list")
    public ModelAndView list(HttpServletRequest request, HttpServletResponse response) throws Exception {

        ModelAndView mav = init(request, response, "screen", "PCTContractorsList");
        mav.addObject("subtitle", "PCT Contractors List");

        List<PCTContractors> pctContractorsList = pctContractorsDao.findAll();
        mav.addObject("pctcontractors", pctContractorsList);

        return mav;
    }

    @RequestMapping(value = "test-chart")
    public ModelAndView testChartEarthquakes(HttpServletRequest request, HttpServletResponse response) throws Exception {

        ModelAndView mav = init(request, response, "screen", "test-chart-pctcontractors");
        mav.addObject("subtitle", "PCT Contractors Charts");

        return mav;
    }

    @Override
    @RequestMapping(value = "service/{service}")
    public ResponseEntity<String> service(@PathVariable String service, HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        throw new UnsupportedOperationException("service");
    }

    @Override
    @RequestMapping(value = "store/{store}")
    public ResponseEntity<String> store(@PathVariable String store, HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        throw new UnsupportedOperationException("store");
    }

    @Override
    @RequestMapping(value = "json/{method}")
    public ResponseEntity<String> json(String method, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        return handleJson(request, response, PCTContractorsStore.class, "select", new QueryStore());
    }

}
