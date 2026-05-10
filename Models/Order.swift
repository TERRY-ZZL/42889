//
//  Order.swift
//  CinemaBooking
//

import Foundation

enum OrderStatus: String, Codable {
    case confirmed
    case cancelled
}

struct Order: Identifiable, Hashable, Codable {
    let id: String
    let movieID: String
    let movieTitle: String
    let showtimeID: String
    let hall: String
    let startsAt: Date
    let seats: Set<Seat>
    let totalPrice: Double
    let createdAt: Date
    let status: OrderStatus

    var seatsLabel: String {
        seats.sorted().map(\.label).joined(separator: ", ")
    }

    /// Returns a NEW order with a different status (pure, idempotent).
    func with(status: OrderStatus) -> Order {
        Order(id: id, movieID: movieID, movieTitle: movieTitle,
              showtimeID: showtimeID, hall: hall, startsAt: startsAt,
              seats: seats, totalPrice: totalPrice,
              createdAt: createdAt, status: status)
    }
}
