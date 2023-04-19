//
//  StringExtension.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/19.
//

import Foundation

extension String {
    var characterArray: [Character]{
        var characterArray = [Character]()
        for character in self {
            characterArray.append(character)
        }
        return characterArray
    }
}
