package com.code4ge.webtools.dojo;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import org.jgrapht.DirectedGraph;
import org.jgrapht.graph.DefaultDirectedGraph;
import org.jgrapht.graph.DefaultEdge;
import org.jgrapht.traverse.TopologicalOrderIterator;

import com.code4ge.json.JSONArray;
import com.code4ge.json.JSONException;
import com.code4ge.json.JSONObject;
import com.code4ge.json.JSONUtil;

/**
 * Combines a list of Dojo Toolkit build profiles into one file.
 * 
 * @author Daniel Stefaniuk
 */
public class CombineProfiles {

	private File fout;

	private JSONObject[] objs;

	public static void main(String[] args) {

		try {
			(new CombineProfiles(args)).run();
		}
		catch(Exception e) {
			e.printStackTrace(System.err);
		}
	}

	public CombineProfiles(String[] args) throws IOException, JSONException {

		fout = new File(args[0]);
		objs = new JSONObject[args.length - 1];
		for(int i = 1; i < args.length; i++) {
			objs[i - 1] = getProfile(new File(args[i]));
		}
	}

	private void run() throws IOException, JSONException {

		JSONObject profile = new JSONObject();
		if(fout.exists()) {
			profile = getProfile(fout);
		}

		for(JSONObject obj: objs) {
			profile.merge(obj);
		}

		// make sure that "dojo.js" layer is defined first in the profile
		JSONArray array = profile.getJSONArray("layers");
		int index = 0;
		boolean swap = false;
		for(Object o: array) {
			JSONObject jobj = (JSONObject) o;
			if(jobj.getString("name").equals("dojo.js")) {
				swap = true;
				break;
			}
			index++;
		}
		if(swap) {
			array.swap(0, index);
		}

		reorderLayers(profile);

		saveProfile(fout, "dependencies = " + profile.toString(4) + ";\n");
	}

	private void reorderLayers(JSONObject profile) throws JSONException {

		JSONArray array = profile.getJSONArray("layers");

		// get vertexes
		DirectedGraph<String, DefaultEdge> g = new DefaultDirectedGraph<String, DefaultEdge>(DefaultEdge.class);
		for(Object o: array) {
			JSONObject jobj = (JSONObject) o;
			g.addVertex(jobj.getString("name"));
		}

		// get edges
		for(Object o: array) {
			JSONObject jobj = (JSONObject) o;
			if(jobj.has("layerDependencies")) {
				String name = jobj.getString("name");
				for(Object dependency: jobj.getJSONArray("layerDependencies")) {
					g.addEdge((String) dependency, name);
				}
			}
		}
		
		// reorder
		JSONArray layers = new JSONArray();
		TopologicalOrderIterator<String, DefaultEdge> iterator = new TopologicalOrderIterator<String, DefaultEdge>(g);
		while(iterator.hasNext()) {
			String layerName = iterator.next();
			for(Object layer: array) {
				if(layerName.equals(((JSONObject) layer).getString("name"))) {
					layers.put(layer);
				}
			}
		}
		profile.put("layers", layers);
	}

	private JSONObject getProfile(File file) throws IOException, JSONException {

		byte[] buffer = new byte[(int) file.length()];
		BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
		bis.read(buffer);
		bis.close();

		return new JSONObject(JSONUtil.clean(new String(buffer)));
	}

	private void saveProfile(File file, String json) throws IOException, JSONException {

		BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(file));
		bos.write(json.getBytes());
		bos.close();
	}

}
