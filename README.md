# Ondemand(od): Faust's new reactive primitive

### What does the new ondemand primitive offer/solve?

The ondemand (od) primitive presents us with a way of triggering certain computations/functions with a clock stream. Previously, Faust had no means of distinguishing which computations to process, and thus computed them all, regardless of the program output. Computations that did not reach/affect the output signal were by default simply multiplied by zero. However, with the new ondemand primitive, computation blocks can now be paired with a binary clock stream that acts as a computation trigger. Depending on the trigger clock stream, the resulting computation is downsampled, computed only at the trigger points, and then upsampled once again. Indeed, formally, supposing that a computation block takes in $n$ signals and outputs $m$ signals, an ondemand iteration would take $n+1$ inputs (adding the clock stream), wihle still returning $m$ signals. 

Consider the following example - suppose we implement an integrator operator (`+~_`) in Faust.

![integrator](integrator.png)

We can construct a table visualizing how the ondemand operator works with a clock stream to down sample and then upsample the integrator output.

| sample 	| clock 	| downsampled (in) 	| downsampled (out) 	| upsampled 	|
|--------	|-------	|------------------	|-------------------	|-----------	|
| 1      	| 0     	|                  	|                   	| 0         	|
| 2      	| 0     	|                  	|                   	| 0         	|
| 3      	| 1     	| 3                	| 3                 	| 3         	|
| 4      	| 1     	| 4                	| 7                 	| 7         	|
| 5      	| 1     	| 5                	| 12                	| 12        	|
| 6      	| 0     	|                  	|                   	| 12        	|

In the table above, the clock is a binary stream that triggers on demand computation. The integrator thus only computes for the samples that have been triggered, before the result is then upsampled in a constant way.


### Formalization of the ondemand primitive

[[source]](https://github.com/orlarey/faust-ondemand-spec/blob/newmaster/spec.pdf) The vast majority of Faust primitives, like $+$, are operations on *signals*. The $\mathtt{ondemand}$ primitive is very different. It is an operation on *signal processors* of type $\mathbb{P}\rightarrow\mathbb{P}$. It transforms a signal processor $P$ into an ondemand version. 

If $P$ has $n$ inputs and $m$ outputs, then `ondemand`$(P)$ has $n+1$ inputs and $m$ outputs. The additional input of `ondemand`$(P)$ is a clock signal $h$ that indicates by a $1$ when there is a computation demand, and by $0$ otherwise. In other words, $h(t)=1$ means that there is a computation demand at time $t$.

$$
\frac{P:n\rightarrow m}{\mathtt{ondemand}(P):1+n\rightarrow m}
$$

From a clock signal $h$ we can derive a signal $h*$ that indicates the time of each demand. For example if $h=1,0,0,1,0,0,0,1,0\ldots$ then $h* =0,3,7,\ldots$ indicating that the first demand is at time $0$, the second one at time $3$, the third one at time $7$, etc. In other words, $h*$ translates internal time (time inside `ondemand`$(P)$ ) into external time (time outside `ondemand`$(P)$ ). We have 

$$
\begin{split}
h*(0) &= \min \{t'|(h(t')=1)\} \\
h*(t) &= \min \{t'|(h(t')=1), (t'>h^*(t-1))\}
\end{split}
$$

We also derive another signal $h^+$ that _counts_ the number of demands:

$$
h^+(t) = \left(\sum_{i=0}^t h(i)\right)-1
$$

For the same $h=1,0,0,1,0,0,0,1,0\ldots$ we have $h^{+}=0,0,0,1,1,1,1,2,2,\ldots$. Here $h^{+}$ translates external time (time outside `ondemand`$(P)$ ) into internal time (time inside `ondemand`$(P)$ ).


### How does ondemand present us with reactive paradigms that don't already exist (i.e. sliders, buttons, osc, etc...)?

The ondemand primitive is not a "user-facing" feature, in that it does not add a layer of interactivity with the user. The ondemand primitive is also not directly a compositional tool, in that it is not intended for temporal segmentation of composition. Rather, what ondemand excels at providing is granularity for optimized computation, which could be critical for embedded systems and microprocessors. Indeed, the purpose of the clock stream is not to send a message in a traditional sense, as is the case with sliders osc messages, and the like. Rather, the clock boolean stream acts strictly as a computation trigger.

### How do functions with ondemand primitives compose in sequence/parallel/recursively?

Indeed, the introduction of the ondemand primitive raises questions regarding its integration with other operations. Having said this, the behavior of two ondemand computations in parallel and/or sequence is fairly straightforward. As the ondemand primitve upsamples its results back up, effectively, the primitive has no bearing on sequential or parallel computations, other than the fact that the produced results will by nature be less granular.

There is however the question of composing two ondemand primitives to one computation. 


### Does the ondemand primitive bring Faust closer to modelling functional reactive paradigms? What about arrow diagrams?

### Does Faust operate in discreet or continuous time?
