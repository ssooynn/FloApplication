//  ViewController.swift
//  FloApplication
//
//  Created by 이수연 on 2021/03/07.

import UIKit
import AVFoundation

var audioPlayer = AVAudioPlayer()
var audioTimer = Timer()
var songs: [String] = []
var thisIndex: Int = 0
var duration: Int = 0
var musicFile: String = ""

var playingDuration: [Float] = []
var playingTimes: [String] = []
var playingLyrics: [String] = []
var lyricsArr: [String] = []


@available(iOS 13.0, *)
class ViewController: UIViewController{


    @IBOutlet weak var songtitle: UILabel!
    @IBOutlet weak var lyrics: UILabel!
    @IBOutlet weak var singer: UILabel!
    
    @IBOutlet weak var album_name: UILabel!
    @IBOutlet weak var album_image: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var lyricsButton: UIButton!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playingButton: UIButton!
    @IBOutlet weak var playingSlider: UISlider!
    

    
    @IBAction func playing(_ sender: Any) {
        if audioPlayer.isPlaying{
            audioPlayer.pause()
            playingButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            self.invalidateTimer()
        }
        else{
            playSong(thisOne: musicFile)
            playingButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.makeAndFireTimer()
        }
    }

    @IBAction func next(_ sender: Any) {
        if thisIndex<songs.count-1
        {   thisIndex += 1
            playSong(thisOne: songs[thisIndex])
        }
    }
    
    @IBAction func previous(_ sender: Any) {
        if thisIndex > 0
        {
            thisIndex -= 1
            playSong(thisOne: songs[thisIndex])
        }
    }
    
    @IBAction func slider(_ sender: UISlider) {
    
        lyricsButton.setTitle(String(sender.value), for: .normal)
        lyricsButton.setTitleColor(UIColor.black, for: .normal)
        
        audioPlayer.currentTime = TimeInterval(sender.value)
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        audioPlayer.currentTime = TimeInterval(sender.value)
        
    }
    
    func playSong(thisOne:String){
        do{
            let audioData = try Data(contentsOf: URL(string: thisOne)!)
            try audioPlayer = AVAudioPlayer(data: audioData)
            audioPlayer.play()
        }
        catch{
            print("ERROR")
        }
    }
    
    func updateTimeLabelText(time: TimeInterval) {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        //let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        let timeText: String = String(format: "%02ld:%02ld", minute, second)
        
        self.timeLabel.text = timeText
        
    }

    func updateTimeLabelText2(time: TimeInterval) {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        //let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        let timeText: String = String(format: "%02ld:%02ld", minute, second)
        
        self.timeLabel2.text = timeText
        
    }
    
    
    func makeAndFireTimer() {
        audioTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            if self.playingSlider.isTracking { return }
            
            self.updateTimeLabelText(time: audioPlayer.currentTime)
            self.playingSlider.value = Float(audioPlayer.currentTime)
    
        })
        audioTimer.fire()
    }
    
    func invalidateTimer() {
        audioTimer.invalidate()
        //audioTimer = nil
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
        
    }

    func parseJSON(){
        let urlString = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
        let url = URL(string: urlString)
        guard url != nil else{
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!){ (data, response, error) in
            
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                do{
                    let songsInfo = try decoder.decode(SongsInfo.self, from: data!)
                    DispatchQueue.main.async {
                        self.songtitle.text = songsInfo.title
                        lyricsArr = songsInfo.lyrics.components(separatedBy: "\n")
                        getTimeAndLyrics(lyrics: lyricsArr)
                        //print(playingLyrics)
                        self.album_name.text = songsInfo.album
                        self.singer.text = songsInfo.singer
                        
                        do{
                            let data = try Data(contentsOf: URL(string: songsInfo.image)!)
                            self.album_image.image = UIImage(data: data)
            
                            
                        }
                        catch{
                            
                        }
                        duration = songsInfo.duration
                        self.updateTimeLabelText2(time: TimeInterval(duration))
                        musicFile = songsInfo.file
                        self.playingSlider.maximumValue = Float(duration)
                        self.playingSlider.minimumValue = 0
                        self.playingSlider.value = Float(audioPlayer.currentTime)
                    }
                    
                }
                catch{
                    print("Error in JSON parsing")
                }
            }
            
        }
        dataTask.resume()

    }
}

