package com.code4ge.jsf.geo;

import java.awt.geom.AffineTransform;
import java.awt.geom.Point2D;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
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

public class Wales {

    private static ObjectMapper mapper = new ObjectMapper();

    private SimpleFeatureSource sfs;

    private SimpleFeatureCollection sfc;

    private ResourceInfo ri;

    private ReferencedEnvelope re;

    private AffineTransform translate;

    private AffineTransform scale;
    
    private AffineTransform scaleFix;

    private int size = 1000;

    private int delta = 5;
    
    private int dx = -135;
    
    private int dy = 0;
    
    public static void main(String[] args) throws Exception {

        (new Wales()).run();
    }

    public Wales() throws IOException {

        File file = new File("d:/projects/geo/downloads/bdline/data/district_borough_unitary_region.shp");
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
        scaleFix = AffineTransform.getScaleInstance(1.1345d, 1.8626d);
        
        /*FileInputStream fis = new FileInputStream("c:/pos.txt");
        DataInputStream in = new DataInputStream(fis);
        BufferedReader br = new BufferedReader(new InputStreamReader(in));
        for(int i=0; i < 2; i++) {
            if(i==0) {
                dx = Integer.parseInt(br.readLine());
            }
            if(i==1) {
                dy = Integer.parseInt(br.readLine());
            }
        }*/
        System.out.println("dx: " + dx + ", dy: " + dy);
        //in.close();
        
    }

    public void run() throws IOException {


        // System.out.println("Name: " + ri.getName());
        // System.out.println("Title: " + ri.getTitle());
        // System.out.println("Desceiption: " + ri.getDescription());
        // System.out.println(re.getMinX() + ", " + re.getMinY() + ", " +
        // re.getMaxX() + ", " + re.getMaxY());

        final ArrayList<String> featureNames = new ArrayList<String>();
        final HashMap<String, ArrayList<ArrayList<Integer>>> shapes = new HashMap<String, ArrayList<ArrayList<Integer>>>();
        final HashMap<String, ArrayList<Integer>> centers = new HashMap<String, ArrayList<Integer>>();
        final HashMap<String, ArrayList<Integer>> bboxes = new HashMap<String, ArrayList<Integer>>();

        FeatureVisitor visitor = new FeatureVisitor() {

            public void visit(Feature feature) {

                String name = feature.getIdentifier().getID();               
                if(!isWales(name)) {
                    return;
                }
                
                featureNames.add((String) name);
                Geometry geom = (Geometry) feature.getDefaultGeometryProperty().getValue();

                int x = -1;
                int y = -1;
                int x_min = 0xFFFF;
                int y_min = 0xFFFF;
                int x_max = 0;
                int y_max = 0;

                ArrayList<ArrayList<Integer>> featureShapes = new ArrayList<ArrayList<Integer>>();
                ArrayList<Integer> shape = new ArrayList<Integer>();
                Coordinate[] cs = geom.getCoordinates();
                //System.out.println(feature.getIdentifier() + " -> coordinate number: " + cs.length);
                for(Coordinate c: cs) {
                    Point2D p = transform2(new Point2D.Double(c.x, c.y));

                    if(x == (int) p.getX() && y == (int) p.getY()) {
                        continue;
                    }

                    int cur_x = x;
                    int cur_y = y;
                    x = (int) p.getX();
                    y = (int) p.getY();

                    if(x < x_min)
                        x_min = x;
                    if(y < y_min)
                        y_min = y;
                    if(x > x_max)
                        x_max = x;
                    if(y > y_max)
                        y_max = y;

                    int delta = 5;
                    if((Math.abs(cur_x - x) > delta && Math.abs(cur_y - y) > delta && cur_x > -1 && cur_y > -1)
                            || (Math.abs(cur_x - x) > 2*delta && cur_x > -1)
                            || (Math.abs(cur_y - y) > 2*delta && cur_y > -1)
                            ) {
                        featureShapes.add(shape);
                        shape = new ArrayList<Integer>();
                        //System.out.println(" --- change of shape: (" + cur_x + "," + cur_y + ") -> (" + x + "," + y + ")");
                    }

                    shape.add((int) p.getX());
                    shape.add((int) p.getY());
                    // System.out.println(c.x + "," + c.y + " -> " + p.getX() +
                    // "," + p.getY());
                }
                featureShapes.add(shape);
                shapes.put(name, featureShapes);

                int center_x = (x_max - x_min) / 2 + x_min;
                int center_y = (y_max - y_min) / 2 + y_min;

                ArrayList<Integer> cl = new ArrayList<Integer>();
                cl.add(center_x);
                cl.add(center_y);
                centers.put(name, cl);

                ArrayList<Integer> bbl = new ArrayList<Integer>();
                bbl.add(x_min);
                bbl.add(y_min);
                bbl.add(x_max - x_min);
                bbl.add(y_max - y_min);
                bboxes.put(name, bbl);

                /*
                 * if (geom != null && !geom.isValid()) {
                 * System.out.println(" * Invalid geoemtry: " +
                 * feature.getIdentifier()); } else {
                 * System.out.println("Valid geoemtry: " +
                 * feature.getIdentifier()); }
                 */
            }
        };

        // final ProgressWindow progress = new ProgressWindow(null);
        // progress.setTitle("Validating feature geometry");
        sfc.accepts(visitor, null);

        ObjectNode result = mapper.createObjectNode();
        ArrayList<Double> layerExtent = new ArrayList<Double>();
        layerExtent.add(transform(new Point2D.Double(re.getMinX(), re.getMinY())).getX());
        layerExtent.add(transform(new Point2D.Double(re.getMinX(), re.getMinY())).getY());
        layerExtent.add(transform(new Point2D.Double(re.getMaxX(), re.getMaxY())).getX());
        layerExtent.add(transform(new Point2D.Double(re.getMaxX(), re.getMaxY())).getY());
        result.put("layerExtent", toJson((List<?>) layerExtent));
        result.put("featureNames", toJson((List<String>) featureNames));
        // features
        
        ObjectNode features = mapper.createObjectNode();
        for(String featureName: featureNames) {
            ObjectNode fnNode = mapper.createObjectNode();
            features.put(featureName, fnNode);
            ArrayList<ArrayList<Integer>> out_outer = new ArrayList<ArrayList<Integer>>(); 
            ArrayList<ArrayList<Integer>> tmp = shapes.get(featureName);
            for(ArrayList<Integer> arr: tmp) {
                ArrayList<Integer> out_inner = new ArrayList<Integer>();
                if(arr.size() > 10) {
                    for(int i=0; i<arr.size(); i++) {
                        int r = i%10;
                        if((i <= 1 || i >= arr.size()-2) || ((r==0 || r==1) /*|| (r==4 || r==5) || (r==8 || r==9)*/)) {
                            out_inner.add(arr.get(i));
                        }
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

        PrintWriter out = new PrintWriter("d:/projects/code4ge-jsf/source/code4ge/tests/geo/resources/united_kingdom_all.json");
        out.println(result.toString());
        out.close();

        //System.out.println(" --- ");
        //System.out.println(result);
        //System.out.println(" --- ");
    }

    private Point2D transform(Point2D point) {

        point = translate.transform(point, null);
        point = scale.transform(point, null);

        return point;
    }

    private Point2D transform2(Point2D point) {

        point = translate.transform(point, null);
        point = scale.transform(point, null);
        point = scaleFix.transform(point, null);

        return new Point2D.Double((double) point.getX() + dx, (double) size - point.getY() + dy);
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

    private boolean isWales(String str) {
        
        if(str.contains("355")) return true;
        if(str.contains("293")) return true;
        if(str.contains("327")) return true;
        if(str.contains("329")) return true;
        if(str.contains("349")) return true;
        if(str.contains("356")) return true;
        if(str.contains("358")) return true;
        if(str.contains("319")) return true;
        if(str.contains("360")) return true;
        if(str.contains("328")) return true;
        if(str.contains("268")) return true;
        if(str.contains("280")) return true;
        if(str.contains("316")) return true;
        if(str.contains("323")) return true;
        if(str.contains("277")) return true;
        if(str.contains("309")) return true;
        if(str.contains("278")) return true;
        if(str.contains("357")) return true;
        if(str.contains("274")) return true;
        if(str.contains("340")) return true;
        if(str.contains("279")) return true;
        if(str.contains("359")) return true;

        return false;
    }

    
}
