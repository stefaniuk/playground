<?php

class Code4ge_CMF_File_FilterIterator extends FilterIterator
{

	private $dir;

	private $pattern;

	public function __construct($dir, $pattern)
	{
		$this->dir = new DirectoryIterator($dir);
		$this->pattern = $pattern;

		parent::__construct($this->dir);
	}

	public function accept()
	{
		return preg_match($this->pattern, $this->current());
	}

}
