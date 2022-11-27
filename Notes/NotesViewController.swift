//
//  NotesViewController.swift
//  Notes
//
//  Created by Hristo on 27.11.22.
//

import UIKit

class NotesViewController: UITableViewController {
    var manager: (Observable & NotesManaging)? {
        didSet {
            manager?.add(observer: self) {
                self.tableView.reloadData()
            }
        }
    }
    private var notes: [Note]? { manager?.notes }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? NoteViewController
        destination?.manager = manager
        if segue.identifier == "update",
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            destination?.note = notes?[safe: indexPath.item]
        }
    }
}

extension NotesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = notes?[indexPath.item]
        cell.textLabel?.text = note?.text
        cell.detailTextLabel?.text = note?.updated.description(with: .current)
        return cell
    }
}

extension NotesViewController {
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete")
        { [weak self] _, _, completionHandler in
            if let note = self?.notes?[safe: indexPath.item] {
                self?.manager?.remove(note)
                self?.tableView.reloadData()
            }
            completionHandler(true)
        }

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}
