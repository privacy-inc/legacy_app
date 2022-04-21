import SwiftUI

private let pi2 = Double.pi * 2

extension About {
    struct Layer: View, Equatable {
        @StateObject private var model = Model()
        private let shades = Color("Shades")
        private let dawn = Color("Dawn")
        @Environment(\.dismiss) private var dismiss

        var body: some View {
            ZStack {
                Image("Logo")
                TimelineView(.periodic(from: .now, by: 0.02)) { timeline in
                    Canvas { context, size in
                        model.tick(date: timeline.date)
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
                VStack(alignment: .trailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .light))
                            .padding(18)
                            .foregroundStyle(.primary)
                            .contentShape(Rectangle())
                    }
                    Spacer()
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
            }
            .accessibilityLabel("Logo animating")
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            true
        }
    }
}

private final class Model: ObservableObject {
    @Published private(set) var particles = [Banner.Particle]()
    private let banner = Banner(width: UIScreen.main.bounds.width, height: 400)
    
    func tick(date: Date) {
        particles = banner.tick(particles: particles)
    }
}
