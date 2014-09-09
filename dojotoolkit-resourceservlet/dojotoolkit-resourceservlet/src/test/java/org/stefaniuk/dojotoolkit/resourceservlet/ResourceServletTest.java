package org.stefaniuk.dojotoolkit.resourceservlet;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.eclipse.jetty.testing.HttpTester;
import org.eclipse.jetty.testing.ServletTester;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.js.resource.ResourceServlet;

@SuppressWarnings("deprecation")
public class ResourceServletTest {

    private static ServletTester tester;

    @BeforeClass
    public static void setUpClass() throws Exception {

        tester = new ServletTester();
        tester.setContextPath("/");
        tester.addServlet(ResourceServlet.class, "/resources/dojotoolkit/*");
        tester.start();
    }

    @Test
    public void testDojoJs() throws Exception {

        HttpTester response = getResource("/resources/dojotoolkit/dojo/dojo.js");
        assertEquals(200, response.getStatus());
    }

    @Test
    public void testNoDojoJs() throws Exception {

        HttpTester response = getResource("/resources/dojotoolkit/dojo/no-dojo.js");
        assertEquals(404, response.getStatus());
    }

    @Test
    public void testDojoJsSize() throws Exception {

        HttpTester response = getResource("/resources/dojotoolkit/dojo/dojo.js");
        assertTrue(50000 < response.getContent().length());
    }

    @AfterClass
    public static void tearDownClass() throws Exception {

        tester.stop();
    }

    public HttpTester getResource(String url) throws Exception {

        HttpTester request = new HttpTester();
        request.setMethod("GET");
        request.setVersion("HTTP/1.1");
        request.setHeader("Host", "127.0.0.1");
        request.setURI(url);
        HttpTester response = new HttpTester();
        response.parse(tester.getResponses(request.generate()));

        return response;
    }

}
