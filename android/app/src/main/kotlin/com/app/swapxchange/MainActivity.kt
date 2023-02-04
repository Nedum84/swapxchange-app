package com.app.swapxchange

import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.Window
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity


class MainActivity: FlutterActivity() {

//    fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        //https://github.com/flutter/flutter/issues/64001
//        val window: Window = getWindow()
//        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
//            window.statusBarColor = 0x00000000
//        }
//        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.HONEYCOMB) {
//            window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
//        }
//
//        configureStatusBarForFullscreenFlutterExperience()
//    }
//
//    private fun configureStatusBarForFullscreenFlutterExperience() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            val window: Window = getWindow()
//            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
//            window.statusBarColor = 0x40000000
//            window.decorView.systemUiVisibility = PlatformPlugin.DEFAULT_SYSTEM_UI
//        }
//    }
}