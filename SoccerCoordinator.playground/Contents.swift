import Foundation
import GameKit

// MARK: - Step One - Create a Collection of the given players
// Dictionary format: [Key : Values] -> ["Player Name" : (Height(inches), "Soccer Experience", "Guardian Names")]
let players: [String : (String,Int,String,String)] = [
    
    "player0"  : ("Joe Smith", 42, "YES", "Jim and Jan Smith"),
    "player1"  : ("Jill Tanner", 36, "YES", "Clara Tanner"),
    "player2"  : ("Bill Bon", 43, "YES", "Sara and Jenny Bon"),
    "player3"  : ("Eva Gordon", 45, "NO",  "Wendy and Mike Gordon"),
    "player4"  : ("Matt Gill", 40, "NO",  "Charles and Sylvia Gill"),
    "player5"  : ("Kimmy Stein", 41, "NO",  "Bill and Hillary Stein"),
    "player6"  : ("Sammy Adams", 45, "NO",  "Jeff Adams"),
    "player7"  : ("Karl Saygan", 42, "YES", "Heather Bledsoe"),
    "player8"  : ("Suzane Greenberg", 44, "YES", "Henrietta Dumas"),
    "player9"  : ("Sal Dali", 41, "NO",  "Gala Dali"),
    "player10" : ("Joe Kavalier", 39, "NO",  "Sam and Elaine Kavalier"),
    "player11" : ("Ben Finkelstein", 44, "NO",  "Aaron and Jill Finkelstein"),
    "player12" : ("Diego Soto", 41, "YES", "Robin and Sarika Soto"),
    "player13" : ("Chloe Alaska", 47, "NO",  "David and Jamie Alaska"),
    "player14" : ("Arnold Willis", 43, "NO",  "Claire Willis"),
    "player15" : ("Phillip Helm", 44, "YES", "Thomas Helm and Eva Jones"),
    "player16" : ("Les Clay", 42, "YES", "Wynonna Brown"),
    "player17" : ("Herschel Krustofski", 45, "YES", "Hyman and Rachel Krustofski")
    
]

// MARK: - Step Two - Assign Players to teams

var teamSharks:  [(String, Int, String, String)] = []
var teamDragons: [(String, Int, String, String)] = []
var teamRaptors: [(String, Int, String, String)] = []

let totalNumberOfPlayers: Int = players.count
let totalNumberOfTeams        = 3
let numberOfPlayersPerTeam    = totalNumberOfPlayers / totalNumberOfTeams

var playersWithExperience:    [(String, Int, String, String)] = []
var playersWithoutExperience: [(String, Int, String, String)] = []

// This function splits the players, corresponding to their soccer experience, into two seperate arrays.
func fillArrayWithAPlayersCorrespondingExperience() {
    
    for j in 0...(players.count - 1) {
        let playerTag = "player" + String(j)
        
        guard players[playerTag]!.2 == "YES" else {
            playersWithoutExperience.append(players[playerTag]!)
            continue
        }
        playersWithExperience.append(players[playerTag]!)
    }
}
fillArrayWithAPlayersCorrespondingExperience()

// This function mixes up the playersWithExperience and playersWithoutExperience arrays in order to allow the program to find a set of players to allow the teams to conform to the 1.5 average height rule.  It is only called if the the first and higher iterations fail to conform.
func shuffleArray() {
    playersWithExperience = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: playersWithExperience) as! [(String, Int, String, String)]
    playersWithoutExperience = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: playersWithoutExperience) as! [(String, Int, String, String)]
}

// The next three functions assign each player to a team.
func assignPlayersToTeamShark() {
    
    for k in 0...2 {
        teamSharks.append(playersWithExperience[k])
        teamSharks.append(playersWithoutExperience[k])
        playersWithExperience.remove(at: k)
        playersWithoutExperience.remove(at: k)
    }
}

func assignPlayersToTeamDragons() {
    for j in 0...2 {
        teamDragons.append(playersWithExperience[j])
        teamDragons.append(playersWithoutExperience[j])
        playersWithExperience.remove(at: j)
        playersWithoutExperience.remove(at: j)
    }
}

func assignPlayersToTeamRaptors() {
    for i in 0...2 {
        teamRaptors.append(playersWithExperience[i])
        teamRaptors.append(playersWithoutExperience[i])
    }
    
}

assignPlayersToTeamShark()
assignPlayersToTeamDragons()
assignPlayersToTeamRaptors()
print(teamSharks)
print(teamDragons)
print(teamRaptors)

// MARK: - Make teams average height conform to the 1.5 inch rule

var averageHeightTeamSharks:  Int
var averageHeightTeamDragons: Int
var averageHeightTeamRaptors: Int

var heightsArrayTeamSharks:  [Int] = []
var heightsArrayTeamDragons: [Int] = []
var heightsArrayTeamRaptors: [Int] = []

// This function is only called until the teams conform to the 1.5 inch rule. It clear all arrays in order to append a new set of players to the team arrays.
func clearAllArrays() {
    playersWithExperience.removeAll()
    playersWithoutExperience.removeAll()
    teamSharks.removeAll()
    teamDragons.removeAll()
    teamRaptors.removeAll()
    heightsArrayTeamSharks.removeAll()
    heightsArrayTeamDragons.removeAll()
    heightsArrayTeamRaptors.removeAll()
}

// This function serves as the logic to make the teams conform to the 1.5 inch rule
func ensureAverageHeightsOfTeamsAre(withinRange range: Float) {
    
    var sumOfHeightsTeamSharks:  Int = teamSharks[0].1
    var sumOfHeightsTeamDragons: Int = teamDragons[0].1
    var sumOfHeightsTeamRaptors: Int = teamRaptors[0].1
    
    
    for j in 1...(teamSharks.count - 1) {
        sumOfHeightsTeamSharks = sumOfHeightsTeamSharks + teamSharks[j].1
        heightsArrayTeamSharks.append(teamSharks[j].1)
        
        sumOfHeightsTeamDragons = sumOfHeightsTeamDragons + teamDragons[j].1
        heightsArrayTeamDragons.append(teamDragons[j].1)
        
        sumOfHeightsTeamRaptors = sumOfHeightsTeamRaptors + teamRaptors[j].1
        heightsArrayTeamRaptors.append(teamRaptors[j].1)
    }
    
    let arrayOfAverageHeights: [Int] = [sumOfHeightsTeamSharks / numberOfPlayersPerTeam, sumOfHeightsTeamDragons / numberOfPlayersPerTeam, sumOfHeightsTeamRaptors / numberOfPlayersPerTeam]
    
    let maxOfAverageHeights = Float(arrayOfAverageHeights.max()!)
    let minOfAverageHeights = Float(arrayOfAverageHeights.min()!)
    
    guard (maxOfAverageHeights - minOfAverageHeights) >= range else {
        print("Team Sharks average team height is \(arrayOfAverageHeights[0]) inches")
        print("Team Dragons average team height is \(arrayOfAverageHeights[1]) inches")
        print("Team Raptors average team height is \(arrayOfAverageHeights[2]) inches")
        return
    }
    
    clearAllArrays()
    fillArrayWithAPlayersCorrespondingExperience()
    shuffleArray()
    assignPlayersToTeamShark()
    assignPlayersToTeamDragons()
    assignPlayersToTeamRaptors()
    ensureAverageHeightsOfTeamsAre(withinRange: 1.5)
    
}
ensureAverageHeightsOfTeamsAre(withinRange: 1.5)

// MARK: - Step 3 - Print letters to guardians

var letterToSharksGuardians: [String] = []
var letterToDragonsGuardians: [String] = []
var letterToRaptorsGuardians: [String] = []

func createLetters() {
    for i in 0...(teamSharks.count - 1) {
        letterToSharksGuardians.append("Dear \(teamSharks[i].3), I am Coach Justin and am excited to inform you that \(teamSharks[i].0) has been selected to play for the Sharks. The first practice will be on March 17 at 3pm. I look forward to meeting you and your athlete. Best, Coach Justin")
        print(letterToSharksGuardians[i])
        
        letterToDragonsGuardians.append("Dear \(teamDragons[i].3), I am Coach Kristine and am proud to announce that \(teamDragons[i].0) has been selected to play for the Sharks.  The first practice will be on March 17 at 3pm.  I look forward to meeting you and your athlete. Take care, Coach Kristine")
        print(letterToDragonsGuardians[i])
        
        letterToRaptorsGuardians.append("Dear \(teamRaptors[i].3), I am Coach Cynthia and I am proud to announce that \(teamRaptors[i].0) has been selected to play for the Sharks.  The first practice will be on March 17 at 3pm.  I look forward to meeting you and your athlete. Sincerely, Coach Cynthia")
        print(letterToRaptorsGuardians[i])
    }
}
createLetters()

// Thanks for looking!

