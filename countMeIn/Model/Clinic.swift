//
//  Clinic.swift
//  countMeIn
//
//  Created by Hansol Jo on 2021-04-30.
//

import Foundation
import Firebase

struct Clinic {
    let ref: DatabaseReference?
    let id: Int
    let name: String
    let lng: Double
    let lat: Double
    
    init(id: Int, name: String, lng: Double, lat: Double) {
      self.ref = nil
      self.id = id
      self.name = name
      self.lng = lng
      self.lat = lat
    }
    
    init?(snapshot: DataSnapshot) {
      guard
        let value = snapshot.value as? [String: AnyObject],
        let name = value["name"] as? String,
        let id = value["id"] as? Int,
        let lng = value["lng"] as? Double,
        let lat = value["lat"] as? Double else {
        return nil
      }
      
      self.ref = snapshot.ref
      self.id = id
      self.name = name
      self.lng = lng
      self.lat = lat
    }
    
    func toAnyObject() -> Any {
      return [
        "name": name,
        "lat": lat,
        "lng": lng
      ]
    }
}
