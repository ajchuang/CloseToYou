jh3478

=======================
Quick Info
=======================

The attached program is a venue search program with the following features.

1. The software follows the MCV principle strictly. All the related data are put into a warehouse, and data accesses are all through the warehouse interfaces. It's clean in design and implementation.

2. The App supports map annotation. The user query results will be put on the map elegantly. Besides, the map will perform auto-scale. That is, all the queries will be places in the map.

3. Touch the annotation, and a detailed view will be displayed. The detailed view is capable to read the google image or icon to show you more about the venue information.

4. Finally, the UI is clean and well-designed. You will focus on the logical flow without any intervention.

=======================
File Highlights (most of the code is here)
=======================

1. MainModel - the data model used throughout the app. (a typical singleton)
2. ViewController - the view controller for the user search
3. MapViewController - the map view controller, manage the location manager, and put the pins
4. DetailViewController - the detail view used to display info in the google results.
5. storyboard
6. images


=======================
Known Bugs
=======================

1. The close-to-you cover image is copied from the famous Carpenters'  album. If it's not allowed in the assignment, please inform me.

2. i did not handle the zero result case elegantly. In this case, the user will only get no pins in the map, and he has no choice but return to the search view.

=======================
Lessons Learned
=======================

- Learning new language should start earlier.
- Design good UI is difficult.
- Xcode is, hmm, not very friendly.


