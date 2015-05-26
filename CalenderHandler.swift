//
//  CalenderHandler.swift
//  Bridge
//
//  Created by 许Bill on 15-3-6.
//  Copyright (c) 2015年 Fudan.SS. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI
class CalenderHandler {
    func addACalender(withActivity:Activity)->Bool{
        getPermisson()
        //createEventInStore()
        
        let eventStore = EKEventStore()
        let calendar = eventStore.defaultCalendarForNewEvents
        var event = EKEvent(eventStore: eventStore)
        event.title = withActivity.activityName
        
        
        let startDate = withActivity.startDate
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let interval = withActivity.duration
//        let hour = interval!.
        let date = dateFormatter.dateFromString(dateFormatter.stringFromDate(interval!))
        let calendarForTest = NSCalendar.currentCalendar()
        let comp = calendarForTest.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: date!)
        var hour = comp.hour
        var minute = comp.minute
        let overall = 3600 * hour + 60 * minute as NSInteger
        let timeInterval = NSTimeInterval(overall)
        let endDate = startDate.dateByAddingTimeInterval(timeInterval)
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "\(withActivity.activityName) is held"
        //        event.calendar = calendar
        return createEventForCalenderInEventStore(event, inCalender: calendar!, store: eventStore)
        
    }
    
    func findSourceForTitle(title:String)->EKSource?{
        let eventStore = EKEventStore()
        for source in eventStore.sources() as [EKSource] {
            if source.title.lowercaseString == title {
                return source
            }
        }
        return nil
    }
    func findCalendarForTitleInEventStore(title:String,eventStore:EKEventStore)->EKCalendar?{
        
        for calender in eventStore.calendarsForEntityType(EKEntityTypeEvent) as [EKCalendar]{
            if calender.title.lowercaseString == title {
                return calender
            }
        }
        return nil
    }
    func createEventForCalenderInEventStore(event:EKEvent,inCalender:EKCalendar,store:EKEventStore)->Bool{
        event.calendar = inCalender
        var error:NSError?
        let result = store.saveEvent(event, span: EKSpanThisEvent, error: &error)
        if result == false {
//            textField.text = "\(error)"
            println("\(error)")
            
        }
        println("Successfully add the event")
        return result
        
    }
    
    
    
    func getPermisson()->Bool{
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent){
        case .Authorized: extractEventEntityCalendarsOutOfStore(eventStore)
        case .Denied: displayAccessDenied()
        case .NotDetermined: eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
            {   [weak self] (granted: Bool, error: NSError!) -> Void in
                if granted{
                    self!.extractEventEntityCalendarsOutOfStore(eventStore) }
                else{
                    self!.displayAccessDenied()
                }
        })
        case .Restricted:
            displayAccessRestricted()
            
        }
        return false
    }
    
    
    func displayAccessDenied(){
        println("Access to the event store is denied.")
    }
    func displayAccessRestricted(){
        println("Access to the event store is restricted.")
    }
    
    
    
    
    func extractEventEntityCalendarsOutOfStore(eventStore: EKEventStore){
        println("In to the function")
        let calendarTypes = [ "Local",
            "CalDAV",
            "Exchange",
            "Subscription",
            "Birthday",
        ]
        let calendars = eventStore.calendarsForEntityType(EKEntityTypeEvent) as [EKCalendar]
        var str:String = ""
        for calendar in calendars {
            str += "Calendar title = \(calendar.title) \n"
            str += "Calendar type = \(calendarTypes[Int(calendar.type.value)])\n"
            
            println("Calendar title = \(calendar.title)")
            println("Calendar type = \(calendarTypes[Int(calendar.type.value)])")
            let color = UIColor(CGColor: calendar.CGColor)
            println("Calendar color = \(color)")
            if calendar.allowsContentModifications{
                println("This calendar allows modifications")
            }else{
                println("This calendar does not allow modifications")
            }
            str += "-------------------------------\n"
            
        }
        
    }
}