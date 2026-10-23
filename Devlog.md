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
Tested the loop by having it output my inputs.  Everything went well until trying to quit.  Need to explore that.
Windows whitespace strikes again, adjusted the quite cmd to trim whitespace and it worked.

4:15 PM
New temp build set up for the loop and evaluation method.  I've set up basic conditions such as checking a list for empty characters and whitespace as well as (hopefully) integrated it down into a re-written else section for the main loop.

A lot of this has been just trying to put together the branch logic and figure out where we branch.  Like skeleton code I suppose where rather than try to get every litte detail in one area I'm trying to just set up where the pathes will go before writing said pathes.

4:20 PM
Beginning to fill our main eval function.  Going to add in helpers to parse and lookup history first.

Number parser is first.