readme.md

Group 13!!!

PupMatch

App Overview

PupMatch is basically Tinder for dogs. Owners create a profile for their pup with photos and info like breed, age, and size, then swipe through other dogs nearby to find a good breeding match. When both owners swipe right, it's a match, and they can chat to set up a meetup. The app keeps things simple, with a clean interface where the dogs are the main focus.

App Evaluation

Category: Social / Lifestyle (Pets)
Mobile: It fits a phone perfectly. Owners use the camera to snap pics of their pup, location finds dogs nearby, and notifications let them know when they get a match or a message.
Story: Super easy to explain. It's Tinder, but for dogs looking for a breeding partner. Right now finding a match usually means scrolling Facebook groups or asking around, and this puts it all in one place.
Market: Dog owners and small breeders who want a compatible match for their pup. It's a niche audience, but a passionate one, and it could grow to other pets later.
Habit: Owners would keep coming back to check new dogs nearby, see their matches, and reply to messages.
Scope: The full Tinder experience is a lot, but the core (profiles, swiping, matching, and chat) is very doable with Firebase. Extras like filters and verification can come once the main stuff works.

App Spec

User Features
Required: Users can sign up, log in, and log out. They can create and edit a profile for their dog with photos, name, breed, age, sex, and size. On the home screen they see a stack of nearby dogs and swipe right to like or left to pass. When both owners like each other it's a match, and they can see all their matches in a list and chat with the other owner.
Optional: Filters by breed, age, and distance, push notifications for new matches and messages, a full profile view with more photos, undoing the last swipe, verification badges for breeders, uploading health and vaccination records, and unmatching or reporting a user.

Screens
Login / Sign Up: where users create an account or log in.
Create / Edit Profile: where users add or update their dog's photos and info.
Swipe (Home): the main screen with the stack of dog cards to swipe through.
Matches: a list of all the dogs you've matched with.
Chat: messaging with the owner of a matched dog.
Profile: shows your dog's profile, with options to edit it or log out.
Navigation Flows
Tab Navigation: Swipe (Home), Matches, and Profile.
Flow Navigation: New users go from Sign Up to Create Profile and then to the Swipe screen, while returning users go straight from Login to Swipe. When two dogs match on the Swipe screen, an "It's a Match!" popup shows up and can take you right to the Chat. From Matches, tapping a match opens the Chat, and the back button returns to Matches. From Profile, you can go to Edit Profile or log out back to the Login screen.

Wireframes
