package io.codeworks.commons.rql.converter;

public interface RqlConverter<Q> {

    public void setRql(String rql);

    public Q convert();

}
