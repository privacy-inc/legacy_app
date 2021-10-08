import SwiftUI

struct Chart: View {
    let values: [Double]
    
    var body: some View {
        ZStack {
            Road(values: values)
                .stroke(Color.primary.opacity(0.35), style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round))
                .clipShape(Holes(values: values))
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            ForEach(0 ..< max(values.count - 1, 0), id: \.self) {
                Dot(y: values[$0], index: $0, radius: 3)
                    .stroke(Color.primary.opacity(0.25), lineWidth: 1)
            }
            if !values.isEmpty {
                Dot(y: values.last!, index: values.count - 1, radius: 6)
                    .fill(Color.accentColor)
            }
        }
    }
}

private struct Road: Shape {
    let values: [Double]

    func path(in rect: CGRect) -> Path {
        .init {
            let rect = rect.insetBy(dx: 30, dy: 30)
            $0.move(to: .init(x: 0, y: rect.maxY))
            if !values.isEmpty {
                $0.addLines(values.enumerated().map {
                    .init(x: (.init(rect.maxX / 9) * .init($0.0)) + Double(15),
                          y: (.init(rect.maxY) - (.init(rect.maxY) * $0.1)) + Double(15))
                })
            } else {
                $0.addLine(to: .init(x: rect.maxX, y: rect.maxY))
            }
        }
    }
}

struct Holes: Shape {
    let values: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        (0 ..< values.count)
            .forEach {
                path
                    .addPath(
                        .init(
                            UIBezierPath(cgPath:
                                            Dot(y: values[$0], index: $0, radius: $0 == values.count - 1 ? 7 : 4)
                                            .path(in: rect)
                                            .cgPath)
                                .cgPath))
            }
        return path
    }
}

private struct Dot: Shape {
    let y: Double
    let index: Int
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        .init {
            let rect = rect.insetBy(dx: 30, dy: 30)
            $0.addArc(center: .init(x: (.init(rect.maxX / 9) * .init(index)) + Double(15),
                                    y: (.init(rect.maxY) - (.init(rect.maxY) * y)) + Double(15)),
                      radius: radius, startAngle: .zero, endAngle: .init(radians: .pi * 2), clockwise: true)
        }
    }
}
