import SwiftUI

struct Web: UIViewRepresentable {
    @Binding var session: Session
    let id: UUID
    let browse: Int
    
    func makeCoordinator() -> Coordinator {
        session.items[web: id] as? Coordinator ?? .init(wrapper: self, id: id, browse: browse)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        if session.items[web: id] == nil {
            session.tab.update(id, web: context.coordinator)
        }
        return context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) {
        
    }
}
