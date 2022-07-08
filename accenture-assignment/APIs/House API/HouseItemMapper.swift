//
//  HouseItemMapper.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/4/22.
//

import Foundation

enum HouseRegion: String {
    case TheNorth = "The North"
    case TheVale = "The Vale"
    case TheRiverlands = "The Riverlands OR Iron Islands"
    case TheWesterlands = "The Westerlands"
    case TheReach = "The Reach"
    case Dorne = "Dorne"
    case TheStormlands = "The Stormlands"
}

enum HouseImageURL: String {
    case TheNorth = "https://bit.ly/2Gcq0r4"
    case TheVale = "https://bit.ly/34FAvws"
    case TheRiverlands = "https://bit.ly/3kJrIiP"
    case TheWesterlands = "https://bit.ly/2TAzjnO"
    case TheReach = "https://bit.ly/2HSCW5N"
    case Dorne = "https://bit.ly/2HOcavT"
    case TheStormlands = "https://bit.ly/34F2sEC"
}

final class HouseItemMapper {
    private struct RemoteHouseItem: Decodable {
        let id: String
        let name: String
        let region: String
        let title: String
        
        var image: URL? {
            var imageString: HouseImageURL?
            switch HouseRegion(rawValue: region) {
            case .TheNorth:
                imageString = .TheNorth
            case .TheVale:
                imageString = .TheVale
            case .TheRiverlands:
                imageString = .TheRiverlands
            case .TheWesterlands:
                imageString = .TheWesterlands
            case .TheReach:
                imageString = .TheReach
            case .Dorne:
                imageString = .Dorne
            case .TheStormlands:
                imageString = .TheStormlands
            default: break
            }
            
            if let imageString = imageString {
                return URL(string: imageString.rawValue)
            }
            return .none
        }
        
        var item: HouseItem {
            return HouseItem(
                id: id,
                name: name,
                region: region,
                title: title,
                imageURL: image
            )
        }
    }
    
    private enum Error: Swift.Error {
        case invalidData
    }

    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [HouseItem] {
        guard response.statusCode == OK_200,
              let items = try? JSONDecoder().decode([RemoteHouseItem].self, from: data) else {
            throw Error.invalidData
        }
        
        return items.map { $0.item }
    }
}
