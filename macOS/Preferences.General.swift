import AppKit
import Combine
import UserNotifications
import CoreLocation

extension Preferences {
    final class General: NSVisualEffectView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .init(origin: .zero, size: .init(width: 580, height: 440)))
            
            let browserIcon = NSImageView(image: .init(systemSymbolName: "magnifyingglass", accessibilityDescription: nil) ?? .init())
            browserIcon.translatesAutoresizingMaskIntoConstraints = false
            browserIcon.symbolConfiguration = .init(pointSize: 18, weight: .light)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            addSubview(browserIcon)
            
            let browserText = Text(vibrancy: true)
            browserText.attributedStringValue = .make {
                $0.append(.make("Default browser", attributes: [
                    .foregroundColor: NSColor.labelColor,
                    .font: NSFont.preferredFont(forTextStyle: .body)]))
                $0.newLine()
                $0.append(.make("All websites will open\nautomatically on Privacy Browser", attributes: [
                    .foregroundColor: NSColor.secondaryLabelColor,
                    .font: NSFont.preferredFont(forTextStyle: .callout)]))
            }
            addSubview(browserText)
            
            let browser = Control.Title("Make default", color: .labelColor, layer: true)
            browser
                .click
                .sink {
                    LSSetDefaultHandlerForURLScheme(URL.Scheme.http.rawValue as CFString, "incognit" as CFString)
                    LSSetDefaultHandlerForURLScheme(URL.Scheme.https.rawValue as CFString, "incognit" as CFString)
                    
                    Task {
                        await UNUserNotificationCenter.send(message: "Privacy is your default browser!")
                    }
                }
                .store(in: &subs)
            addSubview(browser)
            
            let browserBadge = NSImageView()
            browserBadge.translatesAutoresizingMaskIntoConstraints = false
            addSubview(browserBadge)
            
            let notificationsIcon = NSImageView(image: .init(systemSymbolName: "app.badge", accessibilityDescription: nil) ?? .init())
            notificationsIcon.translatesAutoresizingMaskIntoConstraints = false
            notificationsIcon.symbolConfiguration = .init(pointSize: 18, weight: .light)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            addSubview(notificationsIcon)
            
            let notificationsText = Text(vibrancy: true)
            notificationsText.attributedStringValue = .make {
                $0.append(.make("Notifications", attributes: [
                    .foregroundColor: NSColor.labelColor,
                    .font: NSFont.preferredFont(forTextStyle: .body)]))
                $0.newLine()
                $0.append(.make("We only display internal messages,\nand won't send you Push Notifications", attributes: [
                    .foregroundColor: NSColor.secondaryLabelColor,
                    .font: NSFont.preferredFont(forTextStyle: .callout)]))
            }
            addSubview(notificationsText)
            
            let notifications = Control.Title("Configure", color: .labelColor, layer: true)
            notifications
                .click
                .sink {
                    NSWorkspace
                        .shared
                        .open(URL(string: "x-apple.systempreferences:com.apple.preference.notifications")!)
                }
                .store(in: &subs)
            addSubview(notifications)
            
            let notificationsBadge = NSImageView()
            notificationsBadge.translatesAutoresizingMaskIntoConstraints = false
            addSubview(notificationsBadge)
            
            let locationIcon = NSImageView(image: .init(systemSymbolName: "location", accessibilityDescription: nil) ?? .init())
            locationIcon.translatesAutoresizingMaskIntoConstraints = false
            locationIcon.symbolConfiguration = .init(pointSize: 18, weight: .light)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            addSubview(locationIcon)
            
            let locationText = Text(vibrancy: true)
            locationText.attributedStringValue = .make {
                $0.append(.make("Location", attributes: [
                    .foregroundColor: NSColor.labelColor,
                    .font: NSFont.preferredFont(forTextStyle: .body)]))
                $0.newLine()
                $0.append(.make("Websites may request access to\nyour location, for example\nto provide maps or navigation", attributes: [
                    .foregroundColor: NSColor.secondaryLabelColor,
                    .font: NSFont.preferredFont(forTextStyle: .callout)]))
            }
            addSubview(locationText)
            
            let location = Control.Title("Configure", color: .labelColor, layer: true)
            location
                .click
                .sink {
                    NSWorkspace
                        .shared
                        .open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!)
                }
                .store(in: &subs)
            addSubview(location)
            
            let locationBadge = NSImageView()
            locationBadge.translatesAutoresizingMaskIntoConstraints = false
            addSubview(locationBadge)
            
            browserIcon.centerXAnchor.constraint(equalTo: leftAnchor, constant: 60).isActive = true
            browserIcon.centerYAnchor.constraint(equalTo: browserText.centerYAnchor).isActive = true
            
            browserText.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
            browserText.leftAnchor.constraint(equalTo: leftAnchor, constant: 90).isActive = true
            
            browser.centerYAnchor.constraint(equalTo: browserText.centerYAnchor).isActive = true
            browser.leftAnchor.constraint(equalTo: centerXAnchor, constant: 70).isActive = true
            
            browserBadge.centerYAnchor.constraint(equalTo: browser.centerYAnchor).isActive = true
            browserBadge.leftAnchor.constraint(equalTo: browser.rightAnchor, constant: 20).isActive = true
            
            notificationsIcon.centerXAnchor.constraint(equalTo: leftAnchor, constant: 60).isActive = true
            notificationsIcon.centerYAnchor.constraint(equalTo: notificationsText.centerYAnchor).isActive = true
            
            notificationsText.topAnchor.constraint(equalTo: browserText.bottomAnchor, constant: 40).isActive = true
            notificationsText.leftAnchor.constraint(equalTo: leftAnchor, constant: 90).isActive = true
            
            notifications.centerYAnchor.constraint(equalTo: notificationsText.centerYAnchor).isActive = true
            notifications.leftAnchor.constraint(equalTo: browser.leftAnchor).isActive = true
            
            notificationsBadge.centerYAnchor.constraint(equalTo: notifications.centerYAnchor).isActive = true
            notificationsBadge.leftAnchor.constraint(equalTo: notifications.rightAnchor, constant: 20).isActive = true
            
            locationIcon.centerXAnchor.constraint(equalTo: leftAnchor, constant: 60).isActive = true
            locationIcon.centerYAnchor.constraint(equalTo: locationText.centerYAnchor).isActive = true
            
            locationText.topAnchor.constraint(equalTo: notificationsText.bottomAnchor, constant: 40).isActive = true
            locationText.leftAnchor.constraint(equalTo: leftAnchor, constant: 90).isActive = true
            
            location.centerYAnchor.constraint(equalTo: locationText.centerYAnchor).isActive = true
            location.leftAnchor.constraint(equalTo: browser.leftAnchor).isActive = true
            
            locationBadge.centerYAnchor.constraint(equalTo: locationText.centerYAnchor).isActive = true
            locationBadge.leftAnchor.constraint(equalTo: location.rightAnchor, constant: 20).isActive = true
            
            Task {
                await update(badge: browserBadge, value: NSWorkspace
                    .shared
                    .urlForApplication(toOpen: URL(string: URL.Scheme.http.rawValue + "://")!)
                    .map {
                        $0.lastPathComponent == Bundle.main.bundleURL.lastPathComponent
                    }
                    ?? false)
                
                let settings = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
                await update(badge: notificationsBadge, value: settings != .notDetermined && settings != .denied)
                
                let status = CLLocationManager().authorizationStatus
                await update(badge: locationBadge, value: status != .denied || status != .notDetermined)
            }
        }
        
        @MainActor private func update(badge: NSImageView, value: Bool) {
            badge.image = .init(systemSymbolName: value
                                ? "checkmark.circle.fill"
                                : "exclamationmark.triangle.fill", accessibilityDescription: nil)
            badge.symbolConfiguration = .init(pointSize: 20, weight: .medium)
                .applying(.init(hierarchicalColor: value ? .systemBlue : .systemPink))
        }
    }
}
