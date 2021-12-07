//
//  LocationHelper.swift
//  WalkIt
//
//  Created by Arzen Edillo on 2021-11-08.
//

import Foundation
import Combine
import CoreLocation
import MapKit
import Contacts



class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var address : String = "unknown"
    @Published var currentLocation : CLLocation?
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.442626, longitude: -121.891), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var lastSeenLocation: CLLocation?
    override init() {
        super.init()
        
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        //check for permission
        checkPermission()
        
        if (CLLocationManager.locationServicesEnabled() && (self.authorizationStatus == .authorizedAlways || self.authorizationStatus == .authorizedWhenInUse)){
            self.locationManager.startUpdatingLocation()
        }else{
            self.requestPermission()
        }
        
    }
    
    deinit{
        self.locationManager.stopUpdatingLocation()
    }
    
    func requestPermission(){
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkPermission(){
        print(#function, "Checking for permission")
        
        switch self.locationManager.authorizationStatus{
        case .denied:
            print("You have denied this app location permission. Go into settings to change it.")
        case .notDetermined:
            self.requestPermission()
        case .restricted:
            print("Your location is likely due to parental controls")
        case .authorizedAlways, .authorizedWhenInUse:
            //get location updates
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "Authorization Status : \(manager.authorizationStatus.rawValue)")
        checkPermission()
        self.authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.last != nil{
            //most recent
            self.currentLocation = locations.last!
        }else{
            //oldest known
            self.currentLocation = locations.first
        }
        
        self.lastSeenLocation = locations.first
        print(#function, "Last seen location: \(self.lastSeenLocation)")
        print(#function, "Current location: \(self.currentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Error: \(error.localizedDescription)")
    }
    
    func addPinToMapView(mapView: MKMapView, coordinates: CLLocationCoordinate2D, title: String?){
        
        let mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = coordinates
        
        if let title = title {
            mapAnnotation.title = title
        }else{
            mapAnnotation.title = self.address
        }
        
        mapView.addAnnotation(mapAnnotation)
    }
    
}
