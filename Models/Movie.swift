//
//  Movie.swift
//  CinmaBooking
//
//  An immutable value type describing a movie loaded from movies.json.
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
    /// Name of the image set inside Assets.xcassets (e.g. "poster_oppenheimer").
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
