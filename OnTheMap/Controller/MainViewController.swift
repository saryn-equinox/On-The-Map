//
//  MainViewController.swift
//  OnTheMap
//
//  Created by 邱浩庭 on 27/12/2020.
//

import UIKit
import Foundation

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addTapped))
        let refresh = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refreshTapped))
        self.navigationItem.rightBarButtonItems = [add, refresh]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutTapped))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "On The Map"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        OTMClient.getStudentLocations(completion: handleGetLocationsRespnse(data:error:))
        AppData.mainVC = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTapped()
    }
    
    @objc private func addTapped() {
        let newPinVC = (self.storyboard?.instantiateViewController(identifier: "addPin"))!
        
        self.navigationController?.pushViewController(newPinVC, animated: true)
    }
    
    @objc private func refreshTapped() {
        (self.viewControllers![0] as! MapViewController).updateAnnotations()
        (self.viewControllers![1] as! TableViewController).updateAnnotations()
    }
    
    @objc private func logoutTapped() {
        _ = OTMClient.deleteUdaSession(completion: handleLogoutResponse(data:error:))
    }
    
    func handleGetLocationsRespnse(data: StudentsLocationResult?, error: Error?) {
        if (error != nil) {
            showLogoutFailure(title: "Get Students Data Failed", message: error!.localizedDescription)
            return
        }
        AppData.studentsLocation = data!.results
        refreshTapped()
    }
    
    func handleLogoutResponse(data: UdaLogoutResponse?, error: Error?) {
        if (error != nil) {
            showLogoutFailure(title: "Logout Failed", message: error!.localizedDescription)
            return
        }
        
        OTMClient.resetUserInfo()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showLogoutFailure(title: String, message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
}
