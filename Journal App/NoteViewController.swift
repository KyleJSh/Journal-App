//
//  NoteViewController.swift
//  Journal App
//
//  Created by Kyle Sherrington on 2021-03-07.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    var note:Note?
    var notesModel:NotesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if note != nil {
            
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        // clear the fields
        note = nil
        titleTextField.text = ""
        bodyTextView.text = ""
        
    }
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        if self.note != nil {
            
            notesModel?.deleteNote(self.note!)
        }
        // dismiss modal popover when delete is pressed
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        if self.note == nil {
            
            // This is a brand new note
            
            // Create the note
            let n = Note(docId: UUID().uuidString, title: titleTextField.text ?? "", body: bodyTextView.text ?? "", isStarred: false, createdAt: Date(), lastUpdatedAt: Date())
            
            self.note = n
            
        }
        else {
            // This is an update to existing note
            self.note?.title = titleTextField.text ?? ""
            self.note?.body = bodyTextView.text ?? ""
            self.note?.lastUpdatedAt = Date()
        }
        
        // Send it to the notes model
        self.notesModel?.saveNote(self.note!)
        
        // dismiss modal popup when saved
        dismiss(animated: true, completion: nil)

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
