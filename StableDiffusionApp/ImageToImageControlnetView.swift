//
//  ImageToImageControlnetView.swift
//  StableDiffusionApp
//
//  Created by MaxMobile Software on 18/03/2024.
//

import SwiftUI
import AlertToast

struct ImageToImageControlnetView: View {
    @State private var image: Image?
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State var loading: Bool = false
    @State var imageBase64: String = ""
    @State var alertSaveSuccess: Bool = false
    @State var maxSize: CGFloat = 512
    @State var currentLora: Lora = .gakuenAnime
    @State var denoisingStrength: Double = 0.5
    @State var currentControlnet: ControlnetModel = .lineart
    
    var body: some View {
        VStack {
            VStack {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if loading {
                    ProgressView("Loadingggg")
                }
                
                if let image {
                    Text("\(maxSize)")
                    Slider(value: $maxSize, in: 128...2048) {
                        Text("Size Scale")
                    } minimumValueLabel: {
                        Text("128")
                    } maximumValueLabel: {
                        Text("2048")
                    }
                    
                    Text("\(denoisingStrength)")
                    Slider(value: $denoisingStrength, in: 0...1, step: 0.05) {
                        Text("denoisingStrength")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("1")
                    }
                    
                    ScrollViewReader { scrollProxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Lora.allCases, id: \.self) { item in
                                    Button {
                                        currentLora = item
                                    } label: {
                                        Text(item.rawValue)
                                            .font(.system(size: 18))
                                            .foregroundStyle(currentLora == item ? .yellow : .gray)
                                    }
                                    .id(item.rawValue)
                                }
                            }
                        }
                        .onAppear {
                            scrollProxy.scrollTo(currentLora.rawValue, anchor: .center)
                        }
                    }
                    
                    
                    Button {
                        guard let selectedImage else { return }
                        loading = true
                        self.image = nil
                        let size = resizeCGSize(selectedImage.size, maxSize: maxSize)
                        let model = ImageToImageControlnet(
                            prompt: "Best quality, masterpiece, ultra high res, raw photo, 8k, detailed face,",
                            negativePrompt: negativePromt,
                            width: Int(size.width),
                            height: Int(size.height),
                            denoisingStrength: denoisingStrength,
                            initImages: [imageBase64],
                            alwaysonScripts: .init(
                                controlnet: .init(
                                    args: [
                                        .init(
                                            inputImage: imageBase64,
                                            module: ControlnetModel.lineart.module,
                                            model: ControlnetModel.candy.model),
//                                        .init(
//                                            inputImage: imageBase64,
//                                            module: ControlnetModel.inpaint.module,
//                                            model: ControlnetModel.inpaint.model)
                                    ]
                                )
                            )
                        )
                        Api.shared.img2imgInpaint(for: model) { response in
                            loading = false
                            if let response {
                                if let uiImage = imageFromBase64(base64String: response.images.first ?? "") {
                                    DispatchQueue.main.async {
                                        self.selectedImage = uiImage
                                        self.image = Image(uiImage: uiImage)
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Image to image")
                            .padding()
                            .background(.gray)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        if let selectedImage {
                            CustomPhotoAlbum.save(image: .normal(selectedImage)) { error in
                                if let error {
                                    print("error")
                                } else {
                                    alertSaveSuccess = true
                                }
                            }
                        }
                        
                    } label: {
                        Text("Save")
                            .padding()
                            .background(.gray)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }

                }
            }
            
            Button("Select Image") {
                self.isShowingImagePicker = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: self.$selectedImage, isPresented: self.$isShowingImagePicker)
        }
        .onChange(of: selectedImage) { _ in
            loadImage()
        }
        .toast(isPresenting: $alertSaveSuccess) {
            AlertToast(displayMode: .alert, type: .complete(.green))
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        image = Image(uiImage: selectedImage)
        
        // Convert the UIImage to Data
        if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
            // Convert Data to base64 string
            let base64String = imageData.base64EncodedString()
            self.imageBase64 = base64String
        }
    }
    
    func resizeCGSize(_ size: CGSize, maxSize: CGFloat) -> CGSize {
        let widthRatio = maxSize / size.width
        let heightRatio = maxSize / size.height
        var newSize: CGSize

        if widthRatio < heightRatio {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        } else {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }

        return newSize
    }
}

#Preview {
    ImageToImageControlnetView()
}
