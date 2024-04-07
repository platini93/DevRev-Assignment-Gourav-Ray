//
//  AppConstants.swift
//  DevRev-assignment-Gourav_Ray
//
//  Created by Gourav Ray on 03/04/24.
//

import Foundation
import UIKit

/// AppConstants
enum AppConstants {
    enum Logs {
        case enabled
        var value:Bool {
            switch self {
            case .enabled: return false // toggle
            }
        }
    }
    enum APIConstants {
        case apiReadAccessToken
        var value:String {
            switch self {
            case .apiReadAccessToken:
                return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMjZjNzljNzNiYmFiODUzY2Q2YzNiYjI0N2Y1MjM5NiIsInN1YiI6IjY2MGMwZjIzOWM5N2JkMDE3Y2E1MmJiZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.38abOtdOdv-AfVpxX7HjLKwv6MsJUfzAi8V-E0jEIPA"
            }
        }
    }
    enum UDKeys {
        case configurationResponse
        case genresResponse
        var value:String {
            switch self {
            case .configurationResponse: return "configurationResponse"
            case .genresResponse: return "genresResponse"
            }
        }
    }
    enum CollectionViewCells {
        case moviesList
        var value:String {
            switch self {
            case .moviesList: return "MoviesListCollectionViewCell"
            }
        }
    }
    enum TableViewCells {
        case movieDetailsTop
        case movieDetailsBottom
        var value:String {
            switch self {
            case .movieDetailsTop: return "MovieDetailsTop"
            case .movieDetailsBottom: return "MovieDetailsBottom"
            }
        }
    }
    enum Storyboards {
        case main
        var value:UIStoryboard {
            switch self {
            case .main: return createStoryboard(name: "Main")
            }
        }
        func createStoryboard(name:String) -> UIStoryboard {
            return UIStoryboard(name: name, bundle: nil)
        }
    }
    enum ViewControllers {
        case movieLists
        case movieDetails
        var value:String {
            switch self {
            case .movieLists: return "MoviesListViewController"
            case .movieDetails: return "MovieDetailsViewController"
            }
        }
    }
    enum SelectedSegment:Int {
        case latest = 0
        case popular = 1
    }
    enum Images {
        case placeholder
        case background
        var value:String {
            switch self {
            case .placeholder: return "image"
            case .background: return "background"
            }
        }
    }
    enum Notifications{
        case networkLost
        case networkConnected
        var value:String {
            switch self {
            case .networkLost: return "NetworkConnectionLost"
            case .networkConnected: return "NetworkConnected"
            }
        }
    }
    enum SegmentNames{
        case latest
        case popular
        var value:String {
            switch self {
            case .latest: return "Latest"
            case .popular: return "Popular"
            }
        }
    }
}


