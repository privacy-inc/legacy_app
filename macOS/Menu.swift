import AppKit

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
            .child("Show Privacy", #selector(NSApplication.show)),
            .separator(),
            .child("New Window", #selector(triggerNewWindowRegardless)) {
                $0.target = self
            },
            .separator(),
            .child("Quit Privacy", #selector(NSApplication.terminate))]
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
        .parent("File") {
            $0.submenu!.delegate = self
        }
    }
    
    private var fileItems: [NSMenuItem] {
        var items: [NSMenuItem] = [
            .child("New Window", #selector(triggerNewWindow), "n") {
                $0.target = self
            },
            .child("New Tab", #selector(triggerNewTab), "t") {
                $0.target = self
            }]
        
        switch NSApp.keyWindow {
        case let window as Window:
            items += fileItems(window: window)
        case let other?:
            items += fileItems(other: other)
        default:
            break
        }
        
        return items
    }
    
    private var edit: NSMenuItem {
        .parent("Edit") {
            $0.submenu!.delegate = self
        }
    }
    
    private var editItems: [NSMenuItem] {
        var items: [NSMenuItem] = [
            .child("Undo", Selector(("undo:")), "z"),
            .child("Redo", Selector(("redo:")), "Z"),
            .separator(),
            .child("Cut", #selector(NSText.cut), "x"),
            .child("Copy", #selector(NSText.copy(_:)), "c"),
            .child("Paste", #selector(NSText.paste), "v"),
            .child("Delete", #selector(NSText.delete)),
            .child("Select All", #selector(NSText.selectAll), "a")]
        
        if let window = NSApp.keyWindow as? Window,
           case let .web(web) = window.status.item.flow {
            
            items += [
                .separator(),
                .parent("Find", [
                    .child("Find", #selector(NSResponder.performTextFinderAction), "f") {
                        $0.tag = .init(NSTextFinder.Action.showFindInterface.rawValue)
                        $0.target = web
                    },
                    .child("Find Next", #selector(NSResponder.performTextFinderAction), "g") {
                        $0.tag = .init(NSTextFinder.Action.nextMatch.rawValue)
                        $0.target = web
                    },
                    .child("Find Previous", #selector(NSResponder.performTextFinderAction), "G") {
                        $0.tag = .init(NSTextFinder.Action.previousMatch.rawValue)
                        $0.target = web
                    },
                    .separator(),
                    .child("Hide Find Banner", #selector(NSResponder.performTextFinderAction), "F") {
                        $0.tag = .init(NSTextFinder.Action.hideFindInterface.rawValue)
                        $0.isEnabled = web.isFindBarVisible == true
                        $0.target = web
                    }
                ]) {
                    $0.submenu!.autoenablesItems = false
                }]
        }
        
        return items
    }
    
    private var view: NSMenuItem {
        .parent("View") {
            $0.submenu!.delegate = self
        }
    }
    
    private var viewItems: [NSMenuItem] {
        guard let window = NSApp.keyWindow as? Window else { return [] }
        
        var items = [NSMenuItem]()
        
        switch window.status.item.flow {
        case let .web(web):
            items += [
                .child("Stop", #selector(web.stopLoading(_:)), ".") {
                    $0.target = web
                },
                .child("Reload", #selector(web.reload(_:)), "r") {
                    $0.target = web
                },
                .separator(),
                .child("Actual Size", #selector(web.actualSize), "0") {
                    $0.target = web
                },
                .child("Zoom In", #selector(web.zoomIn), "+") {
                    $0.target = web
                },
                .child("Zoom Out", #selector(web.zoomOut), "-") {
                    $0.target = web
                }]
        case let .error(web, _):
            items += [
                .child("Dismiss Error", #selector(web.dismiss), ".") {
                    $0.target = web
                },
                .child("Try Again", #selector(web.tryAgain), "r") {
                    $0.target = web
                }]
        default:
            break
        }
        
        items += [
            .separator(),
            .child(window.contentView?.isInFullScreenMode == true ? "Exit Full Screen" : "Enter Full Screen", #selector(window.toggleFullScreen), "f") {
                $0.target = window
                $0.keyEquivalentModifierMask = [.function]
            }]
        
        return items
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
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
        case "File":
            menu.items = fileItems
        case "Edit":
            menu.items = editItems
        case "View":
            menu.items = viewItems
//        case "Window":
//            menu.items = [
//                .child("Minimize", #selector(NSWindow.miniaturize), "m"),
//                .child("Zoom", #selector(NSWindow.zoom), "p"),
//                .separator(),
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
//                    .separator(),
//                .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
//                .separator()]
//            + (0 ..< NSApp.windows.count)
//                .compactMap {
//                    switch NSApp.windows[$0] {
//                    case let window as Window:
//                        return (index: $0, title: window
//                                    .session
//                                    .tab
//                                    .items
//                                    .value[state: window
//                                            .session
//                                            .current
//                                            .value]
//                                    .browse
//                                    .map {
//                            cloud
//                                .archive
//                                .value
//                                .page($0)
//                                .title
//                        }
//                                ?? "Privacy")
//                        //                    case is Trackers, is Activity, is Settings, is Info:
//                        //                        return (index: $0, title: NSApp.windows[$0].title)
//                        //                    case is Store:
//                        //                        return (index: $0, title: NSLocalizedString("In-App Purchases", comment: ""))
//                        //                    case is About:
//                        //                        return (index: $0, title: NSLocalizedString("About", comment: ""))
//                    default:
//                        return nil
//                    }
//                }
//                .map { (index: Int, title: String) in
//                .child(title, #selector(triggerFocus)) {
//                    $0.target = self
//                    $0.tag = index
//                    $0.state = NSApp.mainWindow == NSApp.windows[index] ? .on : .off
//                }
//                }

        default:
            break
        }
    }
    
    private func fileItems(window: Window) -> [NSMenuItem] {
        var items: [NSMenuItem] = [
            .child("Open Location", #selector(window.search), "l") {
                $0.target = window
            },
            .separator(),
            .child("Close Window", #selector(window.close), "W") {
                $0.target = window
            },
            .child("Close Tab", #selector(window.closeTab), "w") {
                $0.target = window
            }]
        
        if case let .web(web) = window.status.item.flow,
           let url = web.url {
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
        }
        
        return items
    }
    
    private func fileItems(other: NSWindow) -> [NSMenuItem] {
        [
            .separator(),
            .child("Close Window", #selector(other.close), "w") {
                $0.target = other
            }]
    }
    
    @objc private func triggerNewWindow() {
        Window.new()
    }
    
    @objc private func triggerNewWindowRegardless() {
        NSApp.activate(ignoringOtherApps: true)
        Window.new()
    }
    
    @objc private func triggerNewTab() {
        guard let window = NSApp.activeWindow else {
            Window.new()
            return
        }
        
        if !window.isKeyWindow {
            window.makeKeyAndOrderFront(nil)
        }
        
        window.status.addTab()
    }
    
    
    @objc private func triggerWebsite() {
        //        NSApp.newTabWith(url: URL(string: "https://goprivacy.app")!)
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


private extension String {
    var capped: String {
        count > 50 ? prefix(50) + "..." : self
    }
}
