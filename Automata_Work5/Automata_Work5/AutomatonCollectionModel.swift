//
//  AutomatonCollectionModel.swift
//  Automata_Work5
//
//  Created by Jeremie Roche on 1/24/16.
//  Copyright © 2016 jeremieroche. All rights reserved.
//

import UIKit

class AutomatonCollectionModel: NSObject {
    static var instance : AutomatonCollectionModel!
    
    var megaAuto = [Automaton]()
    
    class func sharedMegaCollAutoModel() -> AutomatonCollectionModel! {
        let newModel = AutomatonCollectionModel()
        newModel.megaAuto = self.testAutos()
        
        self.instance = (self.instance ?? newModel)
        return self.instance
    }
    
    static private func testAutos() -> [Automaton]{
        return revised_test1()
    }
    
    static private func test0() ->  [Automaton]{
        // Visual Automaton #1
        let visAuto1 : Automaton = Automaton()
        let point1 : CGPoint = CGPointMake(CGFloat(100),CGFloat(100))
        let state1 : State = visAuto1.addState(at: point1)
        
        let point2 : CGPoint = CGPointMake(CGFloat(200), CGFloat(200))
        let state2 : State = visAuto1.addState(at: point2)
        state2.isFinal = true
        visAuto1.addTransition(from: state1, to: state2, withLabel: "0")
        
        // Visual Automaton #2
        let visAuto2 : Automaton = Automaton()
        let otherState1 : State = visAuto2.addState(at: point1)
        let otherState2 : State = visAuto2.addState(at: point2)
        let otherState3 : State = visAuto2.addState(at: CGPointMake(250, 250))
        visAuto2.addTransition(from: otherState1, to: otherState2, withLabel: "0")
        visAuto2.addTransition(from: otherState1, to: otherState3, withLabel: "1")
        
        
        var arrayVisAuto : [Automaton] = [Automaton]()
        arrayVisAuto.append(visAuto1)
        arrayVisAuto.append(visAuto2)
        
        return arrayVisAuto
        
    }
    
    static private func test1() -> [Automaton]{
        
        // Automaton 1
        let visAuto1 : Automaton = Automaton()
        let point1 : CGPoint = CGPointMake(100, 100)
        let state1 : State = visAuto1.addState(at: point1)
        
        let point2 : CGPoint = CGPointMake(100, 200)
        let state2 : State = visAuto1.addState(at: point2)
        
        let point3 : CGPoint = CGPointMake(100, 300)
        let state3 : State = visAuto1.addState(at: point3)
        
        visAuto1.addTransition(from: state1, to: state2, withLabel: "a")
        visAuto1.addTransition(from: state1, to: state2, withLabel: "b")
        visAuto1.addTransition(from: state2, to: state3, withLabel: "c")
        
        
        // Automaton 2
        let visAuto2 : Automaton = Automaton()
        let oState1 : State = visAuto2.addState(at: point1)
        let oState2 : State = visAuto2.addState(at: point2)
        let oState3 : State = visAuto2.addState(at: point3)
        
        visAuto2.addTransition(from: oState1, to: oState2, withLabel: "a")
        visAuto2.addTransition(from: oState1, to: oState2, withLabel: "d")
        visAuto2.addTransition(from: oState2, to: oState3, withLabel: "c")
        
        var arrayVisAuto : [Automaton] = [Automaton]()
        arrayVisAuto.append(visAuto1)
        arrayVisAuto.append(visAuto2)
        
        return arrayVisAuto
        
        
    }
    
    static private func revised_test1() -> [Automaton]{
        let auto1 : Automaton = Automaton(needs_grid: true)
        
        let state1 : State = auto1.grid_addState()
        let state2 : State = auto1.grid_addStateFrom(origin: state1, label: "a")
        auto1.addTransition(from: state1, to: state2, withLabel: "b")
        auto1.grid_addStateFrom(origin: state2, label: "c")
        
        let auto2 : Automaton = Automaton(needs_grid: true)
        
        let state_1 : State = auto2.grid_addState()
        let state_2 : State = auto2.grid_addStateFrom(origin: state_1, label: "a")
        auto2.addTransition(from: state_1, to: state_2, withLabel: "d")
        auto2.grid_addStateFrom(origin: state_2, label: "c")
        
        let arrayAuto : [Automaton] = [auto1,auto2]
        
        return arrayAuto
    }
    
    static private func test_prune() -> [Automaton]{
        
        // Pruning
        
        // Example 1
        
        let visAuto : Automaton = Automaton(needs_grid: true)
        
        let state1 : State = visAuto.grid_addState()
        let state2 : State = visAuto.grid_addStateFrom(origin: state1, label: "a")
        let state3 : State = visAuto.grid_addStateFrom(origin: state2, label: "b")
        let state4 : State = visAuto.grid_addStateFrom(origin: state2, label: "c")
        
        state3.isFinal = true
        state4.isFinal = true
        
        visAuto.grid_addStateFrom(origin: state1, label: "f")
        
        let stateX : State = visAuto.grid_addState()
        visAuto.addTransition(from: stateX, to: state3, withLabel: "X")
        
        
        let arrayVisAuto : [Automaton] = [visAuto]
        
        return arrayVisAuto
        
        
    }
    
    static private func test_det() -> [Automaton]{
        // Determinsation
        
        var arrayVisAuto :[Automaton] = [Automaton]()
        
        // Example 1
        
        let visAuto1 : Automaton = Automaton(needs_grid: true)
        
        let state1 : State = visAuto1.grid_addState()
        
        let state2 : State = visAuto1.grid_addStateFrom(origin: state1, label: "a")
        visAuto1.addTransition(from: state1, to: state2, withLabel: "b")
        
        let state3 : State = visAuto1.grid_addStateFrom(origin: state1, label: "a")
        
        let state4 : State = visAuto1.grid_addStateFrom(origin: state1, label: "b")
        
        
        let state5 : State = visAuto1.grid_addStateFrom(origin: state2, label: "d")
        visAuto1.addTransition(from: state3, to: state5, withLabel: "c")
        visAuto1.addTransition(from: state4, to: state5, withLabel: "e")
        state5.isFinal = true
        
        arrayVisAuto.append(visAuto1)
        
        // Example 2
        
        let visAuto2 : Automaton = Automaton(needs_grid: true)
        
        let state_1 : State = visAuto2.grid_addState()
        let state_2 : State = visAuto2.grid_addStateFrom(origin: state_1, label: "a")
        visAuto2.addTransition(from: state_2, to: state_2, withLabel: "a")
        let state_3 : State = visAuto2.grid_addStateFrom(origin: state_1, label: "a")
        visAuto2.addTransition(from: state_3, to: state_1, withLabel: "b")
        let state_4 : State = visAuto2.grid_addStateFrom(origin: state_2, label: "b")
        state_4.isFinal = true
        visAuto2.addTransition(from: state_3, to: state_4, withLabel: "c")
        visAuto2.addTransition(from: state_3, to: state_4, withLabel: "a")
        
        arrayVisAuto.append(visAuto2)
        
        // Return
        
        return arrayVisAuto
    }
    
    static private func test_min() -> [Automaton]{
        // Minimization
        
        var arrayVisAuto : [Automaton] = [Automaton]()
        
        // Example 1
        
        let visAuto1 : Automaton = Automaton(needs_grid: true)
        
        let state1 : State = visAuto1.grid_addState()
        
        let state2 : State = visAuto1.grid_addStateFrom(origin: state1, label: "a")
        let state3 : State = visAuto1.grid_addStateFrom(origin: state1, label: "b")
        
        let state4 : State = visAuto1.grid_addStateFrom(origin: state2, label: "a")
        let state5 : State = visAuto1.grid_addStateFrom(origin: state3, label: "a")
        
        let state6 : State = visAuto1.grid_addStateFrom(origin: state4, label: "c")
        state6.isFinal = true
        visAuto1.addTransition(from: state5, to: state6, withLabel: "c")
        
        arrayVisAuto.append(visAuto1)
        
        // Example 2
        
        let visAuto2 : Automaton = Automaton(needs_grid: true)
        
        let state_1 : State = visAuto2.grid_addState()
        let state_2 : State = visAuto2.grid_addStateFrom(origin: state_1, label: "a")
        let state_3 : State = visAuto2.grid_addStateFrom(origin: state_1, label: "b")
        
        visAuto2.addTransition(from: state_2, to: state_2, withLabel: "a")
        visAuto2.addTransition(from: state_3, to: state_2, withLabel: "a")
        visAuto2.addTransition(from: state_3, to: state_3, withLabel: "b")
        
        let state_4 : State = visAuto2.grid_addStateFrom(origin: state_2, label: "b")
        visAuto2.addTransition(from: state_4, to: state_2, withLabel: "a")
        
        let state_5 : State = visAuto2.grid_addStateFrom(origin: state_4, label: "b")
        state_5.isFinal = true
        visAuto2.addTransition(from: state_5, to: state_2, withLabel: "a")
        visAuto2.addTransition(from: state_5, to: state_3, withLabel: "b")
                
        arrayVisAuto.append(visAuto2)
        
        
        // Return
        
        
        return arrayVisAuto
    }

}
