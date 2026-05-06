//
//  OrderConfirmationView.swift
//  CinemaBooking
//

import SwiftUI

struct OrderConfirmationView: View {
    let order: Order

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        VStack(spacing: 22) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 72))
                .foregroundStyle(.green)
                .padding(.top, 36)

            Text("Booking confirmed")
                .font(.title.bold())
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 12) {
                row("Movie", order.movieTitle)
                row("Hall",  order.hall)
                row("Time",  Self.dateFormatter.string(from: order.startsAt))
                row("Seats", order.seatsLabel)
                row("Total", String(format: "$%.2f", order.totalPrice))
                row("Order #", String(order.id.prefix(8)).uppercased())
            }
            .padding(20)
            .background(.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 20)

            Spacer()

            Text("View it anytime in “My Orders”.")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.6))
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(colors: [.black, Color(white: 0.05)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ key: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(key)
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 80, alignment: .leading)
            Text(value)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
