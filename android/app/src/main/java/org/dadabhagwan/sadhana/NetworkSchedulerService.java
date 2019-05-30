package org.dadabhagwan.sadhana;

import android.app.job.JobParameters;
import android.app.job.JobService;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.util.Log;
import android.widget.Toast;
import io.flutter.plugin.common.MethodChannel;
/**
 * Service to handle callbacks from the JobScheduler. Requests scheduled with the JobScheduler
 * ultimately land on this service's "onStartJob" method.
 * @author jiteshmohite
 */

public class NetworkSchedulerService extends JobService implements
        org.dadabhagwan.sadhana.ConnectivityReceiver.ConnectivityReceiverListener {

    private static final String TAG = "KKK," + NetworkSchedulerService.class.getSimpleName();
    private static MethodChannel sBackgroundChannel;
    private org.dadabhagwan.sadhana.ConnectivityReceiver mConnectivityReceiver;
    public static void setBackgroundChannel(MethodChannel channel) {
        sBackgroundChannel = channel;
    }
    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "Service created");
        mConnectivityReceiver = new org.dadabhagwan.sadhana.ConnectivityReceiver(this);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.i(TAG, "Service destroyed");
    }

    /**
     * When the app's MainActivity is created, it starts this service. This is so that the
     * activity and this service can communicate back and forth. See "setUiCallback()"
     */
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i(TAG, "onStartCommand");
        return START_NOT_STICKY;
    }


    @Override
    public boolean onStartJob(JobParameters params) {
        Log.i(TAG, "onStartJob" + mConnectivityReceiver);
        registerReceiver(mConnectivityReceiver, new IntentFilter(Constants.CONNECTIVITY_ACTION));
        return true;
    }

    @Override
    public boolean onStopJob(JobParameters params) {
        Log.i(TAG, "onStopJob");
        unregisterReceiver(mConnectivityReceiver);
        return true;
    }

    @Override
    public void onNetworkConnectionChanged(boolean isConnected) {
        //if (!MyApplication.isInterestingActivityVisible()) {
        Log.i(TAG, "Trying to call flutterFunction");
        sBackgroundChannel.invokeMethod("flutterFunction", null);
        String message = isConnected ? "Good!KKK Sadhana Connected to Internet" : "Sorry!KKK Sadhana Not connected to internet";
        Toast.makeText(getApplicationContext(), message + " Service", Toast.LENGTH_LONG).show();
        //}

    }
}
