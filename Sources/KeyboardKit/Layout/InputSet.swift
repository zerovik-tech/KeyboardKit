//
//  InputSet.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-07-03.
//  Copyright © 2020-2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 An input set defines the input keys on a keyboard.
 
 Input sets can be used to create a ``KeyboardLayout`` which
 defines the full set of keys of a keyboard, often including
 keys around the input rows and a bottom system row.
 
 KeyboardKit has a couple of pre-defined input sets, such as
 standard ``qwerty``, a ``standardNumeric(currency:)`` and a
 ``standardSymbolic(currencies:)``. KeyboardKit Pro provides
 even more input sets like `qwertz` and `azerty`, as well as
 alphabetic, numeric and symbolic input sets for all locales.
 */
public struct InputSet: Equatable {
    
    /// Create an input set with rows.
    public init(rows: Rows) {
        self.rows = rows
    }

    /// The rows in the input set.
    public var rows: Rows
}

public extension InputSet {
    
    static var qwerty: InputSet {
        .init(rows: [
            .init(chars: "qwertyuiop"),
            .init(chars: "asdfghjkl"),
            .init(phone: "zxcvbnm", pad: "zxcvbnm,.")
        ])
    }
    
    static func standardNumeric(currency: String,numerics : String = "1234567890") -> InputSet {
        .init(rows: [
            .init(chars: numerics),
            .init(phone: "-/:;()\(currency)&@”", pad: "@#\(currency)&*()’”"),
            .init(phone: ".,?!’", pad: "%-+=/;:!?")
        ])
    }
    
    static func standardSymbolic(currencies: [String]) -> InputSet {
        .init(rows: [
            .init(phone: "[]{}#%^*+=", pad: "1234567890"),
            .init(
                phone: "_\\|~<>\(currencies.joined())•",
                pad: "\(currencies.joined())_^[]{}"),
            .init(phone: ".,?!’", pad: "§|~…\\<>!?")
        ])
    }
}
