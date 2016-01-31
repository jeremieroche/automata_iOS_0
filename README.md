# automata_iOS_0

automata application and algorithms for iOS devices

## Running

1. Clone Repository
2. Open Project (In "Automata_Work5" directory) in XCode
3. Run Simulator

## Overview

App contains two View Controllers:

* ATVC: AutomatonTableViewController (starting View Controller on Launch)
* AVC: AutomatonViewController



## AutomatonViewController (AVC)

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/Blank_AVC.png)
![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/Sample_AVC_0.png)
![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/Sample_AVC_1.png)


* Contains a View, where the Automaton is visually represented. View should be blank when a new Automaton is created (b/c the automaton has no state nor transition)

View Contains 4 modes
* Normal Mode: Tapping on a State will cause it to be selected. Next Point tap 
* Add State Mode (ASM): Tap point on view, and circular state appears (then ASM ends) (Note: If the state is the first in the Automaton, it is an initial state, hence small arrow points to it)
* Add Transition Mode (ATM): Tap location of 2 states, and transition from first tapped state to second tapped state is formed (then ATM ends)
* Set Final Mode (SFM): Tap State, then state is a final state (then SFM ends)
* Set Label Mode (SLM): Tap Transition (tap its label or control points), the first character of the text field will be the new label of the transition.

Automaton buttons:
* State: Begins ASM
* Transition: Begins ASM
* Final: Begins SFM
* Control Points: Toggles on/off automaton showing its control points
* Set Label: Begins SLM (If and only if Text Field above is empty)

Function buttons (Creates New Automaton):
* Determinization: Deterministic version of the Automaton. (https://en.wikipedia.org/wiki/Deterministic_finite_automaton)
* Prune: Pruned version of the Automaton. (For all states in automaton, one can trace its source to the initial state AND all its transitions will eventually lead to a final state)
* Minimization: Minimized version of the Automaton (http://www.cs.engr.uky.edu/~lewis/essays/compilers/min-fa.html)

###### Test Automaton

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/TestAuto.png)

###### Test Automaton: Deterministic

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/TestAuto_Deterministic.png)

###### Test Automaton: Pruned

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/TestAuto_Pruned.png)

###### Test Automaton: Minimisation (Clustered)

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/TestAuto_Minimisation.png)

###### Moving Automaton: Tap State

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/TestAuto_Minimisation_1.png)

###### Moving Automaton: Tap New State Location

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/TestAuto_Minimisation_2.png)

###### Moving Automaton: Tap Transition

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/TestAuto_Minimisation_3.png)

###### Moving Automaton: Tap New Transition Location (w/ respect to Label)

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/TestAuto_Minimisation_4.png)

###### Test Automaton: Minimisation (Clean)

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/TestAuto_Minimisation_Final.png)



## AutomatonTableViewController (ATVC):
(Starting View Controller when app launches)

* Each cell stores information of an Automaton
* The title of each Automaton is "Automaton (count)", where (count) is the order in which Automaton was created. (eg "Automaton 8")
(Note: count starts at 0)

ATVC has 3 modes:

* Normal Mode: Can create and edit Automaton
* Union Mode: When 2 cells are selected, respective Automatons taken. Union function preformed on respective Automatons, then AVC created with new Automaton  
* Intersect Mode: When 2 cells are selected, respective Automatons taken. Intersect function performed on respective Automatons, then AVC created with new Automaton 

One can perform 4 actions on ATVC

* Edit Automaton (Tap Cell): Automaton taken from cell. AVC created with said Automaton.  
(Note: only in normal mode)
* New Automaton (Tap “+” button): Brand new empty Automaton is created. AVC is created with new Automaton.
* Begin Union (Tap “Union” button): Begins Intersect Mode (see Mode section above)
* Begin Intersect (Tap “Intersect” button): Begins Union Mode (see Mode section above)


###### Sample Table

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/Sample_ATVC.png)

###### Automaton 0

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/Automaton_0.png)

###### Automaton 1

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/Automaton_1.png)

###### Union Automaton (Automaton 0 ∪ Automaton 1)

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/Union_auto0_auto1.png)

###### Intersect Automaton (Automaton 0 ∩ Automaton 1)

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/Intersect_auto0_auto1.png)

###### Updated Table

![alt tag](https://github.com/jeremieroche/automata_iOS_0/blob/master/Automaton_Pics/Updated_ATVC.png)


