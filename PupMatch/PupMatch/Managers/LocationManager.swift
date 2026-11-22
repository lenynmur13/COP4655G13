//
//  LocationManager.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/22/26.
//

import Foundation
import CoreLocation
import Observation

@MainActor
@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    var location: CLLocation?            // latest position; nil until a fix arrives or if denied
    var status: CLAuthorizationStatus = .notDetermined

    @ObservationIgnored private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer // coarse is plenty for three labels
        status = manager.authorizationStatus
    }

    var isAuthorized: Bool { status == .authorizedWhenInUse || status == .authorizedAlways }
    var isDenied: Bool { status == .denied || status == .restricted }

    // asks for permission the first time, otherwise refreshes the position
    func start() {
        switch manager.authorizationStatus {
        case .notDetermined: manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways: manager.requestLocation()
        default: break
        }
    }

    // delegate callbacks arrive off the main actor, so copy the values and hop back
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let newStatus = manager.authorizationStatus
        Task { @MainActor in
            self.status = newStatus
            if self.isAuthorized { self.manager.requestLocation() }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        Task { @MainActor in self.location = latest }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // required for requestLocation; a failed fix just means no label this time
    }
}

// the three labels the UI shows instead of miles
enum Proximity: String {
    case nearby = "Nearby"
    case medium = "Medium distance"
    case far = "Far"

    // nil when either side has no coordinates, so the UI simply hides the label
    static func between(_ user: CLLocation?, and dog: Dog) -> Proximity? {
        guard let user, let lat = dog.latitude, let lon = dog.longitude else { return nil }
        let km = user.distance(from: CLLocation(latitude: lat, longitude: lon)) / 1000
        switch km {
        case ..<30: return .nearby       // roughly the same metro area
        case ..<150: return .medium      // a drive of under a couple of hours
        default: return .far
        }
    }
}
