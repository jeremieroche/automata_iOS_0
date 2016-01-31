import UIKit

class Grid: NSObject {
    
    
    private var grid_layout : [[CGPoint?]] = [[CGPoint?]]()
    
    func get_next_point_from(origin_state origin: State?) -> CGPoint{
        
        let nState_x : Int
        let nState_y : Int
        
        if let original_state : State = origin{
            
            let (oState_x,_) : (Int,Int) = self.gridGetPos(original_state)!
            nState_x = oState_x + 1
            if nState_x >= self.grid_layout.count{
                self.add_column()
            }
            
            nState_y = self.grid_layout[nState_x].count
            
            
        } else {
            nState_x = 0
            if self.grid_layout.count == 0{
                nState_y = 0
            } else {
                nState_y = self.grid_layout[0].count
            }
        }
        
        let graph_point : CGPoint = self.dimension_to_coor_conversion(x: nState_x, y: nState_y)
        
        self.put_in_grid(at: graph_point, inColumn: nState_x)
        
        return graph_point
        
    }
    
    private func add_column(){
        self.grid_layout.append([CGPoint?]())
    }
    
    private func gridGetPos(otherState : State) -> (Int,Int)?
    {
        
        for i in 0..<self.grid_layout.count{ // TODO: DOES THIS WORK????
            var array_states : [CGPoint? ] = self.grid_layout[i]
            
            for j in 0..<array_states.count{
                let state_loc : CGPoint? = array_states[j]
                let oState_loc = otherState.location
                
                let xEqual = (state_loc!.x == oState_loc.x)
                let yEqual = (state_loc!.y == oState_loc.y)
                
                let points_are_equal = (xEqual && yEqual)
                
                if points_are_equal{
                    return(i,j)
                }
            }
        }
        
        return nil
        
        
    }
    
    private func dimension_to_coor_conversion(x x:Int,y y:Int) -> CGPoint{
        
        let jump = 50
        
        // X Coordinate
        let xCoor = CGFloat(jump * x + jump/2)
        
        // Y Coordinate
        let wing = 4
        let span = (wing+1) * jump
        
        let yCoor : CGFloat
        if y < span{
            let control_point = wing * jump + jump/2
            let adjusted_point = (Int(pow(Double(-1),Double(y))) * (jump * ((y+1)/2)))
            
            yCoor = CGFloat(control_point + adjusted_point)
        } else {
            let adjusted_y = span * jump + (y - span)
            
            yCoor = CGFloat(adjusted_y + jump/2)
        }
        
        let position = CGPointMake(xCoor, yCoor)
        return position
        
        
        
    }
    
    private func put_in_grid(at point: CGPoint, inColumn col:Int){
        if self.grid_layout.count <= col{
            self.add_column()
        }
        
        self.grid_layout[col].append(point)
    }
    
}
