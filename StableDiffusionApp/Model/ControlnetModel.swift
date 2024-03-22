//
//  ControlnetModel.swift
//  StableDiffusionApp
//
//  Created by MaxMobile Software on 18/03/2024.
//

import Foundation

enum ControlnetModel {
    case candy
    case inpaint
    case lineart
    
    var module: String {
        switch self {
        case .candy: return "canny"
        case .inpaint: return "inpaint_global_harmonious"
        case .lineart: return "lineart_standard (from white bg & black line)"
        }
    }
    
    var model: String {
        switch self {
        case .candy: return "candy [a3cd7cd6]"
        case .inpaint: return "candy [a3cd7cd6]"
        case .lineart: return "lineart [ef3b58fe]"
        }
    }
}
