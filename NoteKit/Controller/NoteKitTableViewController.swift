//
//  NoteKitTableViewController.swift
//  NoteKit
//
//  Created by Pin Truong on 28/09/2022.
//

import UIKit
import CoreData

    var noteKitList = [Note]()

class NoteKitTableViewController: UITableViewController
{

    
    var firstLoadAppD = true
    
    
    func delNotes() -> [Note] {
        var noDelNoteKitList = [Note]()
        for note in noteKitList {
            if(note.delDate == nil) {
                noDelNoteKitList.append(note)
            }
        }
        return noDelNoteKitList
    }
    @IBOutlet var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// -> Hiển thị tất cả dữ liệu đã dc lưu full if-else
       if(firstLoadAppD) {
            firstLoadAppD = false
            /// Lấy Appdelegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            /// Lấy managedObjec
            let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let requestFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results: NSArray = try managedContext.fetch(requestFetch) as NSArray
                for result in results {
                    let note = result as! Note
                    noteKitList.append(note)
                }
            }
            catch {
                print("Fetch thất bại.")
            }
        }
        tableview.delegate = self
        tableview.dataSource = self
        
        
    }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    override func viewDidAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return delNotes().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHere", for: indexPath) as! NoteKitTableViewCell
        
        let noteHere: Note!
        noteHere = delNotes()[indexPath.row]
        cell.titleLabel.text = noteHere.title
        cell.contentLabel.text = noteHere.content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNoteHere", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editNoteHere") {
            let indexPath = tableView.indexPathForSelectedRow!
            let noteDetail = segue.destination as? NavNoteKitViewController
            
            let selectedNote: Note!
            selectedNote = delNotes()[indexPath.row]
            noteDetail?.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }


}
