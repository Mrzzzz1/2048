//
//  gameView.swift
//  2048_zjt
//
//  Created by 张金涛 on 2022/1/16.
//

import SwiftUI
protocol gameViewDelegate{
    func slideEnded(offset:CGPoint)
    func changeMask(value:Int)
    func success()
    func failure()
}

class gameView: UIView ,UIGestureRecognizerDelegate{
    var delegate:gameViewDelegate?=nil
    //用于手势事件
    private var startLocation = CGPoint()
    private var touchingDetectable = true
    
    
    var size=4
    //边框尺寸（每张卡片有上下左右边框）
    private let margin:CGFloat = 5.0
    //游戏区域矩形（减去四周边框）
    private var drawBound:CGRect{
        var bound = self.bounds
        print(bound)
        bound.origin.x+=margin;bound.origin.y+=margin
        bound.size.width -= margin*2;bound.size.height -= margin*2
        return bound
    }
    //每张卡片区域大小（含边框）
    private var boundSize:CGFloat{
        let viewWidth=drawBound.size.width
        return viewWidth/CGFloat(size)
    }
    //卡片大小不含上下左右边框
    private var cardSize:CGSize{
        return CGSize(width: boundSize-margin*2, height: boundSize-margin*2)
    }
    //生成卡片矩形
    private func getRectOf(row:Int,line:Int)->CGRect{
        var location=CGPoint(x: CGFloat(line)*boundSize, y: CGFloat(row)*boundSize)
        location.x+=margin+drawBound.origin.x
        location.y+=margin+drawBound.origin.y
        return CGRect(origin: location, size: cardSize)
    }
   // 绘制卡片框
    override func draw(_ rect: CGRect) {
        UIColor(displayP3Red: 0.85, green: 0.75, blue: 0.70, alpha: 1).setFill()
        for row in 0..<size{
            for line in 0..<size{
                let rect=UIBezierPath(roundedRect: getRectOf(row: row, line: line), cornerRadius: 10.0)
                rect.fill()
            }
        }
    }
    
    func setUpView(){
        self.backgroundColor = .clear
        guard let superV=superview else {return}
        self.translatesAutoresizingMaskIntoConstraints=false
        self.centerXAnchor.constraint(equalTo: superV.centerXAnchor).isActive=true
        self.centerYAnchor.constraint(equalTo: superV.centerYAnchor).isActive=true
        self.widthAnchor.constraint(equalTo: superV.widthAnchor).isActive=true
        self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        print(self.bounds)
    }
//手势事件
func performActions(_ actions:[Action]){
    for action in actions {
        switch action{
        case .new(at:let position, value:let value):
            newCard(at:position,with:value)
        case .move(from: let from, to: let to):
            moveCard(from: from, to: to)
        case .upgrade(from: let from, to: let to, value: let value):
            upGradeCard(from: from, to: to, newvalue: value)
        case .success:
            delegate?.success()
        case .failure:
            delegate?.failure()
        }
    }
}
    //position->tag
private func tag(at position:position)->Int
    {
        return (1+position.row)*100+position.line
    }
    //tag->card
private func getCardView(at position:position)->cardView?{
        return viewWithTag(tag(at: position)) as? cardView
    }
    //在视图上生成cardview，若已有则remove，用于随机生成和卡片合并
private func newCard(at position:position,with value:Int){
    if let cardView = getCardView(at: position){
        cardView.removeFromSuperview()
    }
    let newCardView=cardView(frame: getRectOf(row: position.row, line: position.line), value: value)
    addSubview(newCardView)
    newCardView.tag=tag(at: position)
    newCardView.createAnimation()
    }
    //卡片移动动画
private func moveCard(from: position, to:position){
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.06*Double(max(abs(from.row-to.row), abs(from.line-to.line))), delay: 0.0, options: [], animations:{
        if let cardView=self.getCardView(at: from){
            cardView.frame=self.getRectOf(row: to.row, line: to.line)
            cardView.tag=self.tag(at: to)
        }
    })
        
    }
    //卡片移动合并
    private func upGradeCard(from:position,to:position,newvalue:Int){
        if let cardView=self.getCardView(at: to){
            cardView.removeFromSuperview()
        }
        moveCard(from: from, to: to)
        self.newCard(at: to, with: newvalue)
        delegate?.changeMask(value: newvalue)
        
    }
//检测手势
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch=touches.first{
            startLocation=touch.preciseLocation(in: self)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touchingDetectable{return}
        if let touch=touches.first{
            let endLocation=touch.preciseLocation(in: self)
            if distance(between: startLocation, and: endLocation)>50{
                touchingDetectable=false
                let offset=CGPoint(x: startLocation.x-endLocation.x, y: startLocation.y-endLocation.y)
                
                    delegate?.slideEnded(offset: offset)
                
                
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchingDetectable{
            if let touch=touches.first{
                let endLocation=touch.preciseLocation(in: self)
                let offset=CGPoint(x: startLocation.x-endLocation.x, y: startLocation.y-endLocation.y)
                if abs(offset.x)>5||abs(offset.y)>5{
                    delegate?.slideEnded(offset: offset)
                }
            }
        }
        else {
            touchingDetectable=true
        }
        
    }
   //两点间距离
    func distance(between pointA:CGPoint,and pointB:CGPoint)->Double{
        return sqrt(Double((pointA.x-pointB.x)*(pointA.x-pointB.x)+(pointA.y-pointB.y)*(pointA.y-pointB.y)))
    }
    //清空视图，用于重启游戏
    func removeAll(){
        for row in 0..<size{
            for line in 0..<size{
                if let cardView=getCardView(at: position(row: row, line: line)){
                    cardView.removeFromSuperview()
                }
            }
        }
        
    }
}




