//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
	func applicationDidFinishLaunching(aNotification: NSNotification)
	{
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

	let includeAndKey = "IncludeAnd"
	let useContinueNumbersKey = "UseContinueNumbers"
	let useSingleNumberKey = "UseSingleNumber"
	let cyclePhrasesKey = "CyclePhrases"

	// MARK: Properties
	
	var _includeAnd = false
	var includeAnd: Bool
		{
		get {return _includeAnd}
		set{
			_includeAnd = newValue
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(newValue, forKey: includeAndKey)
		}
	}
	
	var _useContinueNumbers: Bool = false
	var useContinueNumbers: Bool
		{
		get {return _useContinueNumbers}
		set{
			_useContinueNumbers = newValue
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(newValue, forKey: useContinueNumbersKey)
		}
	}
	
	var _useSingleNumber: Bool = false
	var useSingleNumber: Bool
		{
		get {return _useSingleNumber}
		set{
			_useSingleNumber = newValue
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(_useSingleNumber, forKey: useSingleNumberKey)
		}
	}
	
	var _cyclePhrases: Bool = false
	var cyclePhrases: Bool
		{
		get {return _cyclePhrases}
		set{
			_cyclePhrases = newValue
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(newValue, forKey: cyclePhrasesKey)
		}
	}
	
}

