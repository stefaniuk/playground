package com.code4ge.jsf.mvc.service;

import java.util.List;

import com.code4ge.json.service.JsonService;

/**
 * Spring MVC JSON-RPC CRUD service.
 * 
 * @author Daniel Stefaniuk
 * @param <M> model
 * @param <D> data access object
 */
public abstract class AbstractCRUDService<M, D> extends AbstractService<D> {

    /**
     * JSON-RPC method. Creates persistent object.
     * 
     * @param model
     * @return
     */
    @JsonService
    public abstract Integer create(M model);

    /**
     * JSON-RPC method. Updates persistent object.
     * 
     * @param model
     * @param changed
     * @return
     */
    @JsonService
    public abstract Integer update(M model, M changed);

    /**
     * JSON-RPC method. Removes persistent object.
     * 
     * @param model
     * @return
     */
    @JsonService
    public abstract Integer remove(M model);

    /**
     * JSON-RPC method. Returns all persistent objects.
     * 
     * @return
     */
    @JsonService
    public abstract List<M> findAll();

    /**
     * JSON-RPC method. Returns persistent object by the given id.
     * 
     * @param id
     * @return
     */
    @JsonService
    public abstract M findById(Integer id);

    /**
     * JSON-RPC method. Returns number of all persistent objects.
     * 
     * @return
     */
    @JsonService
    public abstract Integer countAll();

}
