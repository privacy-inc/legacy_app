import SwiftUI
import WidgetKit

@main struct Search: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Search", provider: Provider(), content: Content.init(entry:))
            .configurationDisplayName("Search")
            .description("Search with Privacy")
            .supportedFamilies([.systemSmall])
    }
}

private struct Content: View {
    let entry: Entry
    
    var body: some View {
        ZStack {
            Image("Plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal)
            Image(systemName: "magnifyingglass")
                .font(.title2.weight(.light))
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .bottomTrailing)
                .padding()
        }
        .symbolRenderingMode(.hierarchical)
        .widgetURL(URL(string: "privacy://search")!)
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(LinearGradient(gradient: .init(colors: [.init("Shades"), .init("Dawn")]), startPoint: .bottom, endPoint: .top))
    }
}

private struct Provider: TimelineProvider {
    func placeholder(in: Context) -> Entry {
        .shared
    }

    func getSnapshot(in: Context, completion: @escaping (Entry) -> ()) {
        completion(.shared)
    }

    func getTimeline(in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(.init(entries: [.shared], policy: .never))
    }
}

private struct Entry: TimelineEntry {
    static let shared = Self()

    let date = Date()
}
