10/23/26 1:20 PM
While I've been working a bit behind the scenes on planning out the project and trying to best visualize through draw.io diagrams.  This is the first real setup I've had with the environment for the language/devlog.

Currently I have a rough idea of how I want to approach, typically I try to create a flow chart/UML diagram and follow a more object oriented design approach for projects though obviously that is a bit harder to do here.  My hope is that I can still manage to break down the logic into bite-sized sections to attack.

2:20 PM
Currently writing through the first config block.  As I'm unfamiliar with Racket a lot of my time will be spent commenting lines and ensuring my own understanding of each area of the code as it's not a personally intuitive to me as Python for example.

Alright first success I have the config block working along with test code.  True is prompt on while false is "Nuh uh"
PS C:\Users\colin\OneDrive\Documents\GitHub\Paradigms-Project-1> racket main.rkt
Prompt ON
PS C:\Users\colin\OneDrive\Documents\GitHub\Paradigms-Project-1> racket main.rkt -b
Nuh uh
PS C:\Users\colin\OneDrive\Documents\GitHub\Paradigms-Project-1> racket main.rkt --batch
Nuh uh

The extensive commenting is helping with conceptualizing the lang better so I'm going to continue with that for the next blocks.

3:00 PM
Getting started on the while loop, wrote first "if" statement in racket to call the first config method.  Thankfully it's becoming a bit more intuitive now.