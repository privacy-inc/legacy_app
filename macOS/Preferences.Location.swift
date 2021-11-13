//
//  Preferences.Location.swift
//  macOS
//
//  Created by vaux on 13.11.21.
//

import Foundation



/*
 import AppKit
 import Combine
 import Sleuth

 extension Settings {
     final class Location: NSTabViewItem {
         private var subs = Set<AnyCancellable>()
         
         required init?(coder: NSCoder) { nil }
         override init() {
             super.init(identifier: "Location")
             label = "Location"
             
             let location = Option(title: "Location permission", image: "location")
             location
                 .click
                 .sink {
                     NSWorkspace
                         .shared
                         .open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!)
                 }
                 .store(in: &subs)
             view!.addSubview(location)
             
             let title = Text()
             title.font = .preferredFont(forTextStyle: .body)
             title.textColor = .secondaryLabelColor
             title.stringValue = """
 This app will never access your location, but may ask you to grant access if a website is requesting it.

 You can change this permission on System Preferences.
 """
             title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
             view!.addSubview(title)
             
             location.topAnchor.constraint(equalTo: view!.topAnchor, constant: 20).isActive = true
             location.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
             
             title.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10).isActive = true
             title.leftAnchor.constraint(equalTo: view!.centerXAnchor, constant: -170).isActive = true
             title.rightAnchor.constraint(equalTo: view!.centerXAnchor, constant: 170).isActive = true
         }
     }
 }

 */
