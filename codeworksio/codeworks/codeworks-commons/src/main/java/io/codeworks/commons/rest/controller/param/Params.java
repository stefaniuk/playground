package io.codeworks.commons.rest.controller.param;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

/**
 * This interface defines URL query parameters.
 * 
 * @param <Q> Query type
 * @author Daniel Stefaniuk
 */
public interface Params<Q> {

    public void setQuery(String query);

    public Q getQuery();

    public void setSort(String sort);

    public Sort getSort();

    public void setPage(String page);

    public Pageable getPage();

}
