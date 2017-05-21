//
//  ModelStructure.swift
//  MemeV1
//
//  Created by Divya Kabra on 5/20/17.
//  Copyright © 2017 Divya Kabra. All rights reserved.
//

import Foundation
import UIKit

// MARK: Structure to set up a model
extension MemeEditorViewController {
    
    struct Meme {
        let topText, bottomText: String
        let originalImage, memedImage: UIImage
    }
    
}
