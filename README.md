# automata_iOS_0

automata application and algorithms for iOS devices

App contains two View Controllers:

* AutomatonTableViewController (starting View Controller on Launch)
* AutomatonViewController


## AutomatonTableViewController (ATVC):
(Starting ViewController when app launches)

* Each cell stores information of an Automaton (VisualAuto)
* The title of each Automaton is "Automaton (count)", where (count) is the order in which Automaton was created.
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



## AutomatonViewController (AVC)

* Contains a View, where the Automaton is visually represented. View should be blank when a new Automaton is created (b/c the automaton has no state nor transition)
View Contains 4 modes
* Add State Mode (ASM): Tap point on view, and circular state appears (then ASM ends) (Note: If the state is the first in the Automaton, it is an initial state, hence small arrow points to it)
* Add Transition Mode (ATM): Tap location of 2 states, and transition from first tapped state to second tapped state is formed (then ATM ends)
* Set Final Mode (SFM): Tap State, then state is a final state (then SFM ends)
* Normal Mode: Drag States (long press on states) or Drag Transitions (long press on Transition midpoint or its 2 control points)

4 buttons:
* State: Begins ASM
* Transition: Begins ASM
* Final: Begins SFM
* Control Points: Toggles on/off transitions show its control points
