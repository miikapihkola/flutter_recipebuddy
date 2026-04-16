Readme updated: 16.4.2026

# flutter_recipebuddy

A personal recipe and ingredient management app built with Flutter for Android.<br />
All data is stored locally on device — no accounts, no cloud, no internet required.

## Background for this app

This project was started during course "AL00CM27-3003 Mobiilisovelluskehitys".<br />
Course info: 
- Start date: 7.1.2026
- End date: 19.4.2026
- Ects: 5

Development team: Just me.<br />
Example code: This does not base on any particular example code.<br />
Idea: Idea was purely my own and rose up from personal need for this kind of app.<br /><br />

Project development will continue even after this course.

## Project Status

This project is still work in progress, but at it's current state it could be considered as early prototype/ proof of concept.<br />
Development will be slowed down now since the course that made me start this project has ended.

### Plans for future

Eventually when this is ready i plan to publish this in google play store.

## Features

- **Recipes** — Create and manage recipes
- **Starring** — Star ingredients for quick access
- **Ingredients** — Track your ingredients with current amounts, units, and expiry dates
- **Shopping List** — Add ingredients to a shopping list directly from recipes
- **Ingredient Groups** — Organise recipe ingredients into named groups with optional flags
- **Categories** — Organise recipes and ingredients with custom main and sub categories
- **Notifications** — Ingredients are about to expire
- **Filtering** — Filter recipes and ingredients by category, type and more

### Upcoming feature

- **Recipes** — Create and manage Food, Cocktail, and Ferment recipes with type-specific fields
- **Cook Steps** — Add step-by-step instructions with duration and type to your recipes
- **Pinning & Starring** — Pin or star recipes for quick access
- **Notifications** — Get notified when ferments are ready or ingredients are about to expire
- **Filtering** — More filtering options
- **Export** — Export recipes and share the with your friends

### Other features

- **Asks permissions** — Asks permissions to RECEIVE_BOOT_COMPLETED and POST_NOTIFICATIONS, these are needed by notification system.
- **Phone rotation** — Phone rotation is locked to vertical while using the app.

## Used Packages
- intl
- provider
- sqflite
- path
- shared_preferences
- flutter_local_notifications
- timezone

## Views
- **main_view.dart** — Main menu for navigation using buttons.
- **settings_view.dart** — Used to set settings to sharedpreferences, also if in debug mode adds some debug buttons.
- **ingredients_view.dart** — Displays a list of ingredients (and their info) that can be filtered. Also cards have some function buttons.
- **input_ingredient_view.dart** — Form to add/edit ingredients, also contains delete button if editing, delete will cascade if ingredient is used in recipes.
- **input_ingredient_toshoppinglist_view.dart** — For quick adding ingredient to shoppinglist.
- **shoppinglist_view.dart** — Shows ingredients in shoppinglist, contains resolve shopping button to update_amounts_view for each ingredient.
- **input_ingredient_update_amounts_view.dart** — Handles addition and substraction to/from ingredient, gives calculated suggestion for new value at start.
- **recipes_view.dart** — Shows list of recipes (and some of their info) that can be filtered. Also cards have some function buttons.
- **input_recipe_view.dart** — Form to add/edit recipes, also contains delete button if editing.
- **single_recipe_view.dart** — View all info of single recipe, ingredients (in ingredient groups) have quick action for adding to shoppinglist and consuming from inventory.
- **pinned_view.dart** — Contains placeholder, will be implemented in future

## Getting Started

### Prerequisites

- Flutter SDK
- Android device or emulator (API 21+)

### Run

bash
```
flutter pub get
flutter run
```

### Build APK

bash
```
flutter build apk --release
```

## Data & Privacy

All data is stored locally on your device using SQLite via sqflite.<br />
App settings and preferences are persisted using shared_preferences.<br />
No data is ever sent to any server or third party.

## A.I Usage

I'v used Claude Sonnet to help and speed up development, most prominently i'v used it to debug crashes, warnings and bugs,<br />
but i'v also used it occasionally on following:
- Tough to implement components
- Manual labor (like mapping)
- Crude layout for some cards & views (that i manually edited to fit better and hooked to features)
- Base for this readme file (that i heavily edited)

I always reviewed A.I. generated code, before implementing it.

## License

CC BY-NC-SA
