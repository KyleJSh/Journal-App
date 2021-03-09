//
//  NoteViewController.swift
//  Journal App
//
//  Created by Kyle Sherrington on 2021-03-07.
//


import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var starButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    var note:Note?
    var notesModel:NotesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note != nil {
            
            // user is viewing an existing note, so populate the fields
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
            
            setStarButton()
            
        }
        else {
            // Note property is nil, so create a new note
            // Create the note
            let n = Note(docId: UUID().uuidString, title: titleTextField.text ?? "", body: bodyTextView.text ?? "", isStarred: false, createdAt: Date(), lastUpdatedAt: Date())
            
            self.note = n
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // clear the fields
        note = nil
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
    func setStarButton() {
        
        let imageName = note!.isStarred ? "star.fill" : "star"
        
        starButton.setImage(UIImage(systemName: imageName), for: .normal)
        
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        if self.note != nil {
            
            notesModel?.deleteNote(self.note!)
        }
        // dismiss modal popover when delete is pressed
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        // This is an update to existing note
        self.note?.title = titleTextField.text ?? ""
        self.note?.body = bodyTextView.text ?? ""
        self.note?.lastUpdatedAt = Date()
        
        // Send it to the notes model
        self.notesModel?.saveNote(self.note!)
        
        // dismiss modal popup when saved
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func starTapped(_ sender: Any) {
        
        // Change the property in the note
        note?.isStarred.toggle()
        
        // Update the database
        notesModel?.updateFavStatus(note!.docId, note!.isStarred)
        
        // Update the button
        setStarButton()
        
    }
    
}
