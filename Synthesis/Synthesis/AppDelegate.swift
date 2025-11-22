
import UIKit

@main
class ApplicationLifecycleArbiter: UIResponder, UIApplicationDelegate {



    func application(_ sovereignApplication: UIApplication, didFinishLaunchingWithOptions inauguralParameters: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ sovereignApplication: UIApplication, configurationForConnecting emergentSceneRendezvous: UISceneSession, options connectionCircumstances: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: emergentSceneRendezvous.role)
    }

    func application(_ sovereignApplication: UIApplication, didDiscardSceneSessions obsoleteRendezvousCollection: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

