//
//  RootTabView.swift
//  CinmaBooking
//


import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MovieListView()
            }
            .tabItem {
                Label("Movies", systemImage: "film")
            }

            NavigationStack {
                OrdersView()
            }
            .tabItem {
                Label("My Orders", systemImage: "ticket")
            }
        }
        .tint(.orange)
    }
}
