//
//  Note.swift
//  Notes
//
//  Created by Hristo on 27.11.22.
//

import Foundation

struct Note: Codable {
    private var id: String
    var text: String
    var updated: Date
    
    init(id: String = UUID().uuidString, text: String, updated: Date) {
        self.id = id; self.text = text; self.updated = updated
    }
    
    static func ===(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
