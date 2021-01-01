//
//  PreviewViewController.swift
//  OnTheMap
//
//  Created by 邱浩庭 on 31/12/2020.
//

import UIKit
import MapKit

class PreviewViewController: UIViewController {
    @IBOutlet weak var mapview: MKMapView!
    var location: String = ""
    var lat: Double = 0
    var lon: Double = 0
    var meadiaURL: String = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Location"
        mapview.delegate = self
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))

        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = coordinate
        newAnnotation.title = location
        newAnnotation.subtitle = meadiaURL
        mapview.addAnnotation(newAnnotation)
    }
    
    @objc func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        OTMClient.putStudentLocation(mapString: self.location, mediaURL: self.meadiaURL, lastName: "", firstName: "", completion: self.handleUpdatePinRespnse(data:error:))
    }
    
    func handleUpdatePinRespnse(data: UpdateUserMapResponse?, error: Error?) {
        if (error != nil) {
            self.showFailure(message: error?.localizedDescription ?? "Fail for unknown reason")
            return
        }
        
        self.navigationController?.popToViewController(AppData.mainVC!, animated: true)
    }
    
    func showFailure(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "AddLocation Alert", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

extension PreviewViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
