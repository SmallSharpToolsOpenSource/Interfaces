Side Bar
----------------

A sample project to create a Side Bar navigation system with a Storyboard and autolayout.
This side bar features a bounce effect which is what seems to be missing from most side bar
implementations since the UIScrollView has a bounce effect.

List View
----------------

Sample project which uses a UICollectionView with a horizontal flow layout to implement
what is often done by rotating a UITableView to achieve horizontal scrolling. Using
UICollectionView is surprisingly easy.

Paging Dogs
----------------

The initial launch sequence for some apps features a series of screens which can be paged
through to give the user a quick introduction to what the app does and how it should be
used. This sample project shows how that series of screens can be implemented.

Status View
----------------

Showing the status with a UIAlertView can be a big jarring and it typically requires the
user to tap a button to dismiss it. This status view appears at the top momentarily so 
the user can see the status without being required to dismiss it. It supports rotation
by ensuring it's position is set in response to rotation events.

Multiple Storyboards
----------------

A sample project to show how to segment a project with multiple storyboards. Sometimes
when a project has lots of screens and multiple people are working on the project it
is best to separate the application into sections so developers can work with separate
storyboard documents and avoid having to merge changes, which can be a challenge with
these types of documents which are not as trivial to merge as source files can be.

Flying Modals
----------------

The basic modal which either slides up from the bottom or flips into view is a bit 
dated now and more interesting modals can be done with features introduced in iOS 5.
A couple of examples are implemented in this sample project.

Stacks
----------------

Using Autolayout and constraints to stack a series of views can be a challenge so this
sample project shows how it is done. Normally this would be done with a UITableView but
sometimes these views are meant to be static and not scroll with user interaction at
all. This sample project is an implementationw which attaches constraints to line up
a series of views as a stack of views.

TextAllTheThings
----------------

An experiment to add links and other details to text fields.

Growing Image View
----------------

Base class to allow an UIImageView to fill the screen with a larger image with a simple
tap gesture.

Unwinding
----------------

Programmatically perform an unwind segue without setting it up in a storyboard.

License: BSD  

------

Brennan Stehling  
[SmallSharpTools](http://www.smallsharptools.com/)  
[@smallsharptools](https://alpha.app.net/smallsharptools) (App.net)  
[@smallsharptools](https://twitter.com/smallsharptools) (Twitter)  
