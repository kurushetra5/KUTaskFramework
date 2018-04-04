//
//  KUTimer.swift
//  KUTaskFramework
//
//  Created by Kurushetra on 3/4/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol KUTimerable  {
    var taskType:String {get set}
    var id:String {get set}
    var timer:Timer {get set}
    
}





class KUTimer:KUTimerable {
    
    var taskType:String
    var id:String
    var timer:Timer
    
    init(timer:Timer, id:String, taskType:String) {
        self.timer = timer
        self.id = id
        self.taskType = taskType
        
    }
}

