import SwiftUI
import Specs

struct Trackers: View {
    let domain: String
    @State private var counter = 0
    @State private var items = [Tracking.Item]()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(items, id: \.tracker) { item in
                HStack {
                    Text(item.tracker)
                        .font(.footnote)
                    Spacer()
                    Text("×")
                        .foregroundColor(.secondary)
                        .font(.callout.monospacedDigit().weight(.medium))
                    + Text(item.count.formatted())
                        .foregroundColor(.secondary)
                        .font(.callout.monospacedDigit().weight(.light))
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Text(domain)
                            .padding(.top)
                        Text(counter.formatted() + " Trackers prevented")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .padding(9)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .onReceive(cloud) {
            counter = $0.tracking.count(domain: domain)
            items = $0.tracking.items(for: domain)
        }
    }
}
