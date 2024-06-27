//
//  String + Extensions.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 27.06.2024.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        if isEmpty {
            return ""
        }
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
