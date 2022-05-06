//
//  Library.swift
//  CULibraries
//
//  Created by 过仲懿 on 4/27/22.
//

import Foundation

struct LibraryResponse: Codable {
    var libraries: [Library]
}

struct Library: Codable {
    
    var id: Int?
    var name: String?
    var areaId: Int?
    var timeStart: Int?
    var timeEnd: Int?
    var photo: String? // newly added


    init(id: Int, name: String, areaId: Int, timeStart: Int, timeEnd: Int, photo: String) {
        self.id = id
        self.name = name
        self.areaId = areaId
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.photo = photo // newly added
    }
    
}

struct RoomResponse: Codable {
    var rooms: [Room]
}

struct Room: Codable {
    var id: Int?
    var libraryId: Int?
    var name: String?
    var capacity: Int?
    var availability: [Int]?
    
    init(id: Int, libraryId: Int, name: String, capacity: Int, availability: [Int]) {
        self.id = id
        self.libraryId = libraryId
        self.name = name
        self.capacity = capacity
        self.availability = availability
    }
}

struct Booking: Codable {
    var id: Int?
    var libraryName: String?
    var roomName: String?
    var timeStart: Int?

    init(id: Int, libraryName: String, roomName: String, timeStart: Int) {
        self.id = id
        self.libraryName = libraryName
        self.roomName = roomName
        self.timeStart = timeStart
    }
}

struct BookingResponse: Codable {
    var bookings: [Booking]
}

enum filterList: String, CustomStringConvertible, Codable, CaseIterable {
    case artquad
    case agquad
    case engineering
    
    var description: String {
        switch self {
            case .artquad: return "Arts Quad"
            case .agquad: return "Ag Quad"
            case .engineering: return "Engineering"
        }
    }
}
