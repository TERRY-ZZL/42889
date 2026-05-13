//
//  MovieRepository.swift
//  CinmaBooking
//

import Foundation

protocol MovieRepository {
    func loadMovies() -> [Movie]
    func generateShowtimes(for movies: [Movie]) -> [Showtime]
}

struct LocalMovieRepository: MovieRepository {
    func loadMovies() -> [Movie] {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            assertionFailure("movies.json is missing from the bundle.")
            return []
        }
        do {
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            assertionFailure("Failed to decode movies.json: \(error)")
            return []
        }
    }

    func generateShowtimes(for movies: [Movie]) -> [Showtime] {
        let calendar = Calendar.current
        let baseDay = calendar.startOfDay(for: Date())
        let slotHours = [10, 13, 16, 19, 21]
        let halls     = ["Hall 1", "Hall 2", "Hall 3", "IMAX"]
        var result: [Showtime] = []
        result.reserveCapacity(movies.count * 3)
        for (index, movie) in movies.enumerated() {
            let picks = [0, 2, 3].map { (index + $0) % slotHours.count }
            for (slotIdx, hourIdx) in picks.enumerated() {
                let hour = slotHours[hourIdx]
                let hall = halls[(index + slotIdx) % halls.count]
                let startsAt = calendar.date(byAdding: .hour, value: hour, to: baseDay) ?? baseDay
                let price = 15.0 + Double(slotIdx) * 3.0
                let showtime = Showtime(
                    id: "\(movie.id)-s\(slotIdx)",
                    movieID: movie.id,
                    hall: hall,
                    startsAt: startsAt,
                    price: price,
                    rows: 8,
                    columns: 10,
                    soldSeats: Self.demoSoldSeats(seed: movie.id.hashValue &+ slotIdx)
                )
                result.append(showtime)
            }
        }
        return result
    }

    private static func demoSoldSeats(seed: Int) -> Set<Seat> {
        var rng = SplitMix64(seed: UInt64(bitPattern: Int64(seed)))
        let count = 6 + Int(rng.next() % 8)
        var out: Set<Seat> = []
        while out.count < count {
            let r = 1 + Int(rng.next() % 8)
            let c = 1 + Int(rng.next() % 10)
            out.insert(Seat(row: r, column: c))
        }
        return out
    }
}

private struct SplitMix64 {
    private var state: UInt64
    init(seed: UInt64) { self.state = seed == 0 ? 0xDEADBEEFCAFEBABE : seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
