package io.codeworks.commons.data.repository;

import io.codeworks.commons.data.model.Model;

import java.util.List;

import org.springframework.data.domain.Sort;

/**
 * This interface defines CRUD operations on a domain model.
 * 
 * @param <T> Domain model type
 * @param <C> Criteria type
 * @author Daniel Stefaniuk
 */
public interface Repository<T extends Model, C> {

    public T find(Long id);

    public List<T> find(List<Long> ids);

    public List<T> find(List<Long> ids, Sort sort);

    public ResultPage<T> find(List<Long> ids, RequestPage page);

    public List<T> find(C criteria);

    public List<T> find(C criteria, Sort sort);

    public ResultPage<T> find(C criteria, RequestPage page);

    public List<T> findAll();

    public List<T> findAll(Sort sort);

    public ResultPage<T> findAll(RequestPage page);

    public T save(T model);

    public List<T> save(List<T> models);

    public T update(T model);

    public List<T> update(List<T> models);

    public List<T> update(C criteria, T values);

    public void delete(Long id);

    public void delete(List<Long> ids);

    public void delete(C criteria);

    public void deleteAll();

    public boolean exists(Long id);

    public long count(C criteria);

    public long countAll();

}
