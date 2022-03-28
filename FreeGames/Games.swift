//
//  Games.swift
//  FreeGames
//
//  Created by Илья Маркелов on 04.12.2021.
//

struct MMOGames: Decodable {
    let title: String
    let thumbnail: String
    let short_description: String
    let game_url: String
    let genre: String
    let platform: String
    let publisher: String
    let release_date: String
}

enum Link: String {
    case mmmoGamesApi = "https://www.mmobomb.com/api1/games"
}
