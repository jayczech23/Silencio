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
        let names = ["Auditorium", "Room 101", "Room 102", "Room 105"]
        // For each id in the locations array there must be a 0 in the ranks and sorted arrays
        var ranks: [Int] = [0, 0, 0, 0]
        var sorted: [Int] = [0, 0, 0, 0]
        
        // This should be varied as per the user's personal profile
        let profile = 1
        let ref = FIRDatabase.database().reference()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            
            var i = 0
            for location in locations {
                var s = dict?[location] as! Int
                
                // For the higher profiles, give higher priorities to the lowest profiles, partly to load balance
                // and partly to adjust for user preferences
                if (s < (profile-1)*2) {
                    s += (profile-1)*1
                } else if (s < (profile-1)*3) {
                    s += (profile-1)*2
                } else if (s < (profile-1)*4) {
                    s += (profile-1)*3
                }
                
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
    
    // Used for load balancing within changeRating()
    func swapProfile(profile: Int) -> Int {
        if (profile == 1) {
            return 5
        } else if (profile == 2) {
            return 4
        } else if (profile == 3) {
            return 3
        } else if (profile == 4) {
            return 2
        } else {
            return 1
        }
    }

    // Connect changeRating with an @IBAction to the happy/sad face buttons
    func changeRating(positive: Bool, id: String, profile: Int) {
        // If positive is true, then the rating will go lower (quieter); else higher
        // id is equal to "aud", "r101", etc.
        
        var old = 0
        let ref = FIRDatabase.database().reference()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            old = dict?[id] as! Int
            
            // Basic load balancing
            var val = 1
            if (old >= 38 && positive) {
                val = profile
            } else if (old <= 12 && positive) {
                val = self.swapProfile(profile: profile)
            } else if (old >= 38 && !positive) {
                val = profile
            } else if (old <= 12 && !positive) {
                val = self.swapProfile(profile: profile)
            }
            
            // If the value is bounded by 0 or 50, then break out
            if ((old - val <= 0 && positive) || (old + val >= 50 && !positive)) {
                return
            }
            
            // If postive, decrease, else increase
            if (positive) {
                old -= val
            } else {
                old += val
            }
            
            ref.updateChildValues([id: old])
        })
    }
}
