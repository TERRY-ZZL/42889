//
//  MovieListView.swift
//  CinmaBooking
//

import SwiftUI

struct MovieListView: View {
    @EnvironmentObject private var store: BookingStore
    @State private var keyword: String = ""

    private var results: [Movie] {
        store.movies(matching: keyword)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color(white: 0.08)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            Group {
                if results.isEmpty {
                    emptyView
                } else {
                    List(results) { movie in
                        NavigationLink(value: movie) {
                            MovieRow(movie: movie)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(.white.opacity(0.08))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationTitle("Now Showing")
        .searchable(text: $keyword, prompt: "Search by title or genre")
        .navigationDestination(for: Movie.self) { MovieDetailView(movie: $0) }
    }

    private var emptyView: some View {
        VStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundStyle(.white.opacity(0.4))
            Text("No movies match \"\(keyword)\"")
                .foregroundStyle(.white.opacity(0.75))
            Button("Clear search") { keyword = "" }
                .buttonStyle(.bordered)
                .tint(.orange)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                HStack(spacing: 8) {
                    Label(String(format: "%.1f", movie.rating), systemImage: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    Text("\(movie.year)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    Text(movie.durationDescription)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                Text(movie.genresDescription)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.6))
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 6)
    }
}
