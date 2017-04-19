//
//  TextField.swift
//  Text Field Example
//
//  Created by Ataer Caner on 23/03/17.
//  Copyright © 2017 Bckspace. All rights reserved.
//

import UIKit

protocol SwipeableTextFieldDelegate  {
    func swipeableTextFieldShouldBeginEditing(_ swipeableTextField: SwipeableTextField) -> Bool
    func swipeableTextFieldDidBeginEditing(_ swipeableTextField: SwipeableTextField)
    func swipeableTextFieldShouldEndEditing(_ swipeableTextField: SwipeableTextField) -> Bool
    func swipeableTextFieldDidEndEditing(_ swipeableTextField: SwipeableTextField)
    func swipeableTextFieldDidEndEditing(_ swipeableTextField: SwipeableTextField, reason: UITextFieldDidEndEditingReason)
    func swipeableTextField(_ swipeableTextField: SwipeableTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func swipeableTextFieldShouldClear(_ swipeableTextField: SwipeableTextField) -> Bool
    func swipeableTextFieldShouldReturn(_ swipeableTextField: SwipeableTextField) -> Bool
    
    
}

extension SwipeableTextFieldDelegate {
    func swipeableTextFieldShouldBeginEditing(_ swipeableTextField: SwipeableTextField) -> Bool { return true}
    func swipeableTextFieldDidBeginEditing(_ swipeableTextField: SwipeableTextField) {}
    func swipeableTextFieldShouldEndEditing(_ swipeableTextField: SwipeableTextField) -> Bool {return true}
    func swipeableTextFieldDidEndEditing(_ swipeableTextField: SwipeableTextField) {}
    func swipeableTextFieldDidEndEditing(_ swipeableTextField: SwipeableTextField, reason: UITextFieldDidEndEditingReason) {}
    func swipeableTextField(_ swipeableTextField: SwipeableTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {return true}
    func swipeableTextFieldShouldClear(_ swipeableTextField: SwipeableTextField) -> Bool {return true}
    func swipeableTextFieldShouldReturn(_ swipeableTextField: SwipeableTextField) -> Bool {return true}
}


class SwipeableTextField: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    private let stepsTextField = UITextField()
    private let textLabel = UILabel()
    private let stackView   = UIStackView()
    
    var selectionBorderColor = UIColor.green
    private var _labelColor : UIColor!
    private var _nonSelectionBorderColor = UIColor.lightGray
    private var _textAligment: NSTextAlignment = .center
    private var _keyboardType: UIKeyboardType!
    var errorBorderColor = UIColor.red
    
    
    
    private var _textfieldFont = UIFont(name: "HelveticaNeue", size: 15.0)
    private var _labelFont = UIFont(name: "HelveticaNeue", size: 15.0)
    
    private var _labelText: String!
    private var _placeHolder: String!
    
    private var _labelIsHidden = false
    
    var shakeIsEnable = true
    
    var delegate: SwipeableTextFieldDelegate!
    
    var keyboardType: UIKeyboardType {
        get {
            return _keyboardType
        }
        set {
            _keyboardType = newValue
            stepsTextField.keyboardType = keyboardType
        }
    }
    
    var textAligment: NSTextAlignment {
        get {
            return _textAligment
        }
        set {
            _textAligment = newValue
            stepsTextField.textAlignment = _textAligment
            textLabel.textAlignment = _textAligment
        }
    }
    
    var labelIsHidden: Bool {
        get {
            return _labelIsHidden
        }
        set {
            _labelIsHidden = newValue
            if _labelIsHidden {
                textLabel.alpha = 0.0
            }
            else {
                textLabel.alpha = 1.0
            }
        }
    }
    
    
    
    var placeHolder: String {
        get {
            if _placeHolder == nil {
                _placeHolder = ""
            }
            return _placeHolder
        }
        set {
            _placeHolder = newValue
            stepsTextField.placeholder = placeHolder
            
            if _labelText == nil {
                textLabel.text  = stepsTextField.placeholder
            }
            
        }
    }
    
    var labelText: String {
        get {
            if _labelText == nil {
                _labelText = ""
            }
            
            return _labelText
        }
        set {
            _labelText = newValue
            textLabel.text = _labelText
        }
    }
    
    
    
    var textfieldFont: UIFont {
        get {
            return _textfieldFont!
        }
        set {
            _textfieldFont = newValue
            stepsTextField.font = _textfieldFont
        }
    }
    
    var labelFont: UIFont {
        get {
            return _labelFont!
        }
        set {
            _labelFont = newValue
            textLabel.font = _labelFont
        }
    }
    
    
    var text: String{
        get {
            return stepsTextField.text!
        }
        set {
            if !newValue.isEmpty {
                swipeDown(label: textLabel)
            }
            stepsTextField.text = newValue
        }
    }
    
    var nonSelectionBorderColor: UIColor {
        get {
            return _nonSelectionBorderColor
        }
        set {
            _nonSelectionBorderColor = newValue
            if (stepsTextField.text?.characters.isEmpty)! {
                changeBorderColor(color: _nonSelectionBorderColor)
            }
        }
    }
    
    var labelColor: UIColor {
        get {
            return _labelColor
        }
        set {
            _labelColor = newValue
            textLabel.textColor = _labelColor
        }
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        stepsTextField.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        stepsTextField.heightAnchor.constraint(equalToConstant: self.frame.height/3).isActive = true
        stepsTextField.textAlignment = _textAligment
        stepsTextField.font = _textfieldFont
        stepsTextField.textColor = UIColor.darkGray
        stepsTextField.borderStyle = UITextBorderStyle.none
        stepsTextField.autocorrectionType = UITextAutocorrectionType.no
        stepsTextField.keyboardType = UIKeyboardType.default
        stepsTextField.returnKeyType = UIReturnKeyType.done
        stepsTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        stepsTextField.delegate = self
        
        
        
        textLabel.backgroundColor = UIColor.white
        textLabel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: self.frame.height/3).isActive = true
        textLabel.textColor = selectionBorderColor
        textLabel.font = _labelFont
        textLabel.textAlignment = _textAligment
        textLabel.alpha = 0.0
        
        //Stack View
        stackView.axis  = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing   = 5.0
        
        
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(stepsTextField)
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addSubview(stackView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTabToView))
        
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tap)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        changeBorderColor(color: _nonSelectionBorderColor)
        
        
    }
    
    @objc private func didTabToView(sender: UITapGestureRecognizer){
        stepsTextField.becomeFirstResponder()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var returnType = true
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (textField.text?.characters.count)! == 0 {
            swipeUp(label: textLabel)
        }
        else if (textField.text?.characters.count)! == 1 && isBackSpace == -92 {
            swipeDown(label: textLabel)
        }
        
        changeBorderColor(color: selectionBorderColor)
        
        if let del = delegate {
            returnType = del.swipeableTextField(self, shouldChangeCharactersIn: range, replacementString: string)
        }
        
        return returnType
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        var returnType = true
        
        
        if let del = delegate {
            returnType = del.swipeableTextFieldShouldReturn(self)
        }
        
        return returnType
        
    }
    
    private func changeBorderColor(color: UIColor){
        addBorder(color: color, frame: CGRect(x: 0, y: self.frame.height-3, width: self.frame.width, height: 2))
        
    }
    
    
    
    @objc private func dismissKeyboard() {
        _ = textFieldShouldReturn(stepsTextField)
    }
    
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var returnType = true
        changeBorderColor(color: selectionBorderColor)
        
        if let del = delegate {
            returnType = del.swipeableTextFieldShouldBeginEditing(self)
        }
        return returnType
    }
    
    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        var returnType = true
        changeBorderColor(color: _nonSelectionBorderColor)
        if let del = delegate {
            returnType = del.swipeableTextFieldShouldEndEditing(self)
        }
        return returnType
    }
    
    
    private func addBorder(color:UIColor,frame:CGRect)
    {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = color.cgColor
        border.frame = frame
        border.borderWidth = width
        self.layer.addSublayer(border)
        
    }
    
    
    private func swipeUp(label: UILabel) {
        if _labelIsHidden {
            return
        }
        
        label.alpha = 0.0
        label.center = CGPoint(x: label.center.x, y: label.center.y + label.frame.height)
        UIView.animate(withDuration: 0.2, animations: {
            label.alpha = 1.0
            label.center = CGPoint(x: label.center.x, y: label.center.y - label.frame.height)
        }, completion: {
            completion in
        })
        
    }
    
    private func swipeDown(label: UILabel) {
        if _labelIsHidden {
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            label.alpha = 0.0
            label.center = CGPoint(x: label.center.x, y: label.center.y + label.frame.height)
        }, completion: {
            completion in
            label.center = CGPoint(x: label.center.x, y: label.center.y -  label.frame.height)
        })
    }
    
    func addDoneButton()
    {
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: .done,
                                              target: self, action: #selector((dismissKeyboard)))
        
        toolbarDone.items = [barBtnDone]
        stepsTextField.inputAccessoryView = toolbarDone
    }
    
    private func shake() {
        //implementation
        if !shakeIsEnable {
            return
        }
        
        
        let anim = CABasicAnimation(keyPath: "position")
        anim.duration = 0.05
        anim.repeatCount = 5
        anim.autoreverses = true
        anim.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4.0, y: self.center.y))
        anim.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4.0, y: self.center.y))
        layer.add(anim, forKey: "position")
    }
    
    
    func setError(){
        shake()
        changeBorderColor(color: errorBorderColor)
    }
    
    
    
    
    
    func removeAll(){
        swipeDown(label: textLabel)
        stepsTextField.text?.removeAll()
    }
    
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if let del = delegate {
            del.swipeableTextFieldDidBeginEditing(self)
        }
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if let del = delegate {
            del.swipeableTextFieldDidEndEditing(self)
        }
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let del = delegate {
            del.swipeableTextFieldDidEndEditing(self, reason: reason)
        }
    }
    
    internal func textFieldShouldClear(_ textField: UITextField) -> Bool {
        var returnType = true
        if let del = delegate {
            returnType = del.swipeableTextFieldShouldClear(self)
        }
        return returnType
    }
    
    
    
    
}

