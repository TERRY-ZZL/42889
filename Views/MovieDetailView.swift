//
//  MovieDetailview.swift
//  CinmaBooking
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @EnvironmentObject private var store: BookingStore

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "HH:mm"; return f
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                Text(movie.synopsis)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.9))
                Divider().background(.white.opacity(0.2))
                Text("Showtimes today")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                let showtimes = store.showtimes(for: movie)
                if showtimes.isEmpty {
                    Text("No showtimes available for today.")
                        .foregroundStyle(.white.opacity(0.6))
                } else {
                    VStack(spacing: 10) {
                        ForEach(showtimes) { s in
                            NavigationLink(value: s) {
                                showtimeRow(s)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(
            LinearGradient(colors: [.black, Color(white: 0.06)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)

    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(movie.posterAsset)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 140, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Label(String(format: "%.1f / 10", movie.rating),
                      systemImage: "star.fill")
                    .foregroundStyle(.yellow)
                Label(movie.durationDescription, systemImage: "clock")
                    .foregroundStyle(.white.opacity(0.85))
                Label(String(movie.year), systemImage: "calendar")
                    .foregroundStyle(.white.opacity(0.85))
                tagsView
            }
            Spacer(minLength: 0)
        }
    }

    private var tagsView: some View {
        HStack(spacing: 6) {
            ForEach(movie.genres, id: \.self) { g in
                Text(g)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.white.opacity(0.12))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
    }

    private func showtimeRow(_ s: Showtime) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(Self.timeFormatter.string(from: s.startsAt))
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text(s.hall)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "$%.2f", s.price))
                    .font(.headline)
                    .foregroundStyle(.orange)
                Text("\(s.availableSeats) seats left")
                    .font(.caption)
                    .foregroundStyle(s.availableSeats > 0 ? .white.opacity(0.7) : .red)
            }
            Image(systemName: "chevron.right")
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(14)
        .background(.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
