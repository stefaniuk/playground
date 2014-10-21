package org.stefaniuk.daniel.scjp.examples;

public class Test1{
    private String runNow() { // this is PRIVATE method !!!
         return "High";
    }
    static class B extends Test1{
         public String runNow(){ // it is not overridden method !!!
              return "Low";
         }
    }
    public static void main(String args[]){
         Test1[] a=new B[]{new B(),new C()};
         for(Test1 aa:a)
              System.out.print(aa.runNow()+" ");
    }

}
class C extends Test1.B{
    public String runNow() { // it is not overridden method !!!
         return "Out";
    }

}