//
//  NetworkManager.swift
//  CULibraries
//
//  Created by 过仲懿 on 5/2/22.
//

import Foundation
import UIKit
import Alamofire

class NetworkManager {
    static let host = "http://34.130.189.17"

    static func getAllLibrary(completion: @escaping (([Library]) -> Void)) {
        let endpoint = "\(host)/libraries/"
        AF.request(endpoint, method: .get).responseData { response in
            switch(response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let libraryResponse = try?
                    jsonDecoder.decode(LibraryResponse.self, from:data) {
                    completion(libraryResponse.libraries)
                } else {
                    print("Failed to decode getAllLibrary")
                }
                case .failure(let error):
                print(error.localizedDescription)
        }
    }
    }

    static func getAllRoomByID(libraryid: Int, completion: @escaping (([Room]) -> Void)) { //
        let endpoint = "\(host)/rooms/libraries/\(libraryid)/"
        AF.request(endpoint, method: .get).validate().responseData { response in
                switch(response.result) {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let RoomResponse = try?
                        jsonDecoder.decode(RoomResponse.self, from:data) {
                        completion(RoomResponse.rooms)
                    } else {
                        print("Failed to decode getAllRoomByID")
                    }
                    case .failure(let error):
                    print(error.localizedDescription)
            }
        }}
    
    static func createBooking(netId: String, roomId: Int, timeStart: Int, completion: @escaping ((Booking) -> Void)) {
        let endpoint = "\(host)/bookings/"
        let para: [String : Any] = [
            "net_id" : netId,
            "room_id" : roomId,
            "time_start" : timeStart
        ]
        AF.request(endpoint, method: .post, parameters: para, encoding: JSONEncoding.default).validate().responseData { response in
            switch(response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let createNewBooking = try?
                    jsonDecoder.decode(Booking.self, from: data) {
                    completion(createNewBooking)
                } else {
                    print("Failed to decode createBooking")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
//    static func createBooking(netId: String, roomId: String, timeStart: String, completion: (Booking) ) { // roomId to int, timestart to in t
//        let endpoint = "\(host)/bookings/"
//        let para: [String : String] = [
//            "netId" : netId,
//            "roomId" : roomId,
//            "timeStart" : timeStart
//        ]
//        AF.request(endpoint, method: .post, parameters: para, encoder: JSONParameterEncoder.default).validate().responseData { response in
//            switch(response.result) {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let createNewBooking = try?
//                    jsonDecoder.decode(Booking.self, from: data) {
//                    completion(createNewBooking)
//                } else {
//                    print("Failed to decode createBooking")
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    static func getAllBooking(userid: String, completion: @escaping ([Booking]) -> Void) {
        let endpoint = "\(host)/bookings/users/\(userid)/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch(response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let BookingResponse = try?
                    jsonDecoder.decode(BookingResponse.self, from: data) {
                    completion(BookingResponse.bookings)
                } else {
                    print("Failed to decode getAllBooking")
                }
                case .failure(let error):
                print(error.localizedDescription)
        }
    }
}
    
    static func deleteBooking(bookingid: Int, completion: @escaping (Booking) -> Void) {
        let endpoint = "\(host)/bookings/delete/\(bookingid)/"
        let para: [String : Int] = [
            "bookingid" : bookingid
        ]
        AF.request(endpoint, method: .delete, parameters: para, encoder: JSONParameterEncoder.default).validate().responseData { response in
            switch(response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userResponse = try? jsonDecoder.decode(Booking.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode deleteBooking")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
    
