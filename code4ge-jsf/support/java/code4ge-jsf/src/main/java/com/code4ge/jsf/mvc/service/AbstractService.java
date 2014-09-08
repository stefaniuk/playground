package com.code4ge.jsf.mvc.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.code4ge.json.service.JsonServiceServer;

/**
 * Spring MVC JSON-RPC service.
 * 
 * @author Daniel Stefaniuk
 */
public abstract class AbstractService<D> {

    protected final Logger logger = LoggerFactory.getLogger(AbstractService.class);

    /** Data access object. */
    protected D dao;

    /**
     * Called automatically by the Spring Framework.
     * 
     * @param dao
     */
    @Autowired
    public void setDao(D dao) {

        this.dao = dao;
    }

    /**
     * Called automatically by the Spring Framework.
     * 
     * @param server
     */
    @Autowired
    public void setServer(JsonServiceServer server) {

        server.register(this);
    }

}
