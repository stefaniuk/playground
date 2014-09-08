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


public class UnitaryAuthorities {

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

        (new UnitaryAuthorities()).run();
    }

    public UnitaryAuthorities() throws IOException {

        File file = new File("d:/temp/bdline_gb/data/district_borough_unitary_region.shp");
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
                String pctName = getShapeName1((String) feature.getIdentifier().getID());
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
                String pctName = getShapeName1((String) feature.getIdentifier().getID());
                String cipher = getShapeName2(pctName);
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
                //if(arr.size() > 10) {
                    for(int i=0; i<arr.size(); i++) {
                        int r = i%10;
                        //if((i <= 1 || i >= arr.size()-2) || ((r==0 || r==1) || (r==4 || r==5) || (r==8 || r==9))) {
                            out_inner.add(arr.get(i));
                        //}
                    }
                    
                    // make sure the shape is "closed"
                    if(out_inner.get(0) != out_inner.get(out_inner.size()-2) || out_inner.get(1) != out_inner.get(out_inner.size()-1)) {
                        out_inner.add(out_inner.get(0));
                        out_inner.add(out_inner.get(1));
                    }
                    
                    out_outer.add(out_inner);
                /*}
                else {
                    out_outer.add(arr);
                }*/
            }
            fnNode.put("shape", toJson(out_outer));
            fnNode.put("center", toJson(centers.get(featureName)));
            fnNode.put("bbox", toJson(bboxes.get(featureName)));
        }
        result.put("features", features);

        PrintWriter out = new PrintWriter("d:/projects/code4ge-jsf/source/code4ge/tests/geo/resources/unitary_authorities.json");
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

    private String getShapeName1(String str) {

        str = str.replace("district_borough_unitary_region.", "");

        // TODO

        return str;
    }

    private String getShapeName2(String str) {

        str = str.replace("district_borough_unitary_region.", "");
        
        // TODO

        return str;
    }

}
