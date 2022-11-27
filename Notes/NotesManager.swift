//
//  NotesManaging.swift
//  Notes
//
//  Created by Hristo on 27.11.22.
//

import Foundation

protocol NotesManaging {
    var notes: [Note] { get }
    func append(_ note: Note)
    func update(_ note: Note)
    func remove(_ note: Note)
}

protocol Observable {
    func add(observer: AnyHashable, observation: @escaping () -> ())
    func remove(observer: AnyHashable)
}

class NotesManager: NotesManaging {
    private lazy var storage: UserDefaults = .init()
    private lazy var observations: [AnyHashable: () -> Void] = [:]
    
    lazy var notes: [Note] = {
        if let json = storage.object(forKey: "notes") as? Data,
           let notes = try? Note.array(from: json) {
            return notes
        }
        return []
    }() {
        didSet {
            observations.values.forEach { $0() }
            if let data = try? JSONEncoder().encode(notes) {
                storage.set(data, forKey: "notes")
            }
        }
    }
    
    func append(_ note: Note) {
        notes.append(note)
    }
    
    func update(_ note: Note) {
        if let index = notes.firstIndex(where: { $0 === note }) {
            notes[index] = note
        }
    }
    
    func remove(_ note: Note) {
        if let index = notes.firstIndex(where: { $0 === note }) {
            notes.remove(at: index)
        }
    }
}

extension NotesManager: Observable {
    func add(observer: AnyHashable, observation: @escaping () -> ()) {
        observations[observer] = observation
    }
    
    func remove(observer: AnyHashable) {
        observations[observer] = nil
    }
}

extension Decodable {
    static func array(
        from json: Data,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> [Self]? {
        try decoder.decode([Self].self, from: json)
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
