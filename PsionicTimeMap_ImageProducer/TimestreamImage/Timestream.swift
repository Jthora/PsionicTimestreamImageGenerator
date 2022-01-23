//
//  Timestream.swift
//  Psionic Timestream Image Generator
//
//  Created by Jordan Trana on 1/22/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Foundation

struct Timestream {
    
    var planet:Planet
    var startDate:Date
    var endDate:Date
    var samples:[Sample]
    
    init(planet: Planet, startDate:Date, endDate:Date, samples:[Sample]) {
        self.planet = planet
        self.startDate = startDate
        self.endDate = endDate
        self.samples = samples
    }
    
    struct Sample {
        
        // Date
        let date:Date?
        let monthDidChange:Bool
        let yearDidChange:Bool
        
        // Planet State
        let planetState:Planet.State
        
        // Natural Harmonic
        var naturalHarmonic:Double {
            return Double(planetState.degrees)
        }
        
        // Planetary Distance
        var planetaryDistance:Double {
            return Double(planetState.distance)
        }
        
        // Gravimetric Field Strength
        var gravimetricFieldStrength:Double {
            return Double(planetState.gravity)
        }
        var relativeSpeed:Double {
            return Double(planetState.degreeDelta)
        }
    }
    
    
    typealias PlanetList = [Planet]
    enum Planet:String, CaseIterable {
        case sun
        case moon
        case mercury
        case venus
        case mars
        case jupiter
        case saturn
        case uranus
        case neptune
        case pluto
        case northnode
        case perigee
        case asteroidbelt
        
        var title: String {
            switch self {
            case .sun: return "Sun"
            case .moon: return "Moon"
            case .mercury: return "Mercury"
            case .venus: return "Venus"
            case .mars: return "Mars"
            case .jupiter: return "Jupiter"
            case .saturn: return "Saturn"
            case .uranus: return "Uranus"
            case .neptune: return "Neptune"
            case .pluto: return "Pluto"
            case .northnode: return "Lunar North Node"
            case .perigee: return "Lunar Perigee"
            case .asteroidbelt: return "Asteroid Belt"
            }
        }
        
        struct State {
            let degrees:Float
            let degreeDelta:Float
            let distance:Float
            let retrogradeState:RetrogradeState
            let gravity:Float
            
            enum RetrogradeState {
                case direct
                case retrograde
            }
        }
        
        var column:Int {
            switch self {
            case .sun: return 0
            case .moon: return 1
            case .mercury: return 2
            case .venus: return 3
            case .mars: return 4
            case .jupiter: return 5
            case .saturn: return 6
            case .uranus: return 7
            case .neptune: return 8
            case .pluto: return 9
            case .northnode: return 10
            case .perigee: return 11
            case .asteroidbelt: return 12
            }
        }
        
        static func from(index:Int) -> Planet? {
            switch index {
                case 0: return .sun
                case 1: return .moon
                case 2: return .mercury
                case 3: return .venus
                case 4: return .mars
                case 5: return .jupiter
                case 6: return .saturn
                case 7: return .uranus
                case 8: return .neptune
                case 9: return .pluto
                case 10: return .northnode
                case 11: return .perigee
                case 12: return .asteroidbelt
            default: return nil
            }
        }
    }
    
    func generateAndSaveImageToDisk(colorRenderMode: Timestream.ImageGenerator.ColorRenderMode, dataMetric: Timestream.ImageGenerator.ColorRenderMode.DataMetric, markYears: Bool, markMonths: Bool) {
        let imageStrip = generateImageStrip(colorRenderMode: colorRenderMode, dataMetric: dataMetric, markYears: markYears, markMonths: markMonths)
        imageStrip?.save()
    }
    
    func generateImageStrip(colorRenderMode: Timestream.ImageGenerator.ColorRenderMode, dataMetric: Timestream.ImageGenerator.ColorRenderMode.DataMetric, markYears: Bool, markMonths: Bool) -> Timestream.ImageStrip? {
        return Timestream.ImageGenerator.generateStrip(timestream: self, colorRenderMode: colorRenderMode, dataMetric: dataMetric, markYears: markYears, markMonths: markMonths)
    }
    
    typealias TimestreamSet = [Planet:Timestream]
    static func generateTimestreamSet(allSamples:[Planet:[Sample]], startDate: Date, endDate:Date) -> TimestreamSet {
        var timesteams = TimestreamSet()
        for planet in Planet.allCases {
            guard let samples = allSamples[planet] else {continue}
            let timestream = Timestream(planet: planet,
                                        startDate: startDate,
                                        endDate: endDate,
                                        samples: samples)
            timesteams[planet] = timestream
        }
        return timesteams
    }
}
