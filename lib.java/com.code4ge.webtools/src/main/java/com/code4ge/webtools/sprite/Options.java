package com.code4ge.webtools.sprite;

import com.code4ge.args4j.annotations.Option;
import com.code4ge.webtools.sprite.Build.Direction;

/**
 * Sprite images configuration options.
 * 
 * @author Daniel Stefaniuk
 */
public class Options {

	/** ImageMagick installation directory. */
	@Option(name = "--image-magick-dir")
	private String imageMagickDir;

	/** File name with predefined configuration options in JSON format. */
	@Option(name = "--option-file")
	private String optionFile;

	/** List of images to process. */
	@Option(name = "--input-files", aliases = { "inputFiles" })
	private String[] inputFiles;

	/** Input directory where all images to process are located. */
	@Option(name = "--input-dir", aliases = { "inputDir" })
	private String inputDir;

	/** Name of an output sprite file. */
	@Option(name = "--output-sprite", aliases = { "outputSprite" })
	private String outputSprite;

	/** Name of an output CSS file. */
	@Option(name = "--output-css", aliases = { "outputCss" })
	private String outputCss;

	/** Size to which any image will be resized. */
	@Option(name = "--resize", aliases = { "resize" })
	private int resize;

	/** If true additional images will be generated, i.e. grayed out, lightened. */
	@Option(name = "--action-icons", aliases = { "actionIcons" })
	private boolean actionIcons;

	/** Direction of merging images. */
	@Option(name = "--direction", aliases = { "direction" })
	private Direction direction;

	/** CSS class prefix. */
	@Option(name = "--css-class-prefix", aliases = { "cssClassPrefix" })
	private String cssClassPrefix;

	/** CSS class postfix. */
	@Option(name = "--css-class-postfix", aliases = { "cssClassPostfix" })
	private String cssClassPostfix;

	/** Sprite file name used to define background-image in CSS file. */
	@Option(name = "--css-sprite-file", aliases = { "cssSpriteFile" })
	private String cssSpriteFile;

	/**
	 * Returns ImageMagick installation directory.
	 * 
	 * @return
	 */
	public String getImageMagickDir() {

		return imageMagickDir;
	}

	/**
	 * Returns file name with predefined configuration options in JSON format.
	 * 
	 * @return
	 */
	public String getOptionFile() {

		return optionFile;
	}

	/**
	 * Returns list of images to process.
	 * 
	 * @return
	 */
	public String[] getInputFiels() {

		return inputFiles;
	}

	/**
	 * Returns input directory where all images to process are located.
	 * 
	 * @return
	 */
	public String getInputDir() {

		return inputDir;
	}

	/**
	 * Returns name of an output sprite file.
	 * 
	 * @return
	 */
	public String getOutputSprite() {

		return outputSprite;
	}

	/**
	 * Returns name of an output CSS file.
	 * 
	 * @return
	 */
	public String getOutputCss() {

		return outputCss;
	}

	/**
	 * Returns size to which any image will be resized.
	 * 
	 * @return
	 */
	public int getResize() {

		return resize;
	}

	/**
	 * Indicates if additional images should be generated, i.e. grayed out, lightened.
	 * 
	 * @return
	 */
	public boolean generateActionIcons() {

		return actionIcons;
	}

	/**
	 * Returns direction of merging images.
	 * 
	 * @return
	 */
	public Direction getDirection() {

		return direction;
	}

	/**
	 * Returns CSS class prefix.
	 * 
	 * @return
	 */
	public String getCssClassPrefix() {

		return cssClassPrefix;
	}

	/**
	 * Returns CSS class postfix.
	 * 
	 * @return
	 */
	public String getCssClassPostfix() {

		return cssClassPostfix;
	}

	/**
	 * Returns sprite file name used to define background-image in CSS file.
	 * 
	 * @return
	 */
	public String getCssSpriteFile() {

		return cssSpriteFile;

	}

}
