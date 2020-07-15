# Godot-Ocean-Demo
An ocean demo in Godot 3.2, heavily based on https://github.com/SIsilicon/Godot-Ocean-Demo

For a project I'm developing, I was looking for a nice ocean wave generator. An important feature for my needs was being able to reproduce the waves in GDScript, to use the waveform on the game's physics engine.

This demo was a perfect starting point, but it still needed some make some changes. 

The original demo uses GLES 3.0, but the future of Godot seems to be on GLES 2.0 and Vulkan. Sadly, my main computer is a very good, but old laptop with a Sandy Bridge era i7 processor,and a NVidia GTX 460M graphic card, which being a Fermi-based architecture, has no Vulkan support.

So, I changed the target runtime to GLES 2.0 but... the shader used texelFetch() and other functions not available in GLES 2.0. Those functions where used to send different parameters to the shader as a single texture. To fix this, my first try was to replace texelFetch() with texture() or other variants, but I couldn't make it work (this is the first time I'm writing shader code). So, I ended using different variables to define amplitude, frequency, stepness, wind direction X and Y, and using multiple variables to have more waves. to avoid creating too much variables, data is packed on `vec4` uniforms (`Plane` in GDScript). Anyway, this means the original loop was unrolled by hand to extract data from different variables and components.

Another important target was to squeeze the maximum performance from the shader, after all, I need a lot of spare CPU and GPU power for the real game... Having an old graphic card made optimization a must-to-have thing! The unrolling described above brought a nice performance boost. Trying to simplify the code, I found an interesting fact: branching in the shader seems to have a big impact on performance. the original inner loop for waves was something like (changing all the `texelFech()` calls with a variable name for readability):

```glsl

if(amp == 0.0) continue;

dir = vec2(windX, windY);
steep = steepness /(w*amp);
phase = 2.0 * w;
float W = dot(w*dir, pos) + phase*time;
new_p.xz += steep*amp * dir * cos(W);
new_p.y += amp * sin(W);

```

As can be easily seen, the `steep` variable is calculated dividing by `amp`, this is why the guard `if (amp == 0.0) continue;` is needed. But the only usage of `steep` multiplies it right away by `amp`. So we can simplify to:

```glsl

vec2 dir = vec2(windX, windY);
float phase = 2.0 * w;
float W = dot(w*dir, pos) + phase*time;
r.xz = (steepness / w) * dir * cos(W);
r.y = amp * sin(W);

```

While the result may be a bit different on corner cases, in practice I can't see any real life different, but the frame rate is noticeable better.

One last optimization involves the normal calculation. The original algorithm calculates the wave position on four points around current position, and calculating the cross product between right-left and down-up vectors, we get the  normal vector. The idea here is using only three points to calculate the vectors, avoiding 1 every 4 expensive wave computation. Again, the result is not exactly the same, but the graphic effects doesn't seems to be affected.

Using a completely unscientific performance measuring method (disabling VSync and enabling printing FPS in Godot) I get these numbers:

| algorithm | GLSL | godot version | FPS |
| --------- | :---: | :----: | ---: |
| original  | 3.0 | 3.0.6 |  76 |
| original  | 3.0 | 3.2.2 |  81 |
| optimized | 2.0 | 3.2.2 | 324 |

GDScript code was also heavily affected, to handle setting the new uniforms for shader use, and to align the wave computation to the glsl implementation. Futhermore, all the code was typed as much as possible. Handing the sliders used to change parameters now use signals to update values instead of polling.

As a bonus, the floating object now follows the wave's shape, for a nicer looking floating effect.

Oh, and the floating object is now black!


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
