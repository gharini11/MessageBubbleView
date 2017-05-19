//
//  BubbleView.swift
//  BubbleView
//
//  Created by Harini Reddy on 11/19/16.
//  Copyright © 2016 harini. All rights reserved.
//

import UIKit

private let kArrowWidth:CGFloat = 9.0
private let kArrowHeight:CGFloat = 9.0
private let kCornerRadius:CGFloat = 5.0

class BubbleView: UIView {
    
    var strokeColor:UIColor?
    var fillColor:UIColor?
    var isRightBubble:Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flipVertically()  {
        let context = UIGraphicsGetCurrentContext()
        let transformHorizontally = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, self.frame.size.width, 0.0)
        CGContextConcatCTM(context, transformHorizontally)
    }
    
    func newBubblePath() -> UIBezierPath {
        // metrics
        let drawingOffset:CGFloat = 4.0
        let drawingBounds = CGRectInset(self.bounds, drawingOffset, drawingOffset)
        var roundedCornerReferenceRect = CGRectInset(drawingBounds, kCornerRadius, kCornerRadius)
        roundedCornerReferenceRect.size.width -= kArrowWidth
        roundedCornerReferenceRect = CGRectOffset(roundedCornerReferenceRect, kArrowWidth, 0)
        let arrowStartPoint = CGPointMake(drawingBounds.minX, drawingBounds.maxY)
        let arrowBottomEndPoint = CGPointMake(drawingBounds.minX + kArrowWidth, drawingBounds.maxY - kCornerRadius)
        let arrowTopEndPoint = CGPointMake(arrowBottomEndPoint.x, arrowBottomEndPoint.y - kArrowHeight)
        let bottomRightPoint = CGPointMake(drawingBounds.maxX - kCornerRadius, drawingBounds.maxY)
        let bottomLeftCurveReferencePoint = CGPointMake(roundedCornerReferenceRect.minX, roundedCornerReferenceRect.maxY)
        let bottomRightCurveReferencePoint = CGPointMake(roundedCornerReferenceRect.maxX, roundedCornerReferenceRect.maxY)
        let topRightPoint = CGPointMake(drawingBounds.maxX, drawingBounds.minX + kCornerRadius)
        let topRightCurveReferencePoint = CGPointMake(roundedCornerReferenceRect.maxX, roundedCornerReferenceRect.minY)
        let topLeftPoint = CGPointMake(drawingBounds.minX + kArrowWidth + kCornerRadius, drawingBounds.minY)
        let topLeftCurveReferencePoint  = CGPointMake(roundedCornerReferenceRect.minX, roundedCornerReferenceRect.minY)
        
        // Path
        let path = UIBezierPath()
        path.moveToPoint(arrowStartPoint)
        path.addLineToPoint(arrowBottomEndPoint)
        path.addArcWithCenter(bottomLeftCurveReferencePoint, radius: kCornerRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI) * 0.5, clockwise: false)
        path.addLineToPoint(bottomRightPoint)
        path.addArcWithCenter(bottomRightCurveReferencePoint, radius: kCornerRadius, startAngle: CGFloat(M_PI) * 0.5, endAngle: 0, clockwise: false)
        path.addLineToPoint(topRightPoint)
        path.addArcWithCenter(topRightCurveReferencePoint, radius: kCornerRadius, startAngle: 0, endAngle: (3 * CGFloat(M_PI)) * 0.5, clockwise: false)
        path.addLineToPoint(topLeftPoint)
        path.addArcWithCenter(topLeftCurveReferencePoint, radius: kCornerRadius, startAngle:(3 * CGFloat(M_PI)) * 0.5, endAngle: CGFloat(M_PI), clockwise: false)
        path.addLineToPoint(arrowTopEndPoint)
        path.addLineToPoint(arrowStartPoint)
        path.closePath()
        return path
    }

    
    func drawGradientForBubblePath(path: UIBezierPath) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        path.addClip()
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        let startColor = CGColorGetComponents(fillColor?.CGColor)
        let endColor = CGColorGetComponents(UIColor.whiteColor().CGColor)
        let colorComponents = [startColor[0],startColor[1],startColor[2],startColor[3],endColor[0], endColor[1],endColor[2],endColor[3]]
        let numOfLocations = 2
        let locations:[CGFloat] = [0.0, 1.0]
        var gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, numOfLocations)
        let startPoint = CGPointMake(self.bounds.midX, self.bounds.minY)
        let endPoint = CGPointMake(self.bounds.midX, self.bounds.maxY)
        CGContextSetBlendMode(context, CGBlendMode.Overlay);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])
        CGContextRestoreGState(context)
        colorSpace = nil
        gradient = nil
    }
    
    func drawInnerGlowForBubblePath(path: UIBezierPath) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        path.addClip()
        let boundsPath = UIBezierPath(rect:self.bounds)
        boundsPath.appendPath(path)
        CGContextSetBlendMode(context, CGBlendMode.Overlay)
        CGContextSetShadowWithColor(context, CGSizeZero, 5, UIColor.whiteColor().CGColor)
        strokeColor?.setFill()
        boundsPath.usesEvenOddFillRule = true
        boundsPath.fill()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context);
        if isRightBubble == true {
            flipVertically()
        }
        let path = newBubblePath()
        // fill and shadow
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, CGSizeZero, 5, UIColor(white: 0.0, alpha: 0.5).CGColor)
        
        self.fillColor?.setFill()
        path.fill()
        CGContextRestoreGState(context)
        //gradient
        drawGradientForBubblePath(path)
        drawInnerGlowForBubblePath(path)
        //stroke
        CGContextSaveGState(context)
        CGContextSetAlpha(context, 0.2)
        path.lineWidth = 1
        self.strokeColor?.setStroke()
        path.lineJoinStyle = .Miter
        path.stroke()
        CGContextRestoreGState(context)
        
        CGContextRestoreGState(context)

    }
}
