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
        n.fireDate = NSDate(timeIntervalSinceNow: 10)
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
                JCNotificationCenter.enqueueNotificationWithTitle(
                    notification.alertTitle,
                    message: notification.alertBody,
                    tapHandler: { () -> Void in
                        NSLog("Banner click ///////////////////////////////////////")
                        // 1. Go to somewhere in the app
                        // 2. Cancel the notification from the `notifications view`
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                    })
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
           let fireDate = notification.fireDate,
           let id = userInfo["id"] as? String
           where id == "dailyreminder" {
            NSLog("Repeating daily reminder was called ~ lets fire a noti to show the user //////////////")

            // Some condition checks that need to be true before firing the local notification
            if true {

                NSLog(fireDate.description)

                // 1. Cancel repeating notification

                UIApplication.sharedApplication().cancelLocalNotification(notification)

                // 2. create new repeating + add one day

                let ng = UILocalNotification()
                ng.fireDate = fireDate.dateByAddingTimeInterval(60*60*24)
                ng.timeZone = NSTimeZone.defaultTimeZone()
                ng.userInfo = ["id": "dailyreminder"]
                ng.repeatInterval = NSCalendarUnit.Day

                // 3. schedule repeating

                UIApplication.sharedApplication().scheduleLocalNotification(ng)

                NSLog("New noti was scheduled")
                NSLog(ng.description)

                // Finally create and schedule the onetime notification
                let n = UILocalNotification()
                n.applicationIconBadgeNumber = ++UIApplication.sharedApplication().applicationIconBadgeNumber
                n.userInfo = [
                    "id": "onetimenotification"
                ]
                n.alertTitle = "One time notification title"
                n.alertBody = "One time notification body"

                UIApplication.sharedApplication().scheduleLocalNotification(n)
            }
        }

    }

    func listNotifications() {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications
           where notifications.count > 0 {
            NSLog("Notifications found:::::::::::::::::::::::::::::::::::::::::::::")
            for n in notifications {
                if let fireDate = n.fireDate,
                   let id = n.userInfo?["id"] as? String {
                    NSLog(id)
                    NSLog(fireDate.description)
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
