import SwiftUI

struct Report: View {
    @State private var display = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section {
                ZStack(alignment: .bottomLeading) {
                    Image("Report")
                        .padding(.vertical)
                    Text("Privacy Report")
                        .font(.title.weight(.medium))
                        .padding(.leading, 5)
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .allowsHitTesting(false)
            
            Section {
                Text("Access a fully fledged report of websites and trackers blocked for having attempted to compromise your privacy.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .allowsHitTesting(false)
            
            Section {
                Button {
                    display = true
                } label: {
                    HStack {
                        Text("Check it out")
                            .padding(.vertical, 7)
                        Spacer()
                        Image(systemName: "shield.lefthalf.filled")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .font(.body)
                    .allowsHitTesting(false)
                }
                .buttonStyle(.borderedProminent)
                .tint(.init("Shades"))
                .sheet(isPresented: $display) {
                    Trackers.Stand(display: $display)
                }
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Dismiss")
                            .padding(.vertical, 20)
                        Spacer()
                    }
                    .font(.callout)
                    .allowsHitTesting(false)
                }
                .tint(.secondary)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
        }
        .listStyle(.insetGrouped)
    }
}
