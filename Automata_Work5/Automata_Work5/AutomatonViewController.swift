//
//  ViewController.swift
//  Automata_Work5
//
//  Created by Jeremie Roche on 1/22/16.
//  Copyright © 2016 jeremieroche. All rights reserved.
//

import UIKit

class AutomatonViewController: UIViewController, UIPickerViewDelegate, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Functions.delegate = self
//        Functions.selectRow(0, inComponent: 0, animated: false)
        
        if let insertAuto = self.insertAuto{
            self.autoView.automaton = insertAuto
            self.insertAuto = nil
        }
        self.group_automatonButton_enabled(enabled: true)
        
        self.autoView.setNeedsDisplay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var enable_add_state : Bool = false
    var enable_add_transition : Bool = false
    var set_final : Bool = false
    var show_control_points : Bool = false
    var set_label_bool : Bool = false
    
    private func automaton_bool_reset(){
        self.enable_add_state = false
        self.enable_add_transition = false
        self.set_final = false
        self.show_control_points  = false
        self.set_label_bool = false
        
        self.autoView.inState = nil

    }
    
    private func group_automatonButton_enabled(enabled enableAutoField: Bool){
        
        if enableAutoField {
            
            // TRUE: Turn on only actual tools
            
            self.state_button.enabled = enableAutoField
            
            let state_count : Int = self.autoView.get_state_count()
            
            self.transition_button.enabled = (state_count >= 2)
            self.isFinal_button.enabled = (state_count >= 1)
            
            let has_trans : Bool = self.autoView.has_trans()
            
            self.set_label_button.enabled = has_trans
            self.label_textField.enabled = has_trans
            
            
        } else {
            
            // FALSE: Turn of all relevent tools
            
            self.state_button.enabled = enableAutoField
            self.transition_button.enabled = enableAutoField
            self.isFinal_button.enabled = enableAutoField
            self.set_label_button.enabled = enableAutoField
            self.label_textField.enabled = enableAutoField

        }
        
    }
    
    @IBAction func tap_action(sender: UITapGestureRecognizer) {
        
        let tapPoint : CGPoint = sender.locationInView(self.autoView)
        
        if enable_add_state{
            self.autoView.insert_state(at: tapPoint)
            enable_add_state = false

            
//            let sCount = autoView.get_state_count()
//            
//            //  Button Enabled
//            if sCount >= 1{
//                self.isFinal_button.enabled = true
//            }
//            
//            if sCount >= 2{
//                self.transition_button.enabled = true
//            }
//            
//            self.state_button.enabled = true

            self.group_automatonButton_enabled(enabled: true)
            
            return

        }
        
        if enable_add_transition{
            let result : Bool = self.autoView.transition_action(at: tapPoint)
            
            if !result || autoView.transition_completed(){
                enable_add_transition = false
                
                self.group_automatonButton_enabled(enabled: true)
                
            }
            
            return
        }
        
        if set_final{
            if let final_state = autoView.automaton.retreive_state(from: tapPoint){
                final_state.isFinal = true
                autoView.setNeedsDisplay()
                
                set_final = false
                self.group_automatonButton_enabled(enabled: true)
            }
            
            
            
            return
        }
        
        
        
        if set_label_bool{
            
            if let tapTrans : Transition = self.autoView.automaton.retrieve_trans(from: tapPoint){
                let new_label : Character = self.get_label()!
                tapTrans.label = new_label
                
                set_label_bool = false
                self.group_automatonButton_enabled(enabled: true)
                self.label_textField.text = "" // Clear Text
                
                self.autoView.setNeedsDisplay()
            }
            
            return
            
        }
        
        
        self.autoView.move_action(point: tapPoint)
        
        
    }
    
    
    @IBOutlet weak var autoView: AutomatonView!

    @IBOutlet weak var state_button: UIButton!
    @IBAction func add_state(sender: AnyObject) {
        enable_add_state = true
        
        // Button Enabled
        self.group_automatonButton_enabled(enabled: false)
        
    }
    
    @IBOutlet weak var transition_button: UIButton!
    @IBAction func addTransition(sender: AnyObject) {
        enable_add_transition = true
        
        // Button Enabled
        self.group_automatonButton_enabled(enabled: false)
        
    }
    

    
    @IBOutlet weak var isFinal_button: UIButton!
    @IBAction func final_action(sender: AnyObject) {
        set_final = true
        
        // Button Enabled
        self.group_automatonButton_enabled(enabled: false)

    }
    
    @IBAction func toggle_control_point(sender: AnyObject) {
        self.autoView.toggle_control_point()
    }
    
    @IBOutlet weak var set_label_button: UIButton!
    @IBAction func set_label_action(sender: AnyObject) {
        
        if self.label_textField.text?.characters.first != nil {
            self.set_label_bool = true
            self.group_automatonButton_enabled(enabled: false)
        }
        
    }
    
    // MARK: Set Label
    
    @IBOutlet weak var label_textField: UITextField!
    
    private func get_label() -> Character?
    {
        if let field_string : String = self.label_textField.text{
            
            if field_string.characters.first == nil{
                return nil
            }
            
            let first_char : Character = field_string.characters.first!
            
            
            self.label_textField.text = "" // Clear Text Field
            
            return first_char
            
        } else {
            return nil
        }
    }
    
    
    
    // MARK: Compute

    
    @IBOutlet weak var det_button: UIButton!
    @IBAction func det_action(sender: AnyObject) {
        self.autoView.determinization()
        
        self.automaton_bool_reset()
        self.group_automatonButton_enabled(enabled: true)
    }
    
    @IBOutlet weak var Prune_button: UIButton!
    @IBAction func prune_action(sender: AnyObject) {
        self.autoView.prune()
        
        self.automaton_bool_reset()
        self.group_automatonButton_enabled(enabled: true)

    }
    
    @IBOutlet weak var min_button: UIButton!
    @IBAction func min_action(sender: AnyObject) {
        self.autoView.minimization()
        
        self.automaton_bool_reset()
        self.group_automatonButton_enabled(enabled: true)


    }
    
    
    var insertAuto : Automaton?;

    
    
    
    // MARK: Picker View
    @IBOutlet weak var Functions: UIPickerView!
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil{
            pickerLabel = UILabel()
        }
        
        let titleData : String
        if row == 0{
            titleData = "Determinization"
        } else if row == 1 {
            titleData = "Prune"
        } else {
            titleData = "Minimization"
        }
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Verdana", size: 20)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textColor = UIColor.blackColor()
        
        pickerLabel.textAlignment = NSTextAlignment(rawValue: 0)!
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let titleData : String
        if row == 0{
            titleData = "Determinization"
        } else if row == 1 {
            titleData = "Prune"
        } else {
            titleData = "Minimization"
        }
        
        return nil // TODO
        
        
        
    }
    
    

    
}

