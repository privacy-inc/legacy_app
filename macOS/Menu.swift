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
            $0.submenu!.autoenablesItems = false
        }
    }
    
    private var windowItems: [NSMenuItem] {
        var items: [NSMenuItem] = [
            .child("Minimize", #selector(NSWindow.miniaturize), "m"),
            .child("Zoom", #selector(NSWindow.zoom), "p"),
            .separator()
        ]
        
        if let window = NSApp.keyWindow as? Window {
            items += [
                .child("Show Previous Tab", #selector(window.previousTab), .init(utf16CodeUnits: [unichar(NSTabCharacter)], count: 1)) {
                    $0.keyEquivalentModifierMask = [.control, .shift]
                    $0.target = window
                    $0.isEnabled = window.status.items.value.count > 1
                },
                .child("Show Next Tab", #selector(window.nextTab), .init(utf16CodeUnits: [unichar(NSTabCharacter)], count: 1)) {
                    $0.keyEquivalentModifierMask = [.control]
                    $0.target = window
                    $0.isEnabled = window.status.items.value.count > 1
                },
                .child("Alternate Previous Tab", #selector(window.previousTab), "{") {
                    $0.keyEquivalentModifierMask = [.command]
                    $0.target = window
                    $0.isEnabled = window.status.items.value.count > 1
                },
                .child("Alternate Next Tab", #selector(window.nextTab), "}") {
                    $0.keyEquivalentModifierMask = [.command]
                    $0.target = window
                    $0.isEnabled = window.status.items.value.count > 1
                },
                .separator()]
        }
        
        items += [
            .separator(),
            .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
            .separator()]
        
        items += NSApp
            .windows
            .compactMap { item in
                
                var title = "Privacy"
                let add: NSWindow?
                
                switch item {
                case let window as Window:
                    switch window.status.item.flow {
                    case let .web(web):
                        web
                            .title
                            .map {
                                title = $0.capped
                            }
                    case let .error(_, error):
                        title = error.description.capped
                    default:
                        break
                    }
                    
                    add = window
                case is About:
                    title = "About"
                    add = item
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
            .child("Policy", #selector(triggerWebsite)) {
                $0.target = self
            },
            .child("Terms and conditions", #selector(triggerWebsite)) {
                $0.target = self
            },
            .separator(),
            .child("Privacy +", #selector(triggerWebsite)) {
                $0.target = self
            },
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
        case "Window":
            menu.items = windowItems
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
            .child("Close All Windows", #selector(NSApp.closeAll), "w") {
                $0.target = NSApp
                $0.keyEquivalentModifierMask = [.option, .command]
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
        }
        
        return items
    }
    
    private func fileItems(other: NSWindow) -> [NSMenuItem] {
        [
            .separator(),
            .child("Close Window", #selector(other.close), "w") {
                $0.target = other
            },
            .child("Close All Windows", #selector(NSApp.closeAll), "w") {
                $0.target = NSApp
                $0.keyEquivalentModifierMask = [.option, .command]
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
        NSApp.open(url: URL(string: "https://goprivacy.app")!)
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
        count > 50 ? prefix(50) + "..." : self
    }
}
