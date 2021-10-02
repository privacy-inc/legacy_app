import SwiftUI
import Specs

struct Landing: View {
    let tabs: () -> Void
    let search: () -> Void
    let history: (Int) -> Void
    let access: (AccessType) -> Void
    @State private var sidebar = false
    @State private var editing = false
    @State private var cards = [Specs.Card]()
    
    var body: some View {
        ScrollView {
            ForEach(cards) {
                switch $0.id {
                case .trackers:
                    Trackers()
                case .activity:
                    Activity()
                case .bookmarks:
                    Bookmarks(select: access)
                case .history:
                    History(select: history)
                }
            }
            .animation(.easeInOut(duration: 0.45), value: cards)
            edit
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .clipped()
        .background(.ultraThickMaterial)
        .onReceive(cloud) {
            cards = $0
                .cards
                .filter(\.state)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(search: search) {
                Button {
                    sidebar = true
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 70)
                        .allowsHitTesting(false)
                }
                .sheet(isPresented: $sidebar) {
                    Sidebar(presented: $sidebar, access: access, history: history)
                }
                
                Spacer()
            } trailing: {
                Spacer()
                Button(action: tabs) {
                    Image(systemName: "square.on.square.dashed")
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 70)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    private var edit: some View {
        Button {
            editing = true
        } label: {
            Label("Configure", systemImage: "slider.vertical.3")
                .font(.footnote)
                .imageScale(.large)
        }
        .foregroundStyle(.secondary)
        .padding(.vertical, 50)
        .sheet(isPresented: $editing) {
            Edit(rootView: .init())
        }
    }
}
