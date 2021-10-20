import SwiftUI

extension Plus {
    struct Banner: View {
//        private let leftCenter = CGPoint(x: 82, y: 128.5)
//        private let rightCenter = CGPoint(x: 168, y: 128.5)
        @State private var particles = [Particle]()
        private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        private let gradient = GraphicsContext.Shading.linearGradient(.init(colors: [.init("Shades"), .init("Dawn")]),
                                                                      startPoint: .init(x: -30, y: -30),
                                                                      endPoint: .init(x: 30, y: 30))
        private let pi2 = Double.pi * 2
        
        var body: some View {
            ZStack {
                Image("Plus")
                TimelineView(.periodic(from: .now, by: 0.05)) { timeline in
                    Canvas { context, size in
                        let angle = Angle.radians(Double(timeline.date.timeIntervalSince1970 * 0.5).truncatingRemainder(dividingBy: pi2))
                        
                        context.translateBy(x: 82, y: 128.5)
                        context.rotate(by: -angle)
                        context.fill(.init {
                            $0.addArc(center: .zero,
                                      radius: 28.5,
                                      startAngle: .radians(0),
                                      endAngle: .radians(pi2),
                                      clockwise: false)
                        }, with: gradient)
                        context.rotate(by: angle)
                        context.translateBy(x: -82, y: -128.5)
                        
                        context.translateBy(x: 168, y: 128.5)
                        context.rotate(by: angle)
                        
                        context.fill(.init {
                            $0.addArc(center: .zero,
                                      radius: 28.5,
                                      startAngle: .radians(0),
                                      endAngle: .radians(pi2),
                                      clockwise: false)
                        }, with: gradient)
                        
                        context.rotate(by: -angle)
                        context.translateBy(x: -168, y: -128.5)
                        
                        particles
                            .forEach { particle in
                                context
                                    .fill(.init {
                                        $0.addArc(center: .init(x: particle.x, y: particle.y),
                                                  radius: particle.radius,
                                                  startAngle: .radians(0),
                                                  endAngle: .radians(pi2),
                                                  clockwise: false)
                                    }, with: .color((particle.blue ? Color("Shades") : .init("Dawn")).opacity(particle.opacity)))
                            }
                    }
                }
            }
            .accessibilityLabel("Privacy Plus logo animating")
            .onReceive(timer) { _ in
                particles = particles
                    .compactMap {
                        $0.tick()
                    }
                if Int.random(in: 0 ..< 20) == 0 {
                    particles.append(.new())
                }
            }
        }
    }
}