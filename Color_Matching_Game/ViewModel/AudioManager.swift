//
//  AudioManager.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-26.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var sfxPlayer: AVAudioPlayer?
    private var musicPlayer: AVAudioPlayer?

    // Plays short sound effects like "match" or "error"
    func playSound(named soundName: String) {
        guard UserDefaults.standard.bool(forKey: "soundEnabled"),
              let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.play()
        } catch {
            print("SFX Error: \(error)")
        }
    }

    // Loops background music
    func startBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "background_music", withExtension: "mp3") else { return }
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1 // Loop infinitely
            musicPlayer?.volume = 0.3 // Keep it low
            musicPlayer?.play()
        } catch {
            print("Music Error: \(error)")
        }
    }

    func stopBackgroundMusic() {
        musicPlayer?.stop()
    }
}
