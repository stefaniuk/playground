package org.stefaniuk.daniel.facebook;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;

public class Auction {

    public static void main(String[] args) throws URISyntaxException, IOException {

        (new Auction()).run();
    }

    private void run() throws URISyntaxException, IOException {

        File file = new File(this.getClass().getResource("/org/stefaniuk/daniel/facebook/Auction.in").toURI());
        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;
        int count = -1;
        while((line = br.readLine()) != null) {

            if(++count == 0) {
                continue;
            }

            String[] data = line.split(" ");
            long n = Long.parseLong(data[0]);
            int p1 = Integer.parseInt(data[1]);
            int w1 = Integer.parseInt(data[2]);
            int m = Integer.parseInt(data[3]);
            int k = Integer.parseInt(data[4]);
            int a = Integer.parseInt(data[5]);
            int b = Integer.parseInt(data[6]);
            int c = Integer.parseInt(data[7]);
            int d = Integer.parseInt(data[8]);

            task(count, n, p1, w1, m, k, a, b, c, d);
        }
        br.close();
    }

    private void task(int count, long n, int p1, int w1, int m, int k, int a, int b, int c, int d) {

        ArrayList<Point> list = new ArrayList<Point>();
        HashSet<Long> set = new HashSet<Long>();

        int p = p1;
        int w = w1;
        long hash = (long) ((long) p1 << 32) + w1;

        // variables to deal with a periodic function
        boolean isPeriodicFun = false;
        long done = 0;
        long left = n;
        long numberOfPointsToAdd = 0;
        long lastPointToIncrement = 0;

        // save the first point
        list.add(new Point(p, w));
        set.add(hash);

        for(long i = 2; i <= n; i++) {

            int pi = (int) ((a * p + b) % m) + 1;
            int wi = (int) ((c * w + d) % k) + 1;
            hash = (long) ((long) pi << 32) + wi;

            // check if this is a periodic function
            if(set.contains(hash)) {
                isPeriodicFun = true;
                done = i - 1;
                left = n - done;
                numberOfPointsToAdd = left / done;
                lastPointToIncrement = n % done;
                break;
            }

            // save point
            list.add(new Point(pi, wi));
            if(set.size() < (2 <<16)) {
                set.add(hash);
            }

            p = pi;
            w = wi;
        }

        // if this is a periodic function correct number of points
        if(isPeriodicFun) {
            int index = 1;
            for(Point point: list) {
                point.number += numberOfPointsToAdd;
                if(index <= lastPointToIncrement) {
                    point.number += 1;
                }
                index++;
            }
        }

        // this bit of code uses sweep line algorithm
        // to get number of terrible deals and bargains

        Collections.sort(list, new Sort());
        // terrible
        Point max = list.get(list.size() - 1);
        long terrible = max.number;
        for(int i = list.size() - 2; i >= 0; i--) {
            Point cur = list.get(i);
            if(cur.y > max.y) {
                terrible += cur.number;
                max = cur;
            }
        }
        // bargains
        Point min = list.get(0);
        long bargains = min.number;
        for(int i = 1; i < list.size(); i++) {
            Point cur = list.get(i);
            if(cur.y < min.y) {
                bargains += cur.number;
                min = cur;
            }
        }

        System.out.println("Case #" + count + ": " + terrible + " " + bargains);
    }

    private class Point {

        public int x;

        public int y;

        public long number;

        public Point(int x, int y) {

            this.x = x;
            this.y = y;
            this.number = 1;
        }

    }

    private class Sort implements Comparator<Point> {

        public int compare(Point a, Point b) {

            if(a.x < b.x) {
                return -1;
            }
            else if(a.x > b.x) {
                return 1;
            }
            else if(a.y < b.y) {
                return -1;
            }
            else if(a.y > b.y) {
                return 1;
            }
            return 0;
        }
    };

}
