import SwiftUI

struct Timeline: View {
    let values: [Double]
    
    var body: some View {
        Canvas { context, size in
            let size = CGSize(width: size.width - 30, height: size.height - 30)
            
            context
                .stroke(.init {
                    $0.move(to: .init(x: 0, y: size.height))
                    if !values.isEmpty {
                        $0.addLines(values.enumerated().map {
                            .init(x: (.init(size.width / 9) * .init($0.0)) + Double(15),
                                  y: (.init(size.height) - (.init(size.height) * $0.1)) + Double(15))
                        })
                    } else {
                        $0.addLine(to: .init(x: size.width, y: size.height))
                    }
                },
                        with: .color(.primary.opacity(0.35)),
                        style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round))
            
            for value in values.enumerated() {
                let center = CGPoint(x: (.init(size.width / 9) * .init(value.0)) + .init(15),
                                   y: (.init(size.height) - (.init(size.height) * value.1)) + Double(15))
                
                context.blendMode = .clear
                context.fill(.init {
                    $0.addArc(center: center,
                              radius: value.0 == values.count - 1 ? 8 : 5, startAngle: .zero, endAngle: .init(radians: .pi * 2), clockwise: true)
                }, with: .backdrop)
                context.blendMode = .normal
                
                if value.0 == values.count - 1 {
                    context.fill(.init {
                        $0.addArc(center: center,
                                  radius: 7, startAngle: .zero, endAngle: .init(radians: .pi * 2), clockwise: true)
                    },
                                 with: .color(.init("Shades")))
                } else {
                    context.stroke(.init {
                        $0.addArc(center: center,
                                  radius: 3, startAngle: .zero, endAngle: .init(radians: .pi * 2), clockwise: true)
                    },
                                   with: .color(.primary.opacity(0.25)),
                                   lineWidth: 1)
                }
            }
        }
        .accessibilityLabel("Timeline")
    }
}
