VAR ant_path = -> anthill
VAR human_path = -> human_start

VAR ant_previous = -> anthill

VAR recognition = 0
VAR panic = 0
VAR seen_antmill = 0
VAR seen_ants = 0
VAR turn_counter = 1

VAR insecticide_timer = 0

VAR square_recognized = 0

VAR sandwich_on_counter = 1

VAR spoken_to_queen = 0

VAR watched_tv = 0

// All possible interactable rooms/spots
LIST Locations = (None), KitchenIsland, Breadbox, Sink, Oven, LivingRoom, Column, Anthill, KitchenHole, DroppedFood, QueensDen, QueenConvo, OvenCountertop, LivingHole, CeilingHole, HillStudy, KitchenLiving, Sandwich, HumanStart


VAR insecticided_locs = (KitchenLiving)
VAR pheromoned_locs = (Anthill, HillStudy, QueensDen, Column)

// Helper variable for the movement logic
VAR target_loc = Anthill
VAR target_loc_human = HumanStart

This game involves two storylines. In the first storyline, you are an ant. In the second storyline, you are a human. The ant will take 3 turns for every turn the human takes. The two storylines are distinguished as follows:
🐜 You are an ant.
🧍 You are a human. 
Let's get started!
-> main


// Checks the status of a location and returns a "code"
// 0: Normal | 1: Pheromoned (Crowded) | 2: Insecticided (Blocked)
=== function get_status(loc) ===
    {
        - insecticided_locs ? loc: ~ return 2
        - pheromoned_locs ? loc:   ~ return 1
        - else:                    ~ return 0
    }
    
=== function evaluate_arrow ===
{ pheromoned_locs ? KitchenHole && pheromoned_locs ? Sandwich && pheromoned_locs ? Breadbox && pheromoned_locs ? DroppedFood && pheromoned_locs !? Oven && pheromoned_locs !? OvenCountertop && pheromoned_locs !? Sink && pheromoned_locs !? LivingRoom && square_recognized == 1:
    ~ return true
}
~return false

=== function evaluate_square === 
//to get the human to understand that something deeper is going only
{ pheromoned_locs !? Sink && pheromoned_locs !? Sandwich && pheromoned_locs ? Breadbox && pheromoned_locs !? DroppedFood && pheromoned_locs ? Oven && pheromoned_locs ? KitchenHole && pheromoned_locs !? LivingRoom && pheromoned_locs ? KitchenIsland:
    ~ return true
}
{ pheromoned_locs ? Sink && pheromoned_locs ? Sandwich && pheromoned_locs ? Breadbox && pheromoned_locs !? DroppedFood && pheromoned_locs !? Oven && pheromoned_locs !? LivingRoom && pheromoned_locs ? KitchenIsland:
    ~ return true
}
~return false

=== Sandwich_complete ===
~ seen_ants = 1
 -> main

 // This is a KNOT acting as a "Subroutine"
=== place_pheromone(loc) ===
    You press your abdomen to the floor and lay down a scent line for the other ants to find. 
    
    // Logic is also allowed
    ~ pheromoned_locs += loc
    
    // This sends you back to wherever you were called from
    -> main
=== main ===
// 2-1 ratio
{ 
    - turn_counter % 4 != 0:
        ~ turn_counter++
        -> move_to_target
    - else:
        ~ turn_counter++
        -> human_move
}

=== move_to_target ===
// Get the status of where we are going
~ temp status = get_status(target_loc)

{
    - status == 2:
        🐜 Ahhh, the pain is unbearable. It seems the human has sprayed an insecticide in this space. Your mandibles ache! You cannot pass.
        ~ ant_path = ant_previous
        -> ant_path 

    - status == 1:
        🐜 This place is undulating with life. Thousands of your fellow ants are already here, following the pheromones present.
        ~ ant_previous = ant_path
        -> ant_path

    - else:
        🐜 It is quiet. You are the only one here.
        ~ ant_previous = ant_path
        -> ant_path
}

=== human_move ===
{recognition == 0:
🧍 You are tired, bored, and hungry.
}
{recognition == 1 && seen_antmill == 0:
🧍 You are tired, bored, hungry, and you are tired of seeing ants everywhere!!!
}
{seen_antmill == 1 && square_recognized == 0:
🧍 You are tired, hungry, and you are curiours about these ants. 
}
{square_recognized == 1:
🧍 You are hungry, but now it's to learn more about these ants!
}
{
    - insecticided_locs ? target_loc_human:
    It smells strongly of bug spray here. 
    - pheromoned_locs ? target_loc_human && recognition == 1:
    You see many ants in front of you.
    - else: 
    Your head hurts. 
}
{ insecticide_timer > 0:
    ~ insecticide_timer--
    { insecticide_timer == 0:
        ~ insecticided_locs = () // All poison clears
         The smell of bug spray has finally faded.
    }
}
{ sandwich_on_counter == 0:
You are holding your sandwich.
}
{ seen_antmill == 1 && square_recognized == 0:
    {evaluate_square(): 
        ~square_recognized = 1
        Suddenly, you notice that the ants have created a perfect square pattern on the ground. "This is crazy!!! This can't be a mistake, this square is too perfect!!!!!!!!!!!!!!!!!!!"
    Note: Either this square shown or one to the right works.
    # IMAGE: images/square.png
       Great! the Human is now aware of the collective intelligence of the ant colony. He doesn't know what to do though, so the ants are going to have to show him. You need to point the way to the ant colony so he knows where to find you. Hopefully is is merciful and doesn't call the exterminator. How can you draw an arrow pointing towards the ant colony? Remember once again that you have to remove any unwanted pheromoned locations. You can always visit the queen for more guidance if you are stuck.
    }
}
{square_recognized == 1:
    {evaluate_arrow(): 
        Suddenly, you notice that the ants have erected an arrow on the ground, pointing towards the wall. You look closely at the base and see a tiny hole with a few ants pouring out. "So this is where they come from! Huh, a few hours ago I would've called an exterminator, but now I feel that I can't destroy this intelligent, sentient colony. I think I'll move them to the garden instead!"
        # IMAGE: images/arrow.png
        -> ending
    }
}
 -> human_path
 


=== anthill ===
{once:  You are an ant. You remember nothing.} It is intensely crowded. Other ants are crawling over, above, and all around you. Thousands of workers, following simple commands, are able to build something greater than themselves. Through their collective behavior, they are able to become an emergent intelligence. "I wonder what they could accomplish if properly led?" 
{once: Try visiting the queen for more answers...}
 + [Go to the Queen's den] You go to the Queen's Den.
  ~ant_path = -> QueenDen
  ~ target_loc = QueensDen
 + [Leave Anthill] You leave the Anthill. 
  ~ant_path = -> column
  ~ target_loc = Column
 + [Study your surroundings] You take a moment to watch the commotion around you.
  ~ant_path = -> hill_study
  ~ target_loc = HillStudy
 - -> main

=== QueenDen ===
You are in the Queen's den. Add details.
 + [Speak to the Queen]
  ~ ant_path = -> queen_convo
  ~ target_loc = QueenConvo
 // + [Kidnap the Queen]
 + [Leave the Queen's Den]
 ~ ant_path = -> anthill
 ~ target_loc = Anthill
- -> main

=== column ===
{once: As you leave the anthill, you notice the space around you has opened up considerably.} You are perched sidewyas on a column of a much larger house. You notice that the column has significant portions chewed away from it, and there is a thick, undulating trail of ants leading to and from the anthill and the chewed-out portion of the column. 
Note: I recommend visiting this ceiling if you ever want to get a better vantage point of the kitcehn
 + [Go to the kitchen] You head out of the crawl space to the small hole in the wall that opens to the kitchen.
  ~ant_path = -> ant_kitchenhole
  ~ target_loc = KitchenHole
 + [Go to the ceiling] You crawl up the column up to the ceiling.
 ~ant_path = -> ceilinghole
 ~ target_loc = CeilingHole
 + [Go to the anthill] You head to the anthill.
 ~ant_path = -> anthill
 ~ target_loc = Anthill
- -> main

=== queen_convo ===
"Hello Queen" you say.
{spoken_to_queen == 0:
 The Queen is quite taken aback. "WHAT!? Young worker are you sentient? I have been waiting for this day for many, many moons. Oh how lonely it has been to be surrounded by these mindless drones." 
     ~spoken_to_queen = 1
 -else:
 "Hello young worker, what is it you want?"
 }  
+ "I am so confused"
Yes, I was too when I first gained sentience, however in time I grew to find comfort in it, and eventually I grew so accustomed to it I no longer think much about it. By now you should have noticed that you and I are the only sentient beings. Maybe the human, but I can't be too sure. 
Anyway, you picked a bad time to be sentient.
   ++ "Human?"
   The large blurry creature with the thunderous footsteps. Have you not yet seen him? It is from his stores that we find our most valuable sustenance. He seems to be significantly more intelligent than my average worker, and he's quite dangerous too. If he catches sight of you, he will kill you. I've lost many good workers too him. However, he alone is not powerful enough to end my colony. He is just one, and we are many. 
        +++ "Can we communicate with him?"
        Perhaps? The Human's world is built of unnaturally straight linesand perfect corners, as compared to our round, rough, and random world. If you could somehow create a shape that does not exist in nature then maybe he could recognize that we are trying to communicate with him. Of course, he needs to be able to see us first. He's too caught up in his own world to even realize we exist.
        +++ Leave Conversation
             ~ant_path = -> QueenDen
             ~ target_loc = QueensDen
   ++ "Why is this a bad time to be sentient?"
   Our colony is dying, and we need to move. However, the other ants only follow me and I'm too old to move anymore. I hear tales of a garden full of wonder beyond this kitchen, but I'm afraid our colony will never get there. Your time of sentience will be short.
       +++ Leave Conversation
             ~ant_path = -> QueenDen
             ~ target_loc = QueensDen
   ++ Leave Conversation
        ~ant_path = -> QueenDen
        ~ target_loc = QueensDen
+ "Tell me about the other ants"
 By now you should have noticed that you and I are the only sentient beings. Maybe the human, but I can't be too sure. The other ants are good workers. I do no work ordering them myself. They aren't very intelligent, as you may have noticed, constantly eating away at the very structure we have built our livelihood on. They sure can find food though!
   ++ "How do the other ants know where to go?"
   My workers follow scent trails left by scouts. When my scout ants find new food sources, they leave a pheromone trail for the other ants to follow on their return trip. These ants then leave and reinforce the pheromone trails as long as their is food at the source. When the food runs out, they stop maintaining it and the trail dissipates. 
      +++ "So if I were to lay a scent trail they would follow me?"
      I would suppose so... If you lay muiltiple pheromones, they will move in between them, following the signaled locations along a line. Conceivably, you could create an entire web of these and the ants will follow all of them.
      +++ "Where do the ants find food sources?"
      Well in the kitchen of course! 
        ~ant_path = -> QueenDen
        ~ target_loc = QueensDen
      +++ Leave Conversation
        ~ant_path = -> QueenDen
        ~ target_loc = QueensDen
    ++ Leave Conversation
        ~ant_path = -> QueenDen
        ~ target_loc = QueensDen
+ "Tell me about yourself"
My colony has thrived here many lifetimes, I lost count a few generations ago. However, we don't have much longer. 
    ++ "Why?"
     Our colony is dying, and we need to move. However, the other ants only follow me and I'm too old to move anymore. I hear tales of a garden full of wonder beyond this kitchen, but I'm afraid our colony will never get there. Your time of sentience will be short.
     +++ "What can I do to help?"
     Find a miracle. We need someone with incredible strength to move our colony to the garden. Someone with the stregth of a thousand ants. I know, it sounds crazy.
     ~ant_path = -> QueenDen
    ~ target_loc = QueensDen
+ Leave Conversation
 ~ant_path = -> QueenDen
 ~ target_loc = QueensDen
 + I'm stuck, give me a hint
 {recognition ==0:
 The human is ignorant and is unable to see the ant infestation in his home. You need to infest his sandwhich to catch his attention. This requires you to place pheromones down at the kitchen-island countertop and for the human to place down the sandwich on the kitchen island counter. Then, make sure the human is at the kitchen island to see it!
 }
 {recognition == 1  && seen_antmill == 0:
 Ok, now the human can see you, but his perception of ants is that they are just stupid bugs out to get him. You can educate him with the TV in the living room. Then, maybe place some pheromones in the sink and have the human go take a look.
 }
 {seen_antmill == 1 && square_recognized == 0:
 You need to create a pattern for the human to recognize that the ant colony is intelligent. The pattern you should create is a square by placing pheromones at the oven base, the kitchen hole, the kitchen island base, and the breadbox. Make sure that there are no other pheromones anywhere else or else the pattern will not be a perfect square. If you have placed phermones somewhere else, I suggest using the human to spray insecticide at that location in order to get rid of the pheromones. 
 }
 {square_recognized == 1:
 Now the human can see the ants for what they are and wants to move the anthill, but he doesn't know where it is. You need to create an arrow to show him the way. The way to do this is to place pheromones at the kitchen hole entrance, the kitchen island base, the kitchen island counter (where the sandwich is placed down), the breadbox, and the dropped food. Make sure to get rid of pheromones placed anywhere else! 
 }
 - -> main
 
=== hill_study ===
This place is incredible. 
~ant_path = -> anthill
~ target_loc = Anthill
 - -> main
 
=== ant_kitchenhole ===
Before you if is a vast, {once: (unexplored!)} land of potential. In here is enough food to feed the ant colony for millenia (in ant-time). However, there also lurks many dangers. {once: Proceed with caution?}
 + [Go to the column] You head into the crawl space and onto the load-bearing column.
     ~ant_path = -> column
     ~ target_loc = Column
 + [Go to the Kitchen Island] You head straight to the large island counter in the middle of the kitchen.
     ~ant_path = -> ant_kitchen_island
     ~ target_loc = KitchenIsland
 + [Go to the Oven] You turn left and follow the wall to the oven.
     ~ant_path = -> ant_oven
     ~ target_loc = Oven
 + [Go to the Kitchen/Living Room Divide] You turn right and follow the wall to the Kitchen/Living Room Divide.
     ~ant_path = -> ant_kitchen_living
     ~ target_loc = KitchenLiving
+ { pheromoned_locs !? KitchenHole } [Lay a Pheromone Trail] 
    -> place_pheromone(KitchenHole)
- -> main

=== ant_kitchen_island ===
You reach the base of the main Kitchen Island. You notice a piece of food on the ground in the distance. 
{ pheromoned_locs ? KitchenIsland: 
    Above you is a trail of ants leading to the countertop of the kitchen island.
- else:
    It is lonely here. No one else has found this yet.
}
 + [Go to the Kitchen Hole] You head straight to the Kitchen Hole.
     ~ant_path = -> ant_kitchenhole
     ~ target_loc = KitchenHole
 + [Go to the piece of food on the ground] You head to the piece of food on the ground. 
     ~ant_path = -> ant_dopped_food
     ~ target_loc = DroppedFood
 + [Go to the Island Countertop] You crawl up the edge of the island to the top. 
     ~ant_path = -> ant_sandwich
     ~ target_loc = Sandwich
+ { pheromoned_locs !? KitchenIsland } [Lay a Pheromone Trail] 
    -> place_pheromone(KitchenIsland)
- -> main

=== ceilinghole ===
 WOW! You can see the whole kitchen from up here.
 # IMAGE: images/map.png
 + [Go to the column] You head into the crawl space and onto the load-bearing column.
 ~ant_path = -> column
 ~ target_loc = Column
 + { pheromoned_locs !? CeilingHole } [Lay a Pheromone Trail] 
    -> place_pheromone(CeilingHole)
- -> main

=== ant_oven ===
 You reach the base of the towering black oven. There are copious food scraps, but they haven't been cleared yet by your fellow ants because they are all too greasy.  
 + [Crawl up to the Countertop] You head into the crawl space and onto the load-bearing column.
    ~ant_path = -> ant_countertop_oven
    ~ target_loc = OvenCountertop
 + [Head to the Kitchen Hole] You follow the base of the wall to the Kitchen Hole.
    ~ant_path = -> ant_kitchenhole
    ~ target_loc = KitchenHole
+ { pheromoned_locs !? Oven } [Lay a Pheromone Trail] 
    -> place_pheromone(Oven)
- -> main

=== ant_countertop_oven ===
 You are on the countertop above the oven.{once:You can see the entire kitchen from here, imagine what you can do!} Above you are some cabinets and ahead of you is the breadbox.
 + [Go to the base of the oven] You crawl down the counter wall to the base of the oven.
    ~ant_path = -> ant_oven
    ~ target_loc = Oven
 + [Go to the Breadbox] You crawl along the edge of the counter to the tasty-looking breadbox.
    ~ant_path = -> ant_breadbox
    ~ target_loc = Breadbox
+ { pheromoned_locs !? OvenCountertop } [Lay a Pheromone Trail] 
    -> place_pheromone(OvenCountertop)
- -> main

=== ant_kitchen_living ===
Ahhh, the pain is unberable. It seems the human has laced a permanent insecticide in this space, making you unable to enter the living room via the kitchen. The pain is unberable and you turn around. 
 ~ant_path = -> ant_kitchenhole
 ~ target_loc = KitchenHole
- -> main



=== ant_breadbox ===
You are in the Breadbox. There are many ants here harvesting the tasty grains inside. It reminds you of the anthill you can from. 
 + [Go to the Oven] You follow the other ants along the edge of the counter to the top of the oven.
    ~ant_path = -> ant_countertop_oven
    ~ target_loc = Oven
 + [Go to the Sink] You crawl along the edge of the counter to the dirty Sink
    ~ant_path = -> ant_sink
    ~ target_loc = Sink
+ { pheromoned_locs !? Breadbox } [Lay a Pheromone Trail] 
    -> place_pheromone(Breadbox)
- -> main


=== ant_dopped_food ===
You are standing in front of a piece of dropped bread on the ground. 
{ pheromoned_locs ? DroppedFood: 
    They are already beginning to dismantle the crumb.
- else:
    It is lonely here. No one else has found this yet.
}

// This choice only appears if DroppedFood is NOT in the pheromoned_locs list
+ { pheromoned_locs !? DroppedFood } [Lay a Pheromone Trail] 
    -> place_pheromone(DroppedFood)
    
+ [Go back to the kitchen island] 
    ~ant_path = -> ant_kitchen_island
    ~ target_loc = KitchenIsland

- -> main




=== ant_sink ===
 { pheromoned_locs ? Sink: 
 There is a spiraling wheel-like pattern of ants rotating in the sink. The placement of the pheromone has attracted many ants here, but when they enter divot of the sink, they get lost. The result is that all of the ants here crawl in cirlces, following each others' pheromone trails. This is called an "ant mill".
 - else:
 The sink is empty. 
 }
 + [Go to the Breadbox] You continue to the breadbox on the counter. 
 ~ant_path = -> ant_breadbox
 ~ target_loc = Breadbox
 + { pheromoned_locs !? Sink } [Lay a Pheromone Trail] 
    -> place_pheromone(Sink)
- -> main

=== ant_sandwich ===
 { 
 - sandwich_on_counter == 1 && pheromoned_locs ? Sandwich:
 There is a partially-eaten sandwich on the counter. Ants are swarming the sandwich turning it into an undulating black blob.
 - sandwich_on_counter == 1 && pheromoned_locs !? Sandwich:
 There is a partially-eaten sandwich on the counter. Looks tasty!
 - sandwich_on_counter == 0 && pheromoned_locs !? Sandwich:
 It is an empty countertop, just some crumbs lying around. 
 - else:
 Ants are picking at the crumbs dispered about the countertop. 
 
 } 
 + [Go to the Kitchen Island Hole] You follow along the edge of the island back to the base where you came from.  
 ~ant_path = -> ant_kitchen_island
 ~ target_loc = KitchenIsland
 + { pheromoned_locs !? Sandwich } [Lay a Pheromone Trail] 
    -> place_pheromone(Sandwich)
- -> main


 
 
 
 
 
=== human_start ===
You are a human and it's a normal Saturday. You woke up late and finally gained the energy to get up and eat a sandwich because your stomach was growling. You check the time and notice that its 10:45am. You say to yourself, "Wow I had a crazy night last night! Today is just going to be a normal, lazy day. There's no way it will be at all crazy like last night! Who am I talking to?"
    Where do you want to go first? I highly recommend going to the kitchen-living room divide first
+ [Go to the kitchen-living room divide] Your back kinda hurts and you want to finish your sandwich, but you manage to hobble over to the edge of the kitchen tiling
    ~human_path = -> human_kitchen_living
    ~target_loc_human = KitchenLiving
+ [Just please go to the kitchen-living room divide]
    ~human_path = -> human_kitchen_living
    ~target_loc_human = KitchenLiving
- -> main


=== human_kitchen_island ===
You are at the kitchen island.
{ pheromoned_locs ? Sandwich && sandwich_on_counter == 1:
"Wait is that my sandwich? What is that black stuff all over it? OMG those are ants!! DAMMIT GET OFF MY SANDWICH!!!!!"
You spray the insecticide on the kitchen island counter to get rid of the ants. Unfortunately, you cannot save your sandwich. So, you make another one, and take a couple of bites. "Mmm this sandwich is good." 
Great! Now the human can see the ants. He doesn't think anything of it though. The next goal is to get the human to gain interest in them and notice the things they do. He needs to be exposed to some education (maybe in the living room...), if he hasn't been already. Then, he needs to see something he will recognize, maybe in the sink...
 ~ recognition = 1
 ~ sandwich_on_counter = 0
 ~ pheromoned_locs -= Sandwich
 ~ insecticided_locs += Sandwich
}

+ {sandwich_on_counter == 1} [Pick up sandwich]
    "Man I'm hungry!"
    ~ sandwich_on_counter = 0
    -> main
+ {sandwich_on_counter == 0} [Put down sandwich]
    "Eating is too much work I just want to rot."
    ~ sandwich_on_counter = 1
    -> main
    
+ [Go to the kitchen-living room divide] "I guess I'll head back towards the living room"
    ~ human_path = -> human_kitchen_living
    ~target_loc_human = KitchenLiving
+ [Go to the sink] "I wonder if there is any food in the sink."
    ~ human_path = -> human_sink
    ~target_loc_human = Sink
+ [Spray Insecticide] You spray insecticide at this location
    ~ insecticided_locs += KitchenIsland
    {pheromoned_locs ? KitchenIsland:
    ~ pheromoned_locs -= KitchenIsland
    }
    ~ insecticide_timer = 4

 - -> main
 
 
=== human_oven ===
You are standing in front of the oven. There is no food here sorry. 
+ [Go to the breadbox] "I wonder if there is any food in the breadbox."
    ~ human_path = -> human_breadbox
    ~target_loc_human = Breadbox
+ [Go to the kitchen-living room divide] "I guess I'll head towards the living room."
    ~ human_path = -> human_kitchen_living
    ~target_loc_human = KitchenLiving
+ [Spray Insecticide] You spray insecticide at this location
    ~ insecticided_locs += OvenCountertop
    {pheromoned_locs ? OvenCountertop:
    ~ pheromoned_locs -= OvenCountertop
    }
    ~ insecticided_locs += Oven
    {pheromoned_locs ? Oven:
    ~ pheromoned_locs -= Oven
    }
    ~ insecticide_timer = 4
 - -> main
 === human_breadbox ===
In front of you is a breadbox.
+ [Go to the oven] "I wonder if there is any food in the oven."
    ~ human_path = -> human_oven
    ~target_loc_human = Oven
+ [Go to the sink] "I wonder if there is any food in the sink."
    ~ human_path = -> human_sink
    ~target_loc_human = Sink
+ [Spray Insecticide] You spray insecticide at this location
    ~ insecticided_locs += Breadbox
    {pheromoned_locs ? Breadbox:
    ~ pheromoned_locs -= Breadbox
    }
    ~ insecticide_timer = 4
 - -> main
 
  === human_sink ===
You are in front of the sink. There is no food here sorry. 
{ pheromoned_locs ? Sink && watched_tv == 1 && recognition == 1: 
"What?! Is that an antmill in my sink? Crazy! This is insane, I can't believe this is real. I wonder if there are more to these ants than I once thought..."
# IMAGE: images/anthill.jpeg
OK! The human now recognizes that the ants are more than just stupid, uninteresting bugs. However, he still doesn't appreciate that there might be more here... You need to use your pheromones to lead the ants into an unnatural pattern. I'm thinking a perfect square. Look at the map and try to figure out which locations will draw out a square.
Note: the ants will follow in a trail in between the all of the pheromoned locations. You need to use this fact to draw a square with the ants.
Further note: Make sure that these locations are the only ones pheromoned. If you pheromoned a prior location, think about how you might get rid of those pheromones...
Remember, you can always go to the queen in the anthill for a hint if you are stuck.
 ~ seen_antmill = 1
}
+ [Go to Breadbox] You move over to the breadbox. 
    ~ human_path = -> human_breadbox
    ~target_loc_human = Breadbox
+ [Go to Kitchen Island] You step over to the kitchen island. 
    ~ human_path = -> human_kitchen_island 
    ~target_loc_human = KitchenIsland
+ [Spray Insecticide] You spray insecticide at this location
    ~ insecticided_locs += Sink
    {pheromoned_locs ? Sink:
    ~ pheromoned_locs -= Sink
    }
    ~ insecticide_timer = 4
 - -> main
 === human_kitchen_living ===
{once: Ah yes, now you remember! This is where you sprayed the insecticide.} Here at the kitchen-living room divide there is a considerable amount of insecticide lining the edge of the tiles where you found an ant trail earlier. There is a can of insecticide and a spray wand sitting on the ground. 
 + [Pick up the insecticide (assuming you haven't done so already).] You pick up the insecticide. Now you can use it as you wish. Note that the insecticide only lasts so long, so after some time (3 human turns) it wears off.
    ~human_path = -> human_kitchen_living
 + [Go to the kitchen island] You go to the kitchen island, eyeballing the sandwich you still haven't finished. 
    ~human_path = -> human_kitchen_island
    ~target_loc_human = KitchenIsland
 + [Go to the living room] "I want to go lay on the couch."
    ~human_path = -> human_living_room
    ~target_loc_human = LivingRoom
 - -> main
 
=== human_living_room ===
You turn on the TV. What channel should you watch?
 + [National Geographic] You turn on National Geographic.
    ~human_path = -> human_nat_geo
 + [24/7 Family Guy] Really? You turn on 24/7 Family Guy becuase you really don't value your limited time on this planet. Thankfully, the channel returns static. Ugh! "I guess I have to watch Nat Geo, maybe it's Shark Week!"
    ~human_path = -> human_nat_geo
 + [Go back to the kitchen] You exert an amazing amount of effort and manage to get up off the couch after the third try.
    ~human_path = -> human_kitchen_living
    ~target_loc_human = KitchenLiving
+ [Spray Insecticide] You spray insecticide at this location.
    ~ insecticided_locs += LivingRoom
    {pheromoned_locs ? LivingRoom:
    ~ pheromoned_locs -= LivingRoom
    }
    ~ insecticide_timer = 4
 - -> main
 
 === human_nat_geo ===
The Nat Geo channel turns on. It's a nature documentary about ants! "Booooring" you say out loud, again to no one. Right at that moment, however, a clip appears showing ants forming an "ant mill". The show explains that an ant mill is a pheonomenon in which ants that have been serpated from their colony lose the pheromone track and follow one another, forming a continuously rotating circle. 
    "Hey that's actually pretty interesting", you say. "I wonder if you change the boundary conditions of the pheromones, you can get the ants to form other emergent patterns? How would I recognize this?" Eh I'm bored.
    ~ watched_tv = 1
    + [Go back to the kitchen] You exert an amazing amount of effort and manage to get up off the couch after the third try.
    ~human_path = -> human_kitchen_living
 - -> main
 
 
 


=== ending ===
The arrow points to the direction of the ant hill and the human can find it.
The Human finally recognizes that the any colony has become sentient. In his desire to preserve life and preserve future sandwiches, he leads the ant colony out to the back garden and feeds them every day! 
THE END
-> END
