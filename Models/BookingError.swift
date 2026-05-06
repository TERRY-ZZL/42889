//
//  BookingError.swift
//  CinemaBooking
//

import Foundation

enum BookingError: LocalizedError, Identifiable {
    case emptySelection
    case exceedsLimit(max: Int)
    case seatOutOfBounds
    case seatTaken(seats: [Seat])
    case orderAlreadyCancelled

    var id: String { errorDescription ?? "error" }

    var errorDescription: String? {
        switch self {
        case .emptySelection:
            return "Please select at least one seat."
        case .exceedsLimit(let max):
            return "You can book up to \(max) seats at a time."
        case .seatOutOfBounds:
            return "Selected seat is outside the hall."
        case .seatTaken(let seats):
            let labels = seats.sorted().map(\.label).joined(separator: ", ")
            return "These seats were just taken: \(labels). Please pick again."
        case .orderAlreadyCancelled:
            return "This booking is already cancelled."
        }
    }
}
