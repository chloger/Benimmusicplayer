
//
//  PlayerViewController.swift
//  Benimmusicplayer
//
//  Created by Alperen yıldız on 4.05.2025.
//

import AVFoundation
import UIKit

class PlayerViewController: UIViewController {

    public var position: Int = 0
    public var songs: [Song] = []

    @IBOutlet var holder: UIView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var player: AVAudioPlayer?
    var timer: Timer?
    
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    var isConfigured = false

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !isConfigured {
            isConfigured = true

            playPauseButton.isHidden = false
            playPauseButton.backgroundColor = .white
            playPauseButton.tintColor = .black
            playPauseButton.layer.cornerRadius = 40 // yarıçapı güncelle
            playPauseButton.clipsToBounds = true

            // Buton boyutunu büyüttük
            let buttonSize: CGFloat = 80
            playPauseButton.frame = CGRect(
                x: (holder.frame.width - buttonSize) / 2,
                y: holder.frame.height - 120,
                width: buttonSize,
                height: buttonSize
            )

            // İkon boyutunu da büyüttük
            let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold)
            playPauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
        }
    }



    func configure() {
            let song = songs[position]

            albumImageView.image = UIImage(named: song.imagename)
            songNameLabel.text = song.name
            albumNameLabel.text = song.albumname
            artistNameLabel.text = song.artistname

            guard let path = Bundle.main.path(forResource: song.trackname, ofType: "mp3") else {
                print("Şarkı bulunamadı")
                return
            }

            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.volume = volumeSlider.value
                player?.play()

                progressSlider.minimumValue = 0
                progressSlider.maximumValue = Float(player?.duration ?? 0)
                progressSlider.value = 0

                durationLabel.text = formatTime(player?.duration ?? 0)
                currentTimeLabel.text = "00:00"
                startTimer()

            } catch {
                print("Ses çalma hatası")
            }
        }
        
    func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self, let player = self.player else { return }
                self.progressSlider.value = Float(player.currentTime)
                self.currentTimeLabel.text = self.formatTime(player.currentTime)
            }
        }

        func formatTime(_ time: TimeInterval) -> String {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }

        // MARK: - Buton Aksiyonları

        @IBAction func didTapPlayPauseButton(_ sender: UIButton) {
            guard let player = player else { return }

                let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)

                if player.isPlaying {
                    player.pause()
                    playPauseButton.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
                    UIView.animate(withDuration: 0.2) {
                        self.albumImageView.frame = self.albumImageView.frame.insetBy(dx: 20, dy: 20)
                    }
                } else {
                    player.play()
                    playPauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
                    UIView.animate(withDuration: 0.2) {
                        self.albumImageView.frame = self.albumImageView.frame.insetBy(dx: -20, dy: -20)
                    }
                }
        }

        @IBAction func didTapNextButton(_ sender: UIButton) {
            if position < songs.count - 1 {
                position += 1
                player?.stop()
                timer?.invalidate()
                configure()
            }
        }

        @IBAction func didTapBackButton(_ sender: UIButton) {
            if position > 0 {
                position -= 1
                player?.stop()
                timer?.invalidate()
                configure()
            }
        }

        @IBAction func didSlideVolume(_ sender: UISlider) {
            player?.volume = sender.value
        }

        @IBAction func didSlideProgress(_ sender: UISlider) {
            player?.currentTime = TimeInterval(sender.value)
        }
    
    
    }
        

        

