//
//  Showtime.swift
//  CinmaBooking
//
//  An immutable snapshot of a single screening of a movie.
//

import Foundation

struct Showtime: Identifiable, Hashable {
    let id: String
    let movieID: String
    let hall: String
    let startsAt: Date
    let price: Double
    let rows: Int
    let columns: Int
    let soldSeats: Set<Seat>

    var totalSeats: Int { rows * columns }
    var availableSeats: Int { totalSeats - soldSeats.count }

    /// Returns a NEW showtime with extra seats marked as sold.
    /// Pure, idempotent, does not mutate self.
    func reserving(_ seats: Set<Seat>) -> Showtime {
        Showtime(id: id, movieID: movieID, hall: hall, startsAt: startsAt,
                 price: price, rows: rows, columns: columns,
                 soldSeats: soldSeats.union(seats))
    }

    /// Returns a NEW showtime with the given seats released.
    func releasing(_ seats: Set<Seat>) -> Showtime {
        Showtime(id: id, movieID: movieID, hall: hall, startsAt: startsAt,
                 price: price, rows: rows, columns: columns,
                 soldSeats: soldSeats.subtracting(seats))
    }

    func isInside(_ seat: Seat) -> Bool {
        (1...rows).contains(seat.row) && (1...columns).contains(seat.column)
    }
}

