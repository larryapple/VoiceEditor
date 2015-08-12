//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextDelegate
{	
	@IBOutlet weak var document: Document!

	@IBOutlet var languageTextField: NSTextField!
	@IBOutlet var localeTextField: NSTextField!
	@IBOutlet var voiceNameTextField: NSTextField!
	
	override func validateMenuItem(menuItem: NSMenuItem) -> Bool
	{
		
		return true
	}
	
	// MARK: Delegate functions
	
	//.	Note: should make sure the notification is from the adjustmentsTextView
	
	func textDidChange(notification: NSNotification)
	{
		//document.durationAdjustments = self.adjustmentsTextView.string!
	}
	
	// MARK: Actions
	
	@IBAction func editLanguage(sender: NSTextField)
	{
		document.language = sender.stringValue
	}
	
	@IBAction func editLocale(sender: NSTextField)
	{
		document.locale = sender.stringValue
	}
	
	@IBAction func editVoiceName(sender: NSTextField)
	{
		document.voiceName = sender.stringValue
	}
	
	@IBAction func generate(sender: AnyObject)
	{
		document.generateScores()
	}
	
	@IBAction func speakHand(sender: NSTextField)
	{
		document.speakHandText(sender.stringValue)
	}
	
	@IBAction func importAudioFiles(sender: NSMenuItem)
	{
		let openPanel: NSOpenPanel = NSOpenPanel ()
		openPanel.canChooseDirectories = true
		openPanel.canChooseFiles = false
		openPanel.allowsMultipleSelection = false
		openPanel.message = "Import all audio files from directory"
		
		openPanel.beginWithCompletionHandler { (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton
			{
				self.voiceNameTextField.stringValue = self.document.voiceName
			}
		}
	}
	
	// MARK: Overrides

	override func viewWillAppear()
	{
		super.viewWillAppear()
		
		document = view.window!.windowController!.document as! Document
		languageTextField.stringValue = self.document.language
		localeTextField.stringValue = self.document.locale
		voiceNameTextField.stringValue = self.document.voiceName
	}
}

