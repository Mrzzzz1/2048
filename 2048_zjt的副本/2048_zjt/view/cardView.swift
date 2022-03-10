//
//  cardView.swift
//  2048_zjt
//
//  Created by 张金涛 on 2022/1/16.
//

import SwiftUI

class cardView: UIView {
    
    private let label=UILabel()
    private var value:Int=0{
        didSet{
            if value==0{
                isHidden=true
            }else{
                isHidden=false
                label.backgroundColor = .orange
                label.text = "\(value)"
                label.textColor = .white
                
            }
        }
    }
     init(frame: CGRect,value:Int) {
        super.init(frame: frame)
        self.frame=frame
         self.value=value
         self.backgroundColor = .yellow
        self.layer.masksToBounds=true
        self.layer.cornerRadius=10.0
        set(value:value)
    }
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
   func updateValue(to newValue:Int){
    value=newValue
   }
    private func set(value:Int){
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
        label.adjustsFontSizeToFitWidth=true
        label.minimumScaleFactor=0.5
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints=false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive=true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive=true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        updateValue(to: value)
    }
    //卡片出现动画
    func createAnimation(){
        transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0.0, options: [],
                                                       animations: {
            self.transform = .identity
            
        })
    }
    //  卡片合并动画
    func flash(withView value:Int=0){
        transform=CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
        updateValue(to: value)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.08, delay: 0.0, options: [.repeat], animations: {
            self.transform=CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }){
            position in self.transform = .identity
        }
    }
    
    
    
}


