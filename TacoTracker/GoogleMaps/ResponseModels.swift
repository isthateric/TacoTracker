//
//  ResponseModels.swift
//  TacoTracker
//
//  Created by Eric Fuentes on 3/6/19.
//  Copyright © 2019 Eric Fuentes. All rights reserved.
//

import Foundation





struct GooglePlacesResponse : Codable {
    let results : [Place]
    //c
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct Place : Codable {
    
    let geometry : Location //a
    let name : String
    let openingHours : OpenNow? //b
    let photos : [PhotoInfo] //c
    let types : [String]
    let address : String
    
    enum CodingKeys : String, CodingKey {
        case geometry = "geometry"
        case name = "name"
        case openingHours = "opening_hours" //d
        case photos = "photos"
        case types = "types"
        case address = "vicinity"
    }
    
    struct Location : Codable {
        
        let location : LatLong
        
       
        
        enum CodingKeys: String, CodingKey {
            case location = "location"
        }
        
        
  
        struct LatLong: Codable {
            
            let latitude : Double
            let longitude : Double
            
            enum CodingKeys : String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
        struct OpenNow : Codable {
            //a.
            let isOpen : Bool
            
            enum CodingKeys : String, CodingKey {
                case isOpen = "open_now"
            }
        }
    
        struct PhotoInfo : Codable {
            
            let height : Int
            let width : Int
            let photoReference : String
            
            enum CodingKeys : String, CodingKey {
                case height = "height"
                case width = "width"
                case photoReference = "photo_reference"
            }
        }
}



