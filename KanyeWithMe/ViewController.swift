//
//  ViewController.swift
//  KanyeWithMe
//
//  Created by Nicholas Bittencourt  on 2020-11-27.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let networker = Networker.shared
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var getQuoteButton: UIButton!
    @IBOutlet weak var saveQuoteButton: UIButton!
    
    var currentQuote: KanyeQuote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveQuoteButton.isHidden = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    
    }

    @IBAction func getQuote(_ sender: Any) {
        
        networker.getQuote() { quote, error in
            
            if let error = error {
                print(error)
            }
            
            guard let quote = quote else {return}
            
            self.currentQuote = quote
                                
            DispatchQueue.main.async {
                
                self.quoteLabel.text = self.currentQuote?.quote
                self.saveQuoteButton.isHidden = false
                
            }
        }
    }
    
    func getTimeStamp() -> String {
        
        let currentDate = Date()
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        return format.string(from: currentDate)
    }
    
    @IBAction func saveQuote(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let quoteFetch: NSFetchRequest<Quote> = Quote.fetchRequest()
        
        var storedQuotes: [Quote] = []
        
        do {
            
            storedQuotes = try context.fetch(quoteFetch)
            
        } catch {
            print("Error")
        }
        
        let containsQuote = storedQuotes.contains { quote in
            
            if (currentQuote?.quote == quote.quote) {
                self.showToast(message: "You've already saved this quote!", font: .systemFont(ofSize: 16.0))
                return true
            } else {
                return false
            }
        }
        
        if(!containsQuote) {
            
            let newQuote = Quote(context: context)
            newQuote.quote = currentQuote?.quote
            newQuote.timestamp = getTimeStamp()

            if(locationManager.authorizationStatus == .authorizedWhenInUse ||
                locationManager.authorizationStatus == .authorizedAlways) {
                
                guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
                
                if( locValue.latitude != 0 || locValue.longitude != 0) {
                    
                    newQuote.latitude = locValue.latitude
                    newQuote.longitude = locValue.longitude
                }
            }
            
            appDelegate.saveContext()
        }
    }
}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 140, y: self.view.frame.size.height-250, width: 300, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 3.5, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
