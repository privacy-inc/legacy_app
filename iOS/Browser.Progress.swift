import SwiftUI

extension Browser {
    struct Progress: Shape {
        var progress: AnimatablePair<Double, Double>

        func path(in rect: CGRect) -> Path {
            .init {
                if progress.first != 1 {
                    $0.move(to: .init(x: progress.first * rect.width, y: 1))
                    $0.addLine(to: .init(x: progress.second * rect.width, y: 1))
                }
            }
        }

        var animatableData: AnimatablePair<Double, Double> {
            get {
                progress
            }
            set {
                progress = newValue
            }
        }
    }
}
