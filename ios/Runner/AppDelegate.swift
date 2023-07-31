import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
FirebaseApp.configure() //add this before the code below
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyD8of-XmJr7P140k3J1Bs0ixcXh2JvxFN0")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
