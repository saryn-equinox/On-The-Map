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
        activityIndicator.hidesWhenStopped = true
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        username.text = "haotingqiu@gmail.com"
        password.text = "Ea$onYau1997"
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        toggleActivityIndicator(true)
        _ = OTMClient.postUdaSession(username: username.text ?? "", password: password.text ?? "", completion: handleLoginReponse(data:error:))
        toggleActivityIndicator(false)
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
    
    func handleLoginReponse(data: UdaSessionResponse?, error: Error?) {
        guard let data = data else {
            showLoginFailure(message: error!.localizedDescription)
            return
        }
        OTMClient.Auth.sessionId = data.session.id
        OTMClient.Auth.userId = data.account.key
        let mainVC = self.storyboard!.instantiateViewController(identifier: "main") as! MainViewController
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    func showLoginFailure(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

