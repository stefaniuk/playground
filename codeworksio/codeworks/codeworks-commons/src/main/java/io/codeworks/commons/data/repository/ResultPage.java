package io.codeworks.commons.data.repository;

import java.util.List;

import javax.validation.constraints.NotNull;

import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

/**
 * An implementation of pagination result.
 * 
 * @author Daniel Stefaniuk
 */
public class ResultPage<T> extends PageImpl<T> {

    private static final long serialVersionUID = 6612998400114936808L;

    public ResultPage(@NotNull List<T> pageContent, long totalNumberOfItems, Pageable pageable) {

        super(pageContent, pageable, totalNumberOfItems);
    }

}
