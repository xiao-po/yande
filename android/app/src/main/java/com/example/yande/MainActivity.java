package com.example.yande;

import android.os.Bundle;
import com.example.yande.plugins.ScanImageFileBroadCastPlugin;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    ScanImageFileBroadCastPlugin.registerWith(this.registrarFor("com.example.yande.plugins.ScanImageFileBroadCastPlugin"));
  }
}
