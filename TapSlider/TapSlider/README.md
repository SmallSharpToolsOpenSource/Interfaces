TapSlider
=========

The UISlider for iOS does not respond to tap and pan gestures outside of the thumb control. On OS X and other systems a user can tap anywhere on a slider and have the thumb control jump to that position. Having to precisely get your ifinger onto the thumb control on iOS is sometimes difficult to do. After a few failed attempts is becomes frustrating especially if there are multiple sliders that must be adjusted.

This sample projects shows how the UISlider can be adjusted easily by attaching tap and pan gestures to restore the expected interactions.

## Usage

Place a UISlider on a Storyboard and set the custom class to `SSTTapSlider` in the Identity Inspector. When the slider is initialized the tap and pan gesture recognizers will be attached to added the custom behavior.

## License

MIT

## Contact

Brennan Stehling  
[SmallSharpTools](http://www.smallsharptools.com/)  
[@smallsharptools](https://twitter.com/smallsharptools) (Twitter)  

