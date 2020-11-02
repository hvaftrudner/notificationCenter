//
//  ViewController.swift
//  project 21
//
//  Created by Kristoffer Eriksson on 2020-11-01.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var reminder = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }

    @objc func registerLocal(){
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("yahooo")
            } else {
                print("noooo")
            }
        }
    }
    
    @objc func scheduleLocal(){
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "the early birdy catches da burdy sheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbizz"]
        content.sound = .default
        
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 30
        
        var trigger : UNTimeIntervalNotificationTrigger?
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        if reminder == true {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        } else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "tell me more", options: .foreground)
        // add new notificationAction
        let remind = UNNotificationAction(identifier: "remind", title: "remind me later", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("Custom data received \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                //user swiped to unlock
                print("default identifier")
                let ac = UIAlertController(title: "swiped", message: "to unlock", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default))
                present(ac, animated: true)
                
            case "show":
                print("show more information")
                let ac = UIAlertController(title: "clicked", message: "more info", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default))
                present(ac, animated: true)
                
            case "remind":
                print("setting reminder 24h")
                if reminder == false {
                    reminder = true
                }
                scheduleLocal()
            default:
                break
            }
        }
        completionHandler()
    }
}

