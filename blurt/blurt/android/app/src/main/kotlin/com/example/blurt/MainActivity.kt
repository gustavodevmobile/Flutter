package com.example.blurt
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.blurt/intent"
    var abrirDashboard = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.blurt/intent")
        .setMethodCallHandler { call, result ->
            // Handler do Flutter para chamadas nativas (opcional)
        }

        if (abrirDashboard) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.blurt/intent")
            .invokeMethod("abrir_dashboard", null)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        abrirDashboard = intent.getBooleanExtra("abrir_dashboard", false)
    }
}
