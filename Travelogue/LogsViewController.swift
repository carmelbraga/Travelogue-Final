//
//  LogsViewController.swift
//  Travelogue
//
//  Created by Carmel Braga on 12/7/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//

import UIKit

class LogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var logTableView: UITableView!
    
    var trip: Trip?
        var logs = [Log]()
        let dateFormatter = DateFormatter()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            title = trip?.name ?? ""
            
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            logTableView.dataSource = self as UITableViewDataSource
            logTableView.delegate = self as UITableViewDelegate
        }
        
        override func viewWillAppear(_ animated: Bool) {
            update()
            logTableView.reloadData()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        func update() {
            logs = trip?.log?.sortedArray(using: [NSSortDescriptor(key: "title", ascending: true)]) as? [Log] ?? [Log]()
        }
        
        func delete(at indexPath: IndexPath) {
            let log = logs[indexPath.row]
            
            if let managedObjectContext = log.managedObjectContext {
                managedObjectContext.delete(log)
                
                do {
                    try managedObjectContext.save()
                    self.logs.remove(at: indexPath.row)
                    logTableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                  print("Delete failed.")
                    logTableView.reloadData()
                }
            }
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return logs.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath)
            
            if let cell = cell as? LogTableViewCell {
                let log = logs[indexPath.row]
                cell.titleLabel.text = log.title
                if let rawDate = log.rawDate {
                    cell.dateLabel.text = dateFormatter.string(from: rawDate)
                } else {
                    cell.dateLabel.text = ""
                }
            }
            
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
            if let destination = segue.destination as? NewLogViewController,
                let segueIdentifier = segue.identifier {
                destination.trip = trip
                if (segueIdentifier == "editLog") {
                    if let row = logTableView.indexPathForSelectedRow?.row {
                        destination.log = logs[row]
                    }
                }
            }
        }

    }
