//
//  OrdersView.swift
//  CinmaBooking
//

import SwiftUI


struct OrdersView: View {
    @EnvironmentObject private var store: BookingStore
    @State private var pendingCancellation: Order?

    var body: some View {
        Group {
            if store.orders.isEmpty {
                emptyView
            } else {
                List {
                    if !store.confirmedOrders.isEmpty {
                        Section("Upcoming") {
                            ForEach(store.confirmedOrders) { order in
                                OrderRow(order: order, onCancel: { pendingCancellation = order })
                            }
                        }
                    }
                    
                    if !store.cancelledOrders.isEmpty {
                        Section("Cancelled") {
                            ForEach(store.cancelledOrders) { order in
                                OrderRow(order: order, onCancel: nil)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        
        
        .navigationTitle("My Orders")
        .confirmationDialog(
            "Cancel this booking?",
            isPresented: Binding(
                get: { pendingCancellation != nil },
                set: { if !$0 { pendingCancellation = nil } }
            ),
            presenting: pendingCancellation
        ) { order in
            Button("Cancel booking", role: .destructive) {
                try? store.cancel(order)
                pendingCancellation = nil
            }
            Button("Keep it", role: .cancel) { pendingCancellation = nil }
        } message: { _ in
            Text("Your seats will be released and refunded.")
        }
    }
     
    

    private var emptyView: some View {
        VStack(spacing: 14) {
            Image(systemName: "ticket")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            Text("No bookings yet")
                .font(.title3.bold())
            Text("Pick a movie from the Movies tab and your tickets will appear here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct OrderRow: View {
    let order: Order
    let onCancel: (() -> Void)?

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(order.movieTitle).font(.headline)
                Spacer()
                Text(String(format: "$%.2f", order.totalPrice))
                    .font(.subheadline.bold())
                    .foregroundStyle(.orange)
            } 
            Label(Self.dateFormatter.string(from: order.startsAt),
                  systemImage: "calendar")
                .font(.caption)
            Label(order.hall, systemImage: "rectangle.inset.filled")
                .font(.caption)
            Label(order.seatsLabel, systemImage: "chair")
                .font(.caption)

            if order.status == .cancelled {
                Text("Cancelled")
                    .font(.caption2.bold())
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(.red.opacity(0.2))
                    .foregroundStyle(.red)
                    .clipShape(Capsule())
            } else if let onCancel {
                Button(role: .destructive, action: onCancel) {
                    Label("Cancel booking", systemImage: "xmark.circle")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }
}
