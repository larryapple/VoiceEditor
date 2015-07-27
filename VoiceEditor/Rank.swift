//
//  Copyright © 2015 Rivergate Software, Inc. All rights reserved.
//

public enum Rank: Int, Comparable {
	
	case Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King
	
	///	The number of cases in the Rank enum
	
	public static let count: Int = 13
	
	///	The card-counting value of a rank
	///	Returns a number from 1 to 10
	
	public var faceValue: Int {
		
		switch (self) {
			
		case .Jack, .Queen, .King:
			return 10
			
		default:
			return rawValue + 1
		}
	}
	
	///	Returns the unique name of the rank
	
	public var rankName: String {
		
		return ["A", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K"] [rawValue]
	}
	
	///	Returns the rank with a given name
	
//	public static func rankForRankName (rankName: String) throws -> Rank {
//		
//		guard let rank = ["A": .Ace, "2": Rank.Two, "3": .Three, "4": .Four, "5": .Five, "6": .Six, "7": .Seven, "8": .Eight, "9": .Nine, "T": .Ten, "J": .Jack, "Q": .Queen, "K": .King] [rankName] else { throw CommonError (0) }
//		
//		return rank
//	}
	
	///	Returns a string suitable for displaying the thin representation of the rank in the card font
	
	public var thinFontText: String {
		
		return ["A", "2", "3", "4", "5", "6", "7", "8", "9", "j", "J", "Q", "K"] [rawValue]
	}
	
	///	Returns a string suitable for displaying the fat representation of the rank in the card font
	
	public var fatFontText: String {
		
		return ["l", "2", "3", "4", "5", "6", "7", "8", "9", "u", "v", "w", "x"] [rawValue]
	}
	
}

public func == (lhs: Rank, rhs: Rank) -> Bool
{
	return lhs.rawValue == rhs.rawValue
}

public func < (lhs: Rank, rhs: Rank) -> Bool
{
	return lhs.rawValue < rhs.rawValue
}