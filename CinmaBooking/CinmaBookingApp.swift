//
//  CinmaBookingApp.swift
//  CinmaBooking
//
//  Entry point of the app. Creates the shared BookingStore and injects it
//  into the environment for every SwiftUI view to access.
//

import SwiftUI

@main
struct CinemaBookingApp: App {
    @StateObject private var store = BookingStore()

    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}
 
