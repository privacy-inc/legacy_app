import SwiftUI

struct Timeline: View {
    let values: [Double]
    
    var body: some View {
        Canvas { context, size in
            let size = CGSize(width: size.width - 30, height: size.height - 30)
            
            context
                .stroke(road(size: size),
                        with: .color(.primary.opacity(0.35)),
                        style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round))
            
            for value in values.enumerated() {
                let center = CGPoint(x: (size.width / 9 * .init(value.0)) + 15,
                                     y: size.height - (size.height * value.1) + 15)
                
                context.blendMode = .clear

                if value.0 == values.count - 1 {
                    context.fill(arc(center: center, radius: 8),
                                 with: .backdrop)
                    context.blendMode = .normal
                    context.fill(arc(center: center, radius: 7),
                                 with: .color(.init("Shades")))
                } else {
                    context.fill(arc(center: center, radius: 5),
                                 with: .backdrop)
                    context.blendMode = .normal
                    context.stroke(arc(center: center, radius: 3),
                                   with: .color(.primary.opacity(0.25)),
                                   lineWidth: 1)
                }
            }
        }
        .accessibilityLabel("Timeline")
    }
    
    private func road(size: CGSize) -> Path {
        .init {
            $0.move(to: .init(x: 0, y: size.height))
            if !values.isEmpty {
                $0.addLines(
                    values
                        .enumerated()
                        .map {
                            .init(x: (size.width / 9 * .init($0.0)) + 15,
                                  y: size.height - (size.height * $0.1) + 15)
                        })
            } else {
                $0.addLine(to: .init(x: size.width, y: size.height))
            }
        }
    }
    
    private func arc(center: CGPoint, radius: CGFloat) -> Path {
        .init {
            $0.addArc(center: center,
                      radius: radius,
                      startAngle: .zero,
                      endAngle: .init(radians: .pi * 2),
                      clockwise: true)
        }
    }
}
