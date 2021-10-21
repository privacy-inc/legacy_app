import SwiftUI

extension Plus {
    struct Banner: View {
        private let model = Model()
        private let gradient = GraphicsContext.Shading.linearGradient(.init(colors: [.init("Shades"), .init("Dawn")]),
                                                                      startPoint: .init(x: -30, y: -30),
                                                                      endPoint: .init(x: 30, y: 30))
        private let pi2 = Double.pi * 2
        
        var body: some View {
            ZStack {
                Image("Plus")
                TimelineView(.periodic(from: .now, by: 0.05)) { timeline in
                    Canvas { context, size in
                        model.tick()
                        
                        model
                            .particles
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
                        
                        model
                            .shines
                            .forEach { shine in
                                context
                                    .stroke(.init {
                                        $0.addArc(center: .init(x: shine.x, y: shine.y),
                                                  radius: 25,
                                                  startAngle: .radians(shine.start),
                                                  endAngle: .radians(shine.start + shine.length),
                                                  clockwise: shine.clockwise)
                                    }, with: .color((shine.blue ? Color("Shades") : .init("Dawn")).opacity(0.2)),
                                            style: .init(lineWidth: 6, lineCap: .square))
                            }
                    }
                }
            }
            .accessibilityLabel("Privacy Plus logo animating")
        }
    }
}
