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

    init() {
        movies = Movie.sampleMovies
        showtimes = Showtime.sampleShowtimes
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
}
