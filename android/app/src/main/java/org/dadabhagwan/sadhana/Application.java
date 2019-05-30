package org.dadabhagwan.sadhana;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.androidalarmmanager.AlarmService;
import main.java.org.dadabhagwan.sadhana.SadhanaPlugin;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
  private static final String TAG = Application.class.getSimpleName();
  @Override
  public void onCreate() {
    Log.i(TAG, "onCreated Application");
    super.onCreate();
    AlarmService.setPluginRegistrant(this);
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    GeneratedPluginRegistrant.registerWith(registry);
    Log.i(TAG, "registerWith" + registry);
    SadhanaPlugin.registerWith(registry.registrarFor("org.dadabhagwan.sadhana"));
  }
}
