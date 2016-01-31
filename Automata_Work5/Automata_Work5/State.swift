import UIKit


func ==(lhs:State,rhs:State) -> Bool{
    return lhs.id == rhs.id
}

class State: NSObject {
    
    var id : Int
    var isFinal : Bool = false
    var outTrans : [Transition] = [Transition]()
    
    var location : CGPoint
    var path : UIBezierPath?
    var view : UIView
    var label : UILabel?
    
    var automaton: Automaton
    
    var end_state_count : [State:Int] = [State:Int]()
    
    var isSelected = false
    
    init(id: Int, location : CGPoint, view:UIView, automaton: Automaton){
        self.id = id
        
        self.location = location
        self.view = view
        self.automaton = automaton
    }
    
    init(id: Int, final:Bool, location : CGPoint, view:UIView, automaton: Automaton){
        self.id = id
        self.isFinal = final
        
        self.location = location
        self.view = view
        self.automaton = automaton
        
    }
    
    func addTransition(newTrans:Transition){
        self.outTrans.append(newTrans)
        
        self.update_end_state_count(newTrans)
    }
    
    private func update_end_state_count(trans:Transition){
        
        let end_state : State = trans.end
        
        let id_num : Int? = self.end_state_count[end_state]
        let new_number : Int = (id_num == nil) ? 0 : id_num! + 1
        
        self.end_state_count[end_state] = new_number
        
    }
    
    func is_first() -> Bool{
        return self.id == 0
    }
    
    
    func has_state_at(point:CGPoint) -> Bool{
        let mod_global : CGFloat = CGFloat(global_radius)
        
        let point_below_upper_x = point.x < self.location.x + mod_global
        let point_above_lower_x = point.x > self.location.x - mod_global
        let point_left_right_y  = point.y < self.location.y + mod_global
        let point_right_left_y  = point.y > self.location.y - mod_global
        
        return point_above_lower_x && point_below_upper_x && point_left_right_y && point_right_left_y
    }
    
    // MARK: Drawing Methods
    
    func draw(){
        if self.is_first(){
            self.draw_initial_arrow()
        }
        
        self.draw_circle()
        self.drawID()
    }
    
    
    private func draw_initial_arrow(){
        
        let end_point : CGPoint = CGPoint(x: self.location.x - CGFloat(global_radius * 3), y: self.location.y)
        let tip : CGPoint = CGPoint(x: self.location.x - CGFloat(global_radius), y: self.location.y)
        
        let modifier : Int = 25
        
        let side1 : CGPoint = rotate_vector(by: CGFloat(180 - modifier), relative: tip, rotating_point: self.location)
        let side2 : CGPoint = rotate_vector(by: CGFloat(180 + modifier), relative: tip, rotating_point: self.location)
        
        let path_direction : UIBezierPath = UIBezierPath()
        path_direction.moveToPoint(end_point)
        path_direction.addLineToPoint(tip)
        path_direction.lineWidth = 1
        
        let path_arrow : UIBezierPath = UIBezierPath()
        path_arrow.moveToPoint(side1)
        path_arrow.addLineToPoint(tip)
        path_arrow.addLineToPoint(side2)
        path_arrow.lineWidth = 1
        
        path_direction.stroke()
        path_arrow.stroke()
        
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
    
    func draw_circle(){
        self.path = UIBezierPath(arcCenter: self.location, radius:CGFloat(global_radius), startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        UIColor.blackColor().setStroke()
        
        self.path!.lineWidth = 1
        self.path!.stroke()
        
        if self.isFinal{
            let outerCircle : UIBezierPath = UIBezierPath(arcCenter: self.location, radius: CGFloat(global_radius + 3), startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
            outerCircle.lineWidth = 1
            outerCircle.stroke()
        }
        
        if self.isSelected{
            UIColor.grayColor().setFill()
            self.path!.fill()
        }
        
    }
    
    private func drawID(){
        let idLabel : NSAttributedString = NSAttributedString(string: String(self.id))
        
        idLabel.drawAtPoint(self.location)
    }
    
    func moveTo(location: CGPoint){
        self.location = location
    }
    
    
    
    func arrivalStateWithLabel(label:Character) -> State?{
        
        for trans : Transition in self.outTrans{
            if trans.label == label{
                return trans.end
            }
        }
        
        return nil
        
    }
    
    
    
    
    
    
}




