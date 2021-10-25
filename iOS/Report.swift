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
                            .padding(.vertical, 5)
                        Spacer()
                        Image(systemName: "shield.lefthalf.filled")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .font(.callout)
                    .allowsHitTesting(false)
                }
                .buttonStyle(.borderedProminent)
                .tint(.init("Shades"))
                .sheet(isPresented: $display) {
                    Trackers.Stand(display: $display)
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            
            Section {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Dismiss")
                            .padding(.vertical, 5)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .font(.callout)
                    .allowsHitTesting(false)
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
        }
        .listStyle(.insetGrouped)
    }
}
