//
//  ViewController.swift
//  Journal App
//
//  Created by Kyle Sherrington on 2021-03-07.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var notesModel = NotesModel()
    private var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and datasource for the table
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set self as delegate for notes model
        notesModel.delegate = self
        
        // Retrieve all notes
        notesModel.getNotes()
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        // TODO: Customize cell
        let titleLabel = cell.viewWithTag(1) as? UILabel
        
        // pass in title text
        titleLabel?.text = notes[indexPath.row].title
        
        let bodyLabel = cell.viewWithTag(2) as? UILabel
        
        // pass in body text
        bodyLabel?.text = notes[indexPath.row].body
        
        return cell
    }
}

extension ViewController: NotesModelProtocol {
    func notesRetrieved(notes: [Note]) {
        
        // Set notes property and refresh tableview
        self.notes = notes
        
        tableView.reloadData()
    }
}
