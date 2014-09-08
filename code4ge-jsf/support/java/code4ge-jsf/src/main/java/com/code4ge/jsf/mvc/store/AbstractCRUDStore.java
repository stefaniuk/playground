package com.code4ge.jsf.mvc.store;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.code4ge.json.service.JsonService;
import com.code4ge.json.service.JsonServiceServer;

/**
 * Spring MVC CRUD store. This class returns list of objects on select.
 * 
 * @author Daniel Stefaniuk
 */
public abstract class AbstractCRUDStore<M, D> {

    protected final Logger logger = LoggerFactory.getLogger(AbstractCRUDStore.class);

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

    /**
     * JSON-RPC method. Returns all persistent objects.
     * 
     * @param query
     * @return
     */
    @JsonService
    public abstract List<M> select(QueryStore query);

    /**
     * JSON-RPC method. Updates persistent object.
     * 
     * @param id
     * @param model
     * @return
     */
    @JsonService
    public abstract Integer update(Integer id, M model);

    /**
     * JSON-RPC method. Creates persistent object.
     * 
     * @param model
     * @return
     */
    @JsonService
    public abstract Integer insert(M model);

    /**
     * JSON-RPC method. Removes persistent object.
     * 
     * @param id
     * @return
     */
    @JsonService
    public abstract Integer delete(Integer id);

}
