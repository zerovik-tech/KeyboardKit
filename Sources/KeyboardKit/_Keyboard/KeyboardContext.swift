//
//  KeyboardContext.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-06-15.
//  Copyright © 2020-2023 Daniel Saidi. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/**
 This class provides keyboard extensions with contextual and
 observable information about the keyboard extension itself.

 This class will continuously sync with the input controller
 to provide updated information. It is also extensively used
 within the library, to make keyboard-related decisions.

 You can use ``locale`` to get and set the raw locale of the
 keyboard or use the properties and functions that allows us
 to use a ``KeyboardLocale``. You can use ``locales`` to set
 all locales, then call ``selectNextLocale()`` to select the
 next available locale.
 
 KeyboardKit automatically creates an instance of this class
 and binds it to ``KeyboardInputViewController/state``.
 */


// MARK: - Custom View Type
public enum CustomView {
    
    case selectfont
    case selectsymbol
    case selectkaomojis
    case selectorganizer
    
}


// MARK: - Custom Theme
public struct Theme {
    
    let name : String
    let keyboardBackgroundColor : Color
    let primaryBackgroundColor : Color      //color of input keys
    let secondaryBackgroundColor : Color    //color of action keys
    let primaryForegroundColor : Color
    let calloutBackgroundColor : Color
    let calloutForegroundColor : Color
    
    public static var oceanBlue : Theme = Theme(name: "ocean-blue", keyboardBackgroundColor: Color(red: 1/255, green: 70/255, blue: 112/255), primaryBackgroundColor: Color(red: 3/255, green: 86/255, blue: 136/255), secondaryBackgroundColor: Color(red: 0/255, green: 56/255, blue: 90/255), primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255), calloutBackgroundColor: Color(red: 3/255, green: 86/255, blue: 136/255), calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var brightPurple : Theme = Theme(name: "bright-purple", keyboardBackgroundColor: Color(red: 255/255, green: 213/255, blue: 109/255), primaryBackgroundColor: Color(red: 162/255, green: 138/255, blue: 200/255), secondaryBackgroundColor: Color(red: 250/255, green: 95/255, blue: 38/255), primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255), calloutBackgroundColor: Color(red: 162/255, green: 138/255, blue: 200/255), calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var autumn : Theme = Theme(name: "autumn", keyboardBackgroundColor: Color(red: 115/255, green: 13/255, blue: 86/255), primaryBackgroundColor: Color(red: 225/255, green: 95/255, blue: 27/255), secondaryBackgroundColor: Color(red: 225/255, green: 199/255, blue: 4/255), primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255), calloutBackgroundColor: Color(red: 225/255, green: 95/255, blue: 27/255), calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var leaf : Theme = Theme(name: "leaf", keyboardBackgroundColor: Color(red: 202/255, green: 224/255, blue: 158/255), primaryBackgroundColor: Color(red: 254/255, green: 225/255, blue: 228/255), secondaryBackgroundColor: Color(red: 165/255, green: 191/255, blue: 141/255), primaryForegroundColor: Color(red: 125/255, green: 127/255, blue: 115/255), calloutBackgroundColor: Color(red: 254/255, green: 225/255, blue: 228/255), calloutForegroundColor: Color(red: 125/255, green: 127/255, blue: 115/255))
    
    public static var lemon : Theme = Theme(name: "lemon", keyboardBackgroundColor: Color(red: 211/255, green: 234/255, blue: 255/255), primaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 190/255), secondaryBackgroundColor: Color(red: 249/255, green: 230/255, blue: 0/255), primaryForegroundColor: Color(red: 170/255, green: 162/255, blue: 154/255), calloutBackgroundColor: Color(red: 255/255, green: 255/255, blue: 190/255), calloutForegroundColor: Color(red: 170/255, green: 162/255, blue: 154/255))
    
    public static var pink : Theme = Theme(name: "pink", keyboardBackgroundColor: Color(red: 254/255, green: 230/255, blue: 246/255), primaryBackgroundColor: Color(red: 255/255, green: 213/255, blue: 237/255), secondaryBackgroundColor: Color(red: 244/255, green: 194/255, blue: 223/255), primaryForegroundColor: Color(red: 155/255, green: 155/255, blue: 155/255), calloutBackgroundColor: Color(red: 255/255, green: 213/255, blue: 237/255), calloutForegroundColor: Color(red: 155/255, green: 155/255, blue: 155/255))
    
    public static var lightBlue : Theme = Theme(name: "light-blue", keyboardBackgroundColor: Color(red: 232/255, green: 242/255, blue: 254/255), primaryBackgroundColor: Color(red: 201/255, green: 221/255, blue: 224/255), secondaryBackgroundColor: Color(red: 189/255, green: 213/255, blue: 249/255), primaryForegroundColor: Color(red: 166/255, green: 166/255, blue: 168/255), calloutBackgroundColor: Color(red: 201/255, green: 221/255, blue: 224/255), calloutForegroundColor: Color(red: 166/255, green: 166/255, blue: 168/255))
    
    public static var pastleBlueAndGreen : Theme = Theme(name: "pastle-blue-and-green", keyboardBackgroundColor: Color(red: 237/255, green: 183/255, blue: 196/255), primaryBackgroundColor: Color(red: 177/255, green: 222/255, blue: 184/255), secondaryBackgroundColor: Color(red: 166/255, green: 213/255, blue: 229/255), primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255), calloutBackgroundColor: Color(red: 177/255, green: 222/255, blue: 184/255), calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var dagobahGreen : Theme = Theme(name: "dagobah-green", keyboardBackgroundColor: Color(red: 13/255, green: 154/255, blue: 144/255), primaryBackgroundColor: Color(red: 0/255, green: 184/255, blue: 171/255), secondaryBackgroundColor: Color(red: 11/255, green: 141/255, blue: 132/255), primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255), calloutBackgroundColor: Color(red: 0/255, green: 184/255, blue: 171/255), calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var classicTurquoise : Theme = Theme(name: "classic-turquoise", keyboardBackgroundColor: Color(red: 65/255, green: 197/255, blue: 215/255), primaryBackgroundColor: Color(red: 27/255, green: 176/255, blue: 195/255), secondaryBackgroundColor: Color(red: 20/255, green: 146/255, blue: 163/255), primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255), calloutBackgroundColor: Color(red: 27/255, green: 176/255, blue: 195/255), calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var brightBlue : Theme = Theme(name: "bright-blue", keyboardBackgroundColor: Color(red: 0/255, green: 143/255, blue: 176/255), primaryBackgroundColor: Color(red: 0/255, green: 181/255, blue: 224/255), secondaryBackgroundColor: Color(red: 0/255, green: 111/255, blue: 137/255), primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255), calloutBackgroundColor: Color(red: 0/255, green: 181/255, blue: 224/255), calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var classicBlue : Theme = Theme(name: "classic-blue", keyboardBackgroundColor: Color(red: 47/255, green: 144/255, blue: 203/255), primaryBackgroundColor: Color(red: 59/255, green: 133/255, blue: 231/255), secondaryBackgroundColor: Color(red: 28/255, green: 87/255, blue: 163/255), primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255), calloutBackgroundColor: Color(red: 59/255, green: 133/255, blue: 231/255), calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var gold : Theme = Theme(name: "gold", keyboardBackgroundColor: Color(red: 213/255, green: 155/255, blue: 58/255), primaryBackgroundColor: Color(red: 247/255, green: 189/255, blue: 83/255), secondaryBackgroundColor: Color(red: 194/255, green: 141/255, blue: 49/255), primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255), calloutBackgroundColor: Color(red: 247/255, green: 189/255, blue: 83/255), calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var magicalPurple : Theme = Theme(name: "magical-purple", keyboardBackgroundColor: Color(red: 218/255, green: 183/255, blue: 222/255), primaryBackgroundColor: Color(red: 236/255, green: 219/255, blue: 238/255), secondaryBackgroundColor: Color(red: 154/255, green: 141/255, blue: 197/255), primaryForegroundColor: Color(red: 255/255, green: 246/255, blue: 255/255), calloutBackgroundColor: Color(red: 236/255, green: 219/255, blue: 238/255), calloutForegroundColor: Color(red: 255/255, green: 246/255, blue: 255/255))
    
    public static var fairyPurple : Theme = Theme(name: "fairy-purple", keyboardBackgroundColor: Color(red: 218/255, green: 183/255, blue: 222/255), primaryBackgroundColor: Color(red: 236/255, green: 219/255, blue: 238/255), secondaryBackgroundColor: Color(red: 154/255, green: 141/255, blue: 197/255), primaryForegroundColor: Color(red: 255/255, green: 246/255, blue: 255/255), calloutBackgroundColor: Color(red: 236/255, green: 219/255, blue: 238/255), calloutForegroundColor: Color(red: 255/255, green: 246/255, blue: 255/255))
    
    public static var darkPurple : Theme = Theme(name: "dark-purple", keyboardBackgroundColor: Color(red: 62/255, green: 23/255, blue: 114/255),primaryBackgroundColor: Color(red: 82/255, green: 28/255, blue: 158/255),secondaryBackgroundColor: Color(red: 54/255, green: 16/255, blue: 95/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 82/255, green: 28/255, blue: 158/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var veryDarkPurple : Theme = Theme(name: "very-dark-purple", keyboardBackgroundColor: Color(red: 14/255, green: 0/255, blue: 85/255),primaryBackgroundColor: Color(red: 40/255, green: 28/255, blue: 116/255),secondaryBackgroundColor: Color(red: 6/255, green: 0/255, blue: 59/255),primaryForegroundColor: Color(red: 255/255, green:255/255, blue: 255/255),calloutBackgroundColor: Color(red: 40/255, green: 28/255, blue: 116/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var watermelonRed : Theme = Theme(name: "watermelon-red", keyboardBackgroundColor: Color(red: 233/255, green: 92/255, blue: 92/255),primaryBackgroundColor: Color(red: 255/255, green: 120/255, blue: 118/255),secondaryBackgroundColor: Color(red: 202/255, green: 68/255, blue: 65/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 255/255, green: 120/255, blue: 118/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var blushPink : Theme = Theme(name: "blush-pink", keyboardBackgroundColor: Color(red: 255/255, green: 206/255, blue: 206/255),primaryBackgroundColor: Color(red: 244/255, green: 178/255, blue: 177/255),secondaryBackgroundColor: Color(red: 201/255, green: 127/255, blue: 134/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 244/255, green: 178/255, blue: 177/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var peach : Theme = Theme(name: "peach", keyboardBackgroundColor: Color(red: 167/255, green: 171/255, blue: 147/255),primaryBackgroundColor: Color(red: 255/255, green: 180/255, blue: 154/255),secondaryBackgroundColor: Color(red: 255/255, green: 141/255, blue: 102/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 255/255, green: 180/255, blue: 154/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var cherryPink : Theme = Theme(name: "cherry-pink", keyboardBackgroundColor: Color(red: 255/255, green: 82/255, blue: 120/255),primaryBackgroundColor: Color(red: 222/255, green: 66/255, blue: 98/255),secondaryBackgroundColor: Color(red: 195/255, green: 51/255, blue: 82/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 222/255, green: 66/255, blue: 98/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var brightPink : Theme = Theme(name: "bright-pink", keyboardBackgroundColor: Color(red: 151/255, green: 35/255, blue: 160/255),primaryBackgroundColor: Color(red: 216/255, green: 63/255, blue: 224/255),secondaryBackgroundColor: Color(red: 145/255, green: 32/255, blue: 150/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 216/255, green: 63/255, blue: 224/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
 
    public static var autumnCamel : Theme = Theme(name: "autumn-camel", keyboardBackgroundColor: Color(red: 150/255, green: 153/255, blue: 161/255),primaryBackgroundColor: Color(red: 233/255, green: 194/255, blue: 143/255),secondaryBackgroundColor: Color(red: 183/255, green: 135/255, blue: 108/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 233/255, green: 194/255, blue: 143/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var graphite : Theme = Theme(name: "graphite", keyboardBackgroundColor: Color(red: 192/255, green: 190/255, blue: 179/255),primaryBackgroundColor: Color(red: 70/255, green: 68/255, blue: 64/255),secondaryBackgroundColor: Color(red: 130/255, green: 126/255, blue: 118/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 70/255, green: 68/255, blue: 64/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var pacificBlue : Theme = Theme(name: "pacific-blue", keyboardBackgroundColor: Color(red: 155/255, green: 182/255, blue: 193/255),primaryBackgroundColor: Color(red: 52/255, green: 79/255, blue: 93/255),secondaryBackgroundColor: Color(red: 104/255, green: 132/255, blue: 145/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 52/255, green: 79/255, blue: 93/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var midnightGreen : Theme = Theme(name: "midnight-green", keyboardBackgroundColor: Color(red: 123/255, green: 132/255, blue: 119/255),primaryBackgroundColor: Color(red: 62/255, green: 72/255, blue: 64/255),secondaryBackgroundColor: Color(red: 147/255, green: 156/255, blue: 144/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 62/255, green: 72/255, blue: 64/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var violet : Theme = Theme(name: "violet", keyboardBackgroundColor: Color(red: 197/255, green: 189/255, blue: 210/255),primaryBackgroundColor: Color(red: 224/255, green: 221/255, blue: 240/255),secondaryBackgroundColor: Color(red: 178/255, green: 183/255, blue: 220/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 224/255, green: 221/255, blue: 240/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var retro : Theme = Theme(name: "retro", keyboardBackgroundColor: Color(red: 146/255, green: 115/255, blue: 82/255),primaryBackgroundColor: Color(red: 202/255, green: 159/255, blue: 128/255),secondaryBackgroundColor: Color(red: 208/255, green: 180/255, blue: 157/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 202/255, green: 159/255, blue: 128/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var darkDark : Theme = Theme(name: "dark-dark", keyboardBackgroundColor: Color(red: 3/255, green: 3/255, blue: 3/255),primaryBackgroundColor: Color(red: 37/255, green: 37/255, blue: 37/255),secondaryBackgroundColor: Color(red: 19/255, green: 19/255, blue: 19/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 37/255, green: 37/255, blue: 37/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var darkAndRed : Theme = Theme(name: "dark-and-red", keyboardBackgroundColor: Color(red: 11/255, green: 11/255, blue: 11/255),primaryBackgroundColor: Color(red: 40/255, green: 40/255, blue: 40/255),secondaryBackgroundColor: Color(red: 171/255, green: 0/255, blue: 0/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 40/255, green: 40/255, blue: 40/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var darkAndGreen : Theme = Theme(name: "dark-and-green", keyboardBackgroundColor: Color(red: 11/255, green: 11/255, blue: 11/255),primaryBackgroundColor: Color(red: 40/255, green: 40/255, blue: 40/255),secondaryBackgroundColor: Color(red: 0/255, green: 128/255, blue: 15/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 40/255, green: 40/255, blue: 40/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var darkAndBlue : Theme = Theme(name: "dark-and-blue", keyboardBackgroundColor: Color(red: 11/255, green: 11/255, blue: 11/255),primaryBackgroundColor: Color(red: 40/255, green: 40/255, blue: 40/255),secondaryBackgroundColor: Color(red: 0/255, green: 101/255, blue: 162/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 40/255, green: 40/255, blue: 40/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var veryDarkGray : Theme = Theme(name: "very-dark-gray", keyboardBackgroundColor: Color(red: 26/255, green: 27/255, blue: 33/255),primaryBackgroundColor: Color(red: 39/255, green: 40/255, blue: 46/255),secondaryBackgroundColor: Color(red: 15/255, green: 16/255, blue: 25/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 39/255, green: 40/255, blue: 46/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var veryDarkBlue : Theme = Theme(name: "very-dark-blue", keyboardBackgroundColor: Color(red: 14/255, green: 2/255, blue: 47/255),primaryBackgroundColor: Color(red: 62/255, green: 61/255, blue: 82/255),secondaryBackgroundColor: Color(red: 40/255, green: 34/255, blue: 56/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 62/255, green: 61/255, blue: 82/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var almostBlack : Theme = Theme(name: "almost-black", keyboardBackgroundColor: Color(red: 39/255, green: 40/255, blue: 46/255),primaryBackgroundColor: Color(red: 26/255, green: 27/255, blue: 33/255),secondaryBackgroundColor: Color(red: 15/255, green: 16/255, blue: 25/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 26/255, green: 27/255, blue: 33/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var darkPurpleShadow : Theme = Theme(name: "dark-purple-shadow", keyboardBackgroundColor: Color(red: 0/255, green: 7/255, blue: 19/255),primaryBackgroundColor: Color(red: 24/255, green: 33/255, blue: 48/255),secondaryBackgroundColor: Color(red: 20/255, green: 37/255, blue: 59/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 24/255, green: 33/255, blue: 48/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var blackBlack : Theme = Theme(name: "black-black", keyboardBackgroundColor: Color(red: 16/255, green: 17/255, blue: 26/255),primaryBackgroundColor: Color(red: 16/255, green: 17/255, blue: 26/255),secondaryBackgroundColor: Color(red: 15/255, green: 16/255, blue: 26/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutBackgroundColor: Color(red: 16/255, green: 17/255, blue: 26/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 255/255))
    
    public static var softBlue : Theme = Theme(name: "soft-blue", keyboardBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),primaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),secondaryBackgroundColor: Color(red: 236/255, green: 244/255, blue: 255/255),primaryForegroundColor: Color(red: 60/255, green: 90/255, blue: 139/255),calloutBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutForegroundColor: Color(red: 60/255, green: 90/255, blue: 139/255))
    
    public static var softGray : Theme = Theme(name: "soft-gray", keyboardBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),primaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),secondaryBackgroundColor: Color(red: 244/255, green: 248/255, blue: 255/255),primaryForegroundColor: Color(red: 247/255, green: 247/255, blue: 247/255),calloutBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutForegroundColor: Color(red: 247/255, green: 247/255, blue: 247/255))
    
    public static var softPurple : Theme = Theme(name: "soft-purple", keyboardBackgroundColor: Color(red: 248/255, green: 253/255, blue: 255/255),primaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),secondaryBackgroundColor: Color(red: 234/255, green: 239/255, blue: 255/255),primaryForegroundColor: Color(red: 121/255, green: 135/255, blue: 255/255),calloutBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutForegroundColor: Color(red: 121/255, green: 135/255, blue: 255/255))
    
    public static var softBrightBlue : Theme = Theme(name: "soft-bright-blue", keyboardBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),primaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),secondaryBackgroundColor: Color(red: 236/255, green: 244/255, blue: 255/255),primaryForegroundColor: Color(red: 11/255, green: 171/255, blue: 238/255),calloutBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutForegroundColor: Color(red: 11/255, green: 171/255, blue: 238/255))
    
    public static var softDarkBlue : Theme = Theme(name: "soft-dark-blue", keyboardBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),primaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),secondaryBackgroundColor: Color(red: 251/255, green: 255/255, blue: 255/255),primaryForegroundColor: Color(red: 60/255, green: 90/255, blue: 136/255),calloutBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutForegroundColor: Color(red: 60/255, green: 90/255, blue: 136/255))
    
    public static var softWhite : Theme = Theme(name: "soft-white", keyboardBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),primaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),secondaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),primaryForegroundColor: Color(red: 26/255, green: 27/255, blue: 31/255),calloutBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutForegroundColor: Color(red: 26/255, green: 27/255, blue: 31/255))
    
    public static var softSoft : Theme = Theme(name: "soft-soft", keyboardBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),primaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),secondaryBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),primaryForegroundColor: Color(red: 26/255, green: 27/255, blue: 31/255),calloutBackgroundColor: Color(red: 255/255, green: 255/255, blue: 255/255),calloutForegroundColor: Color(red: 26/255, green: 27/255, blue: 31/255))
    
    public static var fireRed : Theme = Theme(name: "fire-red", keyboardBackgroundColor: Color(red: 196/255, green: 56/255, blue: 26/255),primaryBackgroundColor: Color(red: 255/255, green: 80/255, blue: 42/255),secondaryBackgroundColor: Color(red: 154/255, green: 50/255, blue: 28/255),primaryForegroundColor: Color(red: 255/255, green: 255/255, blue: 281/255),calloutBackgroundColor: Color(red: 255/255, green: 80/255, blue: 42/255),calloutForegroundColor: Color(red: 255/255, green: 255/255, blue: 281/255))
    
}

public class KeyboardContext: ObservableObject {

    public init() {}

    // MARK: = Custom Properties
    
    @Published
    public var currentInputSet : InputSetBasedKeyboardLayoutProvider = InputSetBasedKeyboardLayoutProvider()
    
    @Published
    public var showKeyboard : Bool = true
    
    @Published
    public var currentCustomView : CustomView = .selectfont

    @Published
    public var selectedLightTheme : Theme?
    
    @Published
    public var selectedDarkTheme : Theme?

    @Published
    public var currentSelectedFontID : Int = 1 // 'Normal font id to be used by default'


    // MARK: - Published Properties
    
    /// Set this to override the ``autocapitalizationType``.
    @Published
    public var autocapitalizationTypeOverride: Keyboard.AutocapitalizationType?

    /// The current device type.
    @Published
    public var deviceType: DeviceType = .current

    /// Whether or not the keyboard has a dictation key.
    @Published
    public var hasDictationKey: Bool = false

    /// Whether or not the extension has full access.
    @Published
    public var hasFullAccess: Bool = false

    /// The current interface orientation.
    @Published
    public var interfaceOrientation: InterfaceOrientation = .portrait

    /// Whether or not autocapitalization is enabled.
    @Published
    public var isAutoCapitalizationEnabled = true

    /// Whether or not the keyboard is in floating mode.
    @Published
    public var isKeyboardFloating = false
    
    /// Whether or not a space drag gesture is active.
    @Published
    public var isSpaceDragGestureActive = false
    
    func setIsSpaceDragGestureActive(
        _ value: Bool,
        animated: Bool
    ) {
        if animated {
            withAnimation { isSpaceDragGestureActive = value }
        } else {
            isSpaceDragGestureActive = value
        }
    }

    /// An optional dictation replacement action.
    @Published
    public var keyboardDictationReplacement: KeyboardAction?

    /// The keyboard type that is currently used.
    @Published
    public var keyboardType = Keyboard.KeyboardType.alphabetic(.lowercased)

    /// The locale that is currently being used.
    @Published
    public var locale = Locale.current

    /// The locales that are currently available.
    @Published
    public var locales: [Locale] = [.current]

    /// The locale to use when displaying other locales.
    @Published
    public var localePresentationLocale: Locale?

    /// Whether or not to add an input mode switch key.
    @Published
    public var needsInputModeSwitchKey = false

    /// Whether or not the context prefers autocomplete.
    @Published
    public var prefersAutocomplete = true

    /// The primary language that is currently being used.
    @Published
    public var primaryLanguage: String?

    /// The current screen size (avoid using this).
    @Published
    public var screenSize = CGSize.zero

    /// The space long press behavior to use.
    @Published
    public var spaceLongPressBehavior = Gestures.SpaceLongPressBehavior.moveInputCursor
    
    
    #if os(iOS) || os(tvOS)
    
    // MARK: - iOS/tvOS proxy properties
    
    /// The original text document proxy.
    @Published
    public var originalTextDocumentProxy: UITextDocumentProxy = .preview

    /// The text document proxy that is currently active.
    public var textDocumentProxy: UITextDocumentProxy {
        textInputProxy ?? originalTextDocumentProxy
    }
    
    /// A custom text proxy to which text can be routed.
    @Published
    public var textInputProxy: TextInputProxy?
    
    
    // MARK: - iOS/tvOS properties

    /// The text input mode of the input controller.
    @Published
    public var textInputMode: UITextInputMode?

    /// The input controller's current trait collection.
    @Published
    public var traitCollection = UITraitCollection()
    #endif
    
    
    // MARK: - Deprecations
    
    #if os(iOS) || os(tvOS)
    @available(*, deprecated, renamed: "originalTextDocumentProxy")
    open var mainTextDocumentProxy: UITextDocumentProxy {
        originalTextDocumentProxy
    }
    #endif
}


// MARK: - Public iOS/tvOS Properties

#if os(iOS) || os(tvOS)
public extension KeyboardContext {

    /// The current trait collection's color scheme.
    var colorScheme: ColorScheme {
        traitCollection.userInterfaceStyle == .dark ? .dark : .light
    }

    /// The current keyboard appearance.
    var keyboardAppearance: UIKeyboardAppearance {
        textDocumentProxy.keyboardAppearance ?? .default
    }
}
#endif


// MARK: - Public Properties

public extension KeyboardContext {

    /**
     The autocapitalization type to use.

     This is by default fetched from the text document proxy.
     You can use ``autocapitalizationTypeOverride`` to apply
     a custom value that overrides the default one.
     */
    var autocapitalizationType: Keyboard.AutocapitalizationType? {
        #if os(iOS) || os(tvOS)
        autocapitalizationTypeOverride ?? textDocumentProxy.autocapitalizationType?.keyboardType
        #else
        autocapitalizationTypeOverride ?? nil
        #endif
    }

    /**
     Whether or not the context specifies that we should use
     a dark color scheme.
     */
    var hasDarkColorScheme: Bool {
        #if os(iOS) || os(tvOS)
        colorScheme == .dark
        #else
        false
        #endif
    }

    /**
     Try to map the current ``locale`` to a keyboard locale.
     */
    var keyboardLocale: KeyboardLocale? {
        KeyboardLocale.allCases.first { $0.localeIdentifier == locale.identifier }
    }
}


// MARK: - Public Functions

public extension KeyboardContext {

    /// Whether or not the context has multiple locales.
    var hasMultipleLocales: Bool {
        locales.count > 1
    }

    /// Whether or not the context has a certain locale.
    func hasKeyboardLocale(_ locale: KeyboardLocale) -> Bool {
        self.locale.identifier == locale.localeIdentifier
    }

    /// Whether or not a certain keyboard type is selected.
    func hasKeyboardType(_ type: Keyboard.KeyboardType) -> Bool {
        keyboardType == type
    }

    /**
     Select the next locale in ``locales``, depending on the
     ``locale``. If ``locale`` is last in ``locales`` or not
     in the list, the first list locale is selected.
     */
    func selectNextLocale() {
        let fallback = locales.first ?? locale
        guard let currentIndex = locales.firstIndex(of: locale) else { return locale = fallback }
        let nextIndex = currentIndex.advanced(by: 1)
        guard locales.count > nextIndex else { return locale = fallback }
        locale = locales[nextIndex]
    }

    /// Set ``keyboardType`` to the provided type.
    func setKeyboardType(_ type: Keyboard.KeyboardType) {
        keyboardType = type
    }

    /// Set ``locale`` to the provided locale.
    func setLocale(_ locale: Locale) {
        self.locale = locale
    }

    /// Set ``locale`` to the provided keyboard locale.
    func setLocale(_ locale: KeyboardLocale) {
        self.locale = locale.locale
    }

    /// Set ``locales`` to the provided locales.
    func setLocales(_ locales: [Locale]) {
        self.locales = locales
    }

    /// Set ``locales`` to the provided keyboard locales.
    func setLocales(_ locales: [KeyboardLocale]) {
        self.locales = locales.map { $0.locale }
    }
}


// MARK: - iOS/tvOS syncing

#if os(iOS) || os(tvOS)
public extension KeyboardContext {
    
    /// Sync the context with the provided input controller.
    func sync(with controller: KeyboardInputViewController) {
        DispatchQueue.main.async {
            self.syncAfterAsync(with: controller)
        }
    }
    
    /// Sync the ``originalTextDocumentProxy``.
    func syncTextDocumentProxy(with controller: KeyboardInputViewController) {
        if originalTextDocumentProxy === controller.originalTextDocumentProxy { return }
        DispatchQueue.main.async {
            self.originalTextDocumentProxy = controller.originalTextDocumentProxy
        }
    }
    
    /// Sync the ``textInputProxy``.
    func syncTextInputProxy(with controller: KeyboardInputViewController) {
        if textInputProxy === controller.textInputProxy { return }
        DispatchQueue.main.async {
            self.textInputProxy = controller.textInputProxy
        }
    }
}

extension KeyboardContext {

    /**
     Perform this after an async delay, to make sure that we
     have the latest information.
     */
    func syncAfterAsync(with controller: KeyboardInputViewController) {
        syncTextDocumentProxy(with: controller)
        syncTextInputProxy(with: controller)
        
        if hasDictationKey != controller.hasDictationKey {
            hasDictationKey = controller.hasDictationKey
        }
        if hasFullAccess != controller.hasFullAccess {
            hasFullAccess = controller.hasFullAccess
        }
        if interfaceOrientation != controller.orientation {
            interfaceOrientation = controller.orientation
        }
        if needsInputModeSwitchKey != controller.needsInputModeSwitchKey {
            needsInputModeSwitchKey = controller.needsInputModeSwitchKey
        }
        
        let keyboardPrefersAutocomplete = textDocumentProxy.keyboardType?.prefersAutocomplete ?? true
        let returnKeyPrefersAutocomplete = textDocumentProxy.returnKeyType?.prefersAutocomplete ?? true
        let newPrefersAutocomplete = keyboardType.prefersAutocomplete && keyboardPrefersAutocomplete && returnKeyPrefersAutocomplete
        if prefersAutocomplete != newPrefersAutocomplete {
            prefersAutocomplete = newPrefersAutocomplete
        }
        
        if primaryLanguage != controller.primaryLanguage {
            primaryLanguage = controller.primaryLanguage
        }
        if screenSize != controller.screenSize {
            screenSize = controller.screenSize
        }
        if textInputMode != controller.textInputMode {
            textInputMode = controller.textInputMode
        }
        if traitCollection != controller.traitCollection {
            traitCollection = controller.traitCollection
        }
    }

    func syncAfterLayout(with controller: KeyboardInputViewController) {
        syncIsFloating(with: controller)
        if controller.orientation == interfaceOrientation { return }
        sync(with: controller)
    }

    /// Perform a sync to check if the keyboard is floating.
    func syncIsFloating(with controller: KeyboardInputViewController) {
        let isFloating = controller.view.frame.width < screenSize.width/2
        if isKeyboardFloating == isFloating { return }
        isKeyboardFloating = isFloating
    }
}

private extension UIInputViewController {

    var orientation: InterfaceOrientation {
        view.window?.screen.interfaceOrientation ?? .portrait
    }

    var screenSize: CGSize {
        view.window?.screen.bounds.size ?? .zero
    }
}
#endif
