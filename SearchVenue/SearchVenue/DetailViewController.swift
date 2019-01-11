//
//  DetailViewController.swift
//  SearchVenue
//
//  Created by John Lester Celis on 11/01/2019.
//  Copyright © 2019 John Lester Celis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var detailVenue: Venue?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = detailVenue?.name
        
        self.addressLabel.text = detailVenue?.location.formattedAddress.reduce("") { "\($0 ?? "")\n\($1)" }
    }
}
