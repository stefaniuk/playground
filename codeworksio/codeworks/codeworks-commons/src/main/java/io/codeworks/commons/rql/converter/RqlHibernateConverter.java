package io.codeworks.commons.rql.converter;

import io.codeworks.commons.data.model.Model;
import io.codeworks.commons.rql.parser.RqlLexer;
import io.codeworks.commons.rql.parser.RqlParser;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.apache.log4j.Logger;
import org.hibernate.criterion.DetachedCriteria;

public class RqlHibernateConverter<T extends Model> implements RqlConverter<DetachedCriteria> {

    private Logger logger = Logger.getLogger(this.getClass());

    private RqlConverterListener<DetachedCriteria> listener;

    private String rql;

    public RqlHibernateConverter() {

        this("");
    }

    public RqlHibernateConverter(String rql) {

        this(new RqlHibernateConverterListener<T>(), rql);
    }

    private RqlHibernateConverter(RqlConverterListener<DetachedCriteria> listener, String rql) {

        this.listener = listener;
        this.rql = rql;
    }

    @Override
    public void setRql(String rql) {

        this.rql = rql;
    }

    @Override
    public DetachedCriteria convert() {

        ANTLRInputStream is = new ANTLRInputStream(rql.toCharArray(), rql.length());
        RqlLexer lexer = new RqlLexer(is);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        RqlParser parser = new RqlParser(tokens);
        parser.addParseListener(listener);
        ParseTree tree = parser.query();

        logger.debug(tree.toStringTree());

        DetachedCriteria criteria = listener.getQuery();

        return criteria;
    }

}
