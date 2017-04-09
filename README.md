# Soccerify
The iOS app, Soccerify, features different soccer leagues, tournaments, events. 
It allows soccer audiences to check out each match in terms of its result, match date and time, location and especially the preliminary analysis breakdown for different types of matches 
(90-regular, extra-time needed and penalty needed matches)

## Note
This current version have focused only Euro 2016 - the latest worldwide soccer event, and so far, data in the app is only able to scale to the knock-out stage, including rounds of 16, quarter, semi-final and the only final.

## Brief demo
The app currently has 4 view controllers: 
+ The first on-screen one (home view controller) is the table view, which is to present the match's data in terms of its 90-minute regular result, match date and time, location (stadium and city). 
The home view has its left view controller child with its functionality to filter out the match based on each round of the knock-out stage. 
+ There is a tab view controller, in my design choice, acting as a master view which should transition to 2 view controllers- the final result break down one, and the stadium lookup one. 
The final result break down view controller is supposed to carry out a set of these sub tasks:


### Match analysis breakdown  
_ A form of table view controller, designed for its match analysis model. Then, I removed the view of the table view controller, and along with presenting this match analysis data in the view,
I also embedded the web view.

### Stadium map
_ A view controller which could be the navigation of the stadium name embedded in the green button in the home view controller, displayed in 3 different settings: standard , satellite, hybrid.

