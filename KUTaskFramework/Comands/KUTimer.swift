//
//  KUTimer.swift
//  KUTaskFramework
//
//  Created by Kurushetra on 3/4/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


  protocol KUTimerable  {
//    var taskType:ComandType{get set}
    var id:String {get set}
    var timer:Timer {get set}
    var isRunning:Bool {get set}
    mutating func run()
    mutating func stop()
    func timerStart()
 
 
}


extension KUTimerable where Self :KUTimer  {
    
     mutating func run() {
         self.isRunning = true
        timerStart()
    }
    
     mutating func stop() {
         self.isRunning = false
    }

    func timerStart() {
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        print("timerStart()")
    }
    
    
}




class KUTimer:KUTimerable {
    
    
     var taskType:String
    var id:String
    var timer:Timer
    var isRunning:Bool
    
    
    init(timer:Timer, id:String, taskType:String) {
        self.timer = timer
        self.id = id
        self.taskType = taskType
        self.isRunning = false
    }
    
    
//    func timerStart() {
//        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
//        print("timerStart()")
//    }
    
    @objc func timerAction() {
        print("timer Action()")

        //        ComandsRuner.run(comand:ComandsRuner.comand1) { (results, comand) in
        //            ComandsRuner.comandsRunerDelegate?.finish(comand:comand, withResult:results)
        //        }
    }
    
 
}

