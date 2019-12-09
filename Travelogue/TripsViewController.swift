//
//  TripsViewController.swift
//  Travelogue
//
//  Created by Carmel Braga on 12/7/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//

import UIKit
import CoreData

class TripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tripTableView: UITableView!
    
        var trips = [Trip]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            tripTableView.dataSource = self 
            tripTableView.delegate = self
            
            // Do any additional setup after loading the view.
        }
        
        override func viewWillAppear(_ animated: Bool) {
            fetchTrips(searchString: "")

        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
    @IBAction func add(_ sender: Any) {
  
            let alert = UIAlertController(title: "Add Trip", message: "Enter new trip name.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {
                (alertAction) -> Void in
                if let textField = alert.textFields?[0], let name = textField.text {
                    let tripName = name.trimmingCharacters(in: .whitespaces)
                    if (tripName == "") {
                        print("Trip not created.\nThe name must contain a value.")
                        return
                    }
                    self.addNew(name: tripName)
                } else {
                    print("Trip not created.\nThe name is not accessible.")
                    return
                }
                
            }))
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter trip name."
                textField.isSecureTextEntry = false
                
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        func addNew(name: String) {
        
            let trip = Trip(name: name)
            
            if let trip = trip {
                do {
                    let managedObjectContext = trip.managedObjectContext
                    try managedObjectContext?.save()
                } catch {
                    print("Failed.")
                }
            }
            
            fetchTrips(searchString: "")

        }
        
        func fetchTrips(searchString: String) {
               guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                   return
               }
               let managedContext = appDelegate.persistentContainer.viewContext
               let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
               fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
               do {
                   if (searchString != "") {
                       fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", searchString)
                   }
                   trips = try managedContext.fetch(fetchRequest)
                   tripTableView.reloadData()
               } catch {
                   print("Fetch could not be performed")
               }
           }
           
        
        func delete(at indexPath: IndexPath) {
            let trip = trips[indexPath.row]
            
            if let managedObjectContext = trip.managedObjectContext {
                managedObjectContext.delete(trip)
                
                do {
                    try managedObjectContext.save()
                    self.trips.remove(at: indexPath.row)
                    tripTableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    print("Delete failed: \(error).")
                    tripTableView.reloadData()
                }
            }
        }
        
        func update(at indexPath: IndexPath, name: String) {
            let trip = trips[indexPath.row]
            trip.name = name
            
            if let managedObjectContext = trip.managedObjectContext {
                do {
                    try managedObjectContext.save()
                } catch {
                    print("Update failed.")
                    tripTableView.reloadData()
                }
            }
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return trips.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
                   
                   let trip = trips[indexPath.row]
                   cell.textLabel?.text = trip.name
                   
                   return cell
        }
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
              let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
                     action, index in
                     self.delete(at: indexPath)
                 }
                 
                 
                 return [delete]
            }
            
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? LogsViewController,
                let row = tripTableView.indexPathForSelectedRow?.row {
                destination.trip = trips[row]
            }
        }

    }
