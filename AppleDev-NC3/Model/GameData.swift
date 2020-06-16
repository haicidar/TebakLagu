//
//  GameData.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 14/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import Foundation

enum SongCategory {
    case all, is90s, is00s
}

enum dataType: Int, Codable {
    case wrong, correct, dimsiss
}

struct Song: Codable {
    let judul: String
    let pencipta: String
    let lirik: [String]
    let kategori: Int
}

class GameData: Codable{
    var listOfPlayers:[Player] = []
    var rounds:Int
    var listOfSongs:[Song] = []
    var time = 32
    var nextRound = 1
    var isAnswering = false
    
    init(rounds : Int) {
        self.rounds = rounds
    }
    
    func randomSongs(rounds:Int, cat:SongCategory) {
        self.listOfSongs = getRandomSong(rounds: rounds, cat: cat)
//        var catId:Int = 0
//        switch cat {
//        case .all:
//            catId = 0
//        case .is90s:
//            catId = 1
//        case .is00s:
//            catId = 2
//        }
    }
    
    func setTime() -> Int{
        return rounds * 4
    }
    
    func getRandomSong(rounds:Int, cat:SongCategory) -> [Song]{
        if let url = Bundle.main.url(forResource: "list_songs", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Song].self, from: data)
                
                let sequence = 0 ..< jsonData.count
                let shuffledSequence = sequence.shuffled().prefix(rounds)
                
                var result:[Song] = []
                
                for a in shuffledSequence{
                    result.append(jsonData[a])
                }
                return result
                
            } catch {
                print("error:\(error)")
                return []
            }
        }
        print("kena")
        return []
    }
}
