Contributions:
Joseph Bourque (40%)
• Expanded REST API
  - AddIngredient, AddRecipe, AddRecipeDirection, AddRecipeIngredient, AddRecipeVitamin, AddUser, AddUserBList, GetIngredient, GetRecipeDirections, GetRecipeIngredients, GetRecipeVitamins, PwordReset, RemoveRecipe, RemoveRecipeDirection, RemoveRecipeIngredient, RemoveRecipeVitamin, RemoveUserBList, UpdateRecipe, UpdateRecipeDirection, UPdateRecipeIngredient, UpdateRecipeVitamin, UpdateUser, VerifyUser
  - Everything is sanitized
  - Passwords are hashed, salted, and encrypted
• Added full functionality to splash screen
  - Splash screen animation continues until a successful connection to database is established
  - If connection cannot be established an alert pops up after 15 seconds asking the user to either retry or gives the option to quit
  - After connection is established, app automatically segues to login screen
• Added Full Functionality to login screen
  - Username and password is checked against database and if there is no match an alert informs user
  - Forgot password allows user to enter their username in order to send an email to the address they have registered as well as creates a new randomly generated password
  - Sign up screen brings user to AddUser page
•  Added Full Functionality to User Signup/Profile page
  - Required fields display a red border if not filled in upon submission
  - 3 different modes for this screen; each display differently
    > Add - Everything open for editing; nothing pre-populated; preferences dispay as table view
    > Edit - Everything except username open for editing; everything pre-populated; preferences display as table view
    > View - Nothing open for editing; password hidden; preferences display as txtBox vs table view
  - Upon form submission, user is added to database and brought to the home screen
• Created A color picker
  - Support R/G/B component entry, color sliders, or hex value entry.
  - Everything updates when any UI component is updated
  - Button shows selected color
• Created popovers for forgotPassword, and entering photo URL
  - both display alerts in the case of errors
• Created User and Photo classes to help interact with the database safely

Pablo Velasco (30%)
• Created New Screens
  - Removed redundancy in screen displays. Replaced multiple screens with a label in the NewItemList screen
  - Implemented navigation and run-time (non-database) adding and displaying of Pantry/Shopping List items, as well as Meals/Favorites
• App-Wide Color Settings
  - Allowed users to set up a color scheme for their navigation bars and app font colors. Works through app reboot
• Add Recipe Page One/Two
  - Created screen functionality for both Add Recipe Pages One and Two
  - Recipe information stored and passed through both screens to be stored in the database
  - Popovers for each of these screens
  
Yen Chen Wee (30%)
• 
  - 


Deviations:
• Shopping/Pantry List, and Meals is ahead of schedule. Some of the functionality such as creating and displaying is currently there, but this is non-database connected (built by users during run-time).
