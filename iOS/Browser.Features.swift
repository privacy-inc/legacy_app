import SwiftUI

extension Browser {
    struct Features: View {
        @ObservedObject var status: Status
        let session: Session
        let index: Int
        @State private var size = Double(1)
        @State private var progress = AnimatablePair(Double(), Double())
        
        var body: some View {
            VStack(spacing: 0) {
                if status.reader {
                    HStack(spacing: 30) {
                        Bar.Item(icon: "textformat.size.smaller") {
                            if size > 0.3 {
                                size -= 0.25
                            } else {
                                size -= 0.025
                            }
                            
                            Task {
                                await session.items[index].web!.resizeFont(size: size)
                            }
                        }
                        .foregroundStyle(size > 0.03 ? .primary : .tertiary)
                        .allowsHitTesting(size > 0.03)
                        
                        Button {
                            size = 1
                            
                            Task {
                                await session.items[index].web!.resizeFont(size: size)
                            }
                        } label: {
                            Text(size, format: .percent)
                                .font(.callout.monospacedDigit())
                                .frame(minWidth: 58)
                        }
                        .foregroundColor(.primary)
                        .tint(.primary.opacity(session.dark ? 0.7 : 0.3))
                        .buttonStyle(.bordered)
                        
                        Bar.Item(icon: "textformat.size.larger") {
                            if size < 0.25 {
                                size = 0.25
                            } else {
                                size += 0.25
                            }
                            
                            Task {
                                await session.items[index].web!.resizeFont(size: size)
                            }
                        }
                        .foregroundStyle(size < 10 ? .primary : .tertiary)
                        .allowsHitTesting(size < 10)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                
                Progress(progress: progress)
                    .stroke(Color("Shades"), style: .init(lineWidth: 3, lineCap: .round))
                    .frame(height: 2)
                
                Divider()
            }
            .onReceive(session.items[index].web!.publisher(for: \.url)) { _ in
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    size = await session.items[index].web!.fontSize
                }
            }
            .background(.regularMaterial)
            .onReceive(session.items[index].web!.progress, perform: progress(value:))
        }
        
        private func progress(value: Double) {
            guard value != 1 || progress.second != 0 else { return }
            
            progress.first = 0
            withAnimation(.easeInOut(duration: 0.5)) {
                progress.second = value
            }
            
            if value == 1 {
                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + 0.7) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            progress = .init(1, 1)
                        }
                    }
            }
        }
    }
}
