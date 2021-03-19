//
//  FriendVM.swift
//  ScrollViewStickyTopSearchBar
//
//  Created by Maxim Macari on 19/3/21.
//

import SwiftUI
import CoreLocation


class FriendVM: ObservableObject, Identifiable{
    
    @Published var friend: Friend
    
    let locationManager = CLLocationManager()
    
    init(friend: Friend) {
        self.friend = friend
    }
    
    private var distanceInBetween: Double? {
        let currentLocation = CLLocation(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        let friendLocation = CLLocation(latitude: friend.latitude, longitude: friend.longitude)
        
        let distanceMeters = currentLocation.distance(from: friendLocation)
        return distanceMeters / 1000
    }
    
    var distanceDetail: String {
        if let distance = distanceInBetween {
            return "\(String(format: "%.2f", distance)) km away"
        } else {
          return ""
        }
        
    }
    
}

