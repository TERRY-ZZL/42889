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


}
