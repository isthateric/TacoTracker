//
//  MapMarkerWindow.swift
//  TacoTracker
//
//  Created by Eric Fuentes on 3/7/19.
//  Copyright © 2019 Eric Fuentes. All rights reserved.
//

import Foundation
import UIKit

//protocol MapMarkerDelegate: class {
//    func didTapInfoButton(data: NSDictionary)
//}

class MapMarkerWindow: UIView {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var operation: UILabel!
    
    
    @IBOutlet weak var moreInfo: UIButton!
    
    
    
    
}
    //    weak var delegate: MapMarkerDelegate?
//    var spotData: NSDictionary?
//
//    @IBAction func didTapInfoButton(_ sender: UIButton) {
//        delegate?.didTapInfoButton(data: spotData!)
//    }
//
//    class func instanceFromNib() -> UIView {
//        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
//    }
    
    
    

