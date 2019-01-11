//
//  ViewController.swift
//  SearchVenue
//
//  Created by John Lester Celis on 11/01/2019.
//  Copyright © 2019 John Lester Celis. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let locationManager  = CLLocationManager()
    var alreadyCalled = false
    fileprivate var searchVenue: [Venue] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        if !alreadyCalled {
            alreadyCalled = true
            getRequestMethod("\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)") { (res: Result<FirstResponse>) in
                switch res {
                case .success(let result):
                    self.searchVenue = result.response.venues
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .error(let err):
                    print("ERROR: \(err)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            if let destinationVC = segue.destination as? DetailViewController {
                let row = (sender as! NSIndexPath).row
                destinationVC.detailVenue = self.searchVenue[row]
            }
        }
    }
}


extension ViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchVenue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ListCell")
        let venue = self.searchVenue[indexPath.row]
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = "\(venue.location.distance) m"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToDetail", sender: indexPath)
    }
}

