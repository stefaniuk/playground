package io.codeworks.commons.test.rql.converter;

import io.codeworks.commons.rql.converter.RqlConverter;
import io.codeworks.commons.rql.converter.RqlHibernateConverter;
import io.codeworks.commons.test.Config;
import io.codeworks.commons.test.application.User;

import org.hibernate.criterion.DetachedCriteria;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = { Config.class })
public class RqlHibernateConverterTest {

    private final String RQL_QUERY = "or( and(ne(FOO,\"test*\"),eq(BAR,1)), and(ne(FOO,'%test'),eq(BAR,-1)), QUX==.0 ) , sort(+FOO,-BAR,BAZ) , limit(10,100)";

    @Test
    public void testRql() {

        RqlConverter<DetachedCriteria> rqlConv = new RqlHibernateConverter<User>();
        rqlConv.setRql(RQL_QUERY);
        DetachedCriteria criteria = rqlConv.convert();

        System.out.println(criteria);
    }

}
