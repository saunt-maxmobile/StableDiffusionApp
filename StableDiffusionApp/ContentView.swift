//
//  ContentView.swift
//  StableDiffusionApp
//
//  Created by MaxMobile Software on 18/03/2024.
//

import SwiftUI

struct ContentView: View {
    enum Tab {
        case txt2img
        case img2img
        case img2imgControlnet
    }
    
    @State var currentTab: Tab = .img2img
    
    var body: some View {
        TabView(selection: $currentTab) {
            TextToImageView()
                .tag(Tab.txt2img)
                .tabItem {
                    Label("Text to Image", systemImage: "list.dash")
                }
            
            ImageToImageView()
                .tag(Tab.img2img)
                .tabItem {
                    Label("Image to Image", systemImage: "square.and.pencil")
                }
            
            ImageToImageControlnetView()
                .tag(Tab.img2imgControlnet)
                .tabItem {
                    Label("Image to Image Controlnet", systemImage: "rectangle.portrait.and.arrow.right.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
