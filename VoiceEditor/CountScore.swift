//
//  Copyright © 2015 Rivergate Software, Inc. All rights reserved.
//

public struct CountScore: RawRepresentable
{
	public var rawValue: Int {
		
		var value = pairsRuns.rawValue
		
		if flush == .Four {
			value |= 2 << 4 }
		else if flush == .Five {
			value |= 3 << 4 }
		
		value |= fifteens << 8
		
		if jack {
			value |= 1 << 12 }
		
		return value
	}
	
	public init (rawValue: Int) {
		
		jack = rawValue & (1 << 12) != 0
		
		fifteens = (rawValue >> 8) & 0xF
		
		let flushBits = (rawValue >> 4) & 0x3
		if flushBits == 2 {
			flush = .Four }
		else if flushBits == 3 {
			flush = .Five }
		else {
			flush = .None }
		
		if let prs = PairsRuns (rawValue: rawValue & 0xF) {
			pairsRuns = prs }
		else {
			pairsRuns = .None }
	}
	
	public init () {
	}
	
	public init (jack: Bool) {
		self.jack = jack
	}
	
	public init (fifteens: Int) {
		self.fifteens = min (fifteens, 15)
	}
	
	public init (pairsRuns: PairsRuns) {
		self.pairsRuns = pairsRuns
	}
	
	public init (flush: Flush) {
		self.flush = flush
	}
	
	///	Possible values of the score for a hand, which may be combined
	
	public private(set) var jack: Bool = false
	
	public private(set) var fifteens: Int = 0
	
	public enum PairsRuns: Int {
		case None = 0, Pairs1, Pairs2, Pairs3, Pairs4, Pairs6, Pairs1Run3, Run3, Run3Double, Run3DoubleDouble, Run3Triple, Run4, Run4Double, Run5
	}
	
	public private(set) var pairsRuns: PairsRuns = .None
	
	public enum Flush: Int {
		case None = 0
		case Four = 4, Five
	}
	
	public private(set) var flush: Flush = .None
	
	public var gamePoints: Int {
		
		var gamePoints = 0
		
		if fifteens > 0 {
			gamePoints += fifteens * 2 }
		
		switch pairsRuns {
			
		case .Pairs1:
			gamePoints += 2
			
		case .Pairs2:
			gamePoints += 4
			
		case .Pairs3:
			gamePoints += 6
			
		case .Pairs4:
			gamePoints += 8
			
		case .Pairs6:
			gamePoints += 12
			
		case .Pairs1Run3:
			gamePoints += 5
			
		case .Run3:
			gamePoints += 3
			
		case .Run3Double:
			gamePoints += 8
			
		case .Run3DoubleDouble:
			gamePoints += 16
			
		case .Run3Triple:
			gamePoints += 15
			
		case .Run4:
			gamePoints += 4
			
		case .Run4Double:
			gamePoints += 10
			
		case .Run5:
			gamePoints += 5
			
		default:
			break
		}
		
		switch flush {
			
		case .Four:
			gamePoints += 4
			
		case .Five:
			gamePoints += 5
			
		default:
			break
		}
		
		if jack {
			gamePoints += 1 }
		
		return gamePoints
	}
	
}

public func == (lhs: CountScore, rhs: CountScore) -> Bool {
	return lhs.rawValue == rhs.rawValue
}

public func |= (inout lhs: CountScore, rhs: CountScore) throws {
	
	lhs.jack = lhs.jack || rhs.jack
	
	if lhs.fifteens == 0 {
		lhs.fifteens = rhs.fifteens }
		
	else if rhs.fifteens != 0 {
		throw CommonError (300) }
	
	if lhs.pairsRuns == .None {
		lhs.pairsRuns = rhs.pairsRuns }
		
	else if rhs.pairsRuns != .None {
		throw CommonError (301) }
	
	if lhs.flush == .None {
		lhs.flush = rhs.flush }
		
	else if rhs.flush != .None {
		throw CommonError (302) }
}

extension CountScore: CustomStringConvertible {
	
	public var description: String {
		
		var scoreString = ""
		
		if jack {
			scoreString += "J" }
		
		if fifteens != 0 {
			scoreString += "15-\(fifteens)" }
		
		let runPairString: String
		switch pairsRuns {
			
		case .Pairs1:
			runPairString = "P1"
		case .Pairs2:
			runPairString = "P2"
		case .Pairs3:
			runPairString = "P3"
		case .Pairs4:
			runPairString = "P4"
		case .Pairs6:
			runPairString = "P6"
		case .Pairs1Run3:
			runPairString = "P1R3"
		case .Run3:
			runPairString = "R3"
		case .Run3Double:
			runPairString = "R3D"
		case .Run3DoubleDouble:
			runPairString = "R3DD"
		case .Run3Triple:
			runPairString = "R3T"
		case .Run4:
			runPairString = "R4"
		case .Run4Double:
			runPairString = "R4D"
		case .Run5:
			runPairString = "R5"
		default:
			runPairString = ""
		}
		
		scoreString += runPairString
		
		if flush == .Four {
			scoreString += "F4" }
		else if flush == .Five {
			scoreString += "F5" }
		
		return scoreString
	}
	
}
