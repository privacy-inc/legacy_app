import SwiftUI
import Specs

struct Navigation: View {
    @Binding var status: Status
    
    var body: some View {
        switch status.flow {
        case .landing:
            Landing(tabs: tabs, search: search, history: history, access: access)
        case .web:
            Tab(web: status.item.web!, tabs: tabs, search: search, find: find, open: url, error: error)
        case .search:
            Search(representable: .init(searching: searching), tab: tab, access: access)
        case .tabs:
            Tabs(status: $status, tab: tab, add: add)
        case .find:
            Find(web: status.item.web!, end: end)
        case .error:
            Recover(url: status.item.error?.url.absoluteString ?? "", description: status.item.error?.description ?? "", tabs: tabs, search: search, dismiss: dismiss, retry: retry)
        }
    }
    
    private func tabs() {
        status.item.image = UIApplication.shared.snapshot
        status.flow = .tabs
    }
    
    private func tab() {
        status.tab()
    }
    
    private func search() {
        status.animate(to: .search)
    }
    
    private func find() {
        status.animate(to: .find)
    }
    
    private func end() {
        status.animate(to: .web)
    }
    
    private func retry() {
        let url = status.item.error!.url
        status.item.error = nil
        status.item.web?.load(url)
        status.tab()
    }
    
    private func error(_ error: Err) {
        status.item.error = error
        status.tab()
    }
    
    private func add() {
        status.add()
    }
    
    private func url(_ url: URL) {
        Task {
            await status.url(url)
        }
    }
    
    private func access(_ access: AccessType) {
        Task {
            await status.access(access)
        }
    }
    
    private func history(_ id: UInt16) {
        Task {
            await status.history(id)
        }
    }
    
    private func dismiss() {
        Task
            .detached(priority: .utility) {
                await status.dismiss()
            }
    }
    
    private func searching(search: String) {
        Task
            .detached(priority: .utility) {
                await status.searching(search: search)
            }
    }
}
