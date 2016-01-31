import UIKit

let global_radius : Int = 15

class Automaton: NSObject {
    
    
    var arrayStates : [State]
    var stateCount : Int
    
    var view : UIView
    
    var show_control_points : Bool {
        didSet{
            for state in self.arrayStates{
                let transArray = state.outTrans
                
                for trans in transArray{
                    trans.show_control_points = self.show_control_points
                }
            }
        }
    }
    
    // MARK: Initialization
    
    override init() {
        self.stateCount = 0
        self.arrayStates = [State]()
        
        self.view = UIView()
        self.show_control_points = false
    }
    
    init(view:UIView)
    {
        self.stateCount = 0
        self.arrayStates = [State]()
        
        self.view = view
        self.arrayStates = [State]()
        self.show_control_points = false
    }
    
    init(needs_grid: Bool){
        
        if needs_grid{
            self.grid = Grid()
        }
        
        self.stateCount = 0
        self.arrayStates = [State]()
        
        self.view = UIView()
        self.show_control_points = false
        
    }
    
    // MARK: Misillancious
    
    func getInitialState() -> State
    {
        return self.arrayStates[0]
    }
    
    func isEmpty() -> Bool{
        return self.arrayStates.isEmpty
    }
    
    func has_trans() -> Bool
    {
        for state : State in self.arrayStates{
            for _ : Transition in state.outTrans{
                return true
            }
        }
        
        return false
    }
    
    
    // MARK: Grid
    var grid : Grid?
    func grid_addStateFrom(origin oState: State, label:Character) -> State{
        
        let next_point : CGPoint = self.grid!.get_next_point_from(origin_state: oState)
        
        return self.addState(at: next_point, from: oState, withLabel: label)
        
    }
    
    func grid_addState() -> State
    {
        let first_point : CGPoint = self.grid!.get_next_point_from(origin_state: nil)
        return self.addState(at: first_point)
    }
    
    // MARK: Add State
    
    func addState(at point: CGPoint) -> State{
        
        let newState = State(id: self.stateCount, location: point, view: self.view, automaton: self)
        
        self.stateCount++
        self.arrayStates.append(newState)
        
        return newState
        
    }
    
    func addState(at point:CGPoint, from fromState:State, withLabel label:Character) -> State{
        
        let newState : State = self.addState(at: point)
        self.addTransition(from: fromState, to: newState, withLabel: label)
        
        return newState
        
    }

    
    // MARK: Add Transition
    
    func addTransition(from start:State, to end:State, withLabel label:Character) -> Transition{
        
        let newTrans = Transition(view: self.view, show_cp: false, label: label, end: end, automaton: self)
        start.addTransition(newTrans)
        
        return newTrans
        
    }
    
    // MARK: Get Object
    func retreive_state(from point:CGPoint) -> State?{
        
        for state in self.arrayStates{
            if state.has_state_at(point){
                return state
            }
        }
        
        return nil
        
    }
    
    func retrieve_trans(from point:CGPoint) -> Transition?{
        
        for state in self.arrayStates{
            for trans in state.outTrans{
                if trans.has_trans(point){
                    return trans
                }
            }
        }
        
        return nil
        
    }
    
    func make_transition(from inState:State, to outState:State){
        let trans = Transition(view: self.view, show_cp: self.show_control_points, label: "0", end: outState, automaton: self)
        inState.addTransition(trans)
    }
    
    // MARK: Move Action
    
    var selected_state : State? = nil
    var selected_trans : Transition? = nil
    func move_action(point tapPoint: CGPoint)
    {
        
        // State
        if let sel_state : State = self.selected_state
        {
            sel_state.location = tapPoint
            
            self.selected_state = nil
            sel_state.isSelected = false
            
            return
            
        } else if let tapState : State = self.retreive_state(from: tapPoint){
            self.selected_state = tapState
            tapState.isSelected = true
                
            return
            
        }
        
        // Transition
        if let sel_trans : Transition = self.selected_trans
        {
            sel_trans.moveTo(tapPoint)
            
            self.selected_trans = nil
            sel_trans.isSelected = false
        } else if let tapTrans : Transition = self.retrieve_trans(from: tapPoint){
            self.selected_trans = tapTrans
            tapTrans.isSelected = true
            
            return
            
        }
        
        
        
        
        
        
        
    }
    
    // MARK: Drawing Methods
    func draw(){
        for state in self.arrayStates{
            
            state.draw()
            
            let transArray = state.outTrans
            for trans in transArray{
                trans.show_control_points = self.show_control_points
                trans.drawFrom(state)
            }
            
        }
    }
    
    // MARK: Automaton Function
    
    func union(with otherAuto:Automaton) -> Automaton?
    {
        if self.arrayStates.count ==  0 || otherAuto.arrayStates.count == 0
        {
            return nil
        }
        
        let auto = Automaton(needs_grid: true)
        
        var arrayPairs = [(NSInteger,NSInteger)]()
        
        arrayPairs.append((0,0))
        
        auto.grid_addState()
        
        var qInt = 0
        while qInt < arrayPairs.count{
            let current_pair : (NSInteger, NSInteger) = arrayPairs[qInt]
            
            let current_state : State = auto.arrayStates[qInt]
            
            let num1 : NSInteger = current_pair.0
            let num2 : NSInteger = current_pair.1
            
            print("qInt: \(qInt); num1: \(num1); num2: \(num2)")
            

            
            if num1 != NSNotFound && num2 != NSNotFound
            {
                let s1 : State = self.arrayStates[num1]
                let s2 : State = otherAuto.arrayStates[num2]
                
                current_state.isFinal = s1.isFinal || s2.isFinal
                
                for trans : Transition in s1.outTrans{
                    let label : Character = trans.label
                    
                    let id : NSInteger
                    if let otherState = s2.arrivalStateWithLabel(label){
                        id = otherState.id
                    } else {
                        id = NSNotFound
                    }
                    
                    let newPair : (NSInteger, NSInteger) = (trans.end.id,id)
                    
                    print("\(newPair.0) \(newPair.1)")
                    
                    if let arrival_state : State = auto.getState(from: newPair, within: arrayPairs){
                        // State already exists
                        auto.addTransition(from: current_state, to: arrival_state, withLabel: label)
                    } else {
                        // No State Created that state
                        auto.grid_addStateFrom(origin: current_state, label: label)
                        arrayPairs.append(newPair)
                    }
                }
                
                for trans : Transition in s2.outTrans
                {
                    
                    if s1.arrivalStateWithLabel(trans.label) != nil
                    {
                        continue
                    }
                    
                    let label : Character = trans.label
                    let newPair : (NSInteger, NSInteger) = (NSNotFound, trans.end.id)
                    print("\(newPair.0) \(newPair.1)")

                    
                    if let arrival_state : State = auto.getState(from: newPair, within: arrayPairs){
                        auto.addTransition(from: current_state, to: arrival_state, withLabel: label)
                    } else {
                        arrayPairs.append(newPair)
                        auto.grid_addStateFrom(origin: current_state, label: label)
                    }
                    
                }
            } else if (num1 != NSNotFound){
                
                
                
                // Just in Automaton 1
                let selectedAuto : Automaton = self
                
                let state1 : State = selectedAuto.arrayStates[num1]
                
                current_state.isFinal = state1.isFinal
                
                for trans : Transition in state1.outTrans
                {
                    let label : Character = trans.label
                    let newPair : (NSInteger, NSInteger) = (trans.end.id, NSNotFound)
                    print("\(newPair.0) \(newPair.1)")

                    
                    if let arrival_state : State = auto.getState(from: newPair, within: arrayPairs){
                        auto.addTransition(from: current_state, to: arrival_state, withLabel: label)
                    } else {
                        arrayPairs.append(newPair)
                        auto.grid_addStateFrom(origin: current_state, label: label)
                    }
                }
                
            } else if (num2 != NSNotFound){
                
                // Just in Automaton 2
                
                let selectedAuto : Automaton = otherAuto
                
                let state2 : State = selectedAuto.arrayStates[num2]
                
                current_state.isFinal = state2.isFinal
                
                for trans : Transition in state2.outTrans
                {
                    let label : Character = trans.label
                    let newPair : (NSInteger,NSInteger) = (NSNotFound,trans.end.id)
                    print("\(newPair.0) \(newPair.1)")

                    
                    if let arrival_state : State = auto.getState(from: newPair, within: arrayPairs){
                        auto.addTransition(from: current_state, to: arrival_state, withLabel: label)
                    } else {
                        arrayPairs.append(newPair)
                        auto.grid_addStateFrom(origin: current_state, label: label)
                    }
                    
                    
                }
            }
            
            qInt += 1
        }
        
        return auto
    }
    
    func intersect(with otherAuto: Automaton) -> Automaton?
    {
        if self.arrayStates.count == 0 || otherAuto.arrayStates.count == 0
        {
            return nil
        }
        
        let auto : Automaton = Automaton(needs_grid: true)
        var arrayPairs = [(NSInteger,NSInteger)]()
        
        auto.grid_addState()
        arrayPairs.append((0,0))
        
        var qInt = 0
        while qInt < arrayPairs.count
        {
            let current_state = auto.arrayStates[qInt]
            
            let currentPair : (NSInteger, NSInteger) = arrayPairs[qInt]
            
            let num1 : NSInteger = currentPair.0
            let num2 : NSInteger = currentPair.1
            
            if num1 != NSNotFound  && num2 != NSNotFound
            {
                let state1 : State = self.arrayStates[num1]
                let state2 : State = otherAuto.arrayStates[num2]
                
                current_state.isFinal = state1.isFinal && state2.isFinal
                
                for trans : Transition in state1.outTrans
                {
                    let label : Character = trans.label
                    
                    let id : NSInteger
                    if let otherState = state2.arrivalStateWithLabel(label){
                        id = otherState.id
                    } else {
                        continue
                    }
                    
                    let newPair : (NSInteger, NSInteger) = (trans.end.id,id)
                    
                    if let arrival_state : State = auto.getState(from: newPair, within: arrayPairs) {
                        auto.addTransition(from: current_state, to: arrival_state, withLabel: label)
                    } else {
                        arrayPairs.append(newPair)
                        auto.grid_addStateFrom(origin: current_state, label: label)
                    }
                }
            }
            
            qInt += 1
            
            
        }
        
        return auto
        
        
    }
    
    private func getState(from arrivalPair: (NSInteger,NSInteger), within arrayPairs: [(NSInteger,NSInteger)]) -> State?
    {
        for i in 0..<arrayPairs.count{
            if arrayPairs[i].0 == arrivalPair.0 && arrayPairs[i].1 == arrivalPair.1{
                return self.arrayStates[i]
            }
        }
        
        return nil
    }
    
    func prune() -> Automaton{
        
        var state_queue = [State]()
        let initial_state : State = self.arrayStates[0]
        state_queue.append(initial_state)
        
        var boolArray : [Bool] = [Bool](count: self.arrayStates.count, repeatedValue: false)
        var trans_array = [(State,State,Character)]()
        
        while !state_queue.isEmpty
        {
            
            let pop_state : State = state_queue.removeFirst()
            
            let idNum = pop_state.id
            boolArray[idNum] = true
            
            for trans in pop_state.outTrans
            {
                let outState : State = trans.end
                
                let out_idNum : Int = outState.id
                if !boolArray[out_idNum]
                {
                    state_queue.append(outState)
                }
                
                trans_array.append((pop_state,outState,trans.label))
            }
            
        }
        
        // If 'new_trans_array' empty, that means there are no final states (??????)

        let final_states : [State] = self.get_final_states()
        if final_states.count == 0{
            return Automaton()
        }
        
        for state : State in final_states{
            for trans in trans_array
            {
                let endState = trans.1
                if endState == state
                {
                    state_queue.append(state)
                }
            }
        }
        
        //coaccessable
        var new_trans_array = [(State,State,Character)]()
        boolArray = [Bool](count: self.arrayStates.count, repeatedValue: false)
        
        while !state_queue.isEmpty
        {
            let state : State = state_queue.removeFirst()
            
            for trans in trans_array
            {
                let endState : State = trans.1
                if endState == state
                {
                    new_trans_array.append(trans)
                    let inState : State = trans.0
                    let idNum = inState.id
                    if !boolArray[idNum]{
                        boolArray[idNum] = true
                        state_queue.append(inState)
                    }
                }
            }
        }
        
        
        
        // sorting (Bubble Sort)
        var sorted : Bool = false
        while !sorted
        {
            sorted = true
            for i in 0..<new_trans_array.count-1{
                let inState1 : State = new_trans_array[i].0
                let inState2 : State = new_trans_array[i+1].0
                
                if inState1.id > inState2.id
                {
                    let temp = new_trans_array[i]
                    new_trans_array[i] = new_trans_array[i+1]
                    new_trans_array[i+1] = temp
                    sorted = false
                }
            }
        }
        
        // Create Automaton
        let auto = Automaton(needs_grid: true)
        var autoDict = [State:State]()
        
        for trans in new_trans_array
        {
            let inState : State = trans.0
            let outState : State = trans.1
            let label : Character = trans.2
            
            if autoDict[inState] == nil {
                let state : State = auto.grid_addState()
                state.isFinal = inState.isFinal
                autoDict[inState] = state
            }
            
            let oInState : State = autoDict[inState]!
            
            if let oOutState = autoDict[outState]{
                auto.addTransition(from: oInState, to: oOutState, withLabel: label)
            } else {
                let state : State = auto.grid_addStateFrom(origin: oInState, label: label)
                state.isFinal = outState.isFinal
                autoDict[outState] = state
            }
            
        }
        
        return auto
        
        
        
    }
    
    private func get_final_states() -> [State]{
        var final_state_array = [State]()
        for state : State in self.arrayStates
        {
            if state.isFinal{
                final_state_array.append(state)
            }
        }
        
        return final_state_array
    }
    
    func determinization() -> Automaton
    {
        let auto = Automaton(needs_grid: true)
        
        // TODO: Convert to SubArray?
        let init_str = "0 "
        
        var set_to_state = [String:State]()
        set_to_state[init_str] = auto.grid_addState()
        
        var set_queue = [String]()
        set_queue.append(init_str)
        
        while !set_queue.isEmpty{
            
            let top_code : String = set_queue.removeFirst()
            let start_state : State = set_to_state[top_code]!
            
            // String to Int
            let code_split : [String] = top_code.componentsSeparatedByString(" ")
            var states_to_observe = [State]()
            for code : String in code_split
            {
                if code == ""{
                    continue
                }
                let num = Int(code)!
                states_to_observe.append(self.arrayStates[num])
            }
            
            // Trans Label to set
            var label_to_set = [Character : [Int]]()
            
            var isFinal : Bool = false
            for state : State in states_to_observe
            {
                for trans : Transition in state.outTrans
                {
                    let label : Character = trans.label
                    
                    let endState : State = trans.end as! State
                    let id_num : Int = endState.id
                    if label_to_set[label] != nil
                    {
                        label_to_set[label]!.append(id_num)
                    } else {
                        label_to_set[label] = [id_num]
                    }
                    
                    label_to_set[label] = self.sort_Int_array(label_to_set[label]!)
                    
                    if endState.isFinal{
                        isFinal = true
                    }
                }
            }
            
            
            // Set to Transition
            for (label, int_array) : (Character, [Int]) in label_to_set
            {
                var string_set = ""
                for number in int_array
                {
                    let str = String(number)
                    string_set += (str + " ")
                }
                
                if let endState : State = set_to_state[string_set]
                {
                    auto.addTransition(from: start_state, to: endState, withLabel: label)
                } else {
                    set_to_state[string_set] = auto.grid_addStateFrom(origin: start_state, label: label)
                    set_queue.append(string_set)
                }
                
                if isFinal{
                    set_to_state[string_set]!.isFinal = true
                }
            }
            
        }
        
        return auto
        
    }
    
    private func sort_Int_array(var int_array : [Int]) -> [Int]{
        
        var sorted : Bool = false
        
        while !sorted{
            sorted = true
            for i in 0..<int_array.count-1{
                
                if int_array[i] > int_array[i+1]{
                    sorted = false
                    let temp : Int = int_array[i]
                    int_array[i] = int_array[i+1]
                    int_array[i+1] = temp
                }
                
            }
            
        }
        
        return int_array
    }
    
    func minimization() -> Automaton
    {
        // Step 1: Create Initial Parition
        
        // a: Find the "Final_Label" for each state
        var fl_array : [Final_Label] = []
        for state : State in self.arrayStates{
            let fin_lab = Final_Label(id_num: state.id, isFinal: state.isFinal)
            for trans : Transition in state.outTrans{
                fin_lab.append(trans.label)
            }
            fl_array.append(fin_lab)
        }
        
        // b: Find Create the set
        var fl_to_set = [Final_Label : Sub_Array]()
        for fin_lab : Final_Label in fl_array
        {
            if let set : Sub_Array = fl_to_set[fin_lab]{
                set.append(fin_lab.id)
            } else {
                fl_to_set[fin_lab] = Sub_Array(number: fin_lab.id)
            }
        }
        
        // c: Put set into Initial Parition (remove all traces of Final Label)
        let first_parition = Parition()
        for (_,set) : (Final_Label,Sub_Array) in fl_to_set
        {
            first_parition.append(set)
        }
        
        // Step 2: Hopcroft Steps (splitting sets)
        
        var prev_parition : Parition = first_parition
        var new_parition = Parition()
        
        while true
        {
            for set : Sub_Array in prev_parition.set_array
            {
                // If set has one element, skip (no need to split)
                if set.id_array.count == 1{
                    new_parition.append(set)
                    continue
                }
                
                // Iterate Through all the transitions and find its corresponding set
                
                var composition_to_set = [Sub_Array:Sub_Array]()
                for id_num : Int in set.id_array{
                    let state : State  = self.arrayStates[id_num]
                    
                    // Create set composition
                    let end_set_composition = Sub_Array()
                    for trans : Transition in state.outTrans
                    {
                        let end_id = trans.end.id
                        
                        let end_set_id : Int = prev_parition.get_set_from_array_id(end_id)
                        
                        end_set_composition.append(end_set_id)
                    }
                    
                    // Puts state into proper place in
                    if let set : Sub_Array = composition_to_set[end_set_composition]{
                        set.append(id_num)
                    } else {
                        composition_to_set[end_set_composition] = Sub_Array(number: id_num)
                    }
                    
                }
                
                // Put into parition
                for (_,set) : (Sub_Array,Sub_Array) in composition_to_set{
                    new_parition.append(set)
                }
            }
            
            // If equal then quit
            if new_parition.isEqualWith(prev_parition){
                break
            }
            
            // Reset Paritions
            prev_parition = new_parition
            new_parition = Parition()
        }
        
        new_parition.set_sort()
        
        // Step 3: Create Automaton
        let auto = Automaton(needs_grid: true)
        
        auto.grid_addState()
        
        for i in 0..<new_parition.set_array.count
        {
            let start_state : State = auto.arrayStates[i]
            
            let set : Sub_Array = new_parition.set_array[i]
            
            // Top behave the same as the rest of the set
            let top_id = set.id_array[0]
            let top_state : State = self.arrayStates[top_id]
            
            // Iterate through transitions to create Automaton
            for trans : Transition in top_state.outTrans
            {
                let end_id : Int = trans.end.id
                let end_set_id : Int = new_parition.get_set_from_array_id(end_id)
                
                let auto_size : Int = auto.size()
                
                if end_set_id < auto_size{ // Check if state has already been created
                    let end_state : State = auto.arrayStates[end_set_id]
                    auto.addTransition(from: start_state, to: end_state, withLabel: trans.label)
                    end_state.isFinal = trans.end.isFinal
                } else{
                    let end_state : State = auto.grid_addStateFrom(origin: start_state, label: trans.label)
                    end_state.isFinal = trans.end.isFinal
                }
            }
            
        }
        
        return auto
    
    }
    
    func size() -> Int{
        return self.arrayStates.count
    }
    
    private class Parition{
        
        var set_array : [Sub_Array] = []
        
        func append(set:Sub_Array){
            set_array.append(set)
        }
        
        func get_set_from_array(id:Int) -> Sub_Array{
            
            let index : Int = self.get_set_from_array_id(id)
            return self.set_array[index]
            
            
        }
        
        func get_set_from_array_id(id:Int) -> Int{
            
            for i in 0..<self.set_array.count{
                let set :Sub_Array = self.set_array[i]
                if set.id_array.contains(id){
                    return i
                }
            }
            
            exit(0)// Error
            
        }
        
        func isEqualWith(other_part:Parition) -> Bool{
            
            if self.set_array.count != other_part.set_array.count{
                return false
            }
            
            for set : Sub_Array in self.set_array{
                var found_set : Sub_Array? = nil
                for other_set : Sub_Array in other_part.set_array{
                    if other_set.isEqualWith(set){
                        found_set = other_set
                        break
                    }
                }
                if found_set == nil{
                    return false
                }
                
            }
            
            return true
            
            
        }
        
        func size() -> Int{
            return set_array.count
        }
        
        func set_sort(){
            
            // Bubble Sort
            
            var sorted : Bool = false
            while !sorted{
                
                sorted = true
                
                for i in 0..<self.set_array.count-1{
                    
                    if self.set_array[i].id_array[0] > self.set_array[i+1].id_array[0]{
                        sorted = false
                        let temp_set : Sub_Array = self.set_array[i]
                        self.set_array[i] = self.set_array[i+1]
                        self.set_array[i+1] = temp_set
                    }
                    
                }
                
                
            }
            
            
            
        }
        
        
        
    }

    
    
}



private func ==(lhs: Sub_Array, rhs: Sub_Array) -> Bool{
    return lhs.hashValue == rhs.hashValue
}

private class Sub_Array : Hashable {
    var id_array : [Int] = []
    private var hash_str : String = ""
    
    init(){
        self.id_array = []
        self.hash_str = ""
    }
    
    init(number : Int){
        self.id_array = [number]
        
        self.hash_str.appendContentsOf(" \(number)")
    }
    
    init(array:[Int]){
        self.id_array = array
        
        for number : Int in array{
            self.hash_str.appendContentsOf(" \(number)")
        }
        
    }
    
    func append(array:[Int]){
        for number : Int in array{
            self.hash_str.appendContentsOf(" \(number)")
        }
    }
    
    func append(number: Int){
        self.id_array.append(number)
        hash_str.appendContentsOf(" \(number)")
    }
    
    var hashValue : Int{
        get{
            return self.hash_str.hashValue
        }
    }
    
    func isEqualWith(array:Sub_Array)->Bool{
        return array.id_array == self.id_array
    }
    
    
}


// TODO: Rename
// Minimization Wrappers
private func ==(lhs:Final_Label,rhs:Final_Label) -> Bool{
    return lhs.hashValue == rhs.hashValue
}

private class Final_Label : Hashable{
    let id : Int
    let isFinal : Bool
    var labels : [Character] = [Character]()
    private var hash_str : String = ""
    
    init(id_num:Int, isFinal : Bool){
        self.isFinal = isFinal
        self.id = id_num
    }
    
    func append(char:Character){
        self.labels.append(char)
        hash_str.appendContentsOf(" \(char)")
    }
    
    
    var hashValue : Int{
        get{
            return "\((isFinal) ? "F" : "NF") \(hash_str)".hashValue
        }
    }
    
}




struct Matrix{
    let rows : Int, columns : Int
    var grid : [Double]
    
    init(rows:Int,columns:Int){
        self.rows = rows
        self.columns = columns
        self.grid = Array(count: rows*columns, repeatedValue: 0.0)
    }
    
    func indexIsValidForRow(r:Int, c:Int) -> Bool{
        return  r >= 0 && r < rows && c >= 0 && c < columns
    }
    
    subscript(r:Int,c:Int) -> Double{
        get{
            assert(indexIsValidForRow(r, c: c),"Index is out of Range")
            return grid[(r*columns) + c]
        }
        
        set {
            assert(indexIsValidForRow(r, c: c), "Index out of Range")
            grid[(r * columns) + c] = newValue
            
        }
        
    }
}