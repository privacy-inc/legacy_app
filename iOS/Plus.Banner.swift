import SwiftUI

extension Plus {
    struct Banner: View {
        private let leftCenter = CGPoint(x: 82, y: 128.5)
        private let rightCenter = CGPoint(x: 168, y: 128.5)
        private let shadingLeft = GraphicsContext.Shading.color(.init("Shades"))
        private let shadingRight = GraphicsContext.Shading.linearGradient(.init(colors: [.init("Shades"), .init("Dawn")]),
                                                                          startPoint: .init(x: -30, y: -30),
                                                                          endPoint: .init(x: 30, y: 30))
//        private let shadingRight = GraphicsContext.Shading.linearGradient(.init(colors: [.white, .black]),
//                                                                          startPoint: .init(x: 138, y: 98.5),
//                                                                          endPoint: .init(x: 198, y: 158.5))
        private let pi_2 = Double.pi / 2
        private let pi2 = Double.pi * 2
        
        var body: some View {
            ZStack {
                Image("Plus")
                TimelineView(.periodic(from: .now, by: 0.05)) { timeline in
                    
                    Canvas { context, size in
                        let angle = Angle.radians(Double(timeline.date.timeIntervalSince1970 * 0.5).truncatingRemainder(dividingBy: pi2))
                        context.fill(.init {
                            $0.addArc(center: leftCenter,
                                      radius: 28.5,
                                      startAngle: .radians(pi2),
                                      endAngle: .radians(0),
                                      clockwise: true)
                        }, with: shadingLeft)
                        context.translateBy(x: 168, y: 128.5)
                        context.rotate(by: angle)
                        
                        context.fill(.init {
                            $0.addArc(center: .zero,
                                      radius: 28.5,
                                      startAngle: .radians(0),
                                      endAngle: .radians(pi2),
                                      clockwise: false)
                        }, with: shadingRight)
                        
                        context.rotate(by: -angle)
                        
                    }
                }
            }
            .accessibilityLabel("Privacy Plus logo animating")
        }
    }
}
