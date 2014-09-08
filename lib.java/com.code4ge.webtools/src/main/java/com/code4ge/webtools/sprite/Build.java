package com.code4ge.webtools.sprite;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

import javax.imageio.ImageIO;

import com.code4ge.args4j.Parser;
import com.code4ge.json.JSONArray;
import com.code4ge.json.JSONException;
import com.code4ge.json.JSONObject;
import com.code4ge.webtools.utils.ImageMagick;
import com.code4ge.webtools.utils.ImageMagickException;

/**
 * Builds a sprite images.
 * 
 * @author Daniel Stefaniuk
 */
public class Build {

	public final String[] EXTENSIONS = new String[] { "png" };

	public enum Direction {
		VERTICALLY, HORIZONTALLY
	};

	private Options options;

	private Parser parser;

	private ImageMagick im;

	private String workingDir;

	/* ================================================================== */

	public static void main(String[] args) {

		try {
			(new Build(args)).run();
		}
		catch(Exception e) {
			e.printStackTrace(System.err);
		}
	}

	/* ================================================================== */

	public Build(String[] cmd) throws InstantiationException, IllegalAccessException, ImageMagickException {

		File tmpdir = (new File(System.getProperty("java.io.tmpdir")));
		// check if temporary directory is valid directory
		if(!tmpdir.isDirectory()) {
			System.setProperty("java.io.tmpdir", System.getProperty("user.dir"));
		}

		options = new Options();
		parser = new Parser(options);
		parser.parse(cmd);

		// get ImageMagic home directory
		String imageMagickDir = options.getImageMagickDir();

		im = new ImageMagick(imageMagickDir);
	}

	private void run() throws IOException, JSONException, InstantiationException, IllegalAccessException,
			InterruptedException, ImageMagickException {

		// check if configuration options should be loaded from a file or were given in the command line
		File file = new File(options.getOptionFile());
		if(file.exists()) {

			// set working directory to the configuration file's directory
			workingDir = file.getParent();

			// get an array of configuration options
			JSONObject content = getOptionFileContent(file);
			JSONArray array = (JSONArray) content.get("options");

			// process each configuration options
			for(int i = 0; i < array.length(); i++) {
				String[] cmd = convertJsonToArgs((JSONObject) array.get(i));
				// new configuration options instance has to be created
				options = new Options();
				parser = new Parser(options);
				parser.parse(cmd);
				process(options);
			}
		}
		else {
			process(options);
		}
	}

	/* ================================================================== */

	private void process(Options options) throws IOException, ImageMagickException {

		File[] files = null;

		// check if a whole directory or a file list has been given to process
		String inputDir = options.getInputDir();
		if(inputDir != null && !inputDir.isEmpty()) {
			files = getFiles(options.getInputDir());
		}
		else {
			ArrayList<File> array = new ArrayList<File>();
			for(String fileName: options.getInputFiels()) {
				array.add(new File(workingDir, fileName));
			}
			files = new File[array.size()];
			array.toArray(files);
		}

		// having a list of files produce a sprite image
		if(files != null) {
			// resize images
			ArrayList<BufferedImage> images = convert(files);
			// merge images
			BufferedImage sprite = merge(images);
			// produce PNG file
			savePng(sprite);
			// produce CSS file
			saveCss(files);
		}
	}

	private ArrayList<BufferedImage> convert(File[] files) throws IOException, ImageMagickException {

		ArrayList<BufferedImage> array = new ArrayList<BufferedImage>();

		int size = options.getResize();

		for(File file: files) {
			// resize
			BufferedImage image = im.resize(getImage(file), size, size);
			array.add(image);
			if(options.generateActionIcons()) {
				// brighter
				array.add(im.brighter(image));
				// grayscale
				array.add(im.grayscale(image));
			}
		}

		return array;
	}

	private BufferedImage merge(ArrayList<BufferedImage> images) {

		Direction direction = options.getDirection();

		// calculate sprite size
		int totalWidth = 0, totalHeight = 0;
		if(options.generateActionIcons()) {
			switch(direction) {
				case HORIZONTALLY:
					totalWidth = images.size() / 3 * options.getResize();
					totalHeight = options.getResize() * 3;
					break;
				case VERTICALLY:
					totalWidth = options.getResize() * 3;
					totalHeight = images.size() / 3 * options.getResize();
					break;
			}
		}
		else {
			switch(direction) {
				case HORIZONTALLY:
					totalWidth = images.size() * options.getResize();
					totalHeight = options.getResize();
					break;
				case VERTICALLY:
					totalWidth = options.getResize();
					totalHeight = images.size() * options.getResize();
					break;
			}
		}

		// merge images
		BufferedImage sprite = new BufferedImage(totalWidth, totalHeight, BufferedImage.TYPE_4BYTE_ABGR);
		Graphics2D g2d = sprite.createGraphics();
		int offset = 0;
		int count = 0;
		for(BufferedImage image: images) {
			switch(direction) {
				case HORIZONTALLY:
					if(options.generateActionIcons()) {
						int number = count % 3;
						if(number == 0) {
							if(count > 1) {
								offset += options.getResize();
							}
							g2d.drawImage(image, offset, 0, null);
						}
						else if(number == 1) {
							g2d.drawImage(image, offset, options.getResize(), null);
						}
						else if(number == 2) {
							g2d.drawImage(image, offset, 2 * options.getResize(), null);
						}
					}
					else {
						g2d.drawImage(image, offset, 0, null);
						offset += options.getResize();
					}
					break;
				case VERTICALLY:
					if(options.generateActionIcons()) {
						int number = count % 3;
						if(number == 0) {
							if(count > 1) {
								offset += options.getResize();
							}
							g2d.drawImage(image, 0, offset, null);
						}
						else if(number == 1) {
							g2d.drawImage(image, options.getResize(), offset, null);
						}
						else if(number == 2) {
							g2d.drawImage(image, 2 * options.getResize(), offset, null);
						}
					}
					else {
						g2d.drawImage(image, 0, offset, null);
						offset += options.getResize();
					}
					break;
			}
			count++;
		}
		g2d.dispose();

		return sprite;
	}

	private void savePng(BufferedImage image) throws IOException {

		File file = new File(workingDir, options.getOutputSprite());
		file.delete();
		ImageIO.write(image, "png", file);
	}

	private void saveCss(File[] files) throws IOException {

		int size = options.getResize();
		String cssClassPrefix = options.getCssClassPrefix();
		String cssClassPostfix = options.getCssClassPostfix();

		FileWriter fw = new FileWriter(new File(workingDir, options.getOutputCss()));
		BufferedWriter out = new BufferedWriter(fw);
		for(int i = 0; i < files.length; i++) {
			String name = getClassName(files[i].getName());
			out.write(".");
			if(cssClassPrefix != null) {
				out.write(cssClassPrefix);
			}
			out.write(name);
			if(cssClassPostfix != null) {
				out.write(cssClassPostfix);
			}
			if(i < files.length - 1) {
				out.write(",");
			}
			out.write("\n");
		}
		out.write("{\n\tbackground-image: url('" + options.getCssSpriteFile() + "');\n");
		out.write("\twidth: " + size + "px;\n");
		out.write("\theight: " + size + "px;\n}\n\n");

		out.write(getCss(files, null, 0));
		if(options.generateActionIcons()) {
			out.write("\n");
			out.write(getCss(files, "Hover", 2 * size));
			out.write("\n");
			out.write(getCss(files, "Disabled", size));
		}

		out.close();
	}

	private String getCss(File[] files, String additionalClassPostfix, int offset) {

		StringBuilder sb = new StringBuilder();

		int size = options.getResize();
		String cssClassPrefix = options.getCssClassPrefix();
		String cssClassPostfix = options.getCssClassPostfix();
		String strOffset = offset == 0 ? "0" : offset + "px";

		for(int i = 0; i < files.length; i++) {

			String name = getClassName(files[i].getName());
			sb.append(".");
			if(cssClassPrefix != null) {
				sb.append(cssClassPrefix);
			}
			sb.append(name);
			if(cssClassPostfix != null) {
				sb.append(cssClassPostfix);
			}
			if(additionalClassPostfix != null && !"".equals(additionalClassPostfix)) {
				sb.append(additionalClassPostfix);
			}
			if(options.getDirection() == Direction.HORIZONTALLY) {
				if(i == 0) {
					sb.append(" { background-position: " + (size * i) + " " + strOffset + "; }\n");
				}
				else {
					sb.append(" { background-position: -" + (size * i) + "px " + strOffset + "; }\n");
				}
			}
			else {
				if(i == 0) {
					sb.append(" { background-position: " + strOffset + " " + (size * i) + "; }\n");
				}
				else {
					sb.append(" { background-position: " + strOffset + " -" + (size * i) + "px; }\n");
				}
			}
		}

		return sb.toString();
	}

	/* ================================================================== */

	private JSONObject getOptionFileContent(File file) throws IOException, JSONException {

		byte[] buffer = new byte[(int) file.length()];
		BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
		bis.read(buffer);
		bis.close();

		String content = (new String(buffer)).trim();
		content = content.replaceFirst("^(var[\\s]*)*[a-zA-Z0-9_]*[\\s]*=[\\s]*", "");

		return new JSONObject(content);
	}

	private String[] convertJsonToArgs(JSONObject json) throws JSONException {

		StringBuilder sb = new StringBuilder();
		for(String name: JSONObject.getNames(json)) {
			String value = json.getString(name);
			if(!value.isEmpty()) {
				sb.append(" ");
				sb.append(name);
				sb.append("=");
				sb.append(json.getString(name).replaceAll("[\\[\\]]", ""));
			}
		}

		return sb.toString().trim().split(" ");
	}

	private File[] getFiles(String dir) throws IOException {

		return new File(workingDir, dir).listFiles(new FilenameFilter() {

			@Override
			public boolean accept(File dir, String name) {

				for(String extension: EXTENSIONS) {
					if(name.toLowerCase().endsWith(extension)) {
						return true;
					}
				}

				return false;
			}
		});
	}

	private String getClassName(String name) {

		String str = name.substring(0, name.lastIndexOf('.'));

		return str.toLowerCase().replace("_", "-");
	}

	/**
	 * Returns an image content from the given file.
	 * 
	 * @param file
	 * @return
	 * @throws IOException
	 */
	private BufferedImage getImage(File file) throws IOException {

		InputStream is = new FileInputStream(file);
		BufferedImage image = ImageIO.read(is);
		is.close();

		return image;
	}
}
