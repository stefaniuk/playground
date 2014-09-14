package org.stefaniuk.daniel.facebook;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.URISyntaxException;

public class Billboards {

    public static void main(String[] args) throws URISyntaxException, IOException {

        (new Billboards()).run();
    }

    private void run() throws URISyntaxException, IOException {

        File file = new File(this.getClass().getResource("/org/stefaniuk/daniel/facebook/Billboards.in").toURI());
        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;
        int count = -1;
        while((line = br.readLine()) != null) {

            if(++count == 0) {
                continue;
            }

            String[] data = line.split(" ", 3);
            Integer w = Integer.parseInt(data[0]);
            Integer h = Integer.parseInt(data[1]);
            String s = data[2];
            String[] words = s.split(" ");
            int maxFontSize = w / max(words);

            //System.out.println("Line: " + count + ", width: " + w + ", height: " + h + ", text: \"" + s + "\"");
            task(count, w, h, maxFontSize, words);
        }
        br.close();
    }

    private void task(int count, int w, int h, int maxFontSize, String[] words) {

        boolean found = false;
        // try maximum font size first
        for(int currFontSize = maxFontSize; currFontSize > 0; currFontSize--) {
            found = fit(w, h, currFontSize, 1, 0, currFontSize, words);
            if(found) {
                System.out.println("Case #" + count + ": " + currFontSize);
                break;
            }
        }
        if(!found) {
            System.out.println("Case #" + count + ": 0");
        }
    }

    private boolean fit(int w, int h, int f, int n, int cw, int ch, String[] words) {

        // check the word number
        if(n <= words.length) {

            String word = words[n - 1];
            int l = word.length() * f;

            //System.out.println(w + " " + h + " " + f + " " + n + " " + cw + " " + " " + ch + " " + word + " " + l);
            if(ch < h || (ch == h && cw < w)) {
                // we still have some space
                if(cw == 0) {
                    // first word in the line, let's try to put some more
                    //System.out.println(" if 1");
                    return fit(w, h, f, n + 1, cw + l, ch, words);
                }
                else {
                    if(cw + f + l <= w) {
                        // next word in the line, let's try to put even more
                        //System.out.println(" if 2");
                        return fit(w, h, f, n + 1, cw + f + l, ch, words);
                    }
                    else {
                        // we have to go to the next line to put this word
                        //System.out.println(" if 3");
                        return fit(w, h, f, n, 0, ch + f, words);
                    }
                }
            }
            else {
                // sorry, not enough space
                return false;
            }
        }
        else {
            // everything fits, we also have some more space but who cares
            return true;
        }
    }

    private int max(String[] words) {

        int l = 0;
        for(String word: words) {
            if(word.length() > l) {
                l = word.length();
            }
        }
        return l;
    }

}
