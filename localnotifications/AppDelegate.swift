import UIKit
import JCNotificationBannerPresenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // Setup local notifications support
        let notificationType: UIUserNotificationType
        = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let settings = UIUserNotificationSettings(forTypes: notificationType,
                                                  categories: nil)
        application.registerUserNotificationSettings(settings)

        // Clean up and reset
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()

        NSLog("Setup one repeating notification")
        self.listNotifications()

        let n = UILocalNotification()
        n.fireDate = NSDate(timeIntervalSinceNow: 8)
        n.soundName = UILocalNotificationDefaultSoundName
        n.timeZone = NSTimeZone.defaultTimeZone()
        n.applicationIconBadgeNumber = 0
        n.userInfo = ["id": "dailyreminder"]
        n.repeatInterval = NSCalendarUnit.Day

        UIApplication.sharedApplication().scheduleLocalNotification(n)

        self.listNotifications()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication,
                     didReceiveLocalNotification notification: UILocalNotification) {

        NSLog("application(... didReceiveLocalNotification/////////////////////////")
        NSLog(notification.description)

        let state = application.applicationState
        if let userInfo = notification.userInfo,
           let id = userInfo["id"] as? String
           where id != "dailyreminder" {
            switch state {
            case UIApplicationState.Active:
                NSLog(String(format: "%@ > UIApplicationState.Active", id))
                let alertController = UIAlertController(
                        title: "Default Style",
                        message: "A standard alert.",
                        preferredStyle: .Alert)

                let cancelAction = UIAlertAction(
                        title: "Cancel",
                        style: .Cancel) { _ in
                NSLog("Do nothing ////////////////////// ")
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                NSLog("OK was pressed //////////////////////////////////////////////")
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
            alertController.addAction(OKAction)

            self.window!.makeKeyAndVisible()
            let v = self.window!.rootViewController!
            v.presentViewController(alertController,
                                    animated: true,
                                    completion: {})
            case UIApplicationState.Inactive:
                NSLog(String(format: "%@ > UIApplicationState.Inactive", id))
                // This is called up when user selects the notification within the `notifications view`
                // and canceled by user touch.
            default:
                let desc = state.rawValue.description
                NSLog(String(format: "%@ > Unexpected app state: %@", id, desc))
            }
        }

        if let userInfo = notification.userInfo,
           let id = userInfo["id"] as? String
           where id == "dailyreminder" {
            NSLog("Repeating daily reminder was called ///////////////////////////")
            NSLog(" ~ lets fire a noti to show the user")

            // Some condition checks that need to be true before firing the local notification
            if true {
                let n = UILocalNotification()
                // n.fireDate = NSDate(timeIntervalSinceNow: 5)
                n.timeZone = NSTimeZone.defaultTimeZone()
                n.applicationIconBadgeNumber = ++UIApplication.sharedApplication().applicationIconBadgeNumber
                n.userInfo = [
                    "id": "onetimenotification"
                ]
                n.alertTitle = "One time notification title"
                n.alertBody = "One time notification body"

                // n.repeatInterval = NSCalendarUnit.init(rawValue: 0)
                UIApplication.sharedApplication().scheduleLocalNotification(n)
            }
        }

    }

    func listNotifications() {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            NSLog("Notifications found:::::::::::::::::::::::::::::::::::::::::::::")
            for n in notifications {
                if let id = n.userInfo?["id"] as? String {
                    NSLog(id)
                }
                else {
                    NSLog("noti has no id")
                }
            }
            NSLog("////////////////////////////////////////////////////////////////")
        }
        else {
            NSLog("No notifications found ////////////////////////////////////////")
        }

    }


}
