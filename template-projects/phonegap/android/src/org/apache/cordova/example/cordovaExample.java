package org.apache.cordova.example;

import org.apache.cordova.DroidGap;

import android.os.Bundle;

public class cordovaExample extends DroidGap {

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        super.loadUrl("file:///android_asset/www/index.html");
    }

}
