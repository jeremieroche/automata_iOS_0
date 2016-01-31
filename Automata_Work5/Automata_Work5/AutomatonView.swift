//
//  AutomatonView.swift
//  Automata_Work5
//
//  Created by Jeremie Roche on 1/24/16.
//  Copyright © 2016 jeremieroche. All rights reserved.
//

import UIKit

class AutomatonView: UIView {

    
    var automaton : Automaton
    var inState : State?
    
    required init?(coder aDecoder: NSCoder) {
        self.automaton = Automaton()
        
        super.init(coder: aDecoder)
        
        self.automaton = Automaton(view: self)
    }
    
    func is_empty() -> Bool
    {
        return self.automaton.isEmpty()
    }
    
    
    func insert_state(at point:CGPoint){
        self.automaton.addState(at: point)
        
        self.setNeedsDisplay()
    }
    
    func get_state_count() -> Int
    {
        return self.automaton.stateCount
    }
    
    func has_trans() -> Bool
    {
        return self.automaton.has_trans()
    }
    
    
    func transition_action(at point:CGPoint) -> Bool
    {
        if let inState = self.inState{
            
            if let outState = self.automaton.retreive_state(from: point){
                self.automaton.addTransition(from: inState, to: outState, withLabel: "0")
                self.show_control_points(show: self.automaton.show_control_points)
                
                self.inState = nil
                self.setNeedsDisplay()
                
                return true
                
            } else {
                return false
            }
            
        } else {
            if let inState  = self.automaton.retreive_state(from: point){
                self.inState = inState
                return true
            } else {
                return false
            }
        }
    }
    
    func transition_completed() -> Bool {
        return self.inState == nil
    }
    
    func toggle_control_point()
    {
        self.automaton.show_control_points = !self.automaton.show_control_points
        
        self.setNeedsDisplay()
        
    }
    
    func show_control_points(show boolean: Bool){
        self.automaton.show_control_points = boolean
        
        self.setNeedsDisplay()
    }
    
    // MARK: Computations
    
    func prune(){
        let pruned_auto : Automaton = self.automaton.prune()
        self.add_automaton(with: pruned_auto)
    }
    
    func determinization(){
        let det_auto : Automaton = self.automaton.determinization()
        self.add_automaton(with: det_auto)
    }
    
    func minimization(){
        let min_auto : Automaton = self.automaton.minimization()
        self.add_automaton(with: min_auto)
    }
    
    func add_automaton(with new_auto: Automaton){
        
        self.automaton = new_auto
        
        let model = AutomatonCollectionModel.sharedMegaCollAutoModel()
        model.megaAuto.append(new_auto)
        
        self.setNeedsDisplay()
        
    }
    
    
    
    override func drawRect(rect: CGRect) {
        self.automaton.revised_draw()
    }
    
    func move_action(point tapPoint: CGPoint)
    {
        self.automaton.move_action(point: tapPoint)
        self.setNeedsDisplay()
    }
    
    // MARK: Computatations
    
    
    
    
    
}
