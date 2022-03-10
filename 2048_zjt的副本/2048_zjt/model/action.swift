//
//  action.swift
//  2048_zjt
//
//  Created by 张金涛 on 2022/1/16.
//

import Foundation
//用于game中的改变传递到gameview中
enum Action{
    case move(from:position,to:position)
    case upgrade(from:position,to:position,value:Int)
    case new(at:position,value:Int)
    case success
    case failure
}

