import SwiftUI
import Specs

struct Settings: View {
    @Binding var presented: Bool
    
    var body: some View {
        List {
            Navigation()
            Features()
            Javascript()
            Notifications(presented: $presented)
            Location(presented: $presented)
            Browser(presented: $presented)
        }
        .symbolRenderingMode(.multicolor)
        .toggleStyle(SwitchToggleStyle(tint: .orange))
        .pickerStyle(SegmentedPickerStyle())
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}
