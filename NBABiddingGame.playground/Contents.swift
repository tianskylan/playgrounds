//: Playground - noun: a place where people can play

let bidValue = 10
let maxBids = 5
let gameBalanceDelta = 5.5

enum Team {
    case teamA
    case teamB
}

struct Transaction {
    let from: Player
    let to: Player
    let amount: Float
}

struct Player {
    let numberOfBids: Int
    let teamSelection: Team
    let name: String
    var transactions: [Transaction]
    
    init(numberOfBids: Int, teamSelection: Team, name: String, transactions: [Transaction] = []) {
        self.numberOfBids = numberOfBids
        self.teamSelection = teamSelection
        self.name = name
        self.transactions = transactions
    }
}

struct TeamPool {
    let totalBids: Int
    
    var totalValue: Float {
        return Float(totalBids * bidValue)
    }
}

let teamA = [
    Player(numberOfBids: 5, teamSelection: .teamA, name: "Tudou"),
    Player(numberOfBids: 5, teamSelection: .teamA, name: "Erjiu"),
    Player(numberOfBids: 1, teamSelection: .teamA, name: "Ivy")
]

let teamB = [
    Player(numberOfBids: 2, teamSelection: .teamB, name: "Sky"),
    Player(numberOfBids: 4, teamSelection: .teamB, name: "Zhuning"),
    Player(numberOfBids: 3, teamSelection: .teamB, name: "YL"),
    Player(numberOfBids: 2, teamSelection: .teamB, name: "Qi"),
]

func calculatePool(for team: Team, in players: [Player]) -> TeamPool {
    let playersForTeam = players.filter {
        $0.teamSelection == team
    }
    let bids = playersForTeam.reduce(0) { $0.0 + $0.1.numberOfBids }
    return TeamPool(totalBids: bids)
}

let teamAPool = calculatePool(for: .teamA, in: teamA)
let teamBPool = calculatePool(for: .teamB, in: teamB)

func findLosers(forWinners winners: [Player], losers: [Player], winnerPool: TeamPool, loserPool: TeamPool) -> [Player] {
    
    var results: [Player] = []
    
    for var loser in losers {
        for winner in winners {
            let moneyToWin = winnerPool.totalValue * Float(winner.numberOfBids) / Float(winnerPool.totalBids)
            let amount = moneyToWin * Float(loser.numberOfBids) / Float(loserPool.totalBids)
            let transaction = Transaction(from: loser, to: winner, amount: amount)
            loser.transactions.append(transaction)
        }
        results.append(loser)
    }
    
    return results
}

for loser in findLosers(forWinners: teamA, losers: teamB, winnerPool: teamAPool, loserPool: teamBPool) {
    for transaction in loser.transactions {
        print ("\(transaction.from.name) should pay \(transaction.to.name) \(transaction.amount) CNY")
    }
    
    print("\n-------------------------------\n")
}

