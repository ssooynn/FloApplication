//
//  getTimeAndLyrics.swift
//  FloApplication
//
//  Created by 이수연 on 2021/03/13.
//
import Foundation
func getTimeAndLyrics(lyrics: Array<String>){
    
    for lyric in lyrics{
        let firstLyricIndex = lyric.index(lyric.startIndex, offsetBy: 11)
        let firstTimeIndex = lyric.index(lyric.startIndex, offsetBy: 1)
        let lastTimeIndex =  lyric.index(lyric.startIndex, offsetBy: 10)
        let arr = lyric[firstTimeIndex..<lastTimeIndex].components(separatedBy: ":")
        let time1 = (Float(arr[0])!*60)
        let time2 = (Float(arr[1])!)
        let time3 = Float(arr[2])! * 0.001
        
        playingDuration.append(time1 + time2 + time3)
        playingTimes.append(String(lyric[firstTimeIndex..<lastTimeIndex]))
        playingLyrics.append(String(lyric[firstLyricIndex...]))
      
    }
    //print(playingTimes)
    //print(playingLyrics)
}
