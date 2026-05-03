//
//  Movie.swift
//  CinemaBooking
//
//

import Foundation

struct Movie: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let year: Int
    let durationMinutes: Int
    let rating: Double
    let genres: [String]
    let synopsis: String

    let posterAsset: String

    var durationDescription: String {
        let h = durationMinutes / 60
        let m = durationMinutes % 60
        return h > 0 ? "\(h)h \(m)m" : "\(m)m"
    }

    var genresDescription: String {
        genres.joined(separator: " · ")
    }

    /// Convenience for keyword search.
    func matches(keyword: String) -> Bool {
        let k = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !k.isEmpty else { return true }
        if title.lowercased().contains(k) { return true }
        if genres.contains(where: { $0.lowercased().contains(k) }) { return true }
        return false
    }
}



//test
extension Movie {
    static let sampleMovies: [Movie] = [
        Movie(
            id: "1",
            title: "Batman",
            year: 2022,
            durationMinutes: 120,
            rating: 8.1,
            genres: ["Action"],
            synopsis: "UTS movie",
            posterAsset: "globe"
        ),
        Movie(
            id: "2",
            title: "Avatar",
            year: 2023,
            durationMinutes: 140,
            rating: 7.8,
            genres: ["Sci-Fi"],
            synopsis: "Another UTS test movie",
            posterAsset: "globe"
        )
    ]
}
extension Showtime {
    static let sampleShowtimes: [Showtime] = [
        Showtime(
            id: "s1",
            movieID: "1",
            hall: "Hall 1",
            startsAt: Date(),
            price: 12.0,
            rows: 5,
            columns: 5,
            soldSeats: []
        ),
        Showtime(
            id: "s2",
            movieID: "2",
            hall: "Hall 2",
            startsAt: Date(),
            price: 10.0,
            rows: 5,
            columns: 5,
            soldSeats: []
        )
    ]
}
