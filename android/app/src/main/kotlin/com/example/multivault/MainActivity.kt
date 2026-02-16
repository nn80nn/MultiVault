package com.example.multivault

import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.view.WindowManager
import android.view.autofill.AutofillManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SCREEN_SECURITY_CHANNEL = "com.multivault/screen_security"
    private val AUTOFILL_CHANNEL = "com.multivault/autofill"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SCREEN_SECURITY_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableSecure" -> {
                    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(true)
                }
                "disableSecure" -> {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUTOFILL_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openAutofillSettings" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val intent = Intent(Settings.ACTION_REQUEST_SET_AUTOFILL_SERVICE).apply {
                            data = android.net.Uri.parse("package:$packageName")
                        }
                        startActivity(intent)
                        result.success(true)
                    } else {
                        result.error("UNSUPPORTED", "Autofill requires Android 8.0+", null)
                    }
                }
                "isAutofillProvider" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val afm = getSystemService(AutofillManager::class.java)
                        result.success(afm?.hasEnabledAutofillServices() ?: false)
                    } else {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
