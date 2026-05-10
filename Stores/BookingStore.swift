//
//  BookingStore.swift
//  CinmaBooking
//

import Foundation
import Combine

@MainActor
final class BookingStore: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var showtimes: [Showtime] = []
    @Published private(set) var orders: [Order] = []

    let service = BookingService()

    private let ordersKey = "saved_orders"

    init() {
        movies = Movie.sampleMovies
        showtimes = Showtime.sampleShowtimes
        orders = []
        loadOrders()
    }

    func movies(matching keyword: String) -> [Movie] {
        let k = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !k.isEmpty else { return movies }
        return movies.filter { $0.matches(keyword: k) }
    }

    func showtimes(for movie: Movie) -> [Showtime] {
        showtimes
            .filter { $0.movieID == movie.id }
            .sorted { $0.startsAt < $1.startsAt }
    }

    func currentShowtime(id: String) -> Showtime? {
        showtimes.first { $0.id == id }
    }

    var confirmedOrders: [Order] {
        orders.filter { $0.status == .confirmed }
              .sorted { $0.createdAt > $1.createdAt }
    }

    var cancelledOrders: [Order] {
        orders.filter { $0.status == .cancelled }
              .sorted { $0.createdAt > $1.createdAt }
    }

    @discardableResult
    func book(seats: Set<Seat>, in showtime: Showtime, of movie: Movie) throws -> Order {
        let (newShowtime, order) = try service.reserve(seats: seats, in: showtime, of: movie)
        replace(showtime: newShowtime)
        orders.append(order)
        saveOrders()
        return order
    }

    func cancel(_ order: Order) throws {
        guard let showtime = currentShowtime(id: order.showtimeID) else {
            throw BookingError.orderAlreadyCancelled
        }

        let (newShowtime, updatedOrder) = try service.cancel(order: order, in: showtime)
        replace(showtime: newShowtime)

        if let idx = orders.firstIndex(where: { $0.id == order.id }) {
            orders[idx] = updatedOrder
            saveOrders()
        }
    }

    private func replace(showtime: Showtime) {
        if let idx = showtimes.firstIndex(where: { $0.id == showtime.id }) {
            showtimes[idx] = showtime
        }
    }

    private func saveOrders() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(orders) {
            UserDefaults.standard.set(data, forKey: ordersKey)
        }
    }

    private func loadOrders() {
        if let data = UserDefaults.standard.data(forKey: ordersKey) {
            let decoder = JSONDecoder()
            if let savedOrders = try? decoder.decode([Order].self, from: data) {
                orders = savedOrders
            }
        }
    }
}
