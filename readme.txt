jh3478

=======================
Quick Info
=======================

The attached program is a venue search program with the following features.
1. The software complies all the mandatory requirements inlcuding item 1 and item 2. For item 1, I choose to use a two-level tabviewcontroller. This design makes sense because the user should first do the search and choose the output form. The UI logic is consistent with the user operation logic. In the first tab, a user can choose the bookmark or search. If the bookmark is empty, the user will be automatically switched to the search view when he/she tries to work with the empty bookmark. The bookmark supports iOS generic delete operations. One can swipe the item (right to left) to delete the item. The delete operation is also synchronized with the CoreData database. All changes will be done on the fly. As for the CoreData requirements, the user can add a certain site to the bookmark by using the "STAR" button in the detail view. One can also check the bookmark output in the bookmark tab.

2. The google place API implementation is also completed (Part 4). I encapsulate the google api operations just like the one we used. For coding details, you can check SofAMyMapManager. Besides, all the other minor requirements in the section are also done. You can cancel the search before it's done. The major trick is that we make use a different thread to handle the UI and the network requests. However, the user should need to wait till the previous operation is done to perform a new search. This is due to the nature that we can not actually detele an existing running search. (Well, yes you can, but it's jsut to brutal to do so.)  

3. I tried my best to handle corner cases. Most corner cases will be alerted by a UIAlertView. Maybe I miss some, but probably not easy to find or reproduce.

=======================
File Highlights (most of the code is here)
=======================

Old files--
1. MainModel - the data model used throughout the app. (a typical singleton)
2. ViewController - the view controller for the user search
3. MapViewController - the map view controller, manage the location manager, and put the pins
4. DetailViewController - the detail view used to display info in the google results.
5. storyboard
6. images

New files--
1. SofAMyMapManager - the Google Place API handler (reference: http://www.raywenderlich.com/13160/using-the-google-places-api-with-mapkit)
2. SofABookmarkViewController - the view controller for the bookmark view.
3. data model - for the CoreData 
4. Some new icons

=======================
Known Bugs
=======================

1. The close-to-you cover image is copied from the famous Carpenters'  album. If it's not allowed in the assignment, please inform me.
2. The table view will shift after accessing the detail view. I think this is caused by the mix use of tabviewcontroller and navifation controller. Till the moment I submit, I can not find any elegant solution to this. So, it's not a functional bug, but not very good-looking @ UI.

=======================
Lessons Learned
=======================

- Design good UI is difficult.
- Xcode is, hmm, not very friendly.

