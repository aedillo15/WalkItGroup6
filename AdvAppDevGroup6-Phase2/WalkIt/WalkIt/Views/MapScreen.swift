//
//  MapScreen.swift
//  WalkIt
//
//  Created by user on 2021-10-04.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id = UUID()
    let name : String
    let coordinate : CLLocationCoordinate2D
    let coinValue : Int
}

struct MapScreen: View {
    @ObservedObject var loggedInPlayer = Player()
    @State private var showAward = false
    @State private var reachedToken = false
    
//    @ObservedObject var locationHelper = LocationHelper()
    @EnvironmentObject var locationHelper : LocationHelper
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64253, longitude: -79.38201), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    //annotations location of place with tokens
    let annotations = [
        Place(name: "Sheridan College - Trafalgar", coordinate: CLLocationCoordinate2D(latitude:43.46874300, longitude:-79.69862200), coinValue: 10),
        Place(name: "Sheridan College - Residence", coordinate: CLLocationCoordinate2D(latitude:43.468580, longitude:-79.697768), coinValue: 10),
        Place(name: "Sheridan College - Book Store", coordinate: CLLocationCoordinate2D(latitude:43.468624, longitude:-79.700141), coinValue: 10),
        Place(name: "2000 Garth Plaza", coordinate: CLLocationCoordinate2D(latitude:43.196512, longitude:-79.918212), coinValue: 10)
    ]
    func roundToFive(x : Double) -> Int {
        return 5 * Int(round(x / 5.0))
    }
    func checkLocationObtainToken()
    {
        for place in annotations{
            //Winning
            var winningCoordinate = place.coordinate

            var getLat = winningCoordinate.latitude
            var getLon = winningCoordinate.longitude
//            print(#function, self.locationHelper.currentLocation)
            let winningObject = CLLocation(latitude: getLat, longitude: getLon)
            //Current/User Location
            var getCurrentLat = self.locationHelper.currentLocation?.coordinate.latitude ?? 0.0
            var getCurrentLon = self.locationHelper.currentLocation?.coordinate.longitude ?? 0.0
            let userObject = CLLocation(latitude: getCurrentLat, longitude: getCurrentLon)
            let distance = userObject.distance(from: winningObject)    //distance between winningLoaction & userLocation

            var distanceToFive = roundToFive(x: distance)
            
            if (distanceToFive < 5){ //If user is within 5 meters, award user
                loggedInPlayer.tokenCount += place.coinValue;
                reachedToken = true
                //show alert the amount they have been awarded

                
            }

        }
            
    }
        
    var body: some View {
        VStack{
            //MyMap(location: self.locationHelper.currentLocation!)
                Map(coordinateRegion: $locationHelper.region, showsUserLocation: true, annotationItems: annotations) { place in
                    MapAnnotation(coordinate: place.coordinate){
                        Button(action: {
                            
                        } ){
                            HStack {
                                Image(systemName: "bitcoinsign.circle")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 60))

                            }.padding(10)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                            .overlay(
                                Image(systemName: "arrowtriangle.left.fill")
                                    .rotationEffect(Angle(degrees: 270))
                                    .foregroundColor(.white)
                                    .offset(y: 10)
                                , alignment: .bottom)
                        }.alert(isPresented: $reachedToken, content: {
                            Alert(title: Text("You have reached \(place.name) and have been awarded with \(place.coinValue) tokens"))
                        })
                        
                        
                    }
                }
                    .ignoresSafeArea()
                    .accentColor(Color(.systemPink))
                    .onAppear(){
                        locationHelper.checkPermission()
                        
                        //Thank you for signing in, you have earned +1 token
                        
                        
                        loggedInPlayer.tokenCount += 1
                        checkLocationObtainToken()
                        
                    }
        }
            //show current location on Map location: self.locationHelper.currentLocation!
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
    

