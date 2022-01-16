//
//  String+Extension.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 10/9/20.
//  Copyright © 2020 Jordan Trana. All rights reserved.
//

import Foundation

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    var isWord: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
}
