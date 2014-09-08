package com.code4ge.jsf.geo;

import java.awt.geom.AffineTransform;
import java.awt.geom.Point2D;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.node.ArrayNode;
import org.codehaus.jackson.node.ObjectNode;
import org.geotools.data.FileDataStore;
import org.geotools.data.FileDataStoreFinder;
import org.geotools.data.ResourceInfo;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureSource;
import org.geotools.geometry.jts.ReferencedEnvelope;
import org.opengis.feature.Feature;
import org.opengis.feature.FeatureVisitor;

import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.Geometry;

public class ShapeConverter2 {

    private static ObjectMapper mapper = new ObjectMapper();

    private SimpleFeatureSource sfs;

    private SimpleFeatureCollection sfc;

    private ResourceInfo ri;

    private ReferencedEnvelope re;

    private AffineTransform translate;

    private AffineTransform scale;

    private int size = 1000;
    
    private int delta = 5;

    public static void main(String[] args) throws Exception {

        (new ShapeConverter2()).run();
    }

    public ShapeConverter2() throws IOException {

        File file = new File("d:/temp/data/Primary Care Trust (PCT) England/Post 2010 Changes/PCT/shp/PCO_SEPT_2011_EN_BFE_region.shp");
        FileDataStore fds = FileDataStoreFinder.getDataStore(file);

        sfs = fds.getFeatureSource();
        sfc = sfs.getFeatures();
        ri = sfs.getInfo();
        re = ri.getBounds();
        
        System.out.println("MinX: " + re.getMinX());
        System.out.println("MaxX: " + re.getMaxX());
        System.out.println("MinY: " + re.getMinY());
        System.out.println("MaxY: " + re.getMaxY());
        
        translate = AffineTransform.getTranslateInstance(-re.getMinX(), -re.getMinY());
        scale = AffineTransform.getScaleInstance(size / (re.getMaxX() - re.getMinX()), size / (re.getMaxY() - re.getMinY()));
    }

    public void run() throws IOException {

        // get all the data
        final HashMap<String, ArrayList<ArrayList<Point2D>>> pctsMap = new HashMap<String, ArrayList<ArrayList<Point2D>>>();
        FeatureVisitor visitor0 = new FeatureVisitor() {
            public void visit(Feature feature) {
                ArrayList<ArrayList<Point2D>> shapes = new ArrayList<ArrayList<Point2D>>();
                ArrayList<Point2D> shape = new ArrayList<Point2D>();
                int x = -1;
                int y = -1;
                int x_min = 0xFFFF;
                int y_min = 0xFFFF;
                int x_max = 0;
                int y_max = 0;
                String pctName = getPctCode((String) feature.getIdentifier().getID());
                Geometry geom = (Geometry) feature.getDefaultGeometryProperty().getValue();
                Coordinate[] cs = geom.getCoordinates();
                for(Coordinate c: cs) {
                    Point2D p = transform(new Point2D.Double((int) c.x, (int) c.y));
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
                        shape = new ArrayList<Point2D>();
                    }
                    shape.add(new Point2D.Double((int) p.getX(), (int) p.getY()));
                }
                shapes.add(shape);
                pctsMap.put(pctName, shapes);
            }
        };
        sfc.accepts(visitor0, null);
        int numberOfPoints1 = 0;
        for(String key: pctsMap.keySet()) {
            ArrayList<ArrayList<Point2D>> list = pctsMap.get(key);
            for(ArrayList<Point2D> points: list) {
                numberOfPoints1 += points.size();
                //System.out.println(key + ": " + list.size() + ", " + points.size());
            }
        }
        //System.out.println("numberOfPoints1: " + numberOfPoints1);

        final HashMap<String, ArrayList<String>> cipherToPcts = new HashMap<String, ArrayList<String>>();
        FeatureVisitor visitor1 = new FeatureVisitor() {
            public void visit(Feature feature) {
                String pctName = getPctCode((String) feature.getIdentifier().getID());
                String cipher = getCipher(pctName);
                if(cipherToPcts.containsKey(cipher)) {
                    ArrayList<String> list = cipherToPcts.get(cipher);
                    list.add(pctName);
                }
                else {
                    ArrayList<String> list = new ArrayList<String>();
                    list.add(pctName);
                    cipherToPcts.put(cipher, list);
                }
            }
        };
        sfc.accepts(visitor1, null);
        final ArrayList<String> ciphers = new ArrayList<String>();
        for(String key: cipherToPcts.keySet()) {
            ciphers.add(key);
            ArrayList<String> list = cipherToPcts.get(key);
            for(String value: list) {
                //System.out.println(key + ": " + value);
            }
        }

        final HashMap<String, ArrayList<Point2D>> ciphersPoints1 = new HashMap<String, ArrayList<Point2D>>();
        for(String cipher: cipherToPcts.keySet()) {
            ArrayList<Point2D> cipherPoints = new ArrayList<Point2D>();
            ArrayList<String> pcts = cipherToPcts.get(cipher);
            for(String pct: pcts) {
                ArrayList<ArrayList<Point2D>> list = pctsMap.get(pct);
                for(ArrayList<Point2D> points: list) {
                    for(Point2D point: points) {
                        cipherPoints.add(point);
                    }
                }
            }
            ciphersPoints1.put(cipher, cipherPoints);
        }
        for(String key: ciphersPoints1.keySet()) {
            ArrayList<Point2D> points = ciphersPoints1.get(key);
            //System.out.println("ciphersPoints -> cipher: " + key + ", number of points: " + points.size());
        }
     
        int numberOfPoints2 = 0;
        int duplicated = 0;
        final HashMap<String, ArrayList<Point2D>> ciphersPoints2 = new HashMap<String, ArrayList<Point2D>>();
        for(String key: ciphersPoints1.keySet()) {
            HashMap<Point2D, Integer> count = new HashMap<Point2D, Integer>();
            HashMap<Point2D, Integer> nearest = new HashMap<Point2D, Integer>();
            ArrayList<Point2D> points = ciphersPoints1.get(key);
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
            ArrayList<Point2D> ps = ciphersPoints1.get(key);
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
            ciphersPoints2.put(key, ps2);
        }
        for(String key: ciphersPoints1.keySet()) {
            ArrayList<Point2D> points1 = ciphersPoints1.get(key);
            ArrayList<Point2D> points2 = ciphersPoints2.get(key);
            //System.out.println("ciphersPoints -> cipher: " + key + ", number of points 1: " + points1.size() + ", number of points 2: " + points2.size());
        }
        //System.out.println("numberOfPoints2: " + numberOfPoints2);
        //System.out.println("All duplicated points: " + duplicated);
        
        
        final HashMap<String, ArrayList<ArrayList<Integer>>> ciphersPoints3 = new HashMap<String, ArrayList<ArrayList<Integer>>>();
        final HashMap<String, ArrayList<Integer>> centers = new HashMap<String, ArrayList<Integer>>();
        final HashMap<String, ArrayList<Integer>> bboxes = new HashMap<String, ArrayList<Integer>>();
        for(String cipher: ciphersPoints2.keySet()) {
            int x = -1;
            int y = -1;
            int x_min = 0xFFFF;
            int y_min = 0xFFFF;
            int x_max = 0;
            int y_max = 0;
            ArrayList<ArrayList<Integer>> shapes = new ArrayList<ArrayList<Integer>>();
            ArrayList<Integer> shape = new ArrayList<Integer>();
            ArrayList<Point2D> points = ciphersPoints2.get(cipher);
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
            ciphersPoints3.put(cipher, shapes);
            int center_x = (x_max - x_min) / 2 + x_min;
            int center_y = (y_max - y_min) / 2 + y_min;

            ArrayList<Integer> cl = new ArrayList<Integer>();
            cl.add(center_x);
            cl.add(center_y);
            centers.put(cipher, cl);

            ArrayList<Integer> bbl = new ArrayList<Integer>();
            bbl.add(x_min);
            bbl.add(y_min);
            bbl.add(x_max - x_min);
            bbl.add(y_max - y_min);
            bboxes.put(cipher, bbl);
        }
        
        
        final HashMap<String, ArrayList<ArrayList<Integer>>> ciphersPointsFinal = new HashMap<String, ArrayList<ArrayList<Integer>>>();
        for(String cipher: ciphersPoints3.keySet()) {
            ArrayList<ArrayList<Integer>> shapes = ciphersPoints3.get(cipher);
            System.out.println("cipher: " + cipher + " (" + shapes.size() + " shapes)");
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
            ciphersPointsFinal.put(cipher, matched);
        }

        ObjectNode result = mapper.createObjectNode();
        ArrayList<Double> layerExtent = new ArrayList<Double>();
        layerExtent.add(0.0);
        layerExtent.add(0.0);
        layerExtent.add((double) size);
        layerExtent.add((double) size);
        result.put("layerExtent", toJson((List<?>) layerExtent));
        result.put("featureNames", toJson((List<String>) ciphers));

        ObjectNode features = mapper.createObjectNode();
        for(String featureName: ciphers) {
            ObjectNode fnNode = mapper.createObjectNode();
            features.put(featureName, fnNode);
            ArrayList<ArrayList<Integer>> out_outer = new ArrayList<ArrayList<Integer>>(); 
            ArrayList<ArrayList<Integer>> tmp = ciphersPointsFinal.get(featureName);
            for(ArrayList<Integer> arr: tmp) {
                ArrayList<Integer> out_inner = new ArrayList<Integer>();
                if(arr.size() > 10) {
                    for(int i=0; i<arr.size(); i++) {
                        int r = i%10;
                        if((i <= 1 || i >= arr.size()-2) || ((r==0 || r==1) /*|| (r==4 || r==5) || (r==8 || r==9)*/)) {
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
        result.put("features", features);

        PrintWriter out = new PrintWriter("d:/projects/code4ge-jsf/source/code4ge/tests/geo/united_kingdom.json");
        out.println(result.toString());
        out.close();

    }

    private Point2D transform(Point2D point) {

        point = translate.transform(point, null);
        point = scale.transform(point, null);

        return new Point2D.Double((int) point.getX(), (int) ((double) size - point.getY()));
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

    private String getPctCode(String str) {

        str = str.replace("PCO_SEPT_2011_EN_BFE_region.", "");

        if(str.equals("1")) {
            str = "5A3";
        }
        else if(str.equals("2")) {
            str = "5A4";
        }
        else if(str.equals("3")) {
            str = "5A5";
        }
        else if(str.equals("4")) {
            str = "5A7";
        }
        else if(str.equals("5")) {
            str = "5A8";
        }
        else if(str.equals("6")) {
            str = "5A9";
        }
        else if(str.equals("7")) {
            str = "5AT";
        }
        else if(str.equals("8")) {
            str = "5C1";
        }
        else if(str.equals("9")) {
            str = "5C2";
        }
        else if(str.equals("10")) {
            str = "5C3";
        }
        else if(str.equals("11")) {
            str = "5C4";
        }
        else if(str.equals("12")) {
            str = "5C5";
        }
        else if(str.equals("13")) {
            str = "5C9";
        }
        else if(str.equals("14")) {
            str = "5CN";
        }
        else if(str.equals("15")) {
            str = "5CQ";
        }
        else if(str.equals("16")) {
            str = "5D7";
        }
        else if(str.equals("17")) {
            str = "5D8";
        }
        else if(str.equals("18")) {
            str = "5D9";
        }
        else if(str.equals("19")) {
            str = "5E1";
        }
        else if(str.equals("20")) {
            str = "5EF";
        }
        else if(str.equals("21")) {
            str = "5EM";
        }
        else if(str.equals("22")) {
            str = "5ET";
        }
        else if(str.equals("23")) {
            str = "5F1";
        }
        else if(str.equals("24")) {
            str = "5F5";
        }
        else if(str.equals("25")) {
            str = "5F7";
        }
        else if(str.equals("26")) {
            str = "5FE";
        }
        else if(str.equals("27")) {
            str = "5FL";
        }
        else if(str.equals("28")) {
            str = "5GC";
        }
        else if(str.equals("29")) {
            str = "5H1";
        }
        else if(str.equals("30")) {
            str = "5H8";
        }
        else if(str.equals("31")) {
            str = "5HG";
        }
        else if(str.equals("32")) {
            str = "5HP";
        }
        else if(str.equals("33")) {
            str = "5HQ";
        }
        else if(str.equals("34")) {
            str = "5HX";
        }
        else if(str.equals("35")) {
            str = "5HY";
        }
        else if(str.equals("36")) {
            str = "5J2";
        }
        else if(str.equals("37")) {
            str = "5J4";
        }
        else if(str.equals("38")) {
            str = "5J5";
        }
        else if(str.equals("39")) {
            str = "5J6";
        }
        else if(str.equals("40")) {
            str = "5J9";
        }
        else if(str.equals("41")) {
            str = "5JE";
        }
        else if(str.equals("42")) {
            str = "5JX";
        }
        else if(str.equals("43")) {
            str = "5K3";
        }
        else if(str.equals("44")) {
            str = "5K5";
        }
        else if(str.equals("45")) {
            str = "5K6";
        }
        else if(str.equals("46")) {
            str = "5K7";
        }
        else if(str.equals("47")) {
            str = "5K8";
        }
        else if(str.equals("48")) {
            str = "5K9";
        }
        else if(str.equals("49")) {
            str = "5KF";
        }
        else if(str.equals("50")) {
            str = "5KG";
        }
        else if(str.equals("51")) {
            str = "5KL";
        }
        else if(str.equals("52")) {
            str = "5KM";
        }
        else if(str.equals("53")) {
            str = "5L1";
        }
        else if(str.equals("54")) {
            str = "5L3";
        }
        else if(str.equals("55")) {
            str = "5LA";
        }
        else if(str.equals("56")) {
            str = "5LC";
        }
        else if(str.equals("57")) {
            str = "5LD";
        }
        else if(str.equals("58")) {
            str = "5LE";
        }
        else if(str.equals("59")) {
            str = "5LF";
        }
        else if(str.equals("60")) {
            str = "5LG";
        }
        else if(str.equals("61")) {
            str = "5LH";
        }
        else if(str.equals("62")) {
            str = "5LQ";
        }
        else if(str.equals("63")) {
            str = "5M1";
        }
        else if(str.equals("64")) {
            str = "5M2";
        }
        else if(str.equals("65")) {
            str = "5M3";
        }
        else if(str.equals("66")) {
            str = "5M6";
        }
        else if(str.equals("67")) {
            str = "5M7";
        }
        else if(str.equals("68")) {
            str = "5M8";
        }
        else if(str.equals("69")) {
            str = "5MD";
        }
        else if(str.equals("70")) {
            str = "5MK";
        }
        else if(str.equals("71")) {
            str = "5MV";
        }
        else if(str.equals("72")) {
            str = "5MX";
        }
        else if(str.equals("73")) {
            str = "5N1";
        }
        else if(str.equals("74")) {
            str = "5N2";
        }
        else if(str.equals("75")) {
            str = "5N3";
        }
        else if(str.equals("76")) {
            str = "5N4";
        }
        else if(str.equals("77")) {
            str = "5N5";
        }
        else if(str.equals("78")) {
            str = "5N6";
        }
        else if(str.equals("79")) {
            str = "5N7";
        }
        else if(str.equals("80")) {
            str = "5N8";
        }
        else if(str.equals("81")) {
            str = "5N9";
        }
        else if(str.equals("82")) {
            str = "5NA";
        }
        else if(str.equals("83")) {
            str = "5NC";
        }
        else if(str.equals("84")) {
            str = "5ND";
        }
        else if(str.equals("85")) {
            str = "5NE";
        }
        else if(str.equals("86")) {
            str = "5NF";
        }
        else if(str.equals("87")) {
            str = "5NG";
        }
        else if(str.equals("88")) {
            str = "5NH";
        }
        else if(str.equals("89")) {
            str = "5NJ";
        }
        else if(str.equals("90")) {
            str = "5NK";
        }
        else if(str.equals("91")) {
            str = "5NL";
        }
        else if(str.equals("92")) {
            str = "5NM";
        }
        else if(str.equals("93")) {
            str = "5NN";
        }
        else if(str.equals("94")) {
            str = "5NP";
        }
        else if(str.equals("95")) {
            str = "5NQ";
        }
        else if(str.equals("96")) {
            str = "5NR";
        }
        else if(str.equals("97")) {
            str = "5NT";
        }
        else if(str.equals("98")) {
            str = "5NV";
        }
        else if(str.equals("99")) {
            str = "5NW";
        }
        else if(str.equals("100")) {
            str = "5NX";
        }
        else if(str.equals("101")) {
            str = "5NY";
        }
        else if(str.equals("102")) {
            str = "5P1";
        }
        else if(str.equals("103")) {
            str = "5P2";
        }
        else if(str.equals("104")) {
            str = "5P5";
        }
        else if(str.equals("105")) {
            str = "5P6";
        }
        else if(str.equals("106")) {
            str = "5P7";
        }
        else if(str.equals("107")) {
            str = "5P8";
        }
        else if(str.equals("108")) {
            str = "5P9";
        }
        else if(str.equals("109")) {
            str = "5PA";
        }
        else if(str.equals("110")) {
            str = "5PC";
        }
        else if(str.equals("111")) {
            str = "5PD";
        }
        else if(str.equals("112")) {
            str = "5PE";
        }
        else if(str.equals("113")) {
            str = "5PF";
        }
        else if(str.equals("114")) {
            str = "5PG";
        }
        else if(str.equals("115")) {
            str = "5PH";
        }
        else if(str.equals("116")) {
            str = "5PJ";
        }
        else if(str.equals("117")) {
            str = "5PK";
        }
        else if(str.equals("118")) {
            str = "5PL";
        }
        else if(str.equals("119")) {
            str = "5PM";
        }
        else if(str.equals("120")) {
            str = "5PN";
        }
        else if(str.equals("121")) {
            str = "5PP";
        }
        else if(str.equals("122")) {
            str = "5PQ";
        }
        else if(str.equals("123")) {
            str = "5PR";
        }
        else if(str.equals("124")) {
            str = "5PT";
        }
        else if(str.equals("125")) {
            str = "5PV";
        }
        else if(str.equals("126")) {
            str = "5PW";
        }
        else if(str.equals("127")) {
            str = "5PX";
        }
        else if(str.equals("128")) {
            str = "5PY";
        }
        else if(str.equals("129")) {
            str = "5QA";
        }
        else if(str.equals("130")) {
            str = "5QC";
        }
        else if(str.equals("131")) {
            str = "5QD";
        }
        else if(str.equals("132")) {
            str = "5QE";
        }
        else if(str.equals("133")) {
            str = "5QF";
        }
        else if(str.equals("134")) {
            str = "5QG";
        }
        else if(str.equals("135")) {
            str = "5QH";
        }
        else if(str.equals("136")) {
            str = "5QJ";
        }
        else if(str.equals("137")) {
            str = "5QK";
        }
        else if(str.equals("138")) {
            str = "5QL";
        }
        else if(str.equals("139")) {
            str = "5QM";
        }
        else if(str.equals("140")) {
            str = "5QN";
        }
        else if(str.equals("141")) {
            str = "5QP";
        }
        else if(str.equals("142")) {
            str = "5QQ";
        }
        else if(str.equals("143")) {
            str = "5QR";
        }
        else if(str.equals("144")) {
            str = "5QT";
        }
        else if(str.equals("145")) {
            str = "5QV";
        }
        else if(str.equals("146")) {
            str = "TAC";
        }
        else if(str.equals("147")) {
            str = "TAK";
        }
        else if(str.equals("148")) {
            str = "TAL";
        }
        else if(str.equals("149")) {
            str = "TAM";
        }
        else if(str.equals("150")) {
            str = "TAN";
        }
        else if(str.equals("151")) {
            str = "TAP";
        }

        return str;
    }

    private String getCipher(String str) {

        if(str.equals("5JE")) {
            str = "BAA";
        }
        else if(str.equals("5GC")) {
            str = "BD";
        }
        else if(str.equals("5P2")) {
            str = "BD";
        }
        else if(str.equals("5QF")) {
            str = "BE";
        }
        else if(str.equals("5QG")) {
            str = "BE";
        }
        else if(str.equals("5NK")) {
            str = "BIK";
        }
        else if(str.equals("5M1")) {
            str = "BIR";
        }
        else if(str.equals("5MX")) {
            str = "BIR";
        }
        else if(str.equals("5PG")) {
            str = "BIR";
        }
        else if(str.equals("5NY")) {
            str = "BRA";
        }
        else if(str.equals("5A3")) {
            str = "BRS";
        }
        else if(str.equals("5FL")) {
            str = "BRS";
        }
        else if(str.equals("5M8")) {
            str = "BRS";
        }
        else if(str.equals("5QJ")) {
            str = "BRS";
        }
        else if(str.equals("5CQ")) {
            str = "BU";
        }
        else if(str.equals("5QD")) {
            str = "BU";
        }
        else if(str.equals("5PN")) {
            str = "CB";
        }
        else if(str.equals("5PP")) {
            str = "CB";
        }
        else if(str.equals("5J2")) {
            str = "CH";
        }
        else if(str.equals("5NN")) {
            str = "CH";
        }
        else if(str.equals("5NP")) {
            str = "CH";
        }
        else if(str.equals("7A1")) {
            str = "CLD";
        }
        else if(str.equals("7A7")) {
            str = "CLD";
        }
        else if(str.equals("5MD")) {
            str = "COV";
        }
        else if(str.equals("5QP")) {
            str = "CR";
        }
        else if(str.equals("5NE")) {
            str = "CU";
        }
        else if(str.equals("5N5")) {
            str = "DCR";
        }
        else if(str.equals("5N6")) {
            str = "DE";
        }
        else if(str.equals("5N7")) {
            str = "DE";
        }
        else if(str.equals("5F1")) {
            str = "DN";
        }
        else if(str.equals("5QQ")) {
            str = "DN";
        }
        else if(str.equals("TAL")) {
            str = "DN";
        }
        else if(str.equals("5QM")) {
            str = "DO";
        }
        else if(str.equals("5QN")) {
            str = "DO";
        }
        else if(str.equals("5J9")) {
            str = "DR";
        }
        else if(str.equals("5ND")) {
            str = "DR";
        }
        else if(str.equals("5PE")) {
            str = "DUD";
        }
        else if(str.equals("7A2")) {
            str = "DYF";
        }
        else if(str.equals("5P1")) {
            str = "EX";
        }
        else if(str.equals("5PV")) {
            str = "EX";
        }
        else if(str.equals("5PW")) {
            str = "EX";
        }
        else if(str.equals("5PX")) {
            str = "EX";
        }
        else if(str.equals("5PY")) {
            str = "EX";
        }
        else if(str.equals("5KF")) {
            str = "GAT";
        }
        else if(str.equals("5KG")) {
            str = "GAT";
        }
        else if(str.equals("5QH")) {
            str = "GG";
        }
        else if(str.equals("5J5")) {
            str = "GMK";
        }
        else if(str.equals("5LH")) {
            str = "GMK";
        }
        else if(str.equals("7A6")) {
            str = "GWE";
        }
        else if(str.equals("5QV")) {
            str = "HT";
        }
        else if(str.equals("5L3")) {
            str = "KC";
        }
        else if(str.equals("5P9")) {
            str = "KC";
        }
        else if(str.equals("5QA")) {
            str = "KC";
        }
        else if(str.equals("5EF")) {
            str = "KHU";
        }
        else if(str.equals("5NW")) {
            str = "KHU";
        }
        else if(str.equals("5NX")) {
            str = "KHU";
        }
        else if(str.equals("TAN")) {
            str = "KHU";
        }
        else if(str.equals("5HP")) {
            str = "LA";
        }
        else if(str.equals("5NF")) {
            str = "LA";
        }
        else if(str.equals("5NG")) {
            str = "LA";
        }
        else if(str.equals("5NH")) {
            str = "LA";
        }
        else if(str.equals("5NS")) {
            str = "LA";
        }
        else if(str.equals("TAP")) {
            str = "LA";
        }
        else if(str.equals("5PA")) {
            str = "LD";
        }
        else if(str.equals("5PC")) {
            str = "LD";
        }
        else if(str.equals("5N1")) {
            str = "LDS";
        }
        else if(str.equals("5NL")) {
            str = "LIP";
        }
        else if(str.equals("5AN")) {
            str = "LL";
        }
        else if(str.equals("5N9")) {
            str = "LL";
        }
        else if(str.equals("5C3")) {
            str = "LNA";
        }
        else if(str.equals("5C4")) {
            str = "LNA";
        }
        else if(str.equals("5C5")) {
            str = "LNA";
        }
        else if(str.equals("5NA")) {
            str = "LNB";
        }
        else if(str.equals("5NC")) {
            str = "LNB";
        }
        else if(str.equals("5A4")) {
            str = "LNC";
        }
        else if(str.equals("5C2")) {
            str = "LNC";
        }
        else if(str.equals("5K7")) {
            str = "LND";
        }
        else if(str.equals("5K8")) {
            str = "LND";
        }
        else if(str.equals("5C1")) {
            str = "LNE";
        }
        else if(str.equals("5C9")) {
            str = "LNE";
        }
        else if(str.equals("5A9")) {
            str = "LNH";
        }
        else if(str.equals("5LA")) {
            str = "LNJ";
        }
        else if(str.equals("5LC")) {
            str = "LNJ";
        }
        else if(str.equals("5AT")) {
            str = "LNK";
        }
        else if(str.equals("5K5")) {
            str = "LNL";
        }
        else if(str.equals("5K6")) {
            str = "LNL";
        }
        else if(str.equals("5H1")) {
            str = "LNM";
        }
        else if(str.equals("5HX")) {
            str = "LNM";
        }
        else if(str.equals("5HY")) {
            str = "LNM";
        }
        else if(str.equals("5A5")) {
            str = "LNN";
        }
        else if(str.equals("5M6")) {
            str = "LNN";
        }
        else if(str.equals("5LG")) {
            str = "LNP";
        }
        else if(str.equals("5M7")) {
            str = "LNP";
        }
        else if(str.equals("5K9")) {
            str = "LNR";
        }
        else if(str.equals("5LD")) {
            str = "LNS";
        }
        else if(str.equals("5LE")) {
            str = "LNS";
        }
        else if(str.equals("5LF")) {
            str = "LNS";
        }
        else if(str.equals("5A7")) {
            str = "LNT";
        }
        else if(str.equals("5A8")) {
            str = "LNW";
        }
        else if(str.equals("TAK")) {
            str = "LNW";
        }
        else if(str.equals("5NT")) {
            str = "MAN";
        }
        else if(str.equals("5D9")) {
            str = "MID";
        }
        else if(str.equals("5E1")) {
            str = "MID";
        }
        else if(str.equals("5KM")) {
            str = "MID";
        }
        else if(str.equals("5QR")) {
            str = "MID";
        }
        else if(str.equals("5D7")) {
            str = "NEW";
        }
        else if(str.equals("5D8")) {
            str = "NEW";
        }
        else if(str.equals("5PQ")) {
            str = "NF";
        }
        else if(str.equals("5PR")) {
            str = "NF";
        }
        else if(str.equals("5EM")) {
            str = "NN";
        }
        else if(str.equals("5ET")) {
            str = "NN";
        }
        else if(str.equals("5N8")) {
            str = "NN";
        }
        else if(str.equals("5PD")) {
            str = "NO";
        }
        else if(str.equals("TAC")) {
            str = "NR";
        }
        else if(str.equals("5QE")) {
            str = "OX";
        }
        else if(str.equals("5JX")) {
            str = "ROC";
        }
        else if(str.equals("5NQ")) {
            str = "ROC";
        }
        else if(str.equals("5H8")) {
            str = "ROT";
        }
        else if(str.equals("5M2")) {
            str = "SA";
        }
        else if(str.equals("5MK")) {
            str = "SA";
        }
        else if(str.equals("7A4")) {
            str = "SGA";
        }
        else if(str.equals("7A5")) {
            str = "SGA";
        }
        else if(str.equals("5N4")) {
            str = "SHE";
        }
        else if(str.equals("5F5")) {
            str = "SLF";
        }
        else if(str.equals("5NR")) {
            str = "SLF";
        }
        else if(str.equals("5QL")) {
            str = "SM";
        }
        else if(str.equals("5FE")) {
            str = "SO";
        }
        else if(str.equals("5L1")) {
            str = "SO";
        }
        else if(str.equals("5QC")) {
            str = "SO";
        }
        else if(str.equals("5QT")) {
            str = "SO";
        }
        else if(str.equals("5NJ")) {
            str = "SOP";
        }
        else if(str.equals("5F7")) {
            str = "SPT";
        }
        else if(str.equals("5PH")) {
            str = "ST";
        }
        else if(str.equals("5PJ")) {
            str = "ST";
        }
        else if(str.equals("5PK")) {
            str = "ST";
        }
        else if(str.equals("5J4")) {
            str = "STL";
        }
        else if(str.equals("5NM")) {
            str = "STL";
        }
        else if(str.equals("5PT")) {
            str = "SU";
        }
        else if(str.equals("5KL")) {
            str = "SUN";
        }
        else if(str.equals("5P5")) {
            str = "SY";
        }
        else if(str.equals("5LQ")) {
            str = "TE";
        }
        else if(str.equals("5P7")) {
            str = "TE";
        }
        else if(str.equals("5P8")) {
            str = "TE";
        }
        else if(str.equals("5P6")) {
            str = "TW";
        }
        else if(str.equals("5PM")) {
            str = "WA";
        }
        else if(str.equals("5N3")) {
            str = "WAK";
        }
        else if(str.equals("5M3")) {
            str = "WAL";
        }
        else if(str.equals("5PF")) {
            str = "WBH";
        }
        else if(str.equals("7A3")) {
            str = "WGA";
        }
        else if(str.equals("5HG")) {
            str = "WIG";
        }
        else if(str.equals("5HQ")) {
            str = "WIG";
        }
        else if(str.equals("5K3")) {
            str = "WL";
        }
        else if(str.equals("5QK")) {
            str = "WL";
        }
        else if(str.equals("5QW")) {
            str = "WMF";
        }
        else if(str.equals("TAM")) {
            str = "WMF";
        }
        else if(str.equals("5MV")) {
            str = "WOM";
        }
        else if(str.equals("5CN")) {
            str = "WR";
        }
        else if(str.equals("5PL")) {
            str = "WR";
        }
        else if(str.equals("5NV")) {
            str = "YN";
        }
        else if(str.equals("5J6")) {
            str = "YW";
        }
        else if(str.equals("5N2")) {
            str = "YW";
        }

        return str;
    }

}
