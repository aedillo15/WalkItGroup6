//
//  MapScreen.swift
//  WalkIt
//
//  Created by user on 2021-10-04.
//

import SwiftUI
import MapKit


struct MapScreen: View {
    @ObservedObject var loggedInPlayer = Player()

    
    @EnvironmentObject var locationHelper : LocationHelper
    //@State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64253, longitude: -79.38201), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        VStack{
            
            
            if (self.locationHelper.currentLocation != nil){
                //show current location on Map
                MyMap(location: self.locationHelper.currentLocation!)
            }else{
                Text("Obtaining user location...")
            }
        }
        .onAppear(){
            self.locationHelper.checkPermission()
        }
        
        Text("Current Token Count: \(loggedInPlayer.tokenCount)")
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
    
}

struct MyMap : UIViewRepresentable{
    private var location: CLLocation
    @EnvironmentObject var locationHelper: LocationHelper
    let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    
    init(location: CLLocation){
        self.location = location
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let sourceCoordinates : CLLocationCoordinate2D
        let region: MKCoordinateRegion
        
        if (self.locationHelper.currentLocation != nil){
            sourceCoordinates = self.locationHelper.currentLocation!.coordinate
        }else{
            sourceCoordinates = CLLocationCoordinate2D(latitude: 43.642567, longitude: -79.387024)
        }
        
        region = MKCoordinateRegion(center: sourceCoordinates, span: span)
        
        let map = MKMapView(frame: .infinite)
        
        map.mapType = MKMapType.standard
        map.showsUserLocation = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isUserInteractionEnabled = true
        
        map.setRegion(region, animated: true)
        self.locationHelper.addPinToMapView(mapView: map, coordinates: sourceCoordinates, title: "You're Here")
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //update map to show current location
        let sourceCoordinates : CLLocationCoordinate2D
        let region: MKCoordinateRegion
        
        if (self.locationHelper.currentLocation != nil){
            sourceCoordinates = self.locationHelper.currentLocation!.coordinate
        }else{
            sourceCoordinates = CLLocationCoordinate2D(latitude: 43.642567, longitude: -79.387024)
        }
        
        region = MKCoordinateRegion(center: sourceCoordinates, span: span)
        
        uiView.setRegion(region, animated: true)
        self.locationHelper.addPinToMapView(mapView: uiView, coordinates: sourceCoordinates, title: "You're Here")
        
    }
    
    typealias UIViewType = MKMapView
    
    
}

