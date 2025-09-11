// import Flutter
// import UIKit
// import FirebaseCore
// import GoogleMaps
// import flutter_local_notifications

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     GMSServices.provideAPIKey("AIzaSyDKZHjGSluLqRpdpgrqrghIlAIi2kZ9FAs")
//     FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
//         GeneratedPluginRegistrant.register(with: registry)
//     }
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import GoogleMaps
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase
    FirebaseApp.configure()

    // Configure Google Maps
    GMSServices.provideAPIKey("AIzaSyDKZHjGSluLqRpdpgrqrghIlAIi2kZ9FAs")

    // Configure local notifications
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    // Register plugins
    GeneratedPluginRegistrant.register(with: self)

    // Register for remote notifications
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Forward APNs token to Firebase
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
