//
//  MapViewController.swift
//  KanyeWithMe
//
//  Created by Nicholas Bittencourt  on 2020-11-27.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var quotesList: [Quote] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadQuotes()
        addPins()
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            
        let center = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)

    }
    
    func addPins() {
        
        removePins()
        quotesList.forEach{ quote in
            
            let center = CLLocationCoordinate2D(latitude: quote.latitude, longitude: quote.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            
            annotation.title = quote.quote!
            mapView.addAnnotation(annotation)
        }
    }
    
    func removePins() {
        
        let annotations = self.mapView.annotations
        
        annotations.forEach{ annotation in
            
            mapView.removeAnnotation(annotation)
            
        }
                    
    }

    
    func loadQuotes(){
        
        quotesList = []
                
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let quoteFetch: NSFetchRequest<Quote> = Quote.fetchRequest()
        
        do {
            
            quotesList = try context.fetch(quoteFetch)
            
        } catch {
            print("Error")
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView?.clusteringIdentifier = "PinCluster"
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}


