package main.java.org.dadabhagwan.sadhana;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.provider.Settings;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.ViewDestroyListener;

import android.content.Context;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.ViewDestroyListener;
import io.flutter.view.FlutterNativeView;
import org.json.JSONArray;
import org.json.JSONException;

public class SadhanaPlugin  implements MethodCallHandler {
    private static final String TAG = SadhanaPlugin.class.getSimpleName();
    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        Log.i(TAG + "registerWith:" + registrar);
        final MethodChannel backgroundChannel = new MethodChannel(registrar.messenger(), "org.dadabhagwan.sadhana/background", JSONMethodCodec.INSTANCE);
        SadhanaPlugin plugin = new SadhanaPlugin(registrar.context());
        backgroundChannel.setMethodCallHandler(plugin);
        org.dadabhagwan.sadhana.NetworkSchedulerService.setBackgroundChannel(backgroundChannel);
    }
    private SadhanaPlugin(Context context) {

    }
    @Override
    public void onMethodCall(MethodCall call, Result result) {

    }

}
