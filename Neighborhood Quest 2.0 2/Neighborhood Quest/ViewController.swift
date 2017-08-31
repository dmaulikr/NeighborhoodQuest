//
//  ViewController.swift
//  Neighborhood Quest
//
//  Created by Kenneth James on 11/18/16.
//  Copyright © 2016 Kenneth James. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib
        
        let initialLocation = CLLocation(latitude: 30.2747, longitude: -97.7404)
        
        centerMapOnLocation(initialLocation)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        // show regions and pins on map
        setupData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. authorization was denied
        else if CLLocationManager.authorizationStatus() == .Denied {
            let alertController = UIAlertController(title: "Warning", message: "Location services were previously denied. Please enable location services for this app in Settings.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "Close Alert", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.cyanColor()
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    func setupData() {
        var i = 0.0;
        var j = 0.0;
        var count = 1
        let inc = 0.005
        let latStart = 30.245893
        let longStart = -97.777885
        var lat = latStart
        var long = longStart
        // 1. check if system can monitor regions
        if CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion.self) {
            while i <= 15 {
                while j <= 15 {
            // 2. region data
            let title = String(i)
            lat = lat + inc
            let coordinate = CLLocationCoordinate2DMake(lat, long)
            let regionRadius = 300.0
            
            // 3. setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            
            locationManager.startMonitoringForRegion(region)
            
            // 4. setup annotation
            let questPin = Artwork(title: "Quest Pin #" + String(count),
                                  locationName: "Austin",
                                  discipline: "Building",
                                  coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            mapView.addAnnotation(questPin)
            
            // 5. setup circle
            let circle = MKCircle(centerCoordinate: coordinate, radius: regionRadius)
            mapView.addOverlay(circle)
                    j = j + 1.0
                    count = count + 1
                }
                long = long + inc
                lat = latStart
                i = i + 1.0
                j = 0
            }
        }
        else {
            print("System can't track regions")
        }
    }

    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if (control == view.rightCalloutAccessoryView) {
            performSegueWithIdentifier("Begin Quest", sender: view)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
                view.pinTintColor = UIColor.blueColor()
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                view.pinTintColor = UIColor.blueColor()
            }
            return view
        }
        return nil
    }
    
    
    //CLRegion methods
    @IBAction func getLocation(sender: MKMapView) {
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NSLog("Entering region")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        NSLog("Exit region")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("\(error)")
    }
    
    
    
}

