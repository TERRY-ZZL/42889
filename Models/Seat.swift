//
//  Seat.swift
//  CinmaBooking
//



import Foundation

struct Seat: Hashable, Codable, Comparable {
    let row: Int
    let column: Int

    var label: String {
        let letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N"]
        let rowLetter = row - 1 < letters.count ? letters[row - 1] : "R\(row)"
        return "\(rowLetter)\(column)"
    }

    static func < (lhs: Seat, rhs: Seat) -> Bool {
        lhs.row == rhs.row ? lhs.column < rhs.column : lhs.row < rhs.row
    }
}
