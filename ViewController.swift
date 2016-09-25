//
//  ViewController.swift
//  CookieQuiet
//
//  Created by Kevin Lu on 9/25/16.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // All the ids in the locations array must match the ids in the firebase database
        let locations = ["aud", "r101", "r102", "r105"]
        let names = ["Auditorium", "Room 101", "Room 102", "Room 103"]
        // For each id in the locations array there must be a 0 in the ranks and sorted arrays
        var ranks: [Int] = [0, 0, 0, 0]
        var sorted: [Int] = [0, 0, 0, 0]
        
        let ref = FIRDatabase.database().reference()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            
            var i = 0
            for location in locations {
                //print(dict?[location])
                let s = dict?[location] as! Int
                print(s)
                ranks[i] = s
                sorted[i] = s
                i += 1
            }
            
            sorted.sort()
            
            for rank in 0...(locations.count - 1) {
                for l in 0...(locations.count - 1) {
                    if (sorted[rank] == ranks[l]) {
                        // Set the next availiable table cell to names[l]
                        // tableCellProtocol.image and stuff = ...
                        // tableCellProtocol.text = names[l] etc.
                        break;
                    }
                }
            }
        })
    }

    // Connect changeRating with an @IBAction to the happy/sad face buttons
    func changeRating(positive: Bool, id: String) {
        // If positive is true, then the rating will go lower (quieter); else higher
        // id is equal to "aud", "r101", etc.
        
        var old = 0
        let ref = FIRDatabase.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            old = dict?[id] as! Int
            
            // If the value is bounded by 0 or 100, then break out
            if ((old <= 0 && positive) || (old >= 100 && !positive)) {
                return
            }
            
            // If postive, decrease, else increase
            if (positive) {
                old -= 1
            } else {
                old += 1
            }
            
            ref.updateChildValues([id: old])
        })
    }
}

