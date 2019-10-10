//
//  GoogleMaps.swift
//  
//
//  Created by Eric Fuentes on 2/27/19.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import WebKit
import GoogleMaps

class GoogleMaps : UIViewController, UISearchBarDelegate, UITextFieldDelegate, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    
 //  private var infoWindow = MapMarkerWindow()
//    fileprivate var locationMarker : GMSMarker? = GMSMarker()
//
    
    
    var tappedMarker = GMSMarker()
  //  var infoWindow = MapMarkerWindow2(frame: CGRect(x: 0, y: 0, width: 300, height: 165))
    
    private let locationManager = CLLocationManager()

    let placez = [Place]()
    
    lazy var googleClient: GoogleClientRequest = GoogleClient()
    var currentLocation: CLLocation = CLLocation(latitude: 40.711540, longitude: -74.011383)

    var searchRadius : Int = 2500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let searchBarButton = UIBarButtonItem(title: "SEARCH", style: .plain, target: self, action: #selector(searchBar))
        self.navigationItem.rightBarButtonItem = searchBarButton
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let camera = GMSCameraPosition.camera(withLatitude: 40.711540, longitude: -74.011383, zoom: 10)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.delegate = self
        self.addmarkers()
        
}

    
    @objc func searchBar() {
        let searchController = UISearchController(searchResultsController: nil)
       searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let locationName = String(searchBar.text!)
        print("the location is \(searchBar.text!)")
        fetchGoogleData(forLocation: currentLocation, locationName: locationName, searchRadius: searchRadius )
    }
    
    
    func addmarkers(){
        
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: 40.711540, longitude: -74.011383)
                marker.title = "Sydney"
                marker.snippet = "Australia"
        
                let marker2 = GMSMarker()
                marker2.position = CLLocationCoordinate2D(latitude: 40.705490, longitude: -74.008507)
                marker2.title = "Oaxaca Taqueria"
                marker2.snippet = "oaxacatacos.com"
        
                let marker3 = GMSMarker()
                marker3.position = CLLocationCoordinate2D(latitude: 40.706971, longitude: -74.006878)
                marker3.title = "Dos Toros Taqueria"
                marker3.snippet = "dostoros.com"
        
        
                let marker4 = GMSMarker()
                marker4.position = CLLocationCoordinate2D(latitude: 40.702545, longitude: -74.012962)
                marker4.title = "Los tacos City Habanero"
                marker4.snippet = "zmenu.com/los-tacos-city-habanero-long-island-city-online-menu"
        
                let marker5 = GMSMarker()
                marker5.position = CLLocationCoordinate2D(latitude: 40.711540, longitude: -74.011383)
                marker5.title = "Choza Taqueria - Westfield World Trade Center"
                marker5.snippet = "chozaeats.com"
                marker5.map = view as? GMSMapView
    }
    
    
    class func instanceFromNib() -> MapMarkerWindowView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MapMarkerWindowView
        
    }
    
    
}


extension GoogleMaps {
    
        func fetchGoogleData(forLocation: CLLocation, locationName: String, searchRadius: Int) {
            googleClient.getGooglePlacesData(forKeyword: locationName, location: currentLocation, withinMeters: 10000) { (response) in
                self.printFirstFive(places: response.results)
            }
        }
    
    /*
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            let location = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
            tappedMarker = marker
           // phoneNumbtoCall = "Add_string_here"
            infoWindow.removeFromSuperview()
            infoWindow = GoogleMaps.instanceFromNib() //make sure to change the name from ViewController to your own ViewController
            infoWindow.name.text = "Add_string_here"
            infoWindow.address.text = "Add_string_here"
            infoWindow.operation.text = "Add_string_here"
            infoWindow.center = mapView.projection.point(for: location)
            self.view.addSubview(infoWindow)
            return false
        }
        */
    
        //delete maybe
        func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
            
            let cv = GoogleMaps.instanceFromNib()
            cv.name.text = marker.title
            cv.address.text = marker.snippet
//            let v =  UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
//            v.text = marker.title
//            v.backgroundColor = .red
            return cv
        }
    
    
    
    
            
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            self.view.bringSubviewToFront(self.view)
            let location = CLLocationCoordinate2D(latitude: tappedMarker.position.latitude, longitude: tappedMarker.position.longitude)
          //  infoWindow.center = mapView.projection.point(for: location)
        }
        
//        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//            infoWindow.removeFromSuperview()
//
//        }


   
        func printFirstFive(places: [Place]) {
            
            for place in places.prefix(5) {
                
                
                print("*******NEW PLACE********")
                
                let name = place.name
                let address = place.address
                let location = ("lat: \(place.geometry.location.latitude), lng: \(place.geometry.location.longitude)")
                
                
                
                guard let open = place.openingHours?.isOpen else {
                    print("\(name) is located at \(address), \(location)")
                    return
                }
                
                if open {

                    print("\(name) is open, located at \(address), \(location)")
                } else {
                    

                    print("\(name) is closed, located at \(address), \(location)")
                }
                
                DispatchQueue.main.async{
                    let position = CLLocationCoordinate2D(latitude: place.geometry.location.latitude, longitude: place.geometry.location.longitude)
                    
                    
                    let marker6 = GMSMarker(position: position)
                    marker6.title = place.name
                    //  marker6.snippet = place.address
                    marker6.map = self.view as? GMSMapView
                        marker6.icon = GMSMarker.markerImage(with: .black)
                }
            }
        }
}

