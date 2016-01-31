import UIKit

class Transition: NSObject {
    
    var label : Character
    var end : State
    
    private var inIntersection : CGPoint?
    private var outIntersection : CGPoint?
    
    var controlPoint1 : CGPoint?
    var controlPoint2 : CGPoint?
    
    private var labelView : UILabel?
    private var labelLocation : CGPoint?
    
    var moveObject : CGPoint?
    
    var view : UIView
    var show_control_points : Bool
    var automaton : Automaton
    
    var isSelected = false
    
    init(view:UIView, show_cp: Bool, label: Character, end:State, automaton: Automaton){
        self.label = label
        self.end = end
        
        self.view = view
        self.show_control_points = show_cp
        self.automaton = automaton
    }
    
    // MARK: Within Bound Boolean
    
    func has_trans(point: CGPoint) -> Bool{
        
        if show_control_points && has_trans_control_point(point, number: 1){
            self.moveObject = self.controlPoint1
            return true
        } else if show_control_points && has_trans_control_point(point, number: 2){
            self.moveObject = self.controlPoint2
            return true
        } else if has_trans_label(point){
            self.moveObject = self.labelLocation!
            return true
        } else {
            self.moveObject = nil
            return false
        }
        
    }
    
    private func has_trans_control_point(point : CGPoint, number:Int) -> Bool
    {
        if number != 1 || number != 2{
            return false
        }
        
        let controlPoint : CGPoint = (number == 1) ? self.controlPoint1! : self.controlPoint2!
        let inBound : Bool = self.within_bound(point, comparison: controlPoint)
        
        return inBound
        
    }
    
    private func within_bound(point:CGPoint, comparison: CGPoint) -> Bool
    {
        
        let window : Int = 15
        let window_modifier : CGFloat = CGFloat(window)
        
        let point_below_upper_x = point.x < comparison.x + window_modifier
        let point_above_lower_x = point.x > comparison.x - window_modifier
        let point_left_right_y  = point.y < comparison.y + window_modifier
        let point_right_left_y  = point.y > comparison.y - window_modifier
        
        let withinBound : Bool = point_above_lower_x && point_below_upper_x && point_left_right_y && point_right_left_y
        
        return withinBound
        
    }
    
    private func has_trans_label(point:CGPoint) -> Bool{
        let label_location : CGPoint = self.labelLocation!
        
        let inBound : Bool = self.within_bound(point, comparison: label_location)
        
        return inBound
    }
    
    // MARK: Drawing Arrow
    
    func drawFrom(inState: State, withIndex index:Int){
        
        self.revised_draw_path(inState, withIndex: index)
        self.draw_label(inState)
        if self.show_control_points{
            self.draw_control_points(inState)
        }
        
        
    }
    
    // MARK: Draw Arrow Line
    
    private func draw_path(inState: State){
        let path : UIBezierPath = UIBezierPath()
        let outState : State = self.end
        
        
        if self.controlPoint1 == nil  || self.controlPoint2 == nil{
            var (controlPoint1, controlPoint2) : (CGPoint,CGPoint)
            if self.is_first(from: inState, to: outState){
                (controlPoint1,controlPoint2) = self.midpoint_compute_control_point(inState)
            } else {
                (controlPoint1,controlPoint2) = self.compute_control_points(inState, end: outState)
            }
            
            self.controlPoint1 = controlPoint1
            self.controlPoint2 = controlPoint2
            
        }
        
        let inIntersection : CGPoint = self.revised_compute_intersection(inState, external_point: self.controlPoint1!)
        let outIntersection : CGPoint = self.revised_compute_intersection(outState, external_point: self.controlPoint2!)
        
        self.inIntersection = inIntersection
        self.outIntersection = outIntersection
        
        self.drawLine(path, inIntersection: inIntersection, outIntersection: outIntersection)
        
        self.revised_draw_arrow(outState, intersection: outIntersection, external_relative: self.controlPoint2!)
    }
    
    private func revised_draw_path(inState: State,withIndex index:Int){
        let path : UIBezierPath = UIBezierPath()
        let outState : State = self.end
        
        
        if self.controlPoint1 == nil  || self.controlPoint2 == nil{
            var (controlPoint1, controlPoint2) : (CGPoint,CGPoint)
            if index == 0{
                (controlPoint1,controlPoint2) = self.midpoint_compute_control_point(inState)
            } else {
                (controlPoint1,controlPoint2) = self.compute_control_points(inState, end: outState)
            }
            
            self.controlPoint1 = controlPoint1
            self.controlPoint2 = controlPoint2
            
        }
        
        let inIntersection : CGPoint = self.revised_compute_intersection(inState, external_point: self.controlPoint1!)
        let outIntersection : CGPoint = self.revised_compute_intersection(outState, external_point: self.controlPoint2!)
        
        self.inIntersection = inIntersection
        self.outIntersection = outIntersection
        
        self.drawLine(path, inIntersection: inIntersection, outIntersection: outIntersection)
        
        self.revised_draw_arrow(outState, intersection: outIntersection, external_relative: self.controlPoint2!)
    }
    
    private func is_first(from inState: State, to outState: State) -> Bool{
        return inState.end_state_count[outState] == 0
    }
    
    
    private func midpoint_compute_control_point(inState: State) -> (CGPoint,CGPoint){
        let outState : State = self.end
        
        let midX : CGFloat = (inState.location.x + outState.location.x)/2
        let midY : CGFloat = (inState.location.y + outState.location.y)/2
        let midPoint : CGPoint = CGPointMake(midX, midY)
        
        return (midPoint,midPoint)
        
        
    }
    
    private func compute_control_points(start: State,end:State) -> (CGPoint,CGPoint){
        
        let startLoc : CGPoint = start.location
        let endLoc : CGPoint = end.location
        
        let x : CGFloat = endLoc.x - startLoc.x
        let y : CGFloat = endLoc.y - startLoc.y
        
        let d : CGFloat = sqrt(x * x + y * y)
        
        var out : CGFloat = CGFloat(100)
        let index : Int = self.find_trans_curve_index(from: start, to: end)! + 1
        
        if (index % 2 == 0){
            out *= CGFloat(index + 1)/CGFloat(4)
        } else {
            out *= (-1) * CGFloat(index) / CGFloat(4)
        }
        
        let modifier : CGFloat = CGFloat(0.4)
        
        let cp1X : CGFloat = startLoc.x + (modifier) * x + (out/d) * (-1) * y
        let cp1Y : CGFloat = startLoc.y + (modifier) * y + (out/d) * x
        let controlPoint1 = CGPointMake(cp1X, cp1Y)
        
        let cp2X : CGFloat = startLoc.x + (1 - modifier) * x + (out/d) * (-1) * y
        let cp2Y : CGFloat = startLoc.y + (1 - modifier) * y + (out/d) * x
        let controlPoint2 : CGPoint = CGPointMake(cp2X, cp2Y)
        
        return (controlPoint1,controlPoint2)
        
        
    }
    
    private func find_trans_curve_index(from start : State, to end: State) -> Int?{
        
        for trans : Transition in start.outTrans{
            if trans == self{
                return start.end_state_count[end]!
            }
        }
        
   
        return nil
    }
    
    private func compute_intersection(state:State, externalPoint: CGPoint) -> CGPoint
    {
        
        let stateLocation : CGPoint =  state.location
        let rightSL : CGPoint = CGPoint(x: (stateLocation.x + CGFloat(global_radius)), y: stateLocation.y)
        
        let degree : CGFloat = calculate_degree(tip1: rightSL, tip2: externalPoint, angle: stateLocation)
        
        let rotated_point : CGPoint = self.rotate_vector(by: degree, relative: stateLocation, rotating_point: rightSL)
        
        return rotated_point
        
        
    }
    
    private func revised_compute_intersection(state:State, external_point: CGPoint) -> CGPoint
    {
        
        let center : CGPoint = state.location
        
        let new_vecX : CGFloat = external_point.x - center.x
        let new_vecY : CGFloat = external_point.y - center.y
        
        
        let comp1 = pow(new_vecX, 2)
        let comp2 = pow(new_vecY, 2)
        let norm : CGFloat = sqrt(comp1 + comp2)
        
        
        let normalized_vec : CGVector = CGVector(dx: new_vecX / norm, dy: new_vecY / norm)
        
        let radius : CGFloat = CGFloat(global_radius)
        
        let updated_vector : CGPoint = CGPointMake(normalized_vec.dx * radius, normalized_vec.dy * radius)
        
        let new_point : CGPoint = CGPointMake(center.x + updated_vector.x, center.y + updated_vector.y)
        
        
        return new_point
        
    }
    
    private func calculate_degree(tip1 tip1: CGPoint, tip2: CGPoint, angle: CGPoint) -> CGFloat
    {
        let v1 : CGVector = CGVector(dx: tip1.x - angle.x, dy: tip1.y - angle.y)
        let v2 : CGVector = CGVector(dx: tip2.x - angle.x, dy: tip2.y - angle.y)
        
        let radian : CGFloat = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        let degree : CGFloat = radian * CGFloat(180.0 / M_PI)
        
        return degree
    }
    
    
    
    private func rotate_vector(by degree: CGFloat, relative: CGPoint, rotating_point: CGPoint) -> CGPoint{
        
        // Linear Algebra: Rotate by Matrix Rotation Function
        let rRadians : Double = Double(degree * CGFloat(M_PI / 180))
        
        var rMatrix = Matrix(rows: 2, columns: 2)
        rMatrix[0,0] = cos(rRadians)
        rMatrix[0,1] = -sin(rRadians)
        rMatrix[1,0] = sin(rRadians)
        rMatrix[1,1] = cos(rRadians)
        
        
        let constX : CGFloat = CGFloat(rMatrix[0,0]) * rotating_point.x + CGFloat(rMatrix[0,1]) * rotating_point.y
        let constY : CGFloat = CGFloat(rMatrix[1,0]) * rotating_point.x + CGFloat(rMatrix[1,1]) * rotating_point.y
        let rotated : CGPoint = CGPointMake(constX, constY)
        
        
        
        var adjRMat : Matrix = Matrix(rows: 2, columns: 2)
        adjRMat[0,0] = 1 - rMatrix[0,0]
        adjRMat[0,1] = -rMatrix[0,1]
        adjRMat[1,0] = -rMatrix[1,0]
        adjRMat[1,1] = 1 - rMatrix[1,1]
        
        let place1 : CGFloat = CGFloat(adjRMat[0,0]) * relative.x + CGFloat(adjRMat[0,1]) * relative.y
        let place2 : CGFloat = CGFloat(adjRMat[1,0]) * relative.x + CGFloat(adjRMat[1,1]) * relative.y
        let placeHolder : CGPoint = CGPointMake(place1,place2)
        
        
        let adjPoint : CGPoint = CGPointMake(rotated.x + placeHolder.x, rotated.y + placeHolder.y)
        
        return adjPoint
        
    }
    
    private func drawLine(path:UIBezierPath, inIntersection: CGPoint, outIntersection:CGPoint){
        path.moveToPoint(inIntersection)
        path.addCurveToPoint(outIntersection, controlPoint1: self.controlPoint1!, controlPoint2: self.controlPoint2!)
        
        path.lineWidth = 1
        
        if self.isSelected{
            UIColor.redColor().setStroke()
        } else {
            UIColor.blackColor().setStroke()

        }
        
        path.stroke()
    }
    
    private func draw_arrow(endState: State, intersection: CGPoint, external_relative: CGPoint){
        
        let degree = self.calculate_degree(tip1: endState.location, tip2: external_relative, angle: intersection)
        
        
        let arrowRotation = 25
        let sides = [degree + CGFloat(arrowRotation), degree - CGFloat(arrowRotation)]
        

        
        var rotatedPoints = [CGPoint]()
        for s in sides{
            let point = self.rotate_vector(by: s, relative: intersection, rotating_point: endState.location)
            rotatedPoints.append(point)
        }
        
        NSLog("\(rotatedPoints[0]) \(rotatedPoints[1])")

        
        let path = UIBezierPath()
        path.moveToPoint(rotatedPoints[0])
        path.addLineToPoint(intersection)
        path.addLineToPoint(rotatedPoints[1])
        
        path.lineWidth = 1
        path.stroke()
        
    }
    
    private func revised_draw_arrow(endState:State, intersection: CGPoint, external_relative: CGPoint){
        
        let center : CGPoint = endState.location
        
        let v1 : CGFloat = external_relative.x - center.x
        let v2 : CGFloat = external_relative.y - center.y
        
        let norm_comp1 : CGFloat = pow(v1, 2)
        let norm_comp2 : CGFloat = pow(v2, 2)
        let norm = sqrt(norm_comp1 + norm_comp2)
        
        let radius : CGFloat = CGFloat(global_radius)
        
        let u1 : CGFloat = radius/norm * v1
        let u2 : CGFloat = radius/norm * v2
        
        let pX : CGFloat = intersection.x + u1
        let pY : CGFloat = intersection.y + u2
        let p : CGPoint = CGPoint(x:pX,y:pY)
        
        let side1Point : CGPoint = self.rotate_vector(by: 30, relative: intersection, rotating_point: p)
        let side2Point : CGPoint = self.rotate_vector(by: -30, relative: intersection, rotating_point: p)
        
        let rotated_points = [side1Point,side2Point]
        
        let path = UIBezierPath()
        path.moveToPoint(rotated_points[0])
        path.addLineToPoint(intersection)
        path.addLineToPoint(rotated_points[1])
        
        path.lineWidth = 1
        path.stroke()
        
        
        
    }
    
    // MARK: Draw Label
    
    private func draw_label(inState: State){
        
        let pointInCurve = self.postition_bezier_curve_parametric(time: 0.5, startLoc: inState.location)
        
        self.labelLocation = pointInCurve
        
        let label : NSAttributedString = NSAttributedString(string: String(self.label))
        
        label.drawAtPoint(self.labelLocation!)
        
    }
    
    private func postition_bezier_curve_parametric(time t:CGFloat, startLoc:CGPoint) -> CGPoint{
        
        let endLoc = self.end.location
        
        let x0 = startLoc.x
        let x1 = self.controlPoint1!.x
        let x2 = self.controlPoint2!.x
        let x3 = endLoc.x
        
        let segment0 = x0
        let segment1 = 3 * t * (x1 - x0)
        let segment2 = 3 * pow(t,2) * (x0 + x2 - 2 * x1)
        let segment3 = pow(t,3) * (x3 - x0 + 3 * x1 - 3 * x2)
        
        let xCoor = segment0 + segment1 + segment2 + segment3
        
        let y0 = startLoc.y
        let y1 = self.controlPoint1!.y
        let y2 = self.controlPoint2!.y
        let y3 = endLoc.y
        
        let segmentA = y0
        let segmentB = 3 * t * (y1 - y0)
        let segmentC = 3 * pow(t,2) * (y0 + y2 - 2 * y1)
        let segmentD = pow(t,3) * (y3 - y0 + 3 * y1 - 3 * y2)
        
        let yCoor = segmentA + segmentB + segmentC + segmentD
        
        let newPoint = CGPointMake(xCoor, yCoor)
        
        return newPoint
        
        
    }
    
    
    // MARK: Draw Control Points
    
    private func draw_control_points(inState:State){
        
        
        let circle1 = UIBezierPath(arcCenter: self.controlPoint1!, radius: 5, startAngle: 0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        let circle2 = UIBezierPath(arcCenter: self.controlPoint2!, radius: 5, startAngle: 0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        let circle_line_combo = [(circle1,self.controlPoint1!,self.inIntersection!),(circle2,self.controlPoint2!,self.outIntersection!)]
        
        for (circle,center,intersection) in circle_line_combo{
            circle.lineWidth = 1
            UIColor.blackColor().setStroke()
            UIColor.yellowColor().setFill()
            circle.fill()
            circle.stroke()
            
            let path = UIBezierPath()
            path.moveToPoint(center)
            path.addLineToPoint(intersection)
            path.lineWidth = 1
            UIColor.orangeColor().setStroke()
            path.stroke()
        }
        
    }
    
    // MARK: Moving Methods
    
    func moveTo(location:CGPoint)
    {
        if self.moveObject == self.labelLocation!{
            self.label_move(location)
        } else if self.moveObject == self.controlPoint1! || self.moveObject == self.controlPoint2!{
            self.control_point_move(location, number: (self.moveObject == self.controlPoint1!) ? 1: 2)
        }
        
        self.moveObject = nil
    }
    
    private func control_point_move(location:CGPoint,number:Int){
        if number != 1 && number != 2{
            fatalError("Arguments must be 1 or 2")
        }
        
        if number == 1{
            self.controlPoint1 = location
        } else if number == 2{
            self.controlPoint2 = location
        }
        
    }
    
    private func label_move(location: CGPoint){
        let deltaX = location.x - self.labelLocation!.x
        let deltaY = location.y - self.labelLocation!.y
        
        self.adjust_control_points(dx: deltaX, dy: deltaY)
    }
    
    private func adjust_control_points(dx x:CGFloat, dy y: CGFloat){
        self.controlPoint1!.x += x
        self.controlPoint1!.y += y
        
        self.controlPoint2!.x += x
        self.controlPoint2!.y += y
    }
    
    
}




