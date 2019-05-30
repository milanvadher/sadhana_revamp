package org.dadabhagwan.sadhana;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;
import android.widget.Toast;

/**
 * This class ensure the network connection changes and notify to the respective callbacks.
 * Created by jiteshmohite on 07/02/18.
 */

public class ConnectivityReceiver extends BroadcastReceiver {

    public static final String TAG = "KKKConnectivityReceiver[NetworkSchedulerService]";
    private ConnectivityReceiverListener mConnectivityReceiverListener;

    ConnectivityReceiver(ConnectivityReceiverListener listener) {
        mConnectivityReceiverListener = listener;
    }


    @Override
    public void onReceive(Context context, Intent intent) {
        Log.i(TAG, "Inside onReceive");
        //Toast.makeText(context, "Inside onReceive Connectivity change", Toast.LENGTH_SHORT).show();
        mConnectivityReceiverListener.onNetworkConnectionChanged(isConnected(context));

    }

    public static boolean isConnected(Context context) {
        ConnectivityManager cm = (ConnectivityManager)
                context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        return activeNetwork != null && activeNetwork.isConnectedOrConnecting();
    }

    public interface ConnectivityReceiverListener {
        void onNetworkConnectionChanged(boolean isConnected);
    }
}
