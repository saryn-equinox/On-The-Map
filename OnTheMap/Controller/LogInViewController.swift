//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by 邱浩庭 on 27/12/2020.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.hidesWhenStopped = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        handleLoginReponse()
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com")!, options: [:], completionHandler: nil)
    }
    
    func toggleActivityIndicator(_ run: Bool) {
        if (run) {
            activityIndicator.startAnimating();
        } else {
            activityIndicator.stopAnimating();
        }
    }
    
    func handleLoginReponse() {
        let mainVC = self.storyboard!.instantiateViewController(identifier: "main")
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
}

