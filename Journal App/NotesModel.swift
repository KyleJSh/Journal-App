//
//  NotesModel.swift
//  Journal App
//
//  Created by Kyle Sherrington on 2021-03-07.
//

import Foundation
import Firebase

protocol NotesModelProtocol {
    
    func notesRetrieved(notes:[Note])
    
}

class NotesModel {
    
    var delegate:NotesModelProtocol?
    
    func getNotes() {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Get all the notes
        db.collection("notes").getDocuments { (snapshot, error) in
            
            // Check for errors
            if error == nil && snapshot != nil {
                
                var notes = [Note]()
                
                // Parse documents to notes
                for doc in snapshot!.documents {
                    
                    // for dates, convert from TimeStamp to Date
                    let createdAtDate = Timestamp.dateValue(doc["createdAt"] as! Timestamp)
                        
                    let lastUpdatedAtDate = Timestamp.dateValue(doc["lastUpdatedAt"] as! Timestamp)
                        
                    
                    let n = Note(docId: doc["docId"] as! String, title: doc["title"] as! String, body: doc["body"] as! String, isStarred: doc["isStarred"] as! Bool, createdAt: createdAtDate(), lastUpdatedAt: lastUpdatedAtDate())
                    
                    notes.append(n)
                    
                }
                // Call the delegate and pass back the notes in the main thread
                DispatchQueue.main.async {
                    self.delegate?.notesRetrieved(notes: notes)
                }
            } // end if/else
        } // end db.collection.getDocuments
    } // end getNote()
} // class NotesModel
