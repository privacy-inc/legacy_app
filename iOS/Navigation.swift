import SwiftUI

struct Navigation: View {
    @ObservedObject var session: Session
    
    var body: some View {
        switch session.current {
        case let .item(id, flow):
            switch flow {
            case .web:
                Browser(web: session.item(for: id).web!)
            case let .search(focus):
                Search(field: .init(session: session, id: id, focus: focus))
            default:
                Circle()
            }
//        case .tabs:
//            Tabs(session: session)
        default:
            Circle()
        }
    }
}

//import SwiftUI
//import Specs
//
//struct Navigation: View {
//    @Binding var status: Status
//    
//    var body: some View {
//        switch status.flow {
//        case .landing:
//            Landing(tabs: tabs, search: search, clear: clear, history: history, access: access)
//        case .web:
//            Tab(web: status.item!.web!, tabs: tabs, search: search, find: find, open: url, error: error)
//        case .search:
//            Search(representable: .init(searching: searching), tab: tab, access: access)
//        case .tabs:
//            Tabs(status: $status)
//        case .find:
//            Find(web: status.item!.web!, end: end)
//        case .error:
//            Recover(error: status.item!.error, tabs: tabs, search: search, dismiss: dismiss, retry: retry)
//        }
//    }
//    
//    private func tabs() {
//        status.item!.image = UIApplication.shared.snapshot
//        status.flow = .tabs
//    }
//    
//    private func tab() {
//        status.tab()
//    }
//    
//    private func search() {
//        status.flow = .search
//    }
//    
//    private func find() {
//        status.flow = .find
//    }
//    
//    private func end() {
//        status.flow = .web
//    }
//    
//    private func retry() {
//        let url = status.item!.error!.url
//        status.item!.error = nil
//        status.item!.web?.load(url)
//        status.tab()
//    }
//    
//    private func error(_ error: Err) {
//        status.item!.error = error
//        status.tab()
//    }
//    
//    private func url(url: URL) {
//        Task {
//            await status.url(url: url)
//        }
//    }
//    
//    private func access(access: AccessType) {
//        Task {
//            await status.access(access: access)
//        }
//    }
//    
//    private func history(id: UInt16) {
//        Task {
//            await status.history(id: id)
//        }
//    }
//    
//    private func dismiss() {
//        Task
//            .detached(priority: .utility) {
//                await status.dismiss()
//            }
//    }
//    
//    private func searching(search: String) {
//        Task
//            .detached(priority: .utility) {
//                await status.searching(search: search)
//            }
//    }
//    
//    private func clear() {
//        status
//            .items
//            .filter {
//                $0.id != status.item!.id
//            }
//            .forEach {
//                $0
//                    .web?
//                    .clear()
//            }
//        status.items = [status.item!]
//        status.index = 0
//    }
//}
