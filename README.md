# ondemand(od): Faust's new reactive primitive

### Does FAUST operate in discreet or continuous time?

### What does the new ondemand primitive offer/solve?

The ondemand (od) primitive presents us with a way of triggering certain computations/functions with a clock stream. Previously, Faust had no means of distinguishing which computations to process, and thus computed them all, regardless of the program output. Computations that did not reach/affect the output signal were by default simply multiplied by zero. However, with the new ondemand primitive, computation blocks can now be paired with a binary clock stream that acts as a computation trigger. Depending on the trigger clock stream, the resulting computation is downsampled, computed, and then upsampled once again. 

Consider the following example - suppose we implement an integrator operator in Faust.

![](integrator.png)

<img src="integrator.jpg" alt="integrator" width="200"/>

### How is ondemand implemented under the hood?

### How does ondemand present us with reactive paradigms that don't already exist (i.e. sliders, buttons, osc, etc...)?

Avoids unecessary computation.

### How do functions with ondemand primitives compose in sequence/parallel/recursion?

### Are there any specific ondemand operators to consider?

ox

### Does the ondemand primitive bring Faust closer to modelling functional reactive paradigms? What about arrow diagrams?
