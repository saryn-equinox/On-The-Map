//
//  TableViewController.swift
//  OnTheMap
//
//  Created by 邱浩庭 on 31/12/2020.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.studentsLocation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        let data = AppData.studentsLocation[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(data.firstName) \(data.lastName)"
        cell.detailTextLabel?.text = data.mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let app = UIApplication.shared
        if let toOpen = cell?.detailTextLabel?.text! {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        }
    }
    
    func updateAnnotations() {
        self.tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
