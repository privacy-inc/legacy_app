import SwiftUI

private let pi2 = Double.pi * 2

extension About {
    struct Layer: View, Equatable {
        @StateObject private var model = Model()
        private let shades = Color("Shades")
        private let dawn = Color("Dawn")

        var body: some View {
            TimelineView(.periodic(from: .now, by: 0.02)) { timeline in
                Canvas { context, size in
                    model.tick(date: timeline.date, size: size)
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
                                }, with: .color((particle.blue ? shades : dawn).opacity(particle.opacity)))
                        }
                }
            }
            .accessibilityLabel("Logo animating")
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            true
        }
    }
}

private final class Model: ObservableObject {
    @Published private(set) var particles = [Particle]()
    
    func tick(date: Date, size: CGSize) {
        particles = particles.tick(particles: particles, width: size.width, height: size.height)
    }
}
