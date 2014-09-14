package org.stefaniuk.daniel.facebook;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.Collections;
import java.util.HashMap;

public class AlphabetSoup {

    public static void main(String[] args) throws URISyntaxException, IOException {

        (new AlphabetSoup()).run();
    }

    private void run() throws URISyntaxException, IOException {

        File file = new File(this.getClass().getResource("/org/stefaniuk/daniel/facebook/AlphabetSoup.in").toURI());
        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;
        int count = -1;
        while((line = br.readLine()) != null) {

            if(++count == 0) {
                continue;
            }

            //System.out.println(line);
            task(count, line);
        }
        br.close();
    }

    private void task(int count, String line) {

        int n = calculate(line);
        if(n > 0) {
            System.out.println("Case #" + count + ": " + n);
        }
        else {
            System.out.println("Case #" + count + ": 0");
        }
    }

    @SuppressWarnings("unused")
    private int calculate(String line) {

        // we need:
        // A x1
        // C x2
        // E x1
        // H x1
        // K x1
        // P x1
        // R x1
        // U x1

        HashMap<String, Integer> map = new HashMap<String, Integer>();
        for(int i = 0; i < line.length(); i++) {
            String key = Character.toString(line.charAt(i));
            if("ACEHKPRU".contains(key)) {
                if(map.containsKey(key)) {
                    map.put(key, map.get(key) + 1);
                }
                else {
                    map.put(key, 1);
                }
            }
        }

        int A = map.containsKey("A") ? map.get("A") : 0;
        int C = map.containsKey("C") ? map.get("C") : 0;
        int E = map.containsKey("E") ? map.get("E") : 0;
        int H = map.containsKey("H") ? map.get("H") : 0;
        int K = map.containsKey("K") ? map.get("K") : 0;
        int P = map.containsKey("P") ? map.get("P") : 0;
        int R = map.containsKey("R") ? map.get("R") : 0;
        int U = map.containsKey("U") ? map.get("U") : 0;
              
        int min = Collections.min(map.values());
        
        //System.out.println("A:" + A + ", C:" + C + ", E:" + E + ", H:" + H + ", K:" + K + ", P:" + P + ", R:" + R + ", U:" + U + ", min:" + min);
        
        if(min*2 <= C) {
            return min;
        }
        else {
            return C / 2;
        }
    }

}
