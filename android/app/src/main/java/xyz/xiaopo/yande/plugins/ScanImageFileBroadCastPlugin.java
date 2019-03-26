package xyz.xiaopo.yande.plugins;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ScanImageFilePlugin */
public class ScanImageFileBroadCastPlugin implements MethodCallHandler {


    private Activity mActivity;
    // 加个构造函数，入参是Activity
    private ScanImageFileBroadCastPlugin(Activity activity) {
        // 存起来
        mActivity = activity;
    }

    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "scan_image_file_broad_cast");
        channel.setMethodCallHandler(new ScanImageFileBroadCastPlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("broadcast")) {
            String path = call.argument("path");
            Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://"+ path));
            Log.d("plugins", "file://"+ path);
            this.mActivity.sendBroadcast(intent);
            result.success("Android " + Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }
}