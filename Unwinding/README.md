Unwinding
=========

A sample project to programmatically perform an unwind segue.

The base class `SSTBaseViewController` provides an option to perform an unwind segue by providing a selector and identifier. See `performUnwindSegueWithIdentifier:action:` in `SSTBaseViewController` for details.

### Why unwind programmatically?

Setting up unwind segues in Xcode with a Storyboard requires an outlet to be set before the segue appears where an identifier can be set. I expect this is either done due a limitation of where Xcode is currently as as IDE or it was by design to prevent unwinds from being attempted where it is not valid. Since a `UIViewController` has the method `canPerformUnwindSegueAction:fromViewController:withSender:` it can check if a view controller can perform an unwind segue. All that needs to be done is traverse up the view controller hiearchy to find a view controller which can perform the requested unwind segue action. The trick seems to be what to do to perform the unwind segue once it identifies the destination view controller. Either the source view controller was pushed or presented and will need to be popped or dismissed accordingly. And if the hierarchy includes a navigation controller and presents a modal at some point it will be necessary to dismiss and pop accordingly. The included code in the base view controller handles these steps, at least for the scenarios set up in the storyboard.

The Storyboard included in this project includes a Navigation Controller stack along with a couple of modals. One is a basic modal scenario while another is under the navigation controller which requires the modal to be dismissed before the navigation controller can be popped. More scenarios are possible which may not be handled when performing the segue.

License: BSD  

------

Brennan Stehling  
[SmallSharpTools](http://www.smallsharptools.com/)  
[@smallsharptools](https://alpha.app.net/smallsharptools) (App.net)  
[@smallsharptools](https://twitter.com/smallsharptools) (Twitter)  
