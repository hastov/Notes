//
//  ExtensionsCommon.swift
//  Notes
//
//  Created by Guest on 28.11.22.
//

import Foundation

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

extension NotificationCenter {
    func addObserver(
        _ observer: Any,
        selector aSelector: Selector,
        names: NSNotification.Name?...,
        object anObject: Any? = nil) {
        for name in names {
            addObserver(observer, selector: aSelector,
                        name: name, object: anObject)
        }
    }
}

import UIKit

extension Notification {
    var keyboardEndFrame: CGRect? {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var keyboardDuration: TimeInterval? {
        userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    }
}
