import SwiftUI
import Specs

struct Trackers: View {
    let domain: String
    @State private var counter = 0
    @State private var items = [Tracking.Item]()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 0) {
                    Text(counter, format: .number)
                        .font(.system(size: 60, weight: .thin))
                        .padding(.top, 50)
                    Text(domain)
                        .font(.callout)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    Label("Trackers prevented\non this website", systemImage: "bolt.shield")
                        .imageScale(.large)
                        .font(.footnote.weight(.light))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                        .padding(.top, 6)
                        .padding(.bottom, 35)
                }
                .frame(maxWidth: .greatestFiniteMagnitude)
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .light))
                        .padding(18)
                        .foregroundStyle(.secondary)
                        .contentShape(Rectangle())
                }
            }
            .background(Color(.tertiarySystemBackground))
            Divider()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.1.tracker) { item in
                        HStack(spacing: 0) {
                            Text((item.0 + 1).formatted())
                                .font(.footnote.monospacedDigit())
                                .foregroundStyle(.tertiary)
                                .frame(width: 35, alignment: .trailing)
                                .padding(.trailing, 10)
                            Text(item.1.tracker)
                                .font(.callout)
                                .lineLimit(1)
                            Spacer()
                            Text("×")
                                .font(.callout.monospacedDigit().weight(.medium))
                                .foregroundStyle(.tertiary)
                            Text(item.1.count.formatted())
                                .font(.callout.monospacedDigit().weight(.light))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        Divider()
                            .padding(.leading, 45)
                    }
                }
                .padding(.top, 10)
                .padding(.trailing, 25)
                .padding(.bottom, 35)
            }
            .background(Color(.secondarySystemBackground))
        }
        .onReceive(cloud) {
            counter = $0.tracking.count(domain: domain)
            items = $0.tracking.items(for: domain)
        }
    }
}
