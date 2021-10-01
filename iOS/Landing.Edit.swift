import SwiftUI

extension Landing {
    struct Edit: View {
        @Environment(\.dismiss) private var dismiss
        @State private var mode = EditMode.active
        
        var body: some View {
            NavigationView {
                List {
                    ForEach(0 ..< 1) { _ in
                        Circle()
                    }
                    .onMove { index, destination in
                        
                    }
                }
                .navigationTitle("Configure")
                .navigationBarTitleDisplayMode(.large)
                .environment(\.editMode, $mode)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Done")
                                .foregroundStyle(.secondary)
                                .font(.callout)
                                .padding(.leading)
                                .allowsHitTesting(false)
                                .contentShape(Rectangle())
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}
