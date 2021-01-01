//
//  NewPinViewController.swift
//  OnTheMap
//
//  Created by 邱浩庭 on 31/12/2020.
//

import UIKit
import CoreLocation

class NewPinViewController: UIViewController {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var mediaLink: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Location", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.title = "Add Location"
        // Do any additional setup after loading the view.
    }
    
    @objc private func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func findLocationTapped(_ sender: Any) {
        let geoDecoder = CLGeocoder()
        geoDecoder.geocodeAddressString(location.text ?? "") { (placemarks, error) in
            if (error != nil) {
                self.showFailure(message: "Cannot parse mapString to coordinate")
                return
            }
            
            let placemark = placemarks?.first
            guard let lat = placemark?.location?.coordinate.latitude else {
                self.showFailure(message: "Cannot parse mapString to coordinate")
                return
            }
            guard let lon = placemark?.location?.coordinate.longitude else {
                self.showFailure(message: "Cannot parse mapString to coordinate")
                return
            }
            let previewVC =  (self.storyboard?.instantiateViewController(identifier: "preview")) as! PreviewViewController
            
            previewVC.lat = lat
            previewVC.lon = lon
            previewVC.location = self.location.text ?? ""
            previewVC.meadiaURL = self.mediaLink.text ?? ""
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    
    func showFailure(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "AddLocation Alert", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
