//
//  PlacesViewController.swift
//  Memorable Places
//  Mini project from Udemy (iOS10 & Swift 3 complete developer) course
//
//  Created by admin on 09/01/2018.
//  Copyright © 2018 Josh_Dog101. All rights reserved.
//

import UIKit

class PlacesViewController: UITableViewController {
    
    var places      = [Dictionary<String, String>()]
    var activePlace = -1

    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let tempPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            places = tempPlaces
        }
        
        if places.count == 1 && places[0].count == 0 {
            places.remove(at: 0)
            places.append(["name":"Taj Mahal", "lat":"27.175277", "lon":"78.042128"])
            
            UserDefaults.standard.set(places, forKey: "places")
        }
        
        activePlace = -1
        table.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            places.remove(at: indexPath.row)
            UserDefaults.standard.set(places, forKey: "places")
            table.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        if places[indexPath.row]["name"] != nil {
            cell.textLabel?.text = places[indexPath.row]["name"]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activePlace = indexPath.row
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            let vc         = segue.destination as! MapViewController
            vc.places      = places
            vc.activePlace = activePlace
        }
    }
}
