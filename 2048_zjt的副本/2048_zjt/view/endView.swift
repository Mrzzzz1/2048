//
//  successView.swift
//  2048_zjt
//
//  Created by 张金涛 on 2022/1/18.
//

import SwiftUI
protocol successViewDelegate{
    func playAgain()
}

class endView:UIView {
    var delegate:successViewDelegate?=nil
    var endLabel=UILabel()
    var playAgainButton=UIButton()
    var backButton=UIButton()
     var score:Int = 0
    func setUpView() {
        

        self.backgroundColor = .white
        guard let superV = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superV.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superV.trailingAnchor),
            self.topAnchor.constraint(equalTo: superV.topAnchor),
            self.bottomAnchor.constraint(equalTo: superV.bottomAnchor),
        ])
        setUpSuccessLabel()
        setUpButton()
       
    }
    
    func setUpSuccessLabel(){
        self.addSubview(endLabel)
        endLabel.translatesAutoresizingMaskIntoConstraints=false
        endLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 200).isActive=true
        endLabel.bottomAnchor.constraint(equalTo: endLabel.topAnchor, constant: 60).isActive=true
        endLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        endLabel.textColor = .black
        endLabel.font=UIFont.boldSystemFont(ofSize: 25)
        //endLabel.text="Victory! Your score is \(self.score) "
        
    }
    func setUpButton(){
        self.addSubview(playAgainButton)
        self.addSubview(backButton)
        playAgainButton.translatesAutoresizingMaskIntoConstraints=false
        playAgainButton.topAnchor.constraint(equalTo: endLabel.bottomAnchor).isActive=true
        playAgainButton.trailingAnchor.constraint(equalTo: endLabel.trailingAnchor).isActive=true
        playAgainButton.setTitle("Play again", for: .normal)
        playAgainButton.setTitleColor(.black, for: .normal)
        playAgainButton.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        
        playAgainButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        playAgainButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.translatesAutoresizingMaskIntoConstraints=false
        backButton.topAnchor.constraint(equalTo: endLabel.bottomAnchor).isActive=true
        backButton.leadingAnchor.constraint(equalTo: endLabel.leadingAnchor).isActive=true
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
    }
    
    @objc func playAgain(){
        self.removeFromSuperview()
        delegate?.playAgain()
    }
    @objc func back(){
        self.removeFromSuperview()
    }
}
