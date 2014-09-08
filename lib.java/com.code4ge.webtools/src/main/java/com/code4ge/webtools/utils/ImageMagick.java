package com.code4ge.webtools.utils;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.imageio.ImageIO;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.SystemUtils;

/**
 * ImageMagick API
 * 
 * @author Daniel Stefaniuk
 */
public class ImageMagick {

	/**
	 * Parameters: input file name, width, height, output file name.
	 */
	private String resize = " %1$s -resize %2$sx%3$s %4$s";

	/**
	 * Parameters: input file name, output file name.
	 */
	private String brighter = " %1$s -modulate 110,95,95 %2$s";

	/**
	 * Parameters: input file name, output file name.
	 */
	private String grayscale = " %1$s -channel RGBA -matte -colorspace gray %2$s";

	private File fin;

	private File fout;

	/**
	 * Initialise ImageMagick API. System environment variable IMAGEMAGICK_HOME must be set.
	 * 
	 * @throws ImageMagickException
	 */
	public ImageMagick() throws ImageMagickException {

		init(System.getenv("IMAGEMAGICK_HOME"));
	}

	/**
	 * Initialise ImageMagick API.
	 * 
	 * @param home
	 *            ImageMagick home directory
	 * @throws ImageMagickException
	 */
	public ImageMagick(String home) throws ImageMagickException {

		init(home);
	}

	private void init(String home) throws ImageMagickException {

		// home directory must be set
		if(home == null || home.equals("")) {
			throw new ImageMagickException("home directory must be specyfied");
		}

		// strip single and double quotas
		home = StringUtils.strip(home, "\"'");

		// get convert command path
		String convert = new File(home, (SystemUtils.IS_OS_WINDOWS ? "convert.exe" : "convert")).getAbsolutePath();

		// check if convert command exists
		if(!(new File(convert)).exists()) {
			throw new ImageMagickException("unable to find convert command " + home);
		}

		// append valid path to the defined commands
		resize = convert + resize;
		brighter = convert + brighter;
		grayscale = convert + grayscale;

		// set temporary files
		String tmpdir = System.getProperty("java.io.tmpdir");
		fin = new File(tmpdir, "input.png");
		fin.deleteOnExit();
		fout = new File(tmpdir, "output.png");
		fout.deleteOnExit();
	}

	/**
	 * Resizes an image.
	 * 
	 * @param image
	 * @param width
	 * @param height
	 * @return
	 * @throws ImageMagickException
	 */
	public BufferedImage resize(BufferedImage image, int width, int height) throws ImageMagickException {

		String cmd = String.format(resize, fin, width, height, fout);

		return convert(image, cmd);
	}

	/**
	 * Makes an image brighter.
	 * 
	 * @param image
	 * @return
	 * @throws ImageMagickException
	 */
	public BufferedImage brighter(BufferedImage image) throws ImageMagickException {

		String cmd = String.format(brighter, fin, fout);

		return convert(image, cmd);
	}

	/**
	 * Converts an image to grayscale.
	 * 
	 * @param image
	 * @return
	 * @throws ImageMagickException
	 */
	public BufferedImage grayscale(BufferedImage image) throws ImageMagickException {

		String cmd = String.format(grayscale, fin, fout);

		return convert(image, cmd);
	}

	/**
	 * Performs conversion on the given image.
	 * 
	 * @param image
	 * @param cmd
	 * @return
	 * @throws ImageMagickException
	 */
	private BufferedImage convert(BufferedImage image, String cmd) throws ImageMagickException {

		BufferedImage bi = null;

		try {
			ImageIO.write(image, "png", fin);
			Runtime.getRuntime().exec(cmd).waitFor();
			bi = getImage(fout);
		}
		catch(Exception e) {
			throw new ImageMagickException("unable to process image");
		}

		return bi;
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
