import SwiftUI

extension Plus {
    struct Banner: View {
        private let leftCenter = CGPoint(x: 82, y: 128.5)
        private let rightCenter = CGPoint(x: 168, y: 128.5)
        
        var body: some View {
            ZStack {
                Image("Plus")
                TimelineView(.periodic(from: .now, by: 0.05)) { timeline in
                    Canvas { context, size in
                        let path = Path {
                            $0.addArc(center: leftCenter, radius: 28.5, startAngle: .degrees(0), endAngle: .degrees(Double(Int(timeline.date.timeIntervalSince1970 * 100) % 360)), clockwise: false)
                        }
                        let path2 = Path {
                            $0.addArc(center: rightCenter, radius: 28.5, startAngle: .degrees(0), endAngle: .degrees(Double(Int(timeline.date.timeIntervalSince1970 * 100) % 360)), clockwise: true)
                        }
                        context.fill(path, with: .color(.init("Shades")))
                        context.fill(path2, with: .color(.init("Dawn")))
                    }
                }
            }
            .accessibilityLabel("Privacy Plus logo animating")
        }
    }
}
