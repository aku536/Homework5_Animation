//
//  ViewController.swift
//  Homework5(Animation)
//
//  Created by Кирилл Афонин on 17/10/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let offset: CGFloat = 125
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        
        setupButtons()
    }
    
    // размещаем кнопки на view
    func setupButtons() {
        
        startButton.center = view.center
        startButton.isHidden = false
        startButton.alpha = 1.0
        view.addSubview(startButton)
        
        treeButton.center = view.center
        treeButton.alpha = 0.0
        treeButton.isHidden = true
        view.addSubview(treeButton)
        
        deerButton.center = CGPoint(x: view.frame.midX - offset, y: view.frame.midY - offset)
        deerButton.isHidden = true
        deerButton.alpha = 0.0
        view.addSubview(deerButton)
        
        cookieButton.center = CGPoint(x: view.frame.midX + offset, y: view.frame.midY - offset)
        cookieButton.isHidden = true
        cookieButton.alpha = 0.0
        view.addSubview(cookieButton)
        
        rabbitButton.center = CGPoint(x: view.frame.midX - offset, y: view.frame.midY + offset)
        rabbitButton.isHidden = true
        rabbitButton.alpha = 0.0
        view.addSubview(rabbitButton)
        
        snowmanButton.center = CGPoint(x: view.frame.midX + offset, y: view.frame.midY + offset)
        snowmanButton.isHidden = true
        snowmanButton.alpha = 0.0
        view.addSubview(snowmanButton)
    }
    
    @objc func startAnimation() {
        // анимация кнопки Start
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.startButton.alpha = 0.0
        }) { (success) in
            
            let buttonsArray = [self.treeButton, self.deerButton,
                                self.cookieButton, self.rabbitButton,
                                self.snowmanButton] // массив анимируемых кнопок
            self.startButton.isHidden = true
            buttonsArray.forEach { $0.isHidden = false }
            
            // появление остальных кнопок
            UIView.animate(withDuration: 1,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            buttonsArray.forEach { $0.alpha = 1.0 }
            }) { (success) in
                
                let centerX = self.view.frame.midX
                let centerY = self.view.frame.midY
                
                
                // анимации движения по кругу
                let deerAnimation = CAKeyframeAnimation(keyPath: "position")
                var pathArray = [[centerX - self.offset, centerY - self.offset],
                                 [centerX - self.offset, centerY + self.offset],
                                 [centerX + self.offset, centerY + self.offset],
                                 [centerX + self.offset, centerY - self.offset],
                                 [centerX - self.offset, centerY - self.offset]]
                deerAnimation.values = pathArray
                deerAnimation.duration = 4.0
                self.deerButton.layer.add(deerAnimation, forKey: "deerAnimation")
                
                let cookieAnimation = CAKeyframeAnimation(keyPath: "position")
                pathArray = [[centerX + self.offset, centerY - self.offset],
                             [centerX - self.offset, centerY - self.offset],
                             [centerX - self.offset, centerY + self.offset],
                             [centerX + self.offset, centerY + self.offset],
                             [centerX + self.offset, centerY - self.offset]]
                cookieAnimation.values = pathArray
                cookieAnimation.duration = deerAnimation.duration
                self.cookieButton.layer.add(cookieAnimation, forKey: "cookieAnimation")
                
                let rabbitAnimation = CAKeyframeAnimation(keyPath: "position")
                pathArray = [[centerX - self.offset, centerY + self.offset],
                             [centerX + self.offset, centerY + self.offset],
                             [centerX + self.offset, centerY - self.offset],
                             [centerX - self.offset, centerY - self.offset],
                             [centerX - self.offset, centerY + self.offset]]
                rabbitAnimation.values = pathArray
                rabbitAnimation.duration = deerAnimation.duration
                self.rabbitButton.layer.add(rabbitAnimation, forKey: "rabbitAnimation")
                
                let snowmanAnimation = CAKeyframeAnimation(keyPath: "position")
                pathArray = [[centerX + self.offset, centerY + self.offset],
                             [centerX + self.offset, centerY - self.offset],
                             [centerX - self.offset, centerY - self.offset],
                             [centerX - self.offset, centerY + self.offset],
                             [centerX + self.offset, centerY + self.offset]]
                snowmanAnimation.values = pathArray
                snowmanAnimation.duration = deerAnimation.duration
                self.snowmanButton.layer.add(snowmanAnimation, forKey: "snowmanAnimation")
                
                // group animations (Движение в центр, Увеличение, Вращение)
                let animation1 = CABasicAnimation(keyPath: "position")
                animation1.toValue = [centerX, centerY]
                animation1.beginTime = deerAnimation.duration
                animation1.duration = 1.0
                
                let animation2 = CABasicAnimation(keyPath: "transform.scale")
                animation2.fromValue = 1.0
                animation2.toValue = 2.0
                animation2.beginTime = animation1.beginTime
                animation2.duration = animation1.duration
                
                let animation3 = CABasicAnimation(keyPath: "transform.rotation")
                animation3.toValue = 360
                animation3.beginTime = animation1.beginTime
                animation3.duration = animation1.duration
                
                let groupAnimation = CAAnimationGroup()
                groupAnimation.animations = [animation1, animation2, animation3]
                groupAnimation.duration = animation2.beginTime + animation2.duration
                
                buttonsArray.forEach { $0.layer.add(groupAnimation, forKey: "groupAnimation") }
            }
        }
    }
    
    // сброс по нажатию на елку
    @objc func reset() {
        view.subviews.forEach { $0.removeFromSuperview() }
        setupButtons()
    }
    
    // настройка кнопок
    let startButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "start"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.addTarget(self, action: #selector(startAnimation), for: .touchDown)
        return button
    }()
    
    let treeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "tree"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        button.addTarget(self, action: #selector(reset), for: .touchDown)
        return button
    }()
    
    let deerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "deer"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    let cookieButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cookie"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    let rabbitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "rabbit"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    let snowmanButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "snowman"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
}
