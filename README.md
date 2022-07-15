# Game of Thrones app

* It's a simple App that fetches a list of categories and stores it inside the app's file system. After the fetching process has been done a list of categories will be presented using **UITableView** and if the user selects one of the presented categories it will fetch the information of that category and display it on another page.
 
 * I sperated the app into two test targets one for main **Unit Tests** and the other for **End to End Tests** multi targets to make the  
 
## App Architecture :

* I've tried to apply clean architecture in all my modules. you can run the test by clicking ⌘ + U.
* Applied MVVM Design pattern inside the presentation layer.
* I've tried to decouple all my modules using protocols, so you can find that I hide the implementation details by using protocols.
* For caching I used **File System** to store the categories I know we can use **UserDefault** to store because it's simple data just an array of Strings, so I made my solution replaceable so you can replace it by using any kind of persistent.
