//
//  QuoteViewController.swift
//  KanyeWithMe
//
//  Created by Nicholas Bittencourt  on 2020-12-02.
//

import UIKit
import MapKit
import CoreLocation

class QuoteViewController: UIViewController {
    
    var quote: Quote?
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quoteLabel.text = quote?.quote
        timestampLabel.text = quote?.timestamp
        
        if let latitude = quote?.latitude, let longitude = quote?.longitude {
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: center, span: span)
            map.setRegion(region, animated: true)
            map.addAnnotation(annotation)
        }
    }
}
