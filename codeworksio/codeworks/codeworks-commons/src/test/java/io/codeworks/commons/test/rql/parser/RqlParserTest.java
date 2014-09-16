package io.codeworks.commons.test.rql.parser;

import io.codeworks.commons.rql.parser.RqlLexer;
import io.codeworks.commons.rql.parser.RqlParser;
import io.codeworks.commons.test.Config;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = { Config.class })
public class RqlParserTest {

    private final String RQL_QUERY = "or( and(ne(FOO,\"test*\"),eq(BAR,1)), and(ne(FOO,'%test'),eq(BAR,-1)), QUX==.0 ) , sort(+FOO,-BAR,BAZ) , limit(10,100)";

    private final String RQL_TOKENS = "(query (cond or ( (cond and ( (cond (op (ne ne ( FOO , \"test*\" )))) , (cond (op (eq eq ( BAR , 1 )))) )) , (cond and ( (cond (op (ne ne ( FOO , '%test' )))) , (cond (op (eq eq ( BAR , -1 )))) )) , (cond (op (eq QUX == .0))) )) , (order sort ( + FOO , - BAR , BAZ )) , (range limit ( 10 , 100 )))";

    @Test
    public void testRql() {

        ANTLRInputStream is = new ANTLRInputStream(RQL_QUERY.toCharArray(), RQL_QUERY.length());
        RqlLexer lexer = new RqlLexer(is);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        RqlParser parser = new RqlParser(tokens);
        ParseTree tree = parser.query();

        String str = tree.toStringTree(parser);
        Assert.isTrue(str.equals(RQL_TOKENS));
    }

}
