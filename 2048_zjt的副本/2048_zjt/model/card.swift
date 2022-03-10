//
//  card.swift
//  2048_zjt
//
//  Created by 张金涛 on 2022/1/16.
//

import Foundation
//卡片2，4，8...
class card{
    var value:Int;
    init(value:Int=0){
        self.value=value
    }
    //获取卡片值
    func getValue() -> Int {
        return value
    }
    //用于卡片合并
    func upGradeValue() -> Int{
        value *= 2
        return value
    }
}
