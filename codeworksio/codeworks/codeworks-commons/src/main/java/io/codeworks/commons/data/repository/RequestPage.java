package io.codeworks.commons.data.repository;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;

/**
 * An implementation of pagination request.
 * 
 * @author Daniel Stefaniuk
 */
public class RequestPage extends PageRequest {

    private static final long serialVersionUID = 9130335340783208777L;

    public RequestPage(int pageNumber, int pageSize) {

        super(pageNumber, pageSize);
    }

    public RequestPage(int pageNumber, int pageSize, Direction direction, String... properties) {

        super(pageNumber, pageSize, direction, properties);
    }

    public RequestPage(int pageNumber, int pageSize, Sort sort) {

        super(pageNumber, pageSize, sort);
    }

}
