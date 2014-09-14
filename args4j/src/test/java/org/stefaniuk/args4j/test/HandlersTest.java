package org.stefaniuk.args4j.test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Arrays;
import java.util.Map;

import org.junit.Test;
import org.stefaniuk.args4j.Parser;
import org.stefaniuk.args4j.test.bean.Json;
import org.stefaniuk.args4j.test.parameter.BooleanParameters;
import org.stefaniuk.args4j.test.parameter.ByteParameters;
import org.stefaniuk.args4j.test.parameter.CharacterParameters;
import org.stefaniuk.args4j.test.parameter.DiffrentTypeOptions;
import org.stefaniuk.args4j.test.parameter.DoubleParameters;
import org.stefaniuk.args4j.test.parameter.EnumParameters;
import org.stefaniuk.args4j.test.parameter.FileParameters;
import org.stefaniuk.args4j.test.parameter.FloatParameters;
import org.stefaniuk.args4j.test.parameter.IntegerParameters;
import org.stefaniuk.args4j.test.parameter.JSONParameters;
import org.stefaniuk.args4j.test.parameter.LongParameters;
import org.stefaniuk.args4j.test.parameter.ShortParameters;
import org.stefaniuk.args4j.test.parameter.StringArrayParameters;
import org.stefaniuk.args4j.test.parameter.StringParameters;
import org.stefaniuk.args4j.test.parameter.URIParameters;
import org.stefaniuk.args4j.test.parameter.URLParameters;

/**
 * Handlers test.
 * 
 * @author Daniel Stefaniuk
 */
public class HandlersTest {

    @Test
    public void testDiffrentTypeOptions() throws InstantiationException, IllegalAccessException {

        DiffrentTypeOptions parameters = new DiffrentTypeOptions();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] { "/opt", "option1", "-o", "option2", "opt", "option3" });

        assertTrue(parameters.getOption1().equals("option1"));
        assertTrue(parameters.getOption2().equals("option2"));
        assertTrue(parameters.getOption3().equals("option3"));
    }

    @Test
    public void testBooleanHandler() throws InstantiationException, IllegalAccessException {

        BooleanParameters parameters = new BooleanParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] { "true", "false", "/opt1=true", "/opt2=false" });

        assertTrue(parameters.getArgument1());
        assertFalse(parameters.getArgument2());
        assertFalse(parameters.getArgument3());
        assertTrue(parameters.getOption1());
        assertFalse(parameters.getOption2());
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testByteHandler() throws InstantiationException, IllegalAccessException {

        ByteParameters parameters = new ByteParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            Byte.toString(Byte.MIN_VALUE),
            Byte.toString(Byte.MAX_VALUE),
            "/opt1=" + Byte.MIN_VALUE,
            "/opt2=" + Byte.MAX_VALUE
        });

        assertTrue(parameters.getArgument1() == Byte.MIN_VALUE);
        assertTrue(parameters.getArgument2() == Byte.MAX_VALUE);
        assertTrue(parameters.getArgument3() == 0);
        assertTrue(parameters.getOption1() == Byte.MIN_VALUE);
        assertTrue(parameters.getOption2() == Byte.MAX_VALUE);
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testCharacterHandler() throws InstantiationException, IllegalAccessException {

        CharacterParameters parameters = new CharacterParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            "/opt1=A",
            "/opt2=%",
            "Z",
            "*"
        });

        assertTrue(parameters.getArgument1() == "Z".charAt(0));
        assertTrue(parameters.getArgument2() == "*".charAt(0));
        assertTrue(parameters.getArgument3() == "\u0000".charAt(0));
        assertTrue(parameters.getOption1() == "A".charAt(0));
        assertTrue(parameters.getOption2() == "%".charAt(0));
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testDoubleHandler() throws InstantiationException, IllegalAccessException {

        DoubleParameters parameters = new DoubleParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            Double.toString(Double.MIN_VALUE),
            Double.toString(Double.MAX_VALUE),
            "/opt1=" + Double.MIN_VALUE,
            "/opt2=" + Double.MAX_VALUE
        });

        assertTrue(parameters.getArgument1() == Double.MIN_VALUE);
        assertTrue(parameters.getArgument2() == Double.MAX_VALUE);
        assertTrue(parameters.getArgument3() == 0.0d);
        assertTrue(parameters.getOption1() == Double.MIN_VALUE);
        assertTrue(parameters.getOption2() == Double.MAX_VALUE);
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testEnumHandler() throws InstantiationException, IllegalAccessException {

        EnumParameters parameters = new EnumParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            EnumParameters.E_TYPE.T1.toString(),
            EnumParameters.E_TYPE.T2.toString(),
            "/opt1=" + EnumParameters.E_TYPE.T1.toString(),
            "/opt2=" + EnumParameters.E_TYPE.T2.toString()
        });

        assertTrue(parameters.getArgument1().equals(EnumParameters.E_TYPE.T1));
        assertTrue(parameters.getArgument2().equals(EnumParameters.E_TYPE.T2));
        assertTrue(parameters.getArgument3() == null);
        assertTrue(parameters.getOption1().equals(EnumParameters.E_TYPE.T1));
        assertTrue(parameters.getOption2().equals(EnumParameters.E_TYPE.T2));
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testFileHandler() throws InstantiationException, IllegalAccessException {

        FileParameters parameters = new FileParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            "/path/to/a/file",
            "\\path\\to\\a\\file",
            "/opt1=/path/to/a/file",
            "/opt2=\\path\\to\\a\\file"
        });

        assertTrue(parameters.getArgument1().equals(new File("/path/to/a/file")));
        assertTrue(parameters.getArgument2().equals(new File("\\path\\to\\a\\file")));
        assertTrue(parameters.getArgument3() == null);
        assertTrue(parameters.getOption1().equals(new File("/path/to/a/file")));
        assertTrue(parameters.getOption2().equals(new File("\\path\\to\\a\\file")));
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testFloatHandler() throws InstantiationException, IllegalAccessException {

        FloatParameters parameters = new FloatParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            Float.toString(Float.MIN_VALUE),
            Float.toString(Float.MAX_VALUE),
            "/opt1=" + Float.MIN_VALUE,
            "/opt2=" + Float.MAX_VALUE
        });

        assertTrue(parameters.getArgument1() == Float.MIN_VALUE);
        assertTrue(parameters.getArgument2() == Float.MAX_VALUE);
        assertTrue(parameters.getArgument3() == 0.0f);
        assertTrue(parameters.getOption1() == Float.MIN_VALUE);
        assertTrue(parameters.getOption2() == Float.MAX_VALUE);
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testIntegerHandler() throws InstantiationException, IllegalAccessException {

        IntegerParameters parameters = new IntegerParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            Integer.toString(Integer.MIN_VALUE),
            Integer.toString(Integer.MAX_VALUE),
            "/opt1=" + Integer.MIN_VALUE,
            "/opt2=" + Integer.MAX_VALUE
        });

        assertTrue(parameters.getArgument1() == Integer.MIN_VALUE);
        assertTrue(parameters.getArgument2() == Integer.MAX_VALUE);
        assertTrue(parameters.getArgument3() == 0);
        assertTrue(parameters.getOption1() == Integer.MIN_VALUE);
        assertTrue(parameters.getOption2() == Integer.MAX_VALUE);
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testLongHandler() throws InstantiationException, IllegalAccessException {

        LongParameters parameters = new LongParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            Long.toString(Long.MIN_VALUE),
            Long.toString(Long.MAX_VALUE),
            "/opt1=" + Long.MIN_VALUE,
            "/opt2=" + Long.MAX_VALUE
        });

        assertTrue(parameters.getArgument1() == Long.MIN_VALUE);
        assertTrue(parameters.getArgument2() == Long.MAX_VALUE);
        assertTrue(parameters.getArgument3() == 0);
        assertTrue(parameters.getOption1() == Long.MIN_VALUE);
        assertTrue(parameters.getOption2() == Long.MAX_VALUE);
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testShortHandler() throws InstantiationException, IllegalAccessException {

        ShortParameters parameters = new ShortParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            Short.toString(Short.MIN_VALUE),
            Short.toString(Short.MAX_VALUE),
            "/opt1=" + Short.MIN_VALUE,
            "/opt2=" + Short.MAX_VALUE
        });

        assertTrue(parameters.getArgument1() == Short.MIN_VALUE);
        assertTrue(parameters.getArgument2() == Short.MAX_VALUE);
        assertTrue(parameters.getArgument3() == 0);
        assertTrue(parameters.getOption1() == Short.MIN_VALUE);
        assertTrue(parameters.getOption2() == Short.MAX_VALUE);
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testStringArrayHandler() throws InstantiationException, IllegalAccessException {

        StringArrayParameters parameters = new StringArrayParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            "/opt1=aa,bb,cc,dd",
            "/opt2=\"aa,bb,cc,dd\",\"ee,ff,gg,hh\"",
            "/opt3", "aa", "bb", "cc", "dd"
        });

        assertTrue("[aa, bb, cc, dd]".equals(Arrays.toString(parameters.getOption1())));
        assertTrue("[aa,bb,cc,dd, ee,ff,gg,hh]".equals(Arrays.toString(parameters.getOption2())));
        assertTrue("[aa, bb, cc, dd]".equals(Arrays.toString(parameters.getOption3())));
    }

    @Test
    public void testStringHandler() throws InstantiationException, IllegalAccessException {

        StringParameters parameters = new StringParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            "/opt1=AAA",
            "/opt2=%%%",
            "ZZZ",
            "***"
        });

        assertTrue("ZZZ".equals(parameters.getArgument1()));
        assertTrue("***".equals(parameters.getArgument2()));
        assertTrue(parameters.getArgument3() == null);
        assertTrue("AAA".equals(parameters.getOption1()));
        assertTrue("%%%".equals(parameters.getOption2()));
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testURIHandler() throws InstantiationException, IllegalAccessException, URISyntaxException {

        URIParameters parameters = new URIParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            "/opt1=mailto:java-net@java.sun.com",
            "/opt2=file:///~/calendar",
            "http://java.sun.com/j2se/1.3/",
            "docs/guide/collections/designfaq.html#28"
        });

        assertTrue(new URI("http://java.sun.com/j2se/1.3/").equals(parameters.getArgument1()));
        assertTrue(new URI("docs/guide/collections/designfaq.html#28").equals(parameters.getArgument2()));
        assertTrue(parameters.getArgument3() == null);
        assertTrue(new URI("mailto:java-net@java.sun.com").equals(parameters.getOption1()));
        assertTrue(new URI("file:///~/calendar").equals(parameters.getOption2()));
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testURLHandler() throws InstantiationException, IllegalAccessException, MalformedURLException {

        URLParameters parameters = new URLParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            "/opt1=mailto:java-net@java.sun.com",
            "/opt2=file:///~/calendar",
            "http://java.sun.com/j2se",
            "https://args4j.dev.java.net/"
        });

        assertTrue(new URL("http://java.sun.com/j2se").equals(parameters.getArgument1()));
        assertTrue(new URL("https://args4j.dev.java.net/").equals(parameters.getArgument2()));
        assertTrue(parameters.getArgument3() == null);
        assertTrue(new URL("mailto:java-net@java.sun.com").equals(parameters.getOption1()));
        assertTrue(new URL("file:///~/calendar").equals(parameters.getOption2()));
        assertTrue(parameters.getOption3() == null);
    }

    @Test
    public void testJSONHandler() throws InstantiationException, IllegalAccessException {

        JSONParameters parameters = new JSONParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            "/json1={\"key1\":\"value1\"}",
            "/json2=[{\"key2\":\"value2\"}]",
            "/json3={\"key3\":\"value3\"}",
            "/json4=[{\"key4\":\"value4\"}]"
        });

        assertTrue(parameters.getJson1().toString().equals("{\"key1\":\"value1\"}"));
        assertTrue(parameters.getJson2().toString().equals("[{\"key2\":\"value2\"}]"));
        assertTrue(parameters.getJson3().get("key3").equals("value3"));
        assertTrue(((Map<?, ?>) parameters.getJson4().get(0)).get("key4").equals("value4"));
    }

    @Test
    public void testJSONHandlerCustomBean() throws InstantiationException, IllegalAccessException {

        JSONParameters parameters = new JSONParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            "/json5={\"key1\":\"value1\",\"key2\":2,\"key3\":3.3}"
        });

        Json json = parameters.getJson5();
        assertTrue(json.getKey1().equals("value1"));
        assertTrue(json.getKey2().equals(2));
        assertTrue(json.getKey3().equals(3.3d));
    }

    @Test
    public void testJSONHandlerFile() throws InstantiationException, IllegalAccessException, IOException {

        String fileName = System.getProperty("java.io.tmpdir") + System.getProperty("file.separator") + "file.json";

        Writer output = null;
        String content = "{\"key1\":\"value1\",\"key2\":2,\"key3\":3.3}";
        File file = new File(fileName);
        file.deleteOnExit();
        output = new BufferedWriter(new FileWriter(file));
        output.write(content);
        output.close();

        JSONParameters parameters = new JSONParameters();
        Parser parser = new Parser(parameters);
        parser.parse(new String[] {
            "/json1", "{\"key1\":\"value1\"}",
            "/json5", "file://" + fileName
        });

        Json json = parameters.getJson5();
        assertTrue(json.getKey1().equals("value1"));
        assertTrue(json.getKey2().equals(2));
        assertTrue(json.getKey3().equals(3.3d));
        assertTrue(parameters.getJson1().toString().equals("{\"key1\":\"value1\"}"));
    }

}
