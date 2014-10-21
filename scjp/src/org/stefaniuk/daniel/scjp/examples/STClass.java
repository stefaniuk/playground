package org.stefaniuk.daniel.scjp.examples;

public class STClass{

    static int i=0;

    public static int getRef(){
         return i++;
    }

    public static class Tash{
         static int p=0;
         public static int getRef(){
              return i+p++;
         }
    }

    public static void main(String... argv){
         int a1=new STClass().getRef();
         int a2=new STClass().getRef();
         //int a3=new STClass().new Tash().getRef(); // runtime exception !!!
         //int a4=new STClass().new Tash().getRef(); // cannot be instantiated through an instance of the outer class
         int a3= new STClass.Tash().getRef();
         int a4= new STClass.Tash().getRef();
         System.out.print(a1+":"+a2+":"+a3+":"+a4);
    }

}