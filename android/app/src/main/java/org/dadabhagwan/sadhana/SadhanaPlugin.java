package org.dadabhagwan.sadhana;

import android.content.Context;
import android.util.Log;

import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class SadhanaPlugin  implements MethodCallHandler {
    private static final String TAG = SadhanaPlugin.class.getSimpleName();
    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        Log.i(TAG , "registerWith:" + registrar);
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
