<?php

final class Code4ge_CMF_Version
{

	const MAJOR = 0;

	const MINOR = 0;

	const REVISION = 0;

	const FLAG = 'dev';

	public static function getMajor()
	{
		return self::MAJOR;
	}

	public static function getMinor()
	{
		return self::MINOR;
	}

	public static function getRevision()
	{
		return self::REVISION;
	}

	public static function getFlag()
	{
		return self::FLAG;
	}

	public static function getVerion()
	{
		return self::MAJOR . '.' . self::MINOR . '.' . self::REVISION . '.' . self::FLAG;
	}

}
