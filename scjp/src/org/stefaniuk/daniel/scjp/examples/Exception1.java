package org.stefaniuk.daniel.scjp.examples;

import java.io.IOException;

class SubClassExceptionList extends RuntimeException{} // compiles !!! as this is unchecked exception
//class SubClassExceptionList extends Exception{} // will NOT compile, compiles if Exception1.row throws Exception

public class Exception1 {
     public void row() /*throws Exception*/ {
          System.out.print("Row Data");
     }
     public static class B extends Exception1 {
          public void row() throws SubClassExceptionList{
               System.out.print("Information");
          }
     }
     public static void main(String args[]){
    	 Exception1 ab=new B(); ab.row();

    	 try {	 
    	 }
    	 catch (Exception e) {
    	 }
    	 // following will NOT compile
    	 /*try {	 
    	 }
    	 catch (IOException e) {
    	 }*/
     }
}