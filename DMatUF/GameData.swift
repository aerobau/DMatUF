//
//  GameData.swift
//  DMatUF
//
//  Created by Ian MacCallum on 1/16/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation


enum GameState {
    case NeedsLandscape
    case Start
    case InProgress
    case GameOver
}

public class Team {
    var name = ""
    var score = 0
    

}

class GameData: NSCoding {

    var orangeTeam = Team()
    var blueTeam = Team()
    var teamUp: Team?

    var round = 0
    var playerCount = 0
    var phrases: [String] = []

    let categoriesArray = [
        /* 0: College Teams*/ ["Florida Gators","LSU Tigers","Tenessee Volunteers","Georgia Bulldogs","Oregon Ducks","Florida State Seminoles","Arkansas Razorbacks",
            "Alabama Crimson Tide","South Carolina Gamecocks","Ole Miss Rebels","Kentucky Wildcats","Texas A&M Aggies","Michigan Wolverines","Michigan State Spartans",
            "Texas Longhorns","Ohio State Buckeyes","Notre Dame FIghting Irish","Duke Blue Devils","Nebraska Cornhuskers","TCU Horned Frogs"],
        /* 1: dances*/["Macarena", "Teach me how to dougie", "Cat Daddy", "Cha Cha Slide", "Cupid Shuffle", "Thriller", "Gangnam Style"],
        /* 2: ESPN*/["Erin Andrews", "Tim Tebow", "Soccer", "Football", "Baseball", "Softball", "Tennis", "Champion", "Hockey", "Basketball", "College Gameday", "The Gators", "Referee", "Yellow Card", "Red Card", "Goalie", "First Down", "Kicker", "Defense", "Offense", "Punt", "Quarterback", "Michael Jordan", "Sideline", "Cheerleaders", "Halftime Show", "Cleats", "Superbowl", "National Championship", "3 Strikes You’re Out", "Foul Ball", "Heisman", "Overtime", "Sweat", "Tackle", "Wide Receiver", "Striker", "Scoreboard", "Head Coach", "Conditioning", "Two-a-Days", "Gatorade", "Practice Makes Perfect", "Jersey", "Puck", "Kick Off", "Rain Delay", "Fans", "Underdog", "Comeback", "Undefeated Season", "Marching Band", "Umpire", "Nike", "3-pointer", "Dribble", "Homerun", "Pitcher", "Stadium", "Under Armor", "Dazzlers", "Time Out", "Fantasy Football", "Just Do It", "Get Your Head in the Game", "Rivalry", "Sponsor", "Tie", "Semi-Finals"],
        
        /* 3: Medieval*/ ["Chivalry", "Jousting", "Dark Ages", "Sword in the Stone", "Duke", "Knight", "Renaissance", "Melee", "Gauntlet", "Chalice", "Alms", "Prince", "Queen", "King", "Princess", "Jester", "Feast", "Cannon", "Chainmail", "Goblet", "Armor", "Axe", "Bow", "Arrow", "Duel", "Castle", "Helmet"],
        
        /* 4: NickeloDM*/ ["Dancing Lobsters", "Orange Soda", "Penelope", "Totally Kyle", "Crazy Courtney", "The Girls Room", "All That", "Tommy Pickles", "Cynthia & Angelica", "Phil & Lil", "Chuckie", "Football Head", "Helga Patnki", "Orange Blimp", "Slime Time Live", "Ren & Shrimpy", "Keenan & Kel", "Are You Afraid of the Dark?", "Ahh Real Monsters", "Spongebob", "The Amanda Show", "The Wild Thornberries", "Rocket Power", "Cat Dog", "Angry Beavers", "Fairly Odd Parents", "Legends of the Hidden Temple"],
        
        /* 5: Dr. Seuss*/ ["The Lorax", "Cat in the Hat", "Green Eggs and Ham", "Andy Lou Who", "The Grinch", "Thing 1 and Thing 2", "Truffala Trees", "Fish", "39 and ½ Foot Pole", "Horton", "Theodore Geisel", "Star-bellied Sneetch", "Sam I am", "Max"],
        
        /* 6: Morale Royale*/ ["Captain", "Karaoke", "Royal Caribbean", "Carnival", "Buffet", "Casino", "Pool Deck", "Formal Night", "Anchor", "Port", "Dock", "Excursion", "Cabin", "Stateroom", "Putt-Putt Golf", "Life Vest", "Titanic", "Comedy Show", "Beach", "Towel", "Swimsuit", "Sunglasses", "Sunscreen", "Spa", "Massage", "Jacuzzi", "Night Club", "Newlyweds", "Vacation", "Bahamas", "Cazumel", "Hair Braiding", "Kids Club", "Tourists", "Sandals", "Soft Serve Ice Cream"],
        
        /* 7: Dance ‘Merica*/ ["Statue of Liberty", "Bald Eagle", "American Flag", "Fireworks", "Obama", "Golden Retriever", "Football", "Baseball", "BBQ", "Mount Rushmore", "Hot Dog", "Frat", "Miss America", "Shucking Corn", "McDonalds", "Jorts", "Oprah", "George Washington", "Beyonce", "Thanksgiving", "4th of July", "Black Friday", "Pearl Harbor", "Great Depression", "Civil War", "Prohibition", "Michael Jackson", "Forrest Gump", "United States", "Louis and Clark", "Sacagawea", "White House", "Grand Canyon", "Niagra Falls", "Declaration of Independence", "Martin Luther King Jr", "Secret Service", "The Kennedys", "NYPD", "FBI", "CIA", "Coca Cola", "New York", "Washington D.C."]
    ]
    
    let categoryNames = ["College Teams", "Dances", "ESPN", "Medieval", "NickeloDM", "Dr. Seuss", "Morale Royale", "Dance 'Merica"]
    
    
//    init(mode: Int, categories: [Int]) {
//        
//        for i in categories {
//            for phrase in categoriesArray[i] as [String] {
//                phrases.append(phrase)
//            }
//        }
//    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        blueTeam = decoder.decodeObjectForKey("blueTeam") as Team
        orangeTeam = decoder.decodeObjectForKey("orangeTeam") as Team
        
        
        blueTeam = decoder.decodeObjectForKey("blueTeam") as Team
        blueTeam = decoder.decodeObjectForKey("blueTeam") as Team
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }

    
    func selectPhrase() -> String {
        let index = Int(arc4random_uniform(UInt32(phrases.count)))
        let c = phrases[index]
        phrases.removeAtIndex(index)
        return c
    }
}

