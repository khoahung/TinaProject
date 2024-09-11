//
//  UIAlert.swift
//  Sinh Vien
//
//  Created by Nguyễn Tất Hùng on 5/17/16.
//  Copyright © 2016 Nguyễn Tất Hùng. All rights reserved.
//

import UIKit
protocol UIAlertDelegate {
    func actionClick(_ sender:AnyObject)
}
class UIAlert: UIView {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    var ground:UIView!
    var view:UIView!
    var delegate:UIAlertDelegate!
    init(frame: CGRect, title:String, message:String, listTitles:[String]) { // for using CustomView in code
        super.init(frame: frame)
        commonInit()
        lblTitle.text = title
        lblMessage.text = message
        var height =  Common.getLabelHeight(lblMessage.text!, font: k_FONT_MEDIUM_17! , width:lblMessage.frame.size.width )
        let hTitle =  Common.getLabelHeight(lblTitle.text!, font: k_FONT_MEDIUM_17! , width:lblMessage.frame.size.width )
        if frame.size.height + height - 120 < 150 {
            height = 150
        }else{
            height = frame.size.height + height + hTitle - 100
        }
        
        self.frame = CGRect(x: frame.origin.x,y: frame.origin.y, width: frame.size.width, height: height )
        
        var listButton=[UIButton]()
        for i in 0...listTitles.count-1 {
            let btn=UIButton(frame: CGRect.zero)
            btn.tag=i
            listButton.append(btn)
            listButton[i].setTitle(listTitles[i], for: UIControl.State())
        }
        for i in 0...listButton.count-1  {
            
            listButton[i].translatesAutoresizingMaskIntoConstraints = false
            listButton[i].setTitleColor(k_COLOR_TITLE_BUTTON, for: UIControl.State())
            listButton[i].titleLabel?.font=k_FONT_MEDIUM_16
            listButton[i].showsTouchWhenHighlighted=true
            listButton[i].addTarget(self, action: #selector(UIAlert.btnOKClick(_:)), for: .touchUpInside)
            view.addSubview(listButton[i])
            
            listButton[i].addConstraint(NSLayoutConstraint(item: listButton[i], attribute: .height , relatedBy: .equal, toItem:nil, attribute: .notAnAttribute , multiplier: 1.0, constant: 30.0))
            
            let width = (frame.size.width - 10 - 2 * CGFloat((listButton.count - 1))) / CGFloat(listButton.count)
            listButton[i].addConstraint(NSLayoutConstraint(item: listButton[i], attribute: .width , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1.0, constant: width))
            
            view.addConstraint(NSLayoutConstraint(item: listButton[i], attribute: .bottom , relatedBy: .equal, toItem:view, attribute: .bottom , multiplier: 1.0, constant: -8.0))
            
            if i == 0 {
                self.view.addConstraint(NSLayoutConstraint(item: listButton[i], attribute: .left , relatedBy: .equal, toItem: self.view, attribute: .left , multiplier: 1.0, constant: 5.0))
            }else{
                self.view.addConstraint(NSLayoutConstraint(item: listButton[i], attribute: .left , relatedBy: .equal, toItem: listButton[i-1], attribute: .right , multiplier: 1.0, constant: 2.0))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        
    }
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UIAlert", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    @objc func btnOKClick(_ sender:AnyObject){
        self.removeFromSuperview()
        ground.removeFromSuperview()
        if delegate != nil {
            delegate.actionClick(sender)
        }
    }
    @objc   
    func closeView(){
        self.removeFromSuperview()
        ground.removeFromSuperview()
    }
}
