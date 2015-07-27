//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Cocoa

class Document: NSDocument
{
	var voice: Voice?
	
	//	Override functions

	override init() {
	    super.init()
		// Add your subclass-specific initialization here.
	}

	override func windowControllerDidLoadNib(aController: NSWindowController) {
		super.windowControllerDidLoadNib(aController)
		// Add any code here that needs to be executed once the windowController has loaded the document's window.
	}

	override class func autosavesInPlace() -> Bool {
		return true
	}

	override func makeWindowControllers() {
		// Returns the Storyboard that contains your Document window.
		let storyboard = NSStoryboard(name: "Main", bundle: nil)
		let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
		self.addWindowController(windowController)
	}

	override func dataOfType(typeName: String) throws -> NSData
	{
		// Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
		// throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		

		let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(voice!)
		return data
	}
	
	override func readFromData(data: NSData, ofType typeName: String) throws
	{
		if let obj: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithData (data)
		{
			voice = obj as? Voice
		}
	
		else
		{
			throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		}
	}

}

