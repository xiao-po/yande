package com.example.yande;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.github.skyhacker2.sqliteonweb.SQLiteOnWeb;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    SQLiteOnWeb.init(this).start();
    GeneratedPluginRegistrant.registerWith(this);
  }
}
