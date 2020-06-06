# Godot-Ocean-Demo
An ocean demo in Godot 3.2, heavily based on https://github.com/SIsilicon/Godot-Ocean-Demo

I have updated the Godot version to 3.2.1, and switched to GLES2 backend, as Godot is moving to GLES2 + Vulkan in the near future, deprecating the GLES3 backend.

As I was unable to make texture lookups work (to replace the GLES3-only texelFetch), I have vec4 uniforms for amplitude, frequency ecc. a single vec4 can contain (surprise!) four variables, a set of three variables are defined. So calculation of waves was completely reorganized.

The GDScript code handling parameters now use events, and also updating shader parameters was simplified.

As a bonus, now the floating mesh follows the ocean's wave shape.

## How to customize the ocean
The ocean demo uses what's known as Gerstner waves. A constant collection of them is used to create that *wavy* feel of the waters. It also uses a lil bit of noise to really sell the effect. Both of these features are customizable with almost self-explanatory parameters.

### Main wave parameters

-**Amplitude** defines how high your waves will be.

-**Wavelength** defines how long your waves will be.

-**Steepness** defines how 'choppy' your waves will be. Don't set this too high or else your waves will start self-intersecting.

-**Wind Direction** controls the direction the overall waves would go.

-**Wind Align** also determines each wave's individual direction. A value of *one* means they all go in the exact same direction. A value of *zero* means waves go in completely random directions.

-**Speed** controls how fast the waves propagates.

### Noise parameters

-**Noise Amp** controls how high the noise looks.

-**Noise Freq** controls the smoothness/granularity of the noise. Higher values make it smoother and less granular.

-**Noise Speed** controls how fast the waves propagate.

## First Person Control

When running the project(sorry if it's slow to load. I'm looking into that.) You can fly around. Look at your ocean from every angle. And you can do so like this.

-Use your **mouse** to look around.

-**W key** go forward.

-**S key** go backward.

-**A key** go left.

-**D key** go right.

-**Q key** toggle between fly and edit mode. You cant play with the ocean parameters and fly at the same time.

# Credits

Code havily based on Roujel Williams code (https://github.com/SIsilicon/Godot-Ocean-Demo)

The flying code is from Jeremy Bullock's youtube tutorial series on first person control.
