package io.codeworks.script.launcher.test.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;

import com.google.common.io.Resources;

public class TestUtil {

    public static String getFileContent(String file) throws Exception {

        URL url = Resources.getResource(file);

        return getFileContent(url);
    }

    public static String getFileContent(URL url) throws Exception {

        StringBuilder sb = new StringBuilder();

        BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream()));
        String line;
        while((line = br.readLine()) != null) {
            sb.append(line);
            sb.append("\n");
        }
        br.close();

        return sb.toString();
    }

}
