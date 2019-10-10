//
//  ViewController.swift
//  TacoTracker
//
//  Created by Eric Fuentes on 1/25/19.
//  Copyright © 2019 Eric Fuentes. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import WebKit
import GoogleMaps


class ViewController: UIViewController, UISearchBarDelegate {
    //google AIzaSyCq2LmwTHasnqqJuZs3A6ngyC0ZRiqtgoQ
    var googleView : GoogleMaps?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tacoLogo: UIImageView!
    
    private let locationManager = CLLocationManager()
    var wkViewController: WkView?
    let web = WKWebView()
    private var currentCoordinate: CLLocationCoordinate2D?
    
    @IBAction func searchButton(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func mapSwitch(_ sender: UISegmentedControl) {
        self.googleView = GoogleMaps()
        
        if sender.selectedSegmentIndex == 0 {
            
        }else{
            self.navigationController?.pushViewController( self.googleView! , animated: false)

        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.configureLocationService()
        self.addAnotation()
        
        mapView.delegate = self
        
//REVIEW
//        let logo = UIImage(named: "e9f70459fc4462131316b495865cd4f8-taco-icon-cartoon-by-vexels")
//
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
        
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        //activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        //hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        
        //create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print("ERROR")
            }
            else{
                //Remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //get data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                if let items = response?.mapItems  {
                    
                    for mapitem in items  {
                        
                         print(mapitem.name)
                        print(mapitem.placemark.title)
                        print(mapitem.placemark.coordinate)
                        
                        let annotation = MKPointAnnotation()
                        
                        annotation.title = mapitem.placemark.name!
                        annotation.subtitle = mapitem.placemark.title!
                        annotation.coordinate = CLLocationCoordinate2DMake(mapitem.placemark.coordinate.latitude, mapitem.placemark.coordinate.longitude)
                        self.mapView.addAnnotation(annotation)
                    
                
                    }
                    
                }
                
                
                
                //create annotation
               
                
                //zooming in on annotation
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate,span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
        
        private func configureLocationService() {
            locationManager.delegate = self
            let status = CLLocationManager.authorizationStatus()
            
            if status == .notDetermined{
                locationManager.requestAlwaysAuthorization()
            } else if status == .authorizedAlways || status == .authorizedWhenInUse{
                beginLocationUpdates(locationManager: locationManager)
            }
        }
    private func beginLocationUpdates(locationManager: CLLocationManager ){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D){
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    private func addAnotation() {
        
        
        let taco1 = MKPointAnnotation()
        taco1.title = "Oaxaca Taqueria"
        taco1.coordinate = CLLocationCoordinate2D(latitude: 40.705490, longitude: -74.008507)
        taco1.subtitle = "oaxacatacos.com"
        
        mapView.addAnnotation(taco1)

        let taco2 = MKPointAnnotation()
        taco2.title = "Dos Toros Taqueria"
        taco2.coordinate = CLLocationCoordinate2D(latitude: 40.706971, longitude: -74.006878)
        taco2.subtitle = "dostoros.com"

        mapView.addAnnotation(taco2)

        let taco3 = MKPointAnnotation()
        taco3.title = "Los tacos City Habanero"
        taco3.coordinate = CLLocationCoordinate2D(latitude: 40.702545, longitude: -74.012962)
        taco3.subtitle = "zmenu.com/los-tacos-city-habanero-long-island-city-online-menu"

        mapView.addAnnotation(taco3)

        let taco4 = MKPointAnnotation()
        taco4.title = "Choza Taqueria - Westfield World Trade Center"
        taco4.coordinate = CLLocationCoordinate2D(latitude: 40.711540, longitude: -74.011383)
        taco4.subtitle = "chozaeats.com"

        mapView.addAnnotation(taco4)
    }

    }

extension ViewController: CLLocationManagerDelegate{
    
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        guard let latestLocation = locations.first else {return}
        
        if currentCoordinate == nil{
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnotation()
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: manager)
        }
    }
    
}



extension ViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tap")
        
        
        self.performSegue(withIdentifier: "webIntro", sender: view)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let view = sender as!  MKAnnotationView
        
        
        print("The Annotation was selected \(String(describing: view.annotation?.subtitle))")
        

        
        let wkView =  segue.destination as! WkView
        wkView.urlString = "https://www.\(view.annotation?.subtitle)"
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
         if let title = annotation.title, title == "Oaxaca Taqueria"{
            annotationView?.image = UIImage(named: "e9f70459fc4462131316b495865cd4f8-taco-icon-cartoon-by-vexels")
            annotationView!.frame.size = CGSize(width: 30.0, height: 30.0)
            
        }
        else if let title = annotation.title, title == "Dos Toros Taqueria"{
            annotationView?.image = UIImage(named: "e9f70459fc4462131316b495865cd4f8-taco-icon-cartoon-by-vexels")
            annotationView!.frame.size = CGSize(width: 30.0, height: 30.0)
            
        }
        else if let title = annotation.title, title == "Los tacos City Habanero"{
            annotationView?.image = UIImage(named: "e9f70459fc4462131316b495865cd4f8-taco-icon-cartoon-by-vexels")
            annotationView!.frame.size = CGSize(width: 30.0, height: 30.0)
            
        }
        else if let title = annotation.title, title == "Choza Taqueria - Westfield World Trade Center"{
            annotationView?.image = UIImage(named: "e9f70459fc4462131316b495865cd4f8-taco-icon-cartoon-by-vexels")
            annotationView!.frame.size = CGSize(width: 30.0, height: 30.0)
        }
        annotationView?.image = UIImage(named: "e9f70459fc4462131316b495865cd4f8-taco-icon-cartoon-by-vexels")
        annotationView?.canShowCallout = true
        annotationView!.frame.size = CGSize(width: 30.0, height: 30.0)
        
        let rightButton = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = rightButton
        
        
        
        
        
        return annotationView!
    }
    
    
    
    @IBAction func mapType(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.standard
            break;
        case 1:
            mapView.mapType = MKMapType.hybridFlyover

            break;
        case 2:
            mapView.mapType = MKMapType.satellite
            break;
        default:
            break;
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The Annotation was selected \(String(describing: view.annotation?.title))")
    }
    
    }




    

