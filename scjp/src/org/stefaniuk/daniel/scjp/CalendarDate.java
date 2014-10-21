package org.stefaniuk.daniel.scjp;

import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class CalendarDate {
	public static void main(String[] args) {
		Calendar c = Calendar.getInstance();
		c = Calendar.getInstance(Locale.getDefault());
		c = Calendar.getInstance(new Locale("ES"));
		Date d = c.getTime();
		System.out.println(d);
	}
}
