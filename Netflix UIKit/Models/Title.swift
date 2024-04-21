//
//  Title.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 21.04.2024.
//

import Foundation

struct TrendingTitleResponse: Decodable {
    let results: [Title]
}


struct Title: Decodable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

/*
 {
adult = 0;
"backdrop_path" = "/FUnAVgaTs5xZWXcVzPJNxd9qGA.jpg";
"genre_ids" =             (
 878,
 28,
 18
);
id = 934632;
"media_type" = movie;
"original_language" = en;
"original_title" = "Rebel Moon - Part Two: The Scargiver";
overview = "The rebels gear up for battle against the Motherworld as unbreakable bonds are forged, heroes emerge \U2014 and legends are made.";
popularity = "410.232";
"poster_path" = "/cxevDYdeFkiixRShbObdwAHBZry.jpg";
"release_date" = "2024-04-19";
title = "Rebel Moon - Part Two: The Scargiver";
video = 0;
"vote_average" = "6.064";
"vote_count" = 194;
},
 */
