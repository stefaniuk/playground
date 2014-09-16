package io.codeworks.commons.rql.converter;

import io.codeworks.commons.data.model.Model;
import io.codeworks.commons.rql.parser.RqlBaseListener;
import io.codeworks.commons.rql.parser.RqlParser;
import io.codeworks.commons.rql.parser.RqlParser.EqContext;
import io.codeworks.commons.rql.parser.RqlParser.NeContext;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.misc.NotNull;
import org.apache.log4j.Logger;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.core.GenericTypeResolver;

public class RqlHibernateConverterListener<T extends Model> extends RqlBaseListener implements
    RqlConverterListener<DetachedCriteria> {

    private Logger logger = Logger.getLogger(this.getClass());

    private Class<T> clazz;

    private List<Map<Integer, Criterion>> criterions;

    @SuppressWarnings("unchecked")
    public RqlHibernateConverterListener() {

        clazz = (Class<T>) GenericTypeResolver.resolveTypeArgument(getClass(), RqlHibernateConverterListener.class);
        criterions = new ArrayList<>();
    }

    @Override
    public DetachedCriteria getQuery() {

        DetachedCriteria dc = DetachedCriteria.forClass(clazz);

        for(Map<Integer, Criterion> map: criterions) {
            for(Integer key: map.keySet()) {
                Criterion criterion = map.get(key);
                dc.add(criterion);
            }
        }

        return dc;
    }

    @Override
    public void exitAnd(@NotNull RqlParser.AndContext ctx) {

        logger.debug(ctx.getText() + " depth: " + ctx.depth());

        List<Criterion> list = new ArrayList<>();

        List<Map<Integer, Criterion>> newCriterions = new ArrayList<>();
        for(Map<Integer, Criterion> map: criterions) {
            for(Integer key: map.keySet()) {
                if(key > ctx.depth()) {
                    System.out.println("found child with depth level " + key);
                    Criterion criterion = map.get(key);
                    list.add(criterion);
                }
                else {
                    System.out.println("carry on with depth level " + key);
                    newCriterions.add(map);
                }
            }
        }

        Criterion[] array = list.toArray(new Criterion[list.size()]);
        Criterion andCriterion = Restrictions.and(array);
        Map<Integer, Criterion> andMap = new HashMap<>();
        andMap.put(ctx.depth(), andCriterion);
        newCriterions.add(andMap);

        criterions = newCriterions;
    }

    @Override
    public void exitOr(@NotNull RqlParser.OrContext ctx) {

        logger.debug(ctx.getText() + " depth: " + ctx.depth());

        List<Criterion> list = new ArrayList<>();

        List<Map<Integer, Criterion>> newCriterions = new ArrayList<>();
        for(Map<Integer, Criterion> map: criterions) {
            for(Integer key: map.keySet()) {
                if(key > ctx.depth()) {
                    System.out.println("found child with depth level " + key);
                    Criterion criterion = map.get(key);
                    list.add(criterion);
                }
                else {
                    System.out.println("carry on with depth level " + key);
                    newCriterions.add(map);
                }
            }
        }

        Criterion[] array = list.toArray(new Criterion[list.size()]);
        Criterion orCriterion = Restrictions.or(array);
        Map<Integer, Criterion> orMap = new HashMap<>();
        orMap.put(ctx.depth(), orCriterion);
        newCriterions.add(orMap);

        criterions = newCriterions;
    }

    @Override
    public void exitEq(EqContext ctx) {

        logger.debug(ctx.getText() + " depth: " + ctx.depth());

        String id = ctx.IDENTIFIER().getText();
        String value = ctx.VALUE().getText();

        Map<Integer, Criterion> map = new HashMap<Integer, Criterion>();
        map.put(ctx.depth(), Restrictions.eq(id, value));
        criterions.add(map);
    }

    @Override
    public void exitNe(NeContext ctx) {

        logger.debug(ctx.getText() + " depth: " + ctx.depth());

        String id = ctx.IDENTIFIER().getText();
        String value = ctx.VALUE().getText();

        Criterion criterion = null;
        if(value.contains("*") || value.contains("%")) {
            criterion = Restrictions.not(Restrictions.ilike(id, value.replace("*", "%")));
        }
        else {
            //isNumeric(value)
            criterion = Restrictions.ne(id, value);
        }

        Map<Integer, Criterion> map = new HashMap<Integer, Criterion>();
        map.put(ctx.depth(), criterion);
        criterions.add(map);
    }

    private boolean isNumeric(String str)
    {

        try
        {
            double d = Double.parseDouble(str);
        }
        catch(NumberFormatException nfe)
        {
            return false;
        }

        return true;
    }

}
