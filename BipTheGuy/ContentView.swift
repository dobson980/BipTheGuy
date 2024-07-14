//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Thomas Dobson on 7/13/24.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var animateImage = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(animateImage ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punch")
                    animateImage = false
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
                        animateImage = true
                    }
                }
            
            Spacer()
            
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .buttonStyle(.borderedProminent)
            .onChange(of: selectedPhoto) {
                Task {
                    if let newImage = try? await selectedPhoto?.loadTransferable(type: Image.self) {
                        bipImage = newImage
                    } else {
                        print("Failed to set new image")
                    }
                }
            }

        }
        .padding()
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("Could not read file named: \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error: \(error.localizedDescription) creating audioPlayer")
        }
    }
    
}

#Preview {
    ContentView()
}
