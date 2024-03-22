//
//  Api.swift
//  StableDiffusionApp
//
//  Created by MaxMobile Software on 18/03/2024.
//

import Foundation
import SwiftUI
import Alamofire
import Foundation

//let host = "http://127.0.0.1:7860/sdapi/v1/"
//let host = "http://192.168.1.12:7860/sdapi/v1/"
let host = "http://34.69.165.198:7860/sdapi/v1/"

let lora: String = "<lora:gakuen_anime:1>"
let negativePromt: String = "easynegative, bad-image-v2-39000, bad_quality, vile_prompt3, bad-hands-5, (mature, fat:1.1), gloves, fat, paintings, sketches, (worst quality:2), (low quality:2), (normal quality:2), lowres, bad anatomy, text, error, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry, bad feet, poorly drawn face, bad proportions, gross proportions, pubic hair, normal quality, ((monochrome)), ((grayscale)), (((bad_nipples))), (((bad_pussy))), artifacts, skin artifacts, (((crossed_eyes)))"

let moduleInpaint = "inpaint_global_harmonious"
let modelInpaint = "inpaint [6098f75e]"

enum Lora: String, CaseIterable {
    case C_fashion = "<lora:C_fashion:1>"
    case animeRealism = "<lora:lora_anime_realism:1>"
    case animeScreencap = "<lora:lora_anime_screencap:1>"
    case tarotCard = "<lora:lora_anime_tarot_card:1>"
    case animeOutlineV4 = "<lora:lora_animeoutlineV4_16:1>"
    case cartoonStyle = "<lora:cartoon_style:1>"
    case chibiAnime = "<lora:chibi_anime:1>"
    case cyberPunk = "<lora:cyberhelmetv0.7:1>"
    case gakuenAnime = "<lora:gakuen_anime:1>"
    case hanfu = "<lora:C_hanfu:1>"
    case Freehand_Brushwork = "<lora:Freehand_Brushwork:1>"
    case animemix_v3_offset = "<lora:animemix_v3_offset:1>"
    case camicDusk = "<lora:ComiDusk:1>"
}

class Api {
    static var shared: Api = .init()
    
    private var alamofireSessionManager: Session

    private init() {
        let timeoutInterval: TimeInterval = 60*60*12
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval

        alamofireSessionManager = Alamofire.Session(configuration: configuration)
    }
    
    func textToImage(for model: TextToImageModel, onComplete: @escaping (ImageResponse?) -> Void) {
        alamofireSessionManager.request(host + "txt2img", method: .post, parameters: model, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(_):
                
                guard let res = response.response else { onComplete(nil); return }
                
                if res.statusCode == 200 {
                    let data = response.data
                    
                    do {
                        let model = try JSONDecoder().decode(ImageResponse.self, from: data!)
                        
                        onComplete(model)
                    } catch {
                        print(error.localizedDescription)
                        onComplete(nil)
                    }
                } else {
                    print("statusCode: \(res.statusCode)")
                    onComplete(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
    
    func imageToImage(for model: ImageToImageModel, onComplete: @escaping (ImageResponse?) -> Void) {
        alamofireSessionManager.request(host + "img2img", method: .post, parameters: model, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(_):
                
                guard let res = response.response else { onComplete(nil); return }
                
                if res.statusCode == 200 {
                    let data = response.data
                    
                    do {
                        let model = try JSONDecoder().decode(ImageResponse.self, from: data!)
                        
                        onComplete(model)
                    } catch {
                        print(error.localizedDescription)
                        onComplete(nil)
                    }
                } else {
                    print("statusCode: \(res.statusCode)")
                    onComplete(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
    
    func img2imgInpaint(for model: ImageToImageControlnet, onComplete: @escaping (ImageResponse?) -> Void) {
        alamofireSessionManager.request(host + "img2img", method: .post, parameters: model, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(_):
                
                guard let res = response.response else { onComplete(nil); return }
                
                if res.statusCode == 200 {
                    let data = response.data
                    
                    do {
                        let model = try JSONDecoder().decode(ImageResponse.self, from: data!)
                        
                        onComplete(model)
                    } catch {
                        print(error.localizedDescription)
                        onComplete(nil)
                    }
                } else {
                    print("statusCode: \(res.statusCode)")
                    onComplete(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
    
    func getLoraList(onComplete: @escaping ([LoraModel]) -> Void) {
        alamofireSessionManager.request(host + "loras", method: .get).response { response in
            switch response.result {
            case .success(_):
                
                guard let res = response.response else { onComplete([]); return }

                if res.statusCode == 200 {
                    let data = response.data
                    
                    do {
                        let model = try JSONDecoder().decode([LoraModel].self, from: data!)
                        
                        onComplete(model)
                    } catch {
                        print(error.localizedDescription)
                        onComplete([])
                    }
                } else {
                    print("statusCode: \(res.statusCode)")
                    onComplete([])
                }
            case .failure(let error):
                print(error.localizedDescription)
                onComplete([])
            }
        }
    }
}

func imageFromBase64(base64String: String) -> UIImage? {
    // Convert Base64 string to Data
    guard let imageData = Data(base64Encoded: base64String) else {
        return nil
    }
    
    // Convert Data to UIImage
    guard let image = UIImage(data: imageData) else {
        return nil
    }
    
    return image
}
