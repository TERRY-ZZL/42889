//
//  BookingService.swift
//  CinemaBooking
//

import Foundation

struct BookingService {
    let maxSeatsPerOrder: Int = 8

    func reserve(seats: Set<Seat>, in showtime: Showtime, of movie: Movie,
                 now: Date = Date()) throws -> (updatedShowtime: Showtime, order: Order) {
        guard !seats.isEmpty else { throw BookingError.emptySelection }
        guard seats.count <= maxSeatsPerOrder else {
            throw BookingError.exceedsLimit(max: maxSeatsPerOrder)
        }
        guard seats.allSatisfy({ showtime.isInside($0) }) else {
            throw BookingError.seatOutOfBounds
        }
        let conflicts = seats.intersection(showtime.soldSeats)
        guard conflicts.isEmpty else {
            throw BookingError.seatTaken(seats: Array(conflicts))
        }

        let updated = showtime.reserving(seats)
        let order = Order(
            id: UUID().uuidString,
            movieID: movie.id,
            movieTitle: movie.title,
            showtimeID: showtime.id,
            hall: showtime.hall,
            startsAt: showtime.startsAt,
            seats: seats,
            totalPrice: Double(seats.count) * showtime.price,
            createdAt: now,
            status: .confirmed
        )
        return (updated, order)
    }

    func cancel(order: Order, in showtime: Showtime) throws -> (updatedShowtime: Showtime, updatedOrder: Order) {
        guard order.status == .confirmed else {
            throw BookingError.orderAlreadyCancelled
        }
        let updatedShowtime = showtime.releasing(order.seats)
        let cancelled = order.with(status: .cancelled)
        return (updatedShowtime, cancelled)
    }
}
