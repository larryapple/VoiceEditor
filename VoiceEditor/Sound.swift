//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Foundation

class Sound
{
	var data: NSData
	var delay: Int
	var duration: Int

	init (phrase: Phrase, voice: Voice, fileData: NSData, adjust: Int)
	{
		data = fileData
		delay = adjust
		duration = voice.durationForPhrase(phrase)
		if (duration == 0)
		{
			duration = 1000
		}
	}
	
	init (number: Int, voice: Voice, fileData: NSData, isLast: Bool)
	{
		data = fileData
		delay = 0
		duration = voice.durationForNumber(number, isLast: isLast)
		if (duration == 0)
		{
			duration = 1000
		}
	}
}