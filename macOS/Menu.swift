import AppKit

final class Menu: NSMenu, NSMenuDelegate {
    private let status = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, page, window, help]
        status.button!.image = NSImage(named: "status")
        status.button!.target = self
        status.button!.action = #selector(triggerStatus)
        status.button!.menu = .init()
        status.button!.sendAction(on: [.leftMouseUp, .rightMouseUp])
//        status.button!.menu!.items = [
//            .child("Show Avocado", #selector(NSApplication.show)),
//            .separator(),
//            .child("Quit Avocado", #selector(NSApplication.terminate))]
    }
    
    private var app: NSMenuItem {
        .parent("Privacy", [
                    .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
                    .separator(),
                    .child("Preferences...", #selector(NSApplication.showPreferencesWindow), ","),
                    .separator(),
                    .child("Hide", #selector(NSApplication.hide), "h"),
                    .child("Hide Others", #selector(NSApplication.hideOtherApplications), "h") {
                        $0.keyEquivalentModifierMask = [.option, .command]
                    },
                    .child("Show all", #selector(NSApplication.unhideAllApplications)),
                    .separator(),
                    .child("Quit", #selector(NSApplication.terminate), "q")])
    }
    
    private var file: NSMenuItem {
        .parent("File", [
//                    .child("New Window", #selector(NSApplication.newWindow), "n"),
//                    .child("New Tab", #selector(NSApplication.newTab), "t"),
//                    .child("Open Location", #selector(Window.location), "l"),
//                    .separator(),
//                    .child("Close Window", #selector(Window.close), "W"),
//                    .child("Close Tab", #selector(NSWindow.closeTab), "w"),
                    .separator(),
                    .parent("Share") {
                        $0.submenu!.delegate = self
                    }])
    }
    
    private var edit: NSMenuItem {
        .parent("Edit", [
                    .child("Undo", Selector(("undo:")), "z"),
                    .child("Redo", Selector(("redo:")), "Z"),
                    .separator(),
                    .child("Cut", #selector(NSText.cut), "x"),
                    .child("Copy", #selector(NSText.copy(_:)), "c"),
                    .child("Paste", #selector(NSText.paste), "v"),
                    .child("Delete", #selector(NSText.delete)),
                    .child("Select All", #selector(NSText.selectAll), "a"),
                    .separator(),
                    .parent("Find", [
                        .child("Find", #selector(NSResponder.performTextFinderAction), "f") {
                            $0.tag = .init(NSTextFinder.Action.showFindInterface.rawValue)
                        },
                        .child("Find Next", #selector(NSResponder.performTextFinderAction), "g") {
                            $0.tag = .init(NSTextFinder.Action.nextMatch.rawValue)
                        },
                        .child("Find Previous", #selector(NSResponder.performTextFinderAction), "G") {
                            $0.tag = .init(NSTextFinder.Action.previousMatch.rawValue)
                        },
                        .separator(),
                        .child("Hide Find Banner", #selector(NSResponder.performTextFinderAction), "F") {
                            $0.tag = .init(NSTextFinder.Action.hideFindInterface.rawValue)
                        }
                    ]) {
                        $0.submenu!.delegate = self
                        $0.submenu!.autoenablesItems = false
                    }])
    }
    
    private var page: NSMenuItem {
        .parent("Page") {
            $0.submenu!.delegate = self
            $0.submenu!.autoenablesItems = false
        }
    }
    
    private var window: NSMenuItem {
        .parent("Window") {
            $0.submenu!.delegate = self
        }
    }
    
    private var help: NSMenuItem {
        .parent("Help", [
                    .separator(),
                    .child("Visit goprivacy.app", #selector(triggerWebsite)) {
                        $0.target = self
                    }])
    }
    /*
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
//        case "Share":
//            menu.items = NSSharingService
//                .sharingServices(forItems: [url])
//                .map { service in
//                    .child(service.menuItemTitle, #selector(triggerShare)) {
//                        $0.target = self
//                        $0.image = service.image
//                        $0.representedObject = service
//                    }
//                } + [
//                    .separator(),
//                    .child("Copy Link", #selector(triggerCopyLink), "C") {
//                        $0.target = self
//                        $0.image = .init(systemSymbolName: "doc.on.doc", accessibilityDescription: nil)
//                    }]
        case "Window":
            menu.items = [
                .child("Minimize", #selector(NSWindow.miniaturize), "m"),
                .child("Zoom", #selector(NSWindow.zoom), "p"),
                .separator(),
//                .child("Show Previous Tab", #selector(Window.previousTab), .init(utf16CodeUnits: [unichar(NSTabCharacter)], count: 1)) {
//                    $0.keyEquivalentModifierMask = [.control, .shift]
//                },
//                .child("Show Next Tab", #selector(Window.nextTab), .init(utf16CodeUnits: [unichar(NSTabCharacter)], count: 1)) {
//                    $0.keyEquivalentModifierMask = [.control]
//                },
//                .child("Alternate Previous Tab", #selector(Window.previousTab), "{") {
//                    $0.keyEquivalentModifierMask = [.command]
//                },
//                .child("Alternate Next Tab", #selector(Window.nextTab), "}") {
//                    $0.keyEquivalentModifierMask = [.command]
//                },
                .separator(),
                .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
                .separator()]
                + (0 ..< NSApp.windows.count)
                .compactMap {
                    switch NSApp.windows[$0] {
                    case let window as Window:
                        return (index: $0, title: window
                                    .session
                                    .tab
                                    .items
                                    .value[state: window
                                            .session
                                            .current
                                            .value]
                                    .browse
                                    .map {
                                        cloud
                                            .archive
                                            .value
                                            .page($0)
                                            .title
                                    }
                                    ?? "Privacy")
//                    case is Trackers, is Activity, is Settings, is Info:
//                        return (index: $0, title: NSApp.windows[$0].title)
//                    case is Store:
//                        return (index: $0, title: NSLocalizedString("In-App Purchases", comment: ""))
//                    case is About:
//                        return (index: $0, title: NSLocalizedString("About", comment: ""))
                    default:
                        return nil
                    }
                }
                .map { (index: Int, title: String) in
                    .child(title, #selector(triggerFocus)) {
                        $0.target = self
                        $0.tag = index
                        $0.state = NSApp.mainWindow == NSApp.windows[index] ? .on : .off
                    }
                }
//        case "Page":
//            var browse = false
//            var error = false
//            (NSApp.keyWindow as? Window)
//                .map {
//                    browse = $0
//                        .session
//                        .tab
//                        .items
//                        .value[state: $0
//                                .session
//                                .current
//                                .value].isBrowse
//                    error = $0
//                        .session
//                        .tab
//                        .items
//                        .value[state: $0
//                                .session
//                                .current
//                                .value].isError
//                }
//
//            menu.items = [
//                .child("Stop", #selector(Window.stop), ".") {
//                    $0.isEnabled = browse
//                },
//                error
//                ? .child("Try Again", #selector(Window.tryAgain), "r")
//                : .child("Reload", #selector(Window.reload), "r") {
//                    $0.isEnabled = browse
//                },
//                .separator(),
//                .child("Actual Size", #selector(Window.actualSize), "0") {
//                    $0.isEnabled = browse
//                },
//                .child("Zoom In", #selector(Window.zoomIn), "+") {
//                    $0.isEnabled = browse
//                },
//                .child("Zoom Out", #selector(Window.zoomOut), "-") {
//                    $0.isEnabled = browse
//                }]
//        case "Find":
//            let browser = (NSApp.keyWindow as? Window)
//                .flatMap {
//                    $0
//                        .contentView?
//                        .subviews
//                        .compactMap {
//                            $0 as? Browser
//                        }
//                        .first
//                }
//            menu
//                .items
//                .forEach {
//                    switch NSTextFinder.Action(rawValue: $0.tag) {
//                    case .hideFindInterface:
//                        $0.isEnabled = browser != nil && browser?.finder.findBarContainer?.isFindBarVisible == true
//                    default:
//                        $0.isEnabled = browser != nil
//                    }
//                }
        default:
            break
        }
    }
    */
    @objc private func triggerStatus(_ button: NSStatusBarButton) {
//        guard let event = NSApp.currentEvent else { return }
//
//        switch event.type {
//        case .rightMouseUp:
//            NSMenu.popUpContextMenu(button.menu!, with: event, for: button)
//        case .leftMouseUp:
//            let activity = Activity()
//            activity.behavior = .transient
//            activity.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
//            activity.contentViewController!.view.window!.makeKey()
//        default:
//            break
//        }
    }
    
    @objc private func triggerWebsite() {
//        NSApp.newTabWith(url: URL(string: "https://goprivacy.app")!)
    }
    
    @objc private func triggerFocus(_ item: NSMenuItem) {
        NSApp.windows[item.tag].makeKeyAndOrderFront(nil)
    }
}


/*
 private var url: URL {
     (NSApp.keyWindow as? Window)
         .flatMap {
             $0
                 .session
                 .tab
                 .items
                 .value[state: $0
                         .session
                         .current
                         .value]
                 .browse
                 .map {
                     cloud
                         .archive
                         .value
                         .page($0)
                         .access
                         .value
                 }
                 .flatMap(URL.init(string:))
         } ?? URL(string: "https://goprivacy.app")!
 }
 
 @objc private func triggerStatus(_ button: NSStatusBarButton) {
     let forget = Forget()
     forget.behavior = .transient
     forget.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
     forget.contentViewController!.view.window!.makeKey()
 }
 
 @objc private func triggerShare(_ item: NSMenuItem) {
     (item.representedObject as? NSSharingService)?
         .perform(withItems: [url])
 }
 
 @objc private func triggerCopyLink() {
     NSPasteboard.general.clearContents()
     NSPasteboard.general.setString(url.absoluteString, forType: .string)
     Toast.show(message: .init(title: "URL copied", icon: "doc.on.doc.fill"))
 }
 
 @objc private func triggerWebsite() {
     NSApp.newTabWith(url: URL(string: "https://goprivacy.app")!)
 }
 
 @objc private func triggerFocus(_ item: NSMenuItem) {
     NSApp.windows[item.tag].makeKeyAndOrderFront(nil)
 }
 */
