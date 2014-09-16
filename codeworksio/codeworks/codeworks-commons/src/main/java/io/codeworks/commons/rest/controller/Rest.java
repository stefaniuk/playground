package io.codeworks.commons.rest.controller;

import io.codeworks.commons.data.model.Model;

import java.util.List;
import java.util.Map;

/**
 * This interface defines REST endpoints for a specific domain model.
 * 
 * @param <T> Domain model type
 * @author Daniel Stefaniuk
 */
public interface Rest<T extends Model> {

    // read endpoints

    public T read(Long id);

    public List<T> read(String query);

    // read endpoints

    public T create(T model);

    public List<T> create(List<T> models);

    // read endpoints

    public T update(Long id, T model);

    public List<T> update(List<T> models);

    public List<T> update(String query, T properties);

    // read endpoints

    public void delete(Long id);

    public void delete(String query);

    // read endpoints

    public Map<String, Long> count(String query);

}
