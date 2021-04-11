//
//  songsInfo.swift
//  FloApplication
//
//  Created by 이수연 on 2021/03/10.
//

import Foundation

struct SongsInfo: Codable{
    var singer: String = ""
    var album: String = ""
    var title: String = ""
    var duration: Int = 0
    var image: String = ""
    var file: String = ""
    var lyrics: String = ""
}
