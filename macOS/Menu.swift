import AppKit
import StoreKit
import Specs

final class Menu: NSMenu, NSMenuDelegate {
    private let shortcut = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, view, window, help]
        shortcut.button!.image = NSImage(named: "status")
        shortcut.button!.target = self
        shortcut.button!.action = #selector(triggerShortcut)
        shortcut.button!.menu = .init()
        shortcut.button!.sendAction(on: [.leftMouseUp, .rightMouseUp])
        shortcut.button!.menu!.items = [
            .child("Show", #selector(NSApplication.show)),
            .separator(),
            .child("New Window", #selector(triggerNewWindowRegardless)) {
                $0.target = self
            }]
    }
    
    private var app: NSMenuItem {
        .parent("Privacy", [
            .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
            .separator(),
            .child("Preferences...", #selector(App.showPreferencesWindow), ","),
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
        .parent("File", fileItems) {
            $0.submenu!.delegate = self
        }
    }
    
    private var fileItems: [NSMenuItem] {
        var items: [NSMenuItem] = [
            .child("New Window", #selector(NSApplication.newWindow), "n") {
                $0.target = NSApp
            },
            .child("New Tab", #selector(triggerNewTab), "t") {
                $0.target = self
            },
            .child("Open Location", #selector(Window.triggerFocus), "l"),
            .separator(),
            .child("Close Window", #selector(Window.close), "W"),
            .child("Close All Windows", #selector(NSApp.closeAll), "w") {
                $0.target = NSApp
                $0.keyEquivalentModifierMask = [.option, .command]
            },
            .child("Close Tab", #selector(NSWindow.triggerCloseTab), "w")]
        
        guard
            let window = NSApp.keyWindow as? Window,
            case let .web(web) = window.status.flow(of: window.status.current.value),
            let url = web.url
        else { return items }
        
        items += [
            .separator(),
            .parent("Share", [
                .child(url.absoluteString.capped),
                .separator()]
                    + NSSharingService
                        .sharingServices(forItems: [url])
                        .map { service in
                            .child(service.menuItemTitle, #selector(web.share)) {
                                $0.target = web
                                $0.image = service.image
                                $0.representedObject = service
                            }
                        }),
            .separator(),
            .child("Save As...", #selector(web.saveAs), "s") {
                $0.target = web
            },
            .child("Copy Link", #selector(web.copyLink), "C") {
                $0.target = web
            },
            .separator(),
            .child("Export as PDF...", #selector(web.exportAsPdf)) {
                $0.target = web
            },
            .child("Export as Snapshot...", #selector(web.exportAsSnapshot)) {
                $0.target = web
            },
            .child("Export as Web archive...", #selector(web.exportAsWebarchive)) {
                $0.target = web
            },
            .separator(),
            .child("Print...", #selector(web.printPage), "p") {
                $0.target = web
            }
        ]
        
        return items
    }
    
    private var edit: NSMenuItem {
        .parent("Edit", editItems) {
            $0.submenu!.delegate = self
        }
    }
    
    private var editItems: [NSMenuItem] {
        [
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
                .child("Find", #selector(Window.performTextFinderAction), "f") {
                    let action = NSTextFinder.Action.showFindInterface
                    $0.tag = .init(action.rawValue)
                    $0.isEnabled = (NSApp.keyWindow as? Window)?.finder.validateAction(action) == true
                    $0.target = NSApp.keyWindow as? NSTextFinderBarContainer
                },
                .child("Find Next", #selector(Window.performTextFinderAction), "g") {
                    $0.tag = .init(NSTextFinder.Action.nextMatch.rawValue)
                    $0.isEnabled = (NSApp.keyWindow as? NSTextFinderBarContainer)?.isFindBarVisible == true
                    $0.target = NSApp.keyWindow as? NSTextFinderBarContainer
                },
                .child("Find Previous", #selector(Window.performTextFinderAction), "G") {
                    $0.tag = .init(NSTextFinder.Action.previousMatch.rawValue)
                    $0.isEnabled = (NSApp.keyWindow as? NSTextFinderBarContainer)?.isFindBarVisible == true
                    $0.target = NSApp.keyWindow as? NSTextFinderBarContainer
                },
                .separator(),
                .child("Hide Find Banner", #selector(Window.performTextFinderAction), "F") {
                    $0.tag = .init(NSTextFinder.Action.hideFindInterface.rawValue)
                    $0.isEnabled = (NSApp.keyWindow as? NSTextFinderBarContainer)?.isFindBarVisible == true
                    $0.target = NSApp.keyWindow as? NSTextFinderBarContainer
                }
            ]) {
                $0.submenu!.autoenablesItems = false
            }]
    }
    
    private var view: NSMenuItem {
        .parent("View", viewItems) {
            $0.submenu!.delegate = self
        }
    }
    
    private var viewItems: [NSMenuItem] {
        var web: Web?
        
        if let window = NSApp.keyWindow as? Window,
           case let .web(item) = window.status.flow(of: window.status.current.value) {
            web = item
        }
        
        return [
            .child("Stop", #selector(Web.stopLoading(_:)), ".") {
                $0.target = web
            },
            .child("Reload", #selector(Web.reload(_:)), "r") {
                $0.target = web
            },
            .separator(),
            .child("Back", #selector(Web.goBack(_:)), "[") {
                $0.target = web
            },
            .child("Forward", #selector(Web.goForward(_:)), "]") {
                $0.target = web
            },
            .separator(),
            .child("Actual Size", #selector(Web.actualSize), "0") {
                $0.target = web
            },
            .child("Zoom In", #selector(Web.zoomIn), "+") {
                $0.target = web
            },
            .child("Zoom Out", #selector(Web.zoomOut), "-") {
                $0.target = web
            },
            .separator(),
            .child("Full Screen", #selector(Window.toggleFullScreen), "f") {
                $0.keyEquivalentModifierMask = [.function]
            }]
    }
    
    private var window: NSMenuItem {
        .parent("Window", windowItems) {
            $0.submenu!.delegate = self
        }
    }
    
    private var windowItems: [NSMenuItem] {
        var items: [NSMenuItem] = [
            .child("Minimize", #selector(NSWindow.miniaturize), "m"),
            .child("Zoom", #selector(NSWindow.zoom)),
            .separator(),
            .child("Show Previous Tab", #selector(Window.triggerPreviousTab), .init(utf16CodeUnits: [unichar(NSTabCharacter)], count: 1)) {
                $0.keyEquivalentModifierMask = [.control, .shift]
            },
            .child("Show Next Tab", #selector(Window.triggerNextTab), .init(utf16CodeUnits: [unichar(NSTabCharacter)], count: 1)) {
                $0.keyEquivalentModifierMask = [.control]
            },
            .child("Alternate Previous Tab", #selector(Window.triggerPreviousTab), "{") {
                $0.keyEquivalentModifierMask = [.command]
            },
            .child("Alternate Next Tab", #selector(Window.triggerNextTab), "}") {
                $0.keyEquivalentModifierMask = [.command]
            },
            .separator(),
            .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
            .separator()]

        items += NSApp
            .windows
            .compactMap { item in
                
                var title = "New tab"
                var add: NSWindow? = item
                
                switch item {
                case let window as Window:
                    switch window.status.flow(of: window.status.current.value) {
                    case let .web(web):
                        web
                            .title
                            .map {
                                title = $0.capped
                            }
                    case let .message(_, _, message, _):
                        title = message.capped
                    default:
                        break
                    }
                case is About:
                    title = "About"
                case is Info.Policy:
                    title = "Policy"
                case is Info.Terms:
                    title = "Terms"
                case is Plus:
                    title = "Privacy +"
                case is Froob:
                    title = "Support Privacy"
                case is Preferences:
                    title = "Preferences"
                default:
                    add = nil
                }
                
                return add
                    .map {
                        .child(title, #selector($0.makeKeyAndOrderFront)) {
                            $0.target = item
                            $0.state = NSApp.mainWindow == item ? .on : .off
                        }
                    }
            }
        
        return items
    }
    
    private var help: NSMenuItem {
        .parent("Help", [
            .child("Policy", #selector(triggerPolicy)) {
                $0.target = self
            },
            .child("Terms and conditions", #selector(triggerTerms)) {
                $0.target = self
            },
            .separator(),
            .child("Rate on the App Store", #selector(triggerRate)) {
                $0.target = self
            },
            .child("Visit goprivacy.app", #selector(triggerWebsite)) {
                $0.target = self
            }])
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
        case "File":
            menu.items = fileItems
        case "Edit":
            menu.items = editItems
        case "View":
            menu.items = viewItems
        case "Window":
            menu.items = windowItems
        default:
            break
        }
    }
    
    @objc private func triggerNewWindowRegardless() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.newWindow()
    }
    
    @objc private func triggerNewTab() {
        guard let window = NSApp.activeWindow else {
            NSApp.newWindow()
            return
        }
        
        if !window.isKeyWindow {
            window.makeKeyAndOrderFront(nil)
        }
        
        window.status.addTab()
    }
    
    @objc private func triggerRate() {
        SKStoreReviewController.requestReview()
        Defaults.hasRated = true
    }
    
    @objc private func triggerWebsite() {
        NSApp.open(url: URL(string: "https://goprivacy.app")!, change: true)
    }
    
    @objc private func triggerPolicy() {
        (NSApp.anyWindow() ?? Info.Policy())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc private func triggerTerms() {
        (NSApp.anyWindow() ?? Info.Terms())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc private func triggerShortcut(_ button: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        
        switch event.type {
        case .rightMouseUp:
            NSMenu.popUpContextMenu(button.menu!, with: event, for: button)
        case .leftMouseUp:
            let shortcut = Shortcut(origin: button)
            shortcut.contentViewController!.view.window!.makeKey()
        default:
            break
        }
    }
}

private extension String {
    var capped: String {
        count > 40 ? prefix(40) + "..." : self
    }
}
