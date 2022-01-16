//
//  ColorRenderMode.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 1/15/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Foundation

enum ColorRenderMode: String, CaseIterable {
    case Gradient_Color
    case Solid_Color
    case Gradient_Color_Retrogrades_Inverted
    case Solid_Color_Retrogrades_Inverted
    case BlackWhite_Retrogrades
    case Grayscale_Retrogrades
    case Clear
    
    var title:String {
        switch self {
        case .Gradient_Color: return "Gradient RGYB Color (default)"
        case .Solid_Color: return "Solid RGYB Color"
        case .Gradient_Color_Retrogrades_Inverted: return "Gradient RGYB Color - Retrogrades Inverted"
        case .Solid_Color_Retrogrades_Inverted: return "Solid RGYB Color - Retrogrades Inverted"
        case .BlackWhite_Retrogrades: return "Black & White - Retrogrades Only"
        case .Grayscale_Retrogrades: return "Grayscale - Retrogrades Only"
        case .Clear: return "Clear (for Rendering Marks with clear background)"
        }
    }
    
    func has(title:String) -> Bool {
        return self.title == title
    }
    
    static func from(title:String) -> ColorRenderMode? {
        for renderMode in ColorRenderMode.allCases {
            if renderMode.title == title { return renderMode }
        }
        return nil
    }
    
    var retrograde: Bool {
        switch self {
        case .Gradient_Color_Retrogrades_Inverted, .Grayscale_Retrogrades, .BlackWhite_Retrogrades, .Solid_Color_Retrogrades_Inverted: return true
        default: return false
        }
    }
    var retrogradeInverted: Bool {
        switch self {
        case .Solid_Color_Retrogrades_Inverted, .Gradient_Color_Retrogrades_Inverted: return true
        default: return false
        }
    }
    var solidColors: Bool {
        switch self {
        case .Solid_Color, .Solid_Color_Retrogrades_Inverted: return true
        default: return false
        }
    }
    
    func color(for planetState:EphemerisDataParser.PlanetState) -> RGBAColor {
        
        let invert = planetState.retrogradeState == .retrograde
        
        switch self {
        case .Clear:
            return RGBAColor.clear
        case .Gradient_Color:
            return RGBAColor(degrees: planetState.degrees, invert: false, solidColors: false)
        case .Gradient_Color_Retrogrades_Inverted:
            return RGBAColor(degrees: planetState.degrees, invert: invert, solidColors: false)
        case .Solid_Color:
            return RGBAColor(degrees: planetState.degrees, invert: false, solidColors: true)
        case .Solid_Color_Retrogrades_Inverted:
            return RGBAColor(degrees: planetState.degrees, invert: invert, solidColors: true)
        case .Grayscale_Retrogrades, .BlackWhite_Retrogrades:
            return invert ? RGBAColor.black : RGBAColor.white
        }
    }
}

