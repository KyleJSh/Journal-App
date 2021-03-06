//
//  ViewController.swift
//  Journal App
//
//  Created by Kyle Sherrington on 2021-03-07.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    private var notesModel = NotesModel()
    private var notes = [Note]()
    private var isStarFiltered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and datasource for the table
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set self as delegate for notes model
        notesModel.delegate = self
        
        // Set the status of the star filter button
        setStarFilterButton()
        
        // Retrieve all notes according to the filter status
        if isStarFiltered {
            notesModel.getNotes(true)
        }
        else {
            notesModel.getNotes()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let notesViewController = segue.destination as! NoteViewController
        
        // if user has selected a row, transition to notesVC
        
        if tableView.indexPathForSelectedRow != nil {
            
            // set notes and notesmodel properties of the note vc
            notesViewController.note = notes[tableView.indexPathForSelectedRow!.row]
            
            // deselect the selected row so it doesn't interfere with new note creation
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
                        
        }
        
        // whether it's a new note or a selected note we still want to pass through the notes model
        notesViewController.notesModel = self.notesModel
        
    }

    func setStarFilterButton() {
        
        let imageName = isStarFiltered ? "star.fill" : "star"
        starButton.image = UIImage(systemName: imageName)
        
    }
    
    @IBAction func starFilterTapped(_ sender: Any) {
        
        // Toggle the star filter status
        isStarFiltered.toggle()
        
        // Run the query
        if isStarFiltered {
            notesModel.getNotes(true)
        }
        else {
            notesModel.getNotes()
        }
        
        // Update the star button
        setStarFilterButton()
        
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
