//
//  NoteViewController.swift
//  Notes
//
//  Created by Hristo on 27.11.22.
//

import UIKit

class NoteViewController: UIViewController {
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var manager: NotesManaging?
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note?.text
        textView.becomeFirstResponder()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillToggle(_:)),
            names: UIResponder.keyboardWillShowNotification, UIResponder.keyboardWillHideNotification
        )
    }
    
    @objc private func keyboardWillToggle(_ notification: Notification) {
        guard let frame = notification.keyboardEndFrame,
              let duration = notification.keyboardDuration else {
            return
        }
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.textViewBottomConstraint.constant = self.view.frame.height - frame.origin.y
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if var note = note {
            note.text = textView.text
            note.updated = Date()
            manager?.update(note)
        } else {
            let note = Note(text: textView.text, updated: Date())
            manager?.append(note)
        }
    }
}
