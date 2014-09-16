package io.codeworks.commons.rql.converter;

import io.codeworks.commons.rql.parser.RqlListener;

public interface RqlConverterListener<Q> extends RqlListener {

    public Q getQuery();

}
