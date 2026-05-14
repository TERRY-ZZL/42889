//
//  SeatSelectionView.swift
//  CinmaBooking
//
//  Cinma-style seat grid. Uses NavigationLink(isActive:) for iOS 16
//  compatibility (value-based navigationDestination is iOS 17+).
//

import SwiftUI

struct SeatSelectionView: View {
    let movie: Movie
    let showtimeID: String

    @EnvironmentObject private var store: BookingStore
    @State private var selected: Set<Seat> = []
    @State private var confirmedOrder: Order?
    @State private var navigateToConfirmation = false
    @State private var lastError: BookingError?

    
    
    
    private var showtime: Showtime? { store.currentShowtime(id: showtimeID) }

    var body: some View {
        Group {
            if let showtime {
                content(showtime: showtime)
            } else {
                Text("Showtime not found.")
                    .foregroundStyle(.white)
            }
        }
        .background(
            LinearGradient(colors: [.black, Color(white: 0.05)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle("Pick Your Seats")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            NavigationLink(
                destination: confirmedOrder.map { OrderConfirmationView(order: $0) },
                isActive: $navigateToConfirmation,
                label: EmptyView.init
            )
            .hidden()
        )
        .alert(item: $lastError) { err in
            Alert(title: Text("Heads up"),
                  message: Text(err.errorDescription ?? "Error"),
                  dismissButton: .default(Text("OK")))
        }
    }

    private func content(showtime: Showtime) -> some View {
        VStack(spacing: 16) {
            screenLabel
            seatGrid(showtime: showtime)
            legend
            Spacer(minLength: 0)
            summaryBar(showtime: showtime)
        }
        .padding(20)
    }

    private var screenLabel: some View {
        VStack(spacing: 6) {
            Capsule()
                .fill(LinearGradient(colors: [.white.opacity(0.6), .white.opacity(0.05)],
                                      startPoint: .top, endPoint: .bottom))
                .frame(height: 8)
                .padding(.horizontal, 40)
            Text("SCREEN")
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(0.7))
                .tracking(4)
        }
    }

    private func seatGrid(showtime: Showtime) -> some View {
        VStack(spacing: 8) {
            ForEach(1...showtime.rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(1...showtime.columns, id: \.self) { col in
                        let seat = Seat(row: row, column: col)
                        SeatButton(
                            seat: seat,
                            state: state(of: seat, showtime: showtime),
                            onTap: { toggle(seat, showtime: showtime) }
                        )
                    }
                }
            }
        }
    }
    

    private var legend: some View {
        HStack(spacing: 18) {
            legendItem(color: .white.opacity(0.15), label: "Available")
            legendItem(color: .orange, label: "Selected")
            legendItem(color: .red.opacity(0.6), label: "Sold")
        }
        .font(.caption)
        .foregroundStyle(.white.opacity(0.85))
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4).fill(color).frame(width: 14, height: 14)
            Text(label)
        }
    }

    private func summaryBar(showtime: Showtime) -> some View {
        let total = Double(selected.count) * showtime.price
        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(selected.count) seat\(selected.count == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                Text(String(format: "$%.2f", total))
                    .font(.title2.bold())
                    .foregroundStyle(.orange)
            }
            Spacer()
            Button(action: { confirm(showtime: showtime) }) {
                Text("Confirm")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 12)
                    .background(selected.isEmpty ? Color.gray : Color.orange)
                    .clipShape(Capsule())
            }
            .disabled(selected.isEmpty)
        }
        .padding(16)
        .background(.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func state(of seat: Seat, showtime: Showtime) -> SeatButton.State {
        if showtime.soldSeats.contains(seat) { return .sold }
        if selected.contains(seat) { return .selected }
        return .available
    }

    private func toggle(_ seat: Seat, showtime: Showtime) {
        guard !showtime.soldSeats.contains(seat) else { return }
        if selected.contains(seat) {
            selected.remove(seat)
        } else {
            selected.insert(seat)
        }
    }

    private func confirm(showtime: Showtime) {
        do {
            let order = try store.book(seats: selected, in: showtime, of: movie)
            confirmedOrder = order
            selected.removeAll()
            navigateToConfirmation = true
        } catch let e as BookingError {
            lastError = e
        } catch {
            lastError = .emptySelection
        }
    }
}

private struct SeatButton: View {
    enum State { case available, selected, sold }
    let seat: Seat
    let state: State
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 28, height: 28)
                .overlay(
                    Text("\(seat.column)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                )
        }
        .buttonStyle(.plain)
        .disabled(state == .sold)
    }

    private var color: Color {
        switch state {
        case .available: return .white.opacity(0.15)
        case .selected:  return .orange
        case .sold:      return .red.opacity(0.6)
        }
    }
}
