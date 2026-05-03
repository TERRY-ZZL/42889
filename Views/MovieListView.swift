//
//  MovieListView.swift
//  CinemaBooking
//

import SwiftUI

struct MovieListView: View {
    @EnvironmentObject private var store: BookingStore

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            List(store.movies) { movie in
                MovieRow(movie: movie)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Now Showing")
    }
}

private struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 14) {
            Image(movie.posterAsset)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("\(movie.year)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))

                Text(movie.genresDescription)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(.vertical, 6)
    }
}
