//
//  ImageToImageControlnet.swift
//  StableDiffusionApp
//
//  Created by MaxMobile Software on 18/03/2024.
//

import Foundation

struct ImageToImageControlnet: Codable {

    let prompt: String
    let negativePrompt: String
    let seed: Int
    let batchSize: Int
    let steps: Int
    let cfgScale: Double
    let width: Int
    let height: Int
    let doNotSaveSamples: Bool
    let doNotSaveGrid: Bool
    let denoisingStrength: Double
    let initImages: [String]
    let mask: String?
    let samplerIndex: String
    let sendImages: Bool
    let saveImages: Bool
    let alwaysonScripts: AlwaysonScripts

    private enum CodingKeys: String, CodingKey {
        case prompt = "prompt"
        case negativePrompt = "negative_prompt"
        case seed = "seed"
        case batchSize = "batch_size"
        case steps = "steps"
        case cfgScale = "cfg_scale"
        case width = "width"
        case height = "height"
        case doNotSaveSamples = "do_not_save_samples"
        case doNotSaveGrid = "do_not_save_grid"
        case denoisingStrength = "denoising_strength"
        case initImages = "init_images"
        case mask = "mask"
        case samplerIndex = "sampler_index"
        case sendImages = "send_images"
        case saveImages = "save_images"
        case alwaysonScripts = "alwayson_scripts"
    }
    
    init(
        prompt: String = lora,
        negativePrompt: String = negativePromt,
        seed: Int = -1,
        batchSize: Int = 1,
        steps: Int = 20,
        cfgScale: Double = 6.5,
        width: Int = 512,
        height: Int = 512,
        doNotSaveSamples: Bool = true,
        doNotSaveGrid: Bool = true,
        denoisingStrength: Double = 0.7,
        initImages: [String], /// array image, start with "data:image/"
        mask: String? = nil,
        samplerIndex: String = "DPM++ 2M Karras",
        sendImages: Bool = true,
        saveImages: Bool = false,
        alwaysonScripts: AlwaysonScripts
    ) {
        self.prompt = prompt
        self.negativePrompt = negativePrompt
        self.seed = seed
        self.batchSize = batchSize
        self.steps = steps
        self.cfgScale = cfgScale
        self.width = width
        self.height = height
        self.doNotSaveSamples = doNotSaveSamples
        self.doNotSaveGrid = doNotSaveGrid
        self.denoisingStrength = denoisingStrength
        self.initImages = initImages
        self.mask = mask
        self.samplerIndex = samplerIndex
        self.sendImages = sendImages
        self.saveImages = saveImages
        self.alwaysonScripts = alwaysonScripts
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try values.decode(String.self, forKey: .prompt)
        negativePrompt = try values.decode(String.self, forKey: .negativePrompt)
        seed = try values.decode(Int.self, forKey: .seed)
        batchSize = try values.decode(Int.self, forKey: .batchSize)
        steps = try values.decode(Int.self, forKey: .steps)
        cfgScale = try values.decode(Double.self, forKey: .cfgScale)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        doNotSaveSamples = try values.decode(Bool.self, forKey: .doNotSaveSamples)
        doNotSaveGrid = try values.decode(Bool.self, forKey: .doNotSaveGrid)
        denoisingStrength = try values.decode(Double.self, forKey: .denoisingStrength)
        initImages = try values.decode([String].self, forKey: .initImages)
        mask = try values.decodeIfPresent(String.self, forKey: .mask)
        samplerIndex = try values.decode(String.self, forKey: .samplerIndex)
        sendImages = try values.decode(Bool.self, forKey: .sendImages)
        saveImages = try values.decode(Bool.self, forKey: .saveImages)
        alwaysonScripts = try values.decode(AlwaysonScripts.self, forKey: .alwaysonScripts)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(negativePrompt, forKey: .negativePrompt)
        try container.encode(seed, forKey: .seed)
        try container.encode(batchSize, forKey: .batchSize)
        try container.encode(steps, forKey: .steps)
        try container.encode(cfgScale, forKey: .cfgScale)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(doNotSaveSamples, forKey: .doNotSaveSamples)
        try container.encode(doNotSaveGrid, forKey: .doNotSaveGrid)
        try container.encode(denoisingStrength, forKey: .denoisingStrength)
        try container.encode(initImages, forKey: .initImages)
        try container.encodeIfPresent(mask, forKey: .mask)
        try container.encode(samplerIndex, forKey: .samplerIndex)
        try container.encode(sendImages, forKey: .sendImages)
        try container.encode(saveImages, forKey: .saveImages)
        try container.encode(alwaysonScripts, forKey: .alwaysonScripts)
    }

}

struct AlwaysonScripts: Codable {

    let controlnet: Controlnet

    private enum CodingKeys: String, CodingKey {
        case controlnet = "controlnet"
    }
    
    init(controlnet: Controlnet) {
        self.controlnet = controlnet
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        controlnet = try values.decode(Controlnet.self, forKey: .controlnet)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(controlnet, forKey: .controlnet)
    }

}

struct Controlnet: Codable {

    let args: [Args]

    private enum CodingKeys: String, CodingKey {
        case args = "args"
    }
    
    init(args: [Args]) {
        self.args = args
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        args = try values.decode([Args].self, forKey: .args)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(args, forKey: .args)
    }

}

struct Args: Codable {

    let inputImage: String
    let module: String
    let model: String

    private enum CodingKeys: String, CodingKey {
        case inputImage = "input_image"
        case module = "module"
        case model = "model"
    }
    
    init(inputImage: String, module: String, model: String) {
        self.inputImage = inputImage
        self.module = module
        self.model = model
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        inputImage = try values.decode(String.self, forKey: .inputImage)
        module = try values.decode(String.self, forKey: .module)
        model = try values.decode(String.self, forKey: .model)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inputImage, forKey: .inputImage)
        try container.encode(module, forKey: .module)
        try container.encode(model, forKey: .model)
    }

}
