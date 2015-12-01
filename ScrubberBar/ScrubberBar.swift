//
//  Copyright © 2015 Squareheads. All rights reserved.
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
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

protocol ScrubberBarDelegate: class {
    func scrubberBar(bar: ScrubberBar, didScrubToProgress: Float)
}

extension Comparable {
    func clamped<T: Comparable>(lower: T, upper: T) -> T {
        let value = self as! T
        return min(max(value, lower), upper)
    }
}

@IBDesignable
class ScrubberBar: UIControl {
    
    @IBInspectable
    var scrubberWidth: Float = 4.0{
        didSet{
            setNeedsLayout()
        }
    }
    
    private var progress: Float = 0.0
    
    let draggerButton = UIButton(frame: CGRectZero)
    let topBar = UIView(frame: CGRectZero)
    let elapsedBar = UIView(frame: CGRectZero)
    var isDragging = false
    weak var delegate: ScrubberBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    func setProgress(progress: Float){
        if !isDragging {
            self.progress = progress
            setNeedsLayout()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        commonSetup()
    }
    
    func commonSetup(){
        setupColor()
        addSubviews()
        addTouchHandlers()
    }
    
    func setupColor(){
        backgroundColor = .clearColor()
        draggerButton.backgroundColor = UIColor.redColor()
        topBar.backgroundColor = UIColor.lightGrayColor()
        elapsedBar.backgroundColor = UIColor.darkGrayColor()
    }
    
    func addSubviews(){
        addSubview(topBar)
        addSubview(elapsedBar)
        addSubview(draggerButton)
    }
    
    func addTouchHandlers(){
        draggerButton.userInteractionEnabled = false
        topBar.userInteractionEnabled = false
        elapsedBar.userInteractionEnabled = false
        addTarget(self, action: Selector("touchStarted"), forControlEvents: .TouchDown)
        addTarget(self, action: Selector("touchEnded"), forControlEvents: .TouchUpInside)
        addTarget(self, action: Selector("touchMoved:event:"), forControlEvents: .TouchDragInside)
    }
    
    func positionFromProgress(progress: Float) -> Float{
        return (Float(frame.width) * progress) - scrubberWidth;
    }
    
    func progressFromPosition(position: Float) -> Float{
        
        return (position / Float(frame.width)).clamped(0, upper: 1)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        let horizontalPosition = positionFromProgress(progress)
        draggerButton.frame = CGRectMake(CGFloat(horizontalPosition) , 0, CGFloat(scrubberWidth), frame.height)
        
        topBar.frame = CGRectMake(0, 0, frame.width, frame.height/2.0)
        elapsedBar.frame = CGRectMake(0, 0, CGFloat(horizontalPosition), frame.height/2.0)
    }
    
    func touchStarted(){
        isDragging = true
    }
    
    func touchEnded(){
        isDragging = false
    }
    
    func touchMoved(object: AnyObject, event:UIEvent){
        if let touch = event.touchesForView(self)?.first {
            let pointInView = touch.locationInView(self)
            let progress = progressFromPosition(Float(pointInView.x))
            self.progress = progress
            delegate?.scrubberBar(self, didScrubToProgress: self.progress)
            setNeedsLayout()
            
        }
    }
    
    
}
