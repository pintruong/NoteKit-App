//
//  NavNoteKitViewController.swift
//  NoteKit
//
//  Created by Pin Truong on 28/09/2022.
//

import UIKit
import CoreData

class NavNoteKitViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(selectedNote != nil) {
            titleTextField.text = selectedNote?.title
            contentTextView.text = selectedNote?.content
        }
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        
        /// Lấy appDel và ManagedContextObject
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContextObject: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if(selectedNote == nil)
        {
            let entityName = NSEntityDescription.entity(forEntityName: "Note", in: managedContextObject)
            let newNote = Note(entity: entityName!, insertInto: managedContextObject)
            newNote.iD = noteKitList.count as NSNumber
            newNote.title = titleTextField.text
            newNote.content = contentTextView.text
            
            do {
                try managedContextObject.save()
                noteKitList.append(newNote)
                navigationController?.popViewController(animated: true)
            }
            catch {
                print("Managed Context Object Lưu thất bại")
            }
        }
        /// -> Sửa
        else {
            let requestFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            
            do {
                let results: NSArray = try managedContextObject.fetch(requestFetch) as NSArray
                for result in results {
                    let note = result as! Note
                    if(note == selectedNote) {
                        note.title = titleTextField.text
                        note.content = contentTextView.text
                        try managedContextObject.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch {
                print("Fetch thất bại.")
            }
        }
    }
    
    
    @IBAction func buttonDelete(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let note = result as! Note
                if(note == selectedNote)
                {
                    note.delDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch
        {
            print("Fetch Failed")
        }    }
    
}
