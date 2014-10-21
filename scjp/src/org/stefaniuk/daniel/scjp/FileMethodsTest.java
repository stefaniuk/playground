package org.stefaniuk.daniel.scjp;

import java.io.File;

public class FileMethodsTest {
	public static void main(String[] args) {
		String strDirectoy = "c:\\testDir";
		File dir= new File(strDirectoy);
		boolean success = dir.mkdir();
		if(success) {
			System.out.println("Directory: '" + strDirectoy + "' created");
		}
		if(dir.renameTo(new File("c:\\dsafa"))) { // only File as an argument
			System.out.println("renamed");
		}
	}
}
