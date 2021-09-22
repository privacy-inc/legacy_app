import Foundation

extension Int {
    func columns(with rows: Int) -> [(col: Int, row: Int, index: Int)] {
        (0 ..< self)
            .flatMap { col in
                (0 ..< rows)
                    .map { row in
                        (col: col, row: row, index: col + (row * self))
                    }
            }
    }
}
