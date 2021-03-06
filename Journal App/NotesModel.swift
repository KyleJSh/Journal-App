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
    
    var listener:ListenerRegistration?
    
    deinit {
        // Unregister database listener
        listener?.remove()
    }
    
    func getNotes(_ starredOnly:Bool = false) {
        
        // Detach any listener
        listener?.remove()
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // create new query
        var query:Query = db.collection("notes")
        
        // If we're only looking for starred notes, update the query
        if starredOnly {
            query = query.whereField("isStarred", isEqualTo: true)
        }
        
        // Get all the notes
        self.listener = query.addSnapshotListener({ (snapshot, error) in
            
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
            }
        }
        )}
    
    func deleteNote(_ n:Note) {
        
        let db = Firestore.firestore()
        
        db.collection("notes").document(n.docId).delete()
        
    }
    
    func saveNote(_ n:Note) {
        
        let db = Firestore.firestore()
        
        db.collection("notes").document(n.docId).setData(noteToDict(n))
        
    }
    
    func updateFavStatus(_ docId:String, _ isStarred:Bool) {
        
        let db = Firestore.firestore()
        
        db.collection("notes").document(docId).updateData(["isStarred":isStarred])
    }
    
    func noteToDict(_ n:Note) -> [String:Any] {
        
        var dict = [String:Any]()
        
        dict["docId"] = n.docId
        dict["title"] = n.title
        dict["body"] = n.body
        dict["createdAt"] = n.createdAt
        dict["lastUpdatedAt"] = n.lastUpdatedAt
        dict["isStarred"] = n.isStarred
        
        return dict
    }
} // class NotesModel
