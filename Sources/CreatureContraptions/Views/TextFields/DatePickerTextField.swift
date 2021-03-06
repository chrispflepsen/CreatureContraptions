//
//  DatePickerTextField.swift
//
//  Copyright (c) 2020 Chris Pflepsen
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

public class DateTextField: DatePickerTextField {
    
    override public func setupViews() {
        super.setupViews()
        
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(timeIntervalSinceReferenceDate: 0), animated: false)
        datePicker.maximumDate = Date()
    }
    
}

public class TimeTextField: DatePickerTextField {
    
    override public func setupViews() {
        super.setupViews()
        
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 15
    }
}

public class DatePickerTextField: TextField {
    
    internal let datePicker = UIDatePicker()
    
    private let calloutImageView = UIImageView(image: UIImage())
    private let toolbar = UIToolbar()
    private let doneButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    private var doneButtonAction: (() -> Void)?
    
    public var date: Observable<Date?> {
        return datePicker.rx.date.map { $0 }.asObservable()
    }
    
    public override func setupViews() {
        super.setupViews()
        
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: false)
        toolbar.barTintColor = style?.primaryColor
        toolbar.isTranslucent = false
        toolbar.tintColor = .white
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
        self.inputView = datePicker
        
        calloutImageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        calloutImageView.contentMode = .scaleAspectFit
        rightView = calloutImageView
        rightViewMode = .always
        calloutImageView.tintColor = .black
        tintColor = .clear
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.doneButtonAction?()
        })
            .disposed(by: bag)
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    public func setCalloutImage(_ image: UIImage) {
        calloutImageView.image = image
    }
    
    public func setToolbarButtonTitle(_ title: String) {
        doneButton.title = title
    }
    
    public func setToolbarButtonAction(_ action: @escaping () -> Void) {
        doneButtonAction = action
    }
}
