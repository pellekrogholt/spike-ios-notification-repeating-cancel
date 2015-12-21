# Spike iOS notification repeating cancel

## Scenario

A daily repeating local notification fires a onetime/single local notification under
some conditions. This onetime/single local notification must be shown as a banner
when the app is in foreground.

When user clicks the banner.

Then the onetime/single local notification must be removed from the global/system
`notifications view`.

## Problem

From a block in the banner I remove the onetime local notification from the
notifications view with cancelLocalNotification. But surprisingly the repeating local
notification is re-triggered when firing
`UIApplication.sharedApplication().cancelLocalNotification('one time notification')
~ why ? And how do I prevent this ?

## How to reproduce

0. Build code `pod install`.
1. Run application in simulator and wait 15 secs +/-.
3. Click the banner.

## More

- [stackoverflow post](http://stackoverflow.com/questions/34186247/why-does-canceling-of-a-local-notification-triggers-a-repeating-local-notificati)
- [Apple dev forum post](https://forums.developer.apple.com/message/94169)
