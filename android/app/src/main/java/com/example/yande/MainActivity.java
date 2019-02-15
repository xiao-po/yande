package com.example.yande;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.widget.Toast;
import com.example.yande.plugins.ScanImageFileBroadCastPlugin;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  // 要申请的权限
  private String[] permissions = {Manifest.permission.WRITE_EXTERNAL_STORAGE};
  private AlertDialog dialog;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    ScanImageFileBroadCastPlugin.registerWith(this.registrarFor("com.example.yande.plugins.ScanImageFileBroadCastPlugin"));


    // 版本判断。当手机系统大于 23 时，才有必要去判断权限是否获取
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {



      // 检查该权限是否已经获取
      int i = ContextCompat.checkSelfPermission(this, permissions[0]);
      // 权限是否已经 授权 GRANTED---授权  DINIED---拒绝


      if (i != PackageManager.PERMISSION_GRANTED) {
        // 如果没有授予该权限，就去提示用户请求
        Toast.makeText(this, "需要获取读写权限以正常运行", Toast.LENGTH_SHORT).show();
        startRequestPermission();
      }
    }

  }

  // 开始提交请求权限
  private void startRequestPermission() {
    ActivityCompat.requestPermissions(this, permissions, 321);
  }

  // 用户权限 申请 的回调方法
  @Override
  public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);

    if (requestCode == 321) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {
          // 判断用户是否 点击了不再提醒。(检测该权限是否还可以申请)
          boolean b = shouldShowRequestPermissionRationale(permissions[0]);
          if (!b) {
            Toast.makeText(this, "存储权限未获取成功，下载功能受限", Toast.LENGTH_SHORT).show();
          } else
            finish();
        } else {
          Toast.makeText(this, "权限获取成功", Toast.LENGTH_SHORT).show();
          super.onRestart();
        }
      }
    }
  }


  //
  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode == 123) {

      if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        // 检查该权限是否已经获取
        int i = ContextCompat.checkSelfPermission(this, permissions[0]);
        // 权限是否已经 授权 GRANTED---授权  DINIED---拒绝
        if (i != PackageManager.PERMISSION_GRANTED) {
          Toast.makeText(this, "存储权限未获取成功，下载功能受限", Toast.LENGTH_SHORT).show();
        } else {
          if (dialog != null && dialog.isShowing()) {
            dialog.dismiss();
          }
          Toast.makeText(this, "权限获取成功", Toast.LENGTH_SHORT).show();
        }
      }
    }
  }
}
