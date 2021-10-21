import Foundation

extension Plus.Banner {
    struct Shine {
        let x: Double
        let y: Double
        let start: Double
        let length: Double
        let clockwise: Bool
        let blue: Bool
        private let step : Double
        private let remain: Int
        
        static func new() -> Self {
            Bool.random() ? .left() : .right()
        }
        
        private static func left() -> Self {
            .init(x: 82, y: 128.5)
        }
        
        private static func right() -> Self {
            .init(x: 168, y: 128.5)
        }
        
        private static var length: Double {
            .random(in: 0.005 ..< 0.8)
        }
        
        private static var step: Double {
            .random(in: 0.001 ..< 0.06)
        }
        
        private init(x: Double, y: Double) {
            self.x = x
            self.y = y
            start = .random(in: 0 ..< .pi * 2)
            remain = .random(in: 200 ..< 2000)
            clockwise = .random()
            blue = .random()
            length = clockwise ? -Self.length : Self.length
            step = clockwise ? Self.step : -Self.step
        }
        
        private init(x: Double, y: Double, start: Double, length: Double, clockwise: Bool, blue: Bool, step: Double, remain: Int) {
            self.x = x
            self.y = y
            self.start = start
            self.length = length
            self.clockwise = clockwise
            self.blue = blue
            self.step = step
            self.remain = remain
        }
        
        func tick() -> Self? {
            remain > 0
            ? .init(x: x, y: y, start: start + step, length: length, clockwise: clockwise, blue: blue, step: step, remain: remain - 1)
            : nil
        }
    }
}
