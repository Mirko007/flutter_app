package com.example.flutterapp;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      NotificationChannel notificationChannel = new NotificationChannel("Polleo", "Polleo", NotificationManager.IMPORTANCE_MAX);
      notificationChannel.setShowBadge(true);
      notificationChannel.setDescription("Notifications");
      notificationChannel.enableVibration(true);
      notificationChannel.enableLights(true);
      //notificationChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
      NotificationManager manager = getSystemService(NotificationManager.class);
      manager.createNotificationChannel(notificationChannel);
    }
    GeneratedPluginRegistrant.registerWith(this);
  }
}
