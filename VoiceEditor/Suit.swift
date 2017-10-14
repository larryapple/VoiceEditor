//
//  Copyright © 2015 Rivergate Software, Inc. All rights reserved.
//

public enum Suit: Int {
	
	case clubs, diamonds, hearts, spades
	
	///	The number fo cases in the Suit enum
	
	public static let count: Int = 4
	
	///	Returns the unique name of the suit
	
	public var suitName: String {
		
		return ["C", "D", "H", "S"] [rawValue]
	}
	
	//	Returns the suit with the given name
	
//	public static func suitForSuitName (suitName: String) throws -> Suit {
//		
//		guard let suit = ["C": .Clubs, "D": Suit.Diamonds, "H": .Hearts, "S": .Spades] [suitName] else { throw CommonError (0) }
//		
//		return suit
//	}
	
	///	Returns a string suitable for displaying the representation of the suit in the card font
	
	public var suitFontText: String {
		
		return ["Y", "W", "X", "Z"] [rawValue]
	}
	
}

public func < (lhs: Suit, rhs: Suit) -> Bool {
	return lhs.rawValue < rhs.rawValue
}

