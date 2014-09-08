package com.code4ge.jsf.geo;

import java.awt.geom.Point2D;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.node.ArrayNode;
import org.codehaus.jackson.node.ObjectNode;
import org.opengis.feature.Feature;
import org.opengis.feature.FeatureVisitor;

public class Wales3 {

    private static ObjectMapper mapper = new ObjectMapper();

    private Map<String,Object> data;

    private int size = 1000;

    private int delta = 5;

    public static void main(String[] args) throws Exception {

        (new Wales3()).run();
    }

    public Wales3() throws IOException {

        data = mapper.readValue(new File("d:/projects/nhsia/www/geo/tmp/wales_only_regions_map.json"), Map.class);
    }

    public void run() throws IOException {

        // convert to Point2D
        HashMap<String, ArrayList<ArrayList<Point2D>>> map = new HashMap<String, ArrayList<ArrayList<Point2D>>>();
        Map<String, Map<String, Object>> features = (Map<String, Map<String, Object>>) data.get("features");
        for (String featureName : features.keySet()) {
            ArrayList<ArrayList<Point2D>> allpoints = new ArrayList<ArrayList<Point2D>>();
            ArrayList<ArrayList<Integer>> shapes = (ArrayList<ArrayList<Integer>>) features.get(featureName).get("shape");
            for(ArrayList<Integer> shape: shapes) {
                ArrayList<Point2D> points = new ArrayList<Point2D>();
                for(int i=0; i<shape.size(); i=i+2) {
                    points.add(new Point2D.Double(shape.get(i), shape.get(i+1)));
                }
                allpoints.add(points);
            }
            map.put(featureName, allpoints);
        }

        // map ha name to region name
        HashMap<String, ArrayList<String>> haToRegion = new HashMap<String, ArrayList<String>>();
        for(String region: features.keySet()) {
            String haName = getHACode(getPctCode((String) region));
            if(haToRegion.containsKey(haName)) {
                ArrayList<String> list = haToRegion.get(haName);
                list.add(region);
            }
            else {
                ArrayList<String> list = new ArrayList<String>();
                list.add(region);
                haToRegion.put(haName, list);
            }
        }
        final ArrayList<String> has = new ArrayList<String>();
        for(String key: haToRegion.keySet()) {
            has.add(key);
            ArrayList<String> list = haToRegion.get(key);
            for(String value: list) {
                System.out.println(key + ": " + value);
            }
        }

        // create a map of ha's points
        final HashMap<String, ArrayList<Point2D>> hasPoints1 = new HashMap<String, ArrayList<Point2D>>();
        for(String ha: haToRegion.keySet()) {
            ArrayList<Point2D> haPoints = new ArrayList<Point2D>();
            ArrayList<String> regions = haToRegion.get(ha);
            for(String region: regions) {
                ArrayList<ArrayList<Point2D>> list = map.get(region);
                for(ArrayList<Point2D> points: list) {
                    for(Point2D point: points) {
                        haPoints.add(point);
                    }
                }
            }
            hasPoints1.put(ha, haPoints);
        }
        for(String key: hasPoints1.keySet()) {
            ArrayList<Point2D> points = hasPoints1.get(key);
            System.out.println("ha points -> ha: " + key + ", number of points: " + points.size());
        }

        // remove borders
        int numberOfPoints2 = 0;
        int duplicated = 0;
        final HashMap<String, ArrayList<Point2D>> hasPoints2 = new HashMap<String, ArrayList<Point2D>>();
        for(String key: hasPoints1.keySet()) {
            HashMap<Point2D, Integer> count = new HashMap<Point2D, Integer>();
            HashMap<Point2D, Integer> nearest = new HashMap<Point2D, Integer>();
            ArrayList<Point2D> points = hasPoints1.get(key);
            for(Point2D point: points) {
                int isDuplicated = incPoint(point, count);
                duplicated += isDuplicated;
                // mark nearest points
                /*if(isDuplicated > 0) {
                    incPoint(new Point2D.Double((int) point.getX() + 1, (int) point.getY()), nearest);
                    incPoint(new Point2D.Double((int) point.getX() + 1, (int) point.getY() - 1), nearest);
                    incPoint(new Point2D.Double((int) point.getX(), (int) point.getY() - 1), nearest);
                    incPoint(new Point2D.Double((int) point.getX() - 1, (int) point.getY() - 1), nearest);
                    incPoint(new Point2D.Double((int) point.getX() - 1, (int) point.getY()), nearest);
                    incPoint(new Point2D.Double((int) point.getX() - 1, (int) point.getY() + 1), nearest);
                    incPoint(new Point2D.Double((int) point.getX(), (int) point.getY() + 1), nearest);
                    incPoint(new Point2D.Double((int) point.getX() + 1, (int) point.getY() + 1), nearest);
                }*/
            }
            ArrayList<Point2D> ps = hasPoints1.get(key);
            ArrayList<Point2D> ps2 = new ArrayList<Point2D>();
            for(Point2D p: ps) {
                if(count.get(p) > 1 || nearest.containsKey(p)) {
                    // we do not need this point
                }
                else {
                    ps2.add(p);
                    numberOfPoints2++;
                }
            }
            hasPoints2.put(key, ps2);
        }
        for(String key: hasPoints1.keySet()) {
            ArrayList<Point2D> points1 = hasPoints1.get(key);
            ArrayList<Point2D> points2 = hasPoints2.get(key);
            System.out.println("ha points -> ha: " + key + ", number of points (before): " + points1.size() + ", number of points (after): " + points2.size() + ", diff: " + (points1.size() - points2.size()));
        }
        //System.out.println("numberOfPoints2: " + numberOfPoints2);
        System.out.println("All duplicated points: " + duplicated);

        final HashMap<String, ArrayList<ArrayList<Integer>>> hasPoints3 = new HashMap<String, ArrayList<ArrayList<Integer>>>();
        final HashMap<String, ArrayList<Integer>> centers = new HashMap<String, ArrayList<Integer>>();
        final HashMap<String, ArrayList<Integer>> bboxes = new HashMap<String, ArrayList<Integer>>();
        for(String ha: hasPoints2.keySet()) {
            int x = -1;
            int y = -1;
            int x_min = 0xFFFF;
            int y_min = 0xFFFF;
            int x_max = 0;
            int y_max = 0;
            ArrayList<ArrayList<Integer>> shapes = new ArrayList<ArrayList<Integer>>();
            ArrayList<Integer> shape = new ArrayList<Integer>();
            ArrayList<Point2D> points = hasPoints2.get(ha);
            for(Point2D p: points) {
                if(x == (int) p.getX() && y == (int) p.getY()) continue;
                int cur_x = x;
                int cur_y = y;
                x = (int) p.getX();
                y = (int) p.getY();
                if(x < x_min) x_min = x;
                if(y < y_min) y_min = y;
                if(x > x_max) x_max = x;
                if(y > y_max) y_max = y;
                if((Math.abs(cur_x - x) > delta && Math.abs(cur_y - y) > delta && cur_x > -1 && cur_y > -1) || (Math.abs(cur_x - x) > 2*delta && cur_x > -1) || (Math.abs(cur_y - y) > 2*delta && cur_y > -1)) {
                    shapes.add(shape);
                    shape = new ArrayList<Integer>();
                }
                shape.add((int) p.getX());
                shape.add((int) p.getY());
            }
            shapes.add(shape);
            hasPoints3.put(ha, shapes);
            int center_x = (x_max - x_min) / 2 + x_min;
            int center_y = (y_max - y_min) / 2 + y_min;

            ArrayList<Integer> cl = new ArrayList<Integer>();
            cl.add(center_x);
            cl.add(center_y);
            centers.put(ha, cl);

            ArrayList<Integer> bbl = new ArrayList<Integer>();
            bbl.add(x_min);
            bbl.add(y_min);
            bbl.add(x_max - x_min);
            bbl.add(y_max - y_min);
            bboxes.put(ha, bbl);
        }

        final HashMap<String, ArrayList<ArrayList<Integer>>> hasPointsFinal = new HashMap<String, ArrayList<ArrayList<Integer>>>();
        for(String ha: hasPoints3.keySet()) {
            ArrayList<ArrayList<Integer>> shapes = hasPoints3.get(ha);
            System.out.println("ha: " + ha + " (" + shapes.size() + " shapes)");
            ArrayList<ArrayList<Integer>> matched = new ArrayList<ArrayList<Integer>>();
            boolean[] array = new boolean[shapes.size()];
            matched.add(shapes.get(0));
            array[0] = true;
            System.out.println("  added shape 0");
            int n = 0;
            while(n < shapes.size()) {
                int diff = 0xFFFF;
                int im = -1;
                int jm = -1;
                for(int i = 0; i < matched.size(); i++) {
                    ArrayList<Integer> shape1 = matched.get(i);
                    int s1_last_x = shape1.get(shape1.size() - 2);
                    int s1_last_y = shape1.get(shape1.size() - 1);
                    for(int j = i + 1; j < shapes.size(); j++) {
                        if(array[j]) continue;
                        ArrayList<Integer> shape2 = shapes.get(j);
                        int s2_first_x = shape2.get(0);
                        int s2_first_y = shape2.get(1);
                        int d = Math.abs(s1_last_x - s2_first_x) + Math.abs(s1_last_y - s2_first_y);
                        System.out.println("    compare shape " + j + " p=(" + s2_first_x + "," + s2_first_y + ") to shape " + i + " p=(" + s1_last_x + "," + s1_last_y + ") >>> diff=" + d);
                        if(
                            (d < diff) && 
                            (Math.abs(s1_last_x - s2_first_x) <= 2*delta) &&
                            (Math.abs(s1_last_y - s2_first_y) <= 2*delta)
                        ) {
                            diff = d;
                            im = i;
                            jm = j;
                            System.out.println("        it is a best match");
                        }
                    }
                }
                // merge shapes
                if(im != -1 && jm != -1) {
                    matched.get(im).addAll(shapes.get(jm));
                    array[jm] = true;
                    System.out.println("  merged shape " + jm + " with shape " + im);
                }
                // do not merge shapes 
                else {
                    // get first shape available
                    for(int k = 0; k < array.length; k++) {
                        if(!array[k]) {
                            matched.add(shapes.get(k));
                            array[k] = true;
                            System.out.println("  added shape " + k);
                            break;
                        }
                    }
                }
                // count all sorted shapes
                n = 0;
                for(int k = 0; k < array.length; k++) {
                    if(array[k]) {
                        n++;
                    }
                }
            }
            hasPointsFinal.put(ha, matched);
        }

        ObjectNode result = mapper.createObjectNode();
        ArrayList<Double> layerExtent = new ArrayList<Double>();
        layerExtent.add(0.0);
        layerExtent.add(0.0);
        layerExtent.add((double) size);
        layerExtent.add((double) size);
        result.put("layerExtent", toJson((List<?>) layerExtent));
        result.put("featureNames", toJson((List<String>) has));

        ObjectNode fts = mapper.createObjectNode();
        for(String featureName: has) {
            ObjectNode fnNode = mapper.createObjectNode();
            fts.put(featureName, fnNode);
            ArrayList<ArrayList<Integer>> out_outer = new ArrayList<ArrayList<Integer>>(); 
            ArrayList<ArrayList<Integer>> tmp = hasPointsFinal.get(featureName);
            for(ArrayList<Integer> arr: tmp) {
                ArrayList<Integer> out_inner = new ArrayList<Integer>();
                if(arr.size() > 10) {
                    for(int i=0; i<arr.size(); i++) {
                        int r = i%10;
                        if((i <= 1 || i >= arr.size()-2) || ((r==0 || r==1) || (r==4 || r==5) || (r==8 || r==9))) {
                            out_inner.add(arr.get(i));
                        }
                    }

                    // make sure the shape is "closed"
                    if(out_inner.get(0) != out_inner.get(out_inner.size()-2) || out_inner.get(1) != out_inner.get(out_inner.size()-1)) {
                        out_inner.add(out_inner.get(0));
                        out_inner.add(out_inner.get(1));
                    }

                    out_outer.add(out_inner);
                }
                else {
                    out_outer.add(arr);
                }
            }
            fnNode.put("shape", toJson(out_outer));
            fnNode.put("center", toJson(centers.get(featureName)));
            fnNode.put("bbox", toJson(bboxes.get(featureName)));
        }
        result.put("features", fts);

        PrintWriter out = new PrintWriter("d:/projects/nhsia/www/geo/tmp/wales_only_health_authorities_map.json");
        out.println(result.toString());
        out.close();
    }

    private String getPctCode(String str) {

        str = str.replace("district_borough_unitary_region.", "");

        if(str.equals("355") || str.equals("356") || str.equals("293") || str.equals("327") || str.equals("329") || str.equals("349")) { // 355 356 293 327 329 349
            str = "7A1";
        }
        else if(str.equals("358") || str.equals("360") || str.equals("328")) { // 358 360 328
            str = "7A2";
        }
        else if(str.equals("268") || str.equals("280") || str.equals("316")) { // 268 280 316
            str = "7A3";
        }
        else if(str.equals("277") || str.equals("357")) { // 277 357
            str = "7A4";
        }
        else if(str.equals("323") || str.equals("309")) { // 323 309
            str = "7A5";
        }
        else if(str.equals("278") || str.equals("274") || str.equals("340") || str.equals("359") || str.equals("279")) { // 278 274 340 359 279
            str = "7A6";
        }
        else if(str.equals("319")) { // 319
            str = "7A7";
        }

        return str;
    }

    private String getHACode(String str) {

        if(str.equals("7A1") || str.equals("7A7")) {
            str = "CLD";
        }
        else if(str.equals("7A2")) {
            str = "DYF";
        }
        else if(str.equals("7A3")) {
            str = "WGA";
        }
        else if(str.equals("7A4") || str.equals("7A5")) {
            str = "SGA";
        }
        else if(str.equals("7A6")) {
            str = "GWE";
        }

        return str;
    }

    private int incPoint(Point2D point, HashMap<Point2D, Integer> count) {
        
        if(count.containsKey(point)) {
            int n = count.get(point);
            count.put(point, n + 1);
            return 1;
        }
        else {
            count.put(point, 1);
            return 0;
        }
    }
    
    private ArrayNode toJson(List<?> list) {

        ArrayNode node = mapper.createArrayNode();

        for(Object obj: list) {
            if(obj instanceof Double) {
                node.add((Double) obj);
            }
            else if(obj instanceof Integer) {
                node.add((Integer) obj);
            }
            else if(obj instanceof Boolean) {
                node.add((Boolean) obj);
            }
            else if(obj instanceof String) {
                node.add((String) obj);
            }
            else if(obj instanceof List<?>) {
                node.add(toJson((List<?>) obj));
            }
            else if(obj instanceof Map<?, ?>) {
                node.add(toJson((Map<?, ?>) obj));
            }
            else {
                try {
                    node.addPOJO(obj);
                }
                catch(Exception e) {
                    node.add(obj != null ? obj.toString() : null);
                }
            }
        }

        return node;
    }

    private ObjectNode toJson(Map<?, ?> map) {

        ObjectNode node = mapper.createObjectNode();

        for(Object key: map.keySet()) {
            String name = (String) key;
            Object obj = map.get(name);

            if(obj instanceof Double) {
                node.put(name, (Double) obj);
            }
            else if(obj instanceof Integer) {
                node.put(name, (Integer) obj);
            }
            else if(obj instanceof Boolean) {
                node.put(name, (Boolean) obj);
            }
            else if(obj instanceof String) {
                node.put(name, (String) obj);
            }
            else if(obj instanceof List<?>) {
                node.put(name, toJson((List<?>) obj));
            }
            else if(obj instanceof Map<?, ?>) {
                node.put(name, toJson((Map<?, ?>) obj));
            }
            else {
                try {
                    node.putPOJO(name, obj);
                }
                catch(Exception e) {
                    node.put(name, obj != null ? obj.toString() : null);
                }
            }
        }

        return node;
    }
    
}
