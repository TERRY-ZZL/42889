# CinmaBooking — Assignment 3


A simple iOS movie ticket booking application built with SwiftUI.

This project was developed step by step across multiple versions.  
The app allows users to browse movies, view showtimes, select seats, confirm bookings, and view saved order history.

---

# Features

## Movie List
- Display movies loaded from local JSON data
- Search movies by title or genre
- Show movie posters, ratings, duration, and genres

## Movie Details
- View movie synopsis
- View available showtimes
- Navigate to seat selection

## Seat Selection
- Interactive cinema seat layout
- Select and deselect seats
- Prevent booking already sold seats
- Limit maximum seat selection

## Booking System
- Confirm ticket booking
- Generate order information
- Show booking confirmation page

## Order History
- View previous bookings
- Cancel confirmed bookings
- Separate confirmed and cancelled orders

## Local Persistence
- Save orders using UserDefaults
- Restore orders after restarting the app

---

# Technologies

- Swift
- SwiftUI
- Combine
- UserDefaults
- JSONDecoder

---

# Project Structure


CinmaBooking
├── Models
│   ├── Movie.swift
│   ├── Showtime.swift
│   ├── Seat.swift
│   ├── Order.swift
│   └── BookingError.swift
│
├── Services
│   ├── BookingService.swift
│   └── MovieRepository.swift
│
├── Stores
│   └── BookingStore.swift
│
├── Views
│   ├── MovieListView.swift
│   ├── MovieDetailView.swift
│   ├── SeatSelectionView.swift
│   ├── OrderConfirmationView.swift
│   ├── OrdersView.swift
│   └── RootTabView.swift
│
├── Resources
│   └── movies.json
│
└── Assets.xcassets



# Data Source

Movie data is loaded from:

Resources/movies.json

Movie posters are stored in:

Assets.xcassets

# How to Run
Open the project in Xcode
Select an iOS simulator
Press Run

# Author

Zelong Zhao 24612855 （vision1，vision2，vision6.1，GitHub version control and upload）

Jiaqi Pan 25656113（vision3，vision4）

Hanting Wang 25246036 （vision5&5.5，vision6&6.2）

University of Technology Sydney (UTS)
