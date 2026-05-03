//
//  CinemaBookingApp.swift
//  CinemaBooking
//
//

import SwiftUI

@main
struct CinemaBookingApp: App {
@StateObject private var store = BookingStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)

        }
    }
}

