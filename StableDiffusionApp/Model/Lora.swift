//
//  Lora.swift
//  StableDiffusionApp
//
//  Created by MaxMobile Software on 22/03/2024.
//

import Foundation

struct LoraModel: Codable {

    let name: String
    let alias: String
    let path: String

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case alias = "alias"
        case path = "path"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        alias = try values.decode(String.self, forKey: .alias)
        path = try values.decode(String.self, forKey: .path)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(alias, forKey: .alias)
        try container.encode(path, forKey: .path)
    }

}

extension LoraModel: Equatable {
}
