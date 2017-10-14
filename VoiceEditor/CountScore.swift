//
//  Copyright © 2015 Rivergate Software, Inc. All rights reserved.
//

enum CommonError: Error, CustomStringConvertible
{
	case code (Int)
	
	init (_ code: Int)
	{
		self = CommonError.code (code)
	}
	
	var description: String
		{
			switch self
			{
			case .code (let code):
				return "Common Error \(code)"
			}
	}
}

public struct CountScore: RawRepresentable
{
	public var rawValue: Int {
		
		var value = pairsRuns.rawValue
		
		if flush == .four {
			value |= 2 << 4 }
		else if flush == .five {
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
			flush = .four }
		else if flushBits == 3 {
			flush = .five }
		else {
			flush = .none }
		
		if let prs = PairsRuns (rawValue: rawValue & 0xF) {
			pairsRuns = prs }
		else {
			pairsRuns = .none }
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
	
	public fileprivate(set) var jack: Bool = false
	
	public fileprivate(set) var fifteens: Int = 0
	
	public enum PairsRuns: Int {
		case none = 0, pairs1, pairs2, pairs3, pairs4, pairs6, pairs1Run3, run3, run3Double, run3DoubleDouble, run3Triple, run4, run4Double, run5
	}
	
	public fileprivate(set) var pairsRuns: PairsRuns = .none
	
	public enum Flush: Int {
		case none = 0
		case four = 4, five
	}
	
	public fileprivate(set) var flush: Flush = .none
	
	public var gamePoints: Int {
		
		var gamePoints = 0
		
		if fifteens > 0 {
			gamePoints += fifteens * 2 }
		
		switch pairsRuns {
			
		case .pairs1:
			gamePoints += 2
			
		case .pairs2:
			gamePoints += 4
			
		case .pairs3:
			gamePoints += 6
			
		case .pairs4:
			gamePoints += 8
			
		case .pairs6:
			gamePoints += 12
			
		case .pairs1Run3:
			gamePoints += 5
			
		case .run3:
			gamePoints += 3
			
		case .run3Double:
			gamePoints += 8
			
		case .run3DoubleDouble:
			gamePoints += 16
			
		case .run3Triple:
			gamePoints += 15
			
		case .run4:
			gamePoints += 4
			
		case .run4Double:
			gamePoints += 10
			
		case .run5:
			gamePoints += 5
			
		default:
			break
		}
		
		switch flush {
			
		case .four:
			gamePoints += 4
			
		case .five:
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

public func |= (lhs: inout CountScore, rhs: CountScore) throws {
	
	lhs.jack = lhs.jack || rhs.jack
	
	if lhs.fifteens == 0 {
		lhs.fifteens = rhs.fifteens }
		
	else if rhs.fifteens != 0 {
		throw CommonError (300) }
	
	if lhs.pairsRuns == .none {
		lhs.pairsRuns = rhs.pairsRuns }
		
	else if rhs.pairsRuns != .none {
		throw CommonError (301) }
	
	if lhs.flush == .none {
		lhs.flush = rhs.flush }
		
	else if rhs.flush != .none {
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
			
		case .pairs1:
			runPairString = "P1"
		case .pairs2:
			runPairString = "P2"
		case .pairs3:
			runPairString = "P3"
		case .pairs4:
			runPairString = "P4"
		case .pairs6:
			runPairString = "P6"
		case .pairs1Run3:
			runPairString = "P1R3"
		case .run3:
			runPairString = "R3"
		case .run3Double:
			runPairString = "R3D"
		case .run3DoubleDouble:
			runPairString = "R3DD"
		case .run3Triple:
			runPairString = "R3T"
		case .run4:
			runPairString = "R4"
		case .run4Double:
			runPairString = "R4D"
		case .run5:
			runPairString = "R5"
		default:
			runPairString = ""
		}
		
		scoreString += runPairString
		
		if flush == .four {
			scoreString += "F4" }
		else if flush == .five {
			scoreString += "F5" }
		
		return scoreString
	}
	
}
