//
//  game.swift
//  2048_zjt
//
//  Created by 张金涛 on 2022/1/16.
//

import Foundation
import SwiftUI
struct position{
    var row:Int
    var line:Int
}
enum direction{
    case left
    case right
    case up
    case down
}
class game{
    private var size:Int = 4
     var Arr = [[card]]()
    init(size:Int = 4){
        self.size = size
   }
    //开始游戏
    func start(completion:(_ actions:[Action])->Void){
        Arr = emptyArr()
        var actions=[Action]()
        actions.append(createNewCard())
        actions.append(createNewCard())
        completion(actions)
    }
   //移动卡片
    func move(direction:direction,completion:(_ actions:[Action])->Void){
        let
    toArr : [direction:[Int]] = [.left:[0,-1],.right:[0,1],.down:[1,0],.up:[-1,0]]
        let to = toArr[direction]!
        var win = false
        var actions=[Action]()
        var newArr = emptyArr()
        //判断此卡片是否可以upgrade，即此次移动此卡片没有upgrade
        var mergeable=Array(repeating: Array(repeating: true, count: size), count: size)
        var outerRange = stride(from: 0, to: size, by: 1)
        var innerRange = stride(from: 0, to: size, by: 1)
        if direction == .right||direction == .down {
            innerRange = stride(from: size-1, to: -1, by: -1)
        
        if direction == .down{
            outerRange = stride(from: size-1, to: -1, by: -1)
        }
        }
        for row in outerRange{
            for line in innerRange{
                if Arr[row][line].getValue() == 0{
                    continue
                }
                var toRow=row,toLine=line
                while(true){
                    if newArr[toRow][toLine].getValue()==0 {
                        toRow += to[0]
                        toLine += to[1]
                        if toRow<0||toRow>=size||toLine<0||toLine>=size{
                          toRow-=to[0]
                          toLine-=to[1]
                            if toRow != row||toLine != line{
                                actions.append(.move(from: position(row: row, line: line), to: position(row: toRow, line: toLine)))
                            }
                          break
                        }
                    }else{
                        if (mergeable[toRow][toLine])&&(newArr[toRow][toLine].getValue()==Arr[row][line].getValue())
                        {
                            Arr[row][line].value =  Arr[row][line].upGradeValue()
                            actions.append(.upgrade(from: position(row: row, line: line), to: position(row: toRow, line: toLine), value: Arr[row][line].value))
                            mergeable[toRow][toLine]=false


                        }else{
                            toRow-=to[0]
                            toLine-=to[1]
                            if toRow != row||toLine != line{
                            actions.append(.move(from: position(row: row, line: line), to: position(row: toRow, line: toLine)))
                            }
                        }
                        break
                    }
                }
                newArr[toRow][toLine]=Arr[row][line]
                if newArr[toRow][toLine].value==2048{
                    win=true
                }
            }
        }
        Arr=newArr
        if actions.count>0{
            actions.append(createNewCard())

        }

        if win{
            actions.append(.success)
        }else if isFailure(){
            actions.append(.failure)
        }
        completion(actions)
        self.debugPrint()
        print(actions)
    }
    //结束游戏
    func end(){

    }//
    //判断是否失败
    private func isFailure()->Bool{
        let tos=[[0,1],[0,-1],[1,0],[-1,0]]
        for row in 0..<size{
            for line in 0..<size{
                if Arr[row][line].getValue()==0{
                    return false
                }else {
                    for to in tos{
                        let toRow=row+to[0],toLine=line+to[1]
                        if toRow>=0&&toRow<size&&toLine>=0&&toLine<size
                        {if Arr[toRow][toLine].getValue()==Arr[row][line].getValue(){
                            return false}
                            
                        }
                    
                        }
                    }
                }
            }
        
        return true

    }
    //生成空卡片数组
     func emptyArr() -> [[card]]{
        var emptyArr = [[card]]()
        for row in 0..<size {
            emptyArr.append([])
            for _ in 0..<size {
                emptyArr[row].append(card())

            }
        }
        return emptyArr
    }
    //在空位随机生成新卡片2或4
    private func createNewCard()->Action{
        var empty=[position]()
        for row in 0 ..< size{
            for line in 0 ..< size{
                if Arr[row][line].getValue() == 0{
                    empty.append(position(row: row, line: line))
                }
            }
        }

        let index=Int(arc4random_uniform(UInt32(empty.count)))
        let value=Int(arc4random_uniform(2)+1)*2
        Arr[empty[index].row][empty[index].line]=card(value:value)

        return Action.new(at: empty[index], value: value)
    }

func debugPrint(){
    for w in Arr{
        print(w.map({$0.getValue()}))
        
    }

    print()
 }
    
}


