
import UIKit

class GridE: NSObject {
    
    //private var grid_layout
    private var grid_layout : [[Bool]] = [[Bool]]()
    
    private let start_gy : Int = 4
    
    private let squareSize : Int = 100
    
    
    func origin_square() -> (Int,Int) {
        
        let gx : Int = 0
        let gy : Int = start_gy
        
        self.set_square_to_true(gx, gy: gy)
        
        return (gx,gy)
    }
    
    func next_square_at_depth(depth: Int) -> (Int,Int) {
        
        // Makes sure the grid is large enough
        
        self.expend_array_to_depth(depth)
        
        let gx : Int = depth
        var gy : Int = 0
        
        var found : Bool = false
        var y_index : Int = 0
        
        // Looks until it reaches back to the top
        while !found {
            
            gy = self.y_index_to_gy(y_index)
            
            if self.square_is_empty(gx, gy: gy){
                
                found = true
                break
            }
            
            y_index++
            
        }
        
        self.set_square_to_true(gx, gy: gy)
        
        
        return (gx,gy)
    }
    
    func convert_square_to_point(gx : Int, gy: Int) -> CGPoint {
        
        let p = CGPoint(x: gx * squareSize , y: gy * squareSize)
        
        return p
    }
    
    // Auxiliary functions
    
    func expend_array_to_depth(depth : Int){
        
        self.expend_array_to(depth, y: start_gy * 2)
    }
    
    // makes sure the 2 dimensional array is expended until (x=column,y=row)
    func expend_array_to(x: Int,y: Int){
        
        while grid_layout.count<=x{
            grid_layout.append([Bool]())
        }
        
        while grid_layout[x].count<=y{
            grid_layout[x].append(false)
        }
        
    }
    
    // 0 -> 4, 1 -> 3, 2 -> 5, 3 -> 2,...
    func y_index_to_gy(index_y : Int) -> Int {
        
        var gy : Int = 0
        
        if index_y < (start_gy * 2 - 1){
            
            if index_y % 2 != 0 {
                
                // ODD
                
                gy = start_gy - 1 - index_y / 2
            }
            else{
                gy = start_gy + index_y / 2
            }
        }
        else{
            gy = index_y
        }
        
        return gy
    }
    
    func square_is_empty(gx : Int, gy: Int) -> Bool {
        if grid_layout.count <= gx{
            return true
        }
        
        if grid_layout[gx].count <= gy{
            return true
        }
        
        return grid_layout[gx][gy]
        
        
    }
    
    func set_square_to_true(gx: Int, gy: Int) {
        self.expend_array_to(gx, y: gy)
        self.grid_layout[gx][gy]=true
    }
    
}
