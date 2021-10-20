import Foundation

enum Copy {
    static let notifications = """
We use notifications to display important messages and provide feedback to your actions, and only when you are actively using the app.

We will never send Push Notifications.

Your privacy is respected at all times.
"""
    
    static let deactivate = """
Notifications are activated
"""
    
    static let location = """
This app will never access your location, but may ask you to grant access if a website is requesting it, useful when using maps, otherwise is not really necessary.

You can always change this permission on Settings.
"""
    
    static let browser = """
You can make this app your default browser and all websites will open automatically on Privacy.

Activate it on Settings.
"""
    
    static let policy = """
This app is **not** tracking you in anyway, nor sharing any information from you with no one, we are also not storing any data concerning you.

We make use of Apple's *iCloud* to synchronise your data across your own devices, but no one other than you, not us nor even Apple can access your data.

If you allow **notifications** these are going to be displayed only for giving feedback on actions you take while using the app, we **don't** want to contact you in anyway and specifically we **don't** want to send you **Push Notifications**.

Whatever you do with this app is up to you and we **don't** want to know about it.
"""
    
    static let terms = """
We make use of Apple's iCloud to synchronise this app among all your devices. The data we synchronise is exactly the same data you enter in here and nothing else, specifically: your _history_, _bookmarks_, _settings_ and _activity_. Activity consisting only of trackers blocked and websites visited over time. As soon as you decide to forget any of those that change gets reflected on iCloud too.

There is nothing stored on iCloud that could be linked to you or your devices.

We do our best to protect your data, however we are a **very small independent team** and we can't commit to provide the maximum state of the art digital security, and we depend mostly of Apple's iCloud own resilience.

You data gets stored both locally and on a *public database* on iCloud.

It is stored on the *public database* so that it doesn't affect your own's account iCloud quota. Instead we take care of the quota for you, we pay for this storage so that you don't have to pay for it with your account.

Even though it is stored in a *public database*, **no one else but you can read or access your data**, not even apple, not even us, that is because it is stored with security rules enforcing only the owner of that data to access it.

The data stored locally is protected by the operative system's *sandbox*, meaning no other app but this app can access it.

By using this app you are accepting these terms.
"""
}
