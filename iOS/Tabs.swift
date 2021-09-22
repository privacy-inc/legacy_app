import SwiftUI

struct Tabs: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.init(.systemFill), .init(.secondarySystemFill)]),
                                       startPoint: .bottom, endPoint: .top)
                .edgesIgnoringSafeArea(.all)
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        Spacer()
                            .frame(width: 20)
                        ForEach(0 ..< 5) {
                            Item(index: $0)
                                .id($0)
                        }
                        Spacer()
                            .frame(width: 20)
                    }
                }
                .onAppear {
                    proxy.scrollTo(3, anchor: .center)
                }
            }
            Group {
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.init("Shades"))
                }
            }
            .frame(maxHeight: .greatestFiniteMagnitude, alignment: .bottom)
        }
    }
}
