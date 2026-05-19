#import "/style.typ": aside, note, note-ref, theme
#import "@preview/booktabs:0.0.4": *

#set document(title: "ELEC0129")

#show: theme
#show: booktabs-default-table-style


#title()

= Intro
== Basic Notation

_Position vector_ (point): $P = vec(P_x, P_y, P_z)$.\
Names are attached as a subscript: $P_"home"$.

_Frame_: ${dot}$, #" "$dot$ is uppercase/numeric name.\
"_Base_ frame" (of a robot) is conventionally ${0}$.

Position vector in frame ${"ref"}$: $attach(P, tl: "ref")$.

_Origin_ of frame ${X}$: $P_(X_"org")$.

_Rotation matrix_ of ${B}$ wrt. ${A}$: $attach(R, tl: A, bl: B)$.

_Homogeneous transform matrix_ of ${B}$ wrt. ${A}$: $attach(T, tl: A, bl: B)$.

== Transformations

Note that while $attach(R, tl: A, bl: B)$ "measures" ${B}$'s rotation in ${A}$ ($attach(R, tl: A, bl: B) hat(X)_A = hat(X)_B$), when applied as a transformation (on position vectors), the "direction" is reversed, producing a ${B}$-to-${A}$ frame substitution ($attach(P, tl: A) = attach(R, tl: A, bl: B) attach(P, tl: B)$). \
The same goes for other transforms, e.g., homogeneous transforms $T$.

#quote(block: true)[
  For frames ${A}$ and ${B}$:\
  if they differ only by a *rotation*,
  then $attach(P, tl: A) = attach(R, tl: A, bl: B) attach(P, tl: B)$;\
  if they differ only by a *translation*,
  then $attach(P, tl: A) = attach(P, tl: B) + attach(P, tl: A, br: B_"org")$
  #"  " (where $attach(P, tl: A, br: B_"org") = P_(B_"org") - P_(A_"org")$);\
  otherwise if *both*, then $attach(P, tl: A) = attach(T, tl: A, bl: B) attach(P, tl: B)$.
]

=== Rotations

Remember to use the right-hand corkscrew rule to figure which way is the positive angle.

==== Matrix Repr.

The rotation of ${B}$ wrt. ${A}$ can be represented as a $3 times 3$ matrix:
$
  attach(R, tl: A, bl: B) = mat(
    hat(X)_B dot hat(X)_A, hat(Y)_B dot hat(X)_A, hat(Z)_B dot hat(X)_A;
    hat(X)_B dot hat(Y)_A, hat(Y)_B dot hat(Y)_A, hat(Z)_B dot hat(Y)_A;
    hat(X)_B dot hat(Z)_A, hat(Y)_B dot hat(Z)_A, hat(Z)_B dot hat(Z)_A;
  )
$
where $hat(X), hat(Y), hat(Z)$ are the orthonormal basis vectors of a frame.

Rotations about a given axis by $theta$:

$R_X = mat(1, 0, 0; 0, cos(theta), -sin(theta); 0, sin(theta), cos(theta);)$

$R_Y = mat(cos(theta), 0, sin(theta); 0, 1, 0; -sin(theta), 0, cos(theta);)$

$R_Z = mat(cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0; 0, 0, 1;)$

Rotation matrices are orthogonal: $attach(R, tl: B, bl: A) = attach(R, tl: A, bl: B)^(-1) = attach(R, tl: A, bl: B)^T$.

==== Roll-pitch-yaw Repr.

Aka. fixed-angle representation.

#aside[
  Three rotations about a fixed set of axes (e.g. the base frame's). \
  Modern terminology calls this _extrinsic_ Euler angles.
]

For XYZ $->$ $alpha$ $beta$ $gamma$:

$R = R_Z (alpha) R_Y (beta) R_X (gamma)$

$
  R = mat(
    cos alpha cos beta, cos alpha sin beta sin gamma - sin alpha cos gamma, cos alpha sin beta cos gamma + sin alpha sin gamma;
    sin alpha cos beta, sin alpha sin beta sin gamma + cos alpha cos gamma, sin alpha sin beta cos gamma - cos alpha sin gamma;
    -sin beta, cos beta sin gamma, cos beta cos gamma;
  )
$

Useful inverses:

#let atan2 = math.op("atan2")
$beta = atan2(-r_31, sqrt(r_11^2 + r_21^2)) \
alpha = atan2(r_21 / (cos beta), r_11 / (cos beta)) \
gamma = atan2(r_32 / (cos beta), r_33 / (cos beta))$

Singularity when $cos beta = 0 <==> beta = (n + 1/2) pi$

==== Euler Angles Repr.

#aside[
  Three rotations about a moving set of axes (that attach to the rotating object). \
  Modern terminology calls this _intrinsic_ Euler angles.
]

Note that extrinsic and intrinsic Euler angles are equivalent via a reversal of axis order; \
For ZYX $->$ $alpha$ $beta$ $gamma$:

$R = R_Z (alpha) R_Y (beta) R_X (gamma)$

As this is identical to the roll-pitch-yaw representation, the same formula applies, but with the angles pertaining to different axes.

==== Angle-Axis Repr.

Aka. Axis-Angle representation.

Rotation is described by a vector + a scalar: \
an axis of rotation $k$ and an angle of rotation $theta$ about that axis.

$k = vec(k_x, k_y, k_z)$

Invariant: $norm(k) = 1$.

Problems:
- 0-vector is ambiguous: the axis becomes undefined.
- 0-degree rotations are problematic: they result in a 0-vector.

#let siv = math.op("siv")
$
  R = mat(
    k_x^2 siv theta + cos theta, k_x k_y siv theta - k_z sin theta, k_x k_z siv theta + k_y sin theta;
    k_y k_x siv theta + k_z sin theta, k_y^2 siv theta + cos theta, k_y k_z siv theta - k_x sin theta;
    k_z k_x siv theta - k_y sin theta, k_z k_y siv theta + k_x sin theta, k_z^2 siv theta + cos theta;
  )
$

where $siv(theta) = 1 - cos theta$.

Useful inverses:

$theta = arccos(1/2 (r_11 + r_22 + r_33 - 1)) \
k = 1 / (2 sin theta) vec(r_32 - r_23, r_13 - r_31, r_21 - r_12)$

Singularity when $sin theta = 0 <==> theta = n pi$.

==== Euler Parameters Repr.

We can avoid singularities of three-parameter representations by, well, using four parameters.

For a rotation with axis represented by a unit vector $k$ and angle $theta$, its four Euler parameters are:

$epsilon_1 = k_x sin theta/2$ \
$epsilon_2 = k_y sin theta/2$ \
$epsilon_3 = k_z sin theta/2$ \
$epsilon_4 = cos theta/2$

Invariant: $epsilon_1^2 + epsilon_2^2 + epsilon_3^2 + epsilon_4^2 = 1$.

$
  R = mat(
    1 - 2 (epsilon_2^2 + epsilon_3^2), 2 (epsilon_1 epsilon_2 - epsilon_3 epsilon_4), 2 (epsilon_1 epsilon_3 + epsilon_2 epsilon_4);
    2 (epsilon_1 epsilon_2 + epsilon_3 epsilon_4), 1 - 2 (epsilon_1^2 + epsilon_3^2), 2 (epsilon_2 epsilon_3 - epsilon_1 epsilon_4);
    2 (epsilon_1 epsilon_3 - epsilon_2 epsilon_4), 2 (epsilon_2 epsilon_3 + epsilon_1 epsilon_4), 1 - 2 (epsilon_1^2 + epsilon_2^2);
  )
$

Useful inverses:

$epsilon_4 = 1/2 sqrt(1 + r_11 + r_22 + r_33) \
epsilon_1 = 1/2 sqrt(1 + r_11 - r_22 - r_33) \
epsilon_2 = 1/2 sqrt(1 - r_11 + r_22 - r_33) \
epsilon_3 = 1/2 sqrt(1 - r_11 - r_22 + r_33)$

... shortcut if $epsilon_4 != 0$:

$epsilon_1 = (r_32 - r_23) / (4 epsilon_4) \
epsilon_2 = (r_13 - r_31) / (4 epsilon_4) \
epsilon_3 = (r_21 - r_12) / (4 epsilon_4)$

No singularities by construction.

=== Translations

Translations can be represented by vector-vector addition; no matrices are needed.

=== Homogeneous Transforms

Essentially, a combination of rotations and translations.
Can be used to represent any "movement" of a frame or rigid body (or a point, but they do not have an orientation).

$attach(P, tl: A) = attach(R, tl: A, bl: B) attach(P, tl: B) + attach(P, tl: A, br: B_"org")$ \
"P in frame A = P in frame B, first rotated by B's orientation in A, then translated by B's origin's offset in frame A"

This can be represented as a $4 times 4$ _homogeneous transform_ matrix:
$
  mat(
    augment: #(hline: 3),
    ;
    attach(P, tl: A);
    ;
    1;
  ) = mat(
    augment: #(hline: 3, vline: 3),
    , , , ;
    , #box(height: 0em, baseline: -0.7em, $attach(R, tl: A, bl: B)$), , #box(height: 0em, baseline: -0.7em, $attach(P, tl: A, br: B_"org")$)
    ;
    , , , ;
    0, 0, 0, 1;
  )
  mat(
    augment: #(hline: 3),
    ;
    attach(P, tl: B);
    ;
    1;
  )
$

By a slight abuse of notation, this is symbolically written as $attach(P, tl: A) = attach(T, tl: A, bl: B) attach(P, tl: B)$.

The homogeneous transform matrix is invertible.
Multiple homogeneous transforms can be trivially converted to a single transform by computing the product of their respective matrices.

Because the rotation matrix is #link("https://en.wikipedia.org/wiki/Orthogonal_matrix")[orthogonal], these transformation matrices are relatively easy to invert:
$
  attach(T, tl: A, bl: B)^(-1) =
  mat(
    augment: #(hline: 3, vline: 3),
    , , , ;
    , #box(height: 0em, baseline: -0.7em, $attach(R, tl: A, bl: B)$), , #box(height: 0em, baseline: -0.7em, $attach(P, tl: A, br: B_"org")$)
    ;
    , , , ;
    0, 0, 0, 1;
  )^(-1)
  =
  mat(
    augment: #(hline: 3, vline: 3),
    , , , ;
    , #box(height: 0em, baseline: -0.7em, $attach(R, tl: A, bl: B)^T$), , #box(height: 0em, baseline: -0.7em, $attach(R, tl: A, bl: B)^T attach(P, tl: A, br: B_"org")$)
    ;
    , , , ;
    0, 0, 0, 1;
  )
  = attach(T, tl: B, bl: A)
$


#pagebreak()
= Terminology and Concepts

== Joints

_Revolute_: rotation about an axis.

_Prismatic_: translation along an axis.

Both types of joints have an axis.
For revolute joints, this is the axis of rotation; for prismatic joints, this is the axis of translation.
The axes also have an orientation, determining the positive angle (using the right-hand corkscrew rule) or translation direction.\
The choice of orientation is arbitrary, and usually are done to make the angle/translation signs more intuitive.

== Frames

A _frame_ is a local coordinate system that rigidly attaches to some object, usually a link or part of a robot.

Conventionally, frame 0, notated ${0}$, is the _base_ frame of a robot, used to describe the robot's position and orientation in the world.
Then, for a robot with $n$ joints, we have frames ${1}$ to ${n}$ rigidly attached to each link, and frame ${n}$, the _end effector_ frame, rigidly attaches to ${n-1}$ but represents the _tool center point_.


#pagebreak()
= Kinematics
== Denavit-Hartenberg Parameters (modified)

In D-H convention, the transformation from one frame to another is only represented by 4 parameters;
two degrees of freedom are removed (one translational, one rotational).\
This works because the D-H convention *restricts* how a frame can be placed relative to its adjacent frames (in a linkage setup).
With proper placement of frames, the convention can still capture any link geometry and model both revolute and prismatic joints.

*Note* that this course specifically uses the #link("https://en.wikipedia.org/wiki/Denavit%E2%80%93Hartenberg_parameters#Modified_DH_parameters")[_Modified_ D-H parameters], and so will all the notes below.

=== Frame Placement

Frame $i$ rigidly attaches to link $i$. ($i$ is 1-indexed, but the robot base frame is frame $0$.)

One way to determine frame placements is by forward-progressing the constraints.
We start with some _sensible_#note-ref(<frame-0-placement>) placement of the base frame ${0}$, then for each subsequent frame ${i}$, its placement is constrained by how ${i-1}$ was placed.

#pad(left: 1em)[
  Let $x_i$, $y_i$, $z_i$ be the axes of frame ${i}$ (lines in 3d space with an arrow).\
  Let $L_i$ be _link_ $i$, and $J_i$ be _joint_ $i$.\
  Let $n_i$ be the _common normal_ between $z_i$ and $z_(i+1)$: the line perpendicular to (and intersecting) both $z_i$ and $z_(i+1)$ (and if they are parallel, any such solution).
]

Frame axis assignment:
- $z_i$ is the axis of $J_i$ (the joint connecting $L_(i-1)$ and $L_i$)
  - for revolute, oriented so the positive angle follows the right-hand corkscrew rule
  - for prismatic, oriented in the positive direction
- $x_i$ is (parallel to) $n_i$
  - oriented from $z_i$ to $z_(i+1)$
- $y_i$ can then be deduced uniquely
  - oriented to form a right-handed coordinate system

The origin of the frame ${i}_"org"$ is of course the intersection point of $z_i$ and $x_i$.

One consequential property of the placement rules is that $x_i$ intersects and is perpendicular to $z_(i+1)$ (and $z_i$).
Also, $z_i$ collinear to the common normal between $x_(i-1)$ and $x_i$, just like how $x$ axes are to $z$ axes.

==== Conventions/Tips

#note(<frame-0-placement>)[
  On base frame placement:\
  While ${0}$ has some freedom in its placement ($z_0$ is unconstrained since there is no joint 0), a strategic placement can simplify the D-H parameters.
  One common strategy is to place ${0}$ to coincide with ${1}$ when the $J_1$ is at its "home" or zero position, so that $a_0 = 0$ and $alpha_0 = 0$.
  Another is to align $z_0$ with $z_1$ and place $x_0$ to 1. align with $x_1$ while $J_1$ is in its "home" state and 2. so ${0}_"org"$ is on the base/mount surface.
]

Reset all prismatic joints to their zero position before placing frames.
This helps create more intuitive $d$ parameters below.

End-effector frame ${n}$ placement:
- this will often violate the D-H constraints, so one might need a generic 6-DOF transform for ${n}$
- align $z_n$ with the end-effector's _approach_ direction (e.g. the shaft of a drill)
- align $x_n$ with the end-effector's _lateral_ direction, if it has one (e.g. the gripping direction of a gripper)

=== Transformations

After the frames are placed, the transformation $T_i$ from ${i-1}$ to ${i}$ can be represented by the 4 (Modified) D-H parameters:

#table(
  columns: 4,
  toprule(),
  table.header[Param][Symbol][Description][Alternative Description],
  midrule(),
  //
  [Link length],
  $a_(i-1)$,
  [distance from $z_(i-1)$ to $z_i$ (along $x_(i-1))$],
  $frac(style: "horizontal", abs((P_i - P_(i-1)) dot (hat(z)_(i-1) times hat(z)_i)), norm(hat(z)_(i-1) times hat(z)_i))$,

  [Link twist],
  $alpha_(i-1)$,
  [angle from $z_(i-1)$ to $z_i$ (about $x_(i-1))$],
  $op("atan2")((hat(z)_(i-1) times hat(z)_i) dot hat(x)_(i-1), hat(z)_(i-1) dot hat(z)_i)$,

  [Joint offset], $d_i$, [distance from $x_(i-1)$ to $x_i$ along $z_i$], [displacement, if prismatic],

  [Joint angle], $theta_i$, [angle from $x_(i-1)$ to $x_i$ about $z_i$], [angle, if revolute],
  bottomrule(),
)

Intuitively, $a_(i-1)$ and $alpha_(i-1)$ describe the geometry of link $i$ ($z_(i-1)$ and $z_i$'s relative position), while $d_i$ and $theta_i$ describe the configuration of joint $i$ (how $L_i$ moves relative to $L_(i-1)$ by $J_i$).

Additional notes:
- $alpha$ specifically measures the angles between _projections_ of the $z$ axes onto a plane normal to $x$ (with sign given by the right-hand corkscrew rule). Same idea for $theta$
- when the orientation of $x_i$ has multiple solutions (when $z_(i-1)$ and $z_i$ intersect or are collinear), $x_i$ is conventionally oriented to make $alpha_(i-1)$ be zero or positive
- when the placement of $x_i$ has multiple solutions (when $z_(i-1)$ and $z_i$ are parallel), $x_i$ is conventionally placed to pass through ${i-1}_"org"$

$
  attach(T, tl: i-1, bl: i) = mat(
    cos theta_i, -sin theta_i, 0, a_(i-1);
    sin theta_i cos alpha_(i-1), cos theta_i cos alpha_(i-1), -sin alpha_(i-1), -d_i sin alpha_(i-1);
    sin theta_i sin alpha_(i-1), cos theta_i sin alpha_(i-1), cos alpha_(i-1), d_i cos alpha_(i-1);
    0, 0, 0, 1;
  )
$

== Inverse Kinematics

=== Algebraic Solution to Planar RRR

For a planar RRR robot, we have

$
  attach(T, tl: 0, bl: 3) = mat(
    cos(theta_1 + theta_2 + theta_3), -sin(theta_1 + theta_2 + theta_3), 0, L_2 cos (theta_1 + theta_2) + L_1 cos theta_1;
    sin(theta_1 + theta_2 + theta_3), cos(theta_1 + theta_2 + theta_3), 0, L_2 sin (theta_1 + theta_2) + L_1 sin theta_1;
    0, 0, 1, 0;
    0, 0, 0, 1;
  ) = mat(
    cos phi, -sin phi, 0, x;
    sin phi, cos phi, 0, y;
    0, 0, 1, 0;
    0, 0, 0, 1;
  )
$

For a target ${3}$ pose of $(x, y, phi)$, we want to solve for the joint angles $theta_1$, $theta_2$, and $theta_3$.

Clearly, we have

$cos phi = cos(theta_1 + theta_2 + theta_3) \
sin phi = sin(theta_1 + theta_2 + theta_3) \
x = L_2 cos(theta_1 + theta_2) + L_1 cos theta_1 \
y = L_2 sin(theta_1 + theta_2) + L_1 sin theta_1$

*Firstly, $theta_2$*

#underline[_Square and sum_] the equations for $x$ and $y$

$x^2 + y^2 &= L_1^2 + 2 L_1 L_2 (cos theta_1 cos(theta_1 + theta_2) + sin theta_1 sin(theta_1 + theta_2)) &+ L_2^2 \
&= L_1^2 + 2 L_1 L_2 cos theta_2 &+ L_2^2$

$cos theta_2 = (x^2 + y^2 - L_1^2 - L_2^2) / (2 L_1 L_2)$

A clean way to obtain both solutions is to use $atan2$:

$theta_2 = atan2(plus.minus sqrt(1 - cos^2 theta_2), cos theta_2)$

*Secondly, $theta_1$*

With knowledge of $cos theta_2$ and $sin theta_2$, we can trig identity our way into reduced equations for $x$ and $y$:

$x &= L_2 cos(theta_1 + theta_2) + L_1 cos theta_1 quad = L_2 (cos theta_1 cos theta_2 - sin theta_1 sin theta_2) + L_1 cos theta_1 \
&= (L_2 cos theta_2 + L_1) cos theta_1 - (L_2 sin theta_2) sin theta_1$

$y &= L_2 sin(theta_1 + theta_2) + L_1 sin theta_1 quad = L_2 (sin theta_1 cos theta_2 + cos theta_1 sin theta_2) + L_1 sin theta_1 \
&= (L_1 + L_2 cos theta_2) sin theta_1 + (L_2 sin theta_2) cos theta_1$

Extract the common, now-known coefficients:

$K_1 &= L_2 cos theta_2 + L_1 \
K_2 &= L_2 sin theta_2$

Now, once we have

$x = K_1 cos theta_1 - K_2 sin theta_1 \
y = K_1 sin theta_1 + K_2 cos theta_1$

we perform #underline[_trigonometric substitution_]: define $gamma$ and $r$ as the angle (opposite $K_2$) and the hypotenuse of the right triangle with legs $K_1$ and $K_2$

$r = sqrt(K_1^2 + K_2^2) \
gamma = atan2(K_2, K_1)$

and so

$x / r = cos gamma cos theta_1 - sin gamma sin theta_1 = cos (gamma + theta_1) \
y / r = cos gamma sin theta_1 + sin gamma cos theta_1 = sin (gamma + theta_1)$

finally

$theta_1 = atan2(y / r, x / r) - gamma$

*Lastly, $theta_3$*

Observe that $theta_1 + theta_2 + theta_3 = atan2(sin phi, cos phi)$, so

$theta_3 = atan2(sin phi, cos phi) - theta_1 - theta_2$

== Jacobians

Forward kinematics are functions of "joint angles" $mapsto$ "end-effector pose". \
Jacobians are the derivatives of these functions wrt. time; Jacobians map joint velocities to cartesian velocity (of end-effector).

It is the "full" derivative of a vector-valued multivariate function, represented as a matrix of partial derivatives.

A function $f: RR^n -> RR^m$ has a Jacobian $J$ of size $m times n$. \
In robotics, our FK functions have output dimension $m = 6$ (3 for position + 3 for orientation), and input dimension $n$ is the number of joints.

Sometimes $m = 3$ when only dealing with position (or orientation)... or even $m = 2$ for planar robots.

We have two main methods to compute the Jacobian of a FK function: velocity propagation and direct differentiation.


==== Notation

_Absolute_ angular velocity of ${i}$ (wrt. ${0}$): $omega_i$.

_Relative_ angular velocity of ${i}$ (wrt. ${i-1}$; i.e., angular velocity of joint $i$): $Omega_i$.

_Absolute_ linear velocity of ${i}$ (wrt. ${0}$): $v_i$.

Note that $Omega$ always denotes a velocity relative to the directly preceding frame.

All of these measures, as usual, can be expressed in any frame, e.g. $attach(omega, tl: A, br: i)$. \
Without a TL-script, absolute velocities are implicitly expressed in the base frame ${0}$.

Angular velocity is represented as a vector; direction is axis and magnitude is speed.

Note that the cross-product $omega times P$ gives the tangential linear velocity at $P$ due to $w$.

// $omega_i eq.delta attach(Omega, tl: 0, br: i) = attach(R, tl: 0, bl: i-1) thick attach(Omega, tl: i-1, br: i)$

$attach(v, tl: i, br: i+1) eq.def dif/(dif t) (attach(P, tl: i, br: i+1))$

Generalized joint parameter (represents either $theta$ or $d$): $q_i$

$bold(q) = vec(q_1, ..., q_n)$

Jacobian (linear + angular): $bold(J)$ \
Liner-velocity Jacobian: $bold(J)_v$ \
Angular-velocity Jacobian: $bold(J)_omega$

=== Velocity Propagation

Quite intuitive; roughly,
+ describe each link's "own" (relative to its own frame) velocity as a function of its joint velocity
+ start from base and "propagate" the velocities down the chain using the transformations between frames
+ express the end-effector velocity in the base frame
+ extract the Jacobian by matching coefficients of $dot(q)_i$

This works for both linear and angular velocities.

=== Direct Differentiation

This method, unlike velocity propagation, does not work well for angular velocities... due to math reasons.
(How do you differentiate a rotation matrix?)

+ obtain the FK function $[x, y, z] = f(q_1, ..., q_n)$
+ differentiate $f$ wrt. $t$; compute all its partial derivatives $(partial f) / (partial q_i)$
+ arrange partials in a matrix to obtain (linear-velocity-only) Jacobian $bold(J)_v$


$dot(x) = (partial f_x) / (partial q_1) dot(q)_1 + ... + (partial f_x) / (partial q_n) dot(q)_n \
dot(y) = (partial f_y) / (partial q_1) dot(q)_1 + ... + (partial f_y) / (partial q_n) dot(q)_n \
dot(z) = (partial f_z) / (partial q_1) dot(q)_1 + ... + (partial f_z) / (partial q_n) dot(q)_n$


$
  bold(J)_v = mat((partial f) / (partial q_1), (partial f) / (partial q_2), ..., (partial f) / (partial q_n);) = mat(
    gradient^top f_x;
    gradient^top f_y;
    gradient^top f_z;
  ) =
  mat(
    (partial f_x) / (partial q_1), (partial f_x) / (partial q_2), ..., (partial f_x) / (partial q_n);
    (partial f_y) / (partial q_1), (partial f_y) / (partial q_2), ..., (partial f_y) / (partial q_n);
    (partial f_z) / (partial q_1), (partial f_z) / (partial q_2), ..., (partial f_z) / (partial q_n);
  )
$


$
  dot(bold(x)) = bold(J) dot(bold(q))
$

== other stuff

/ Singularities: values of $bold(q)$ that result in $det(bold(J)) = 0$

*Statics*

The Jacobian also maps end-effector forces to joint torques:

$
  bold(tau) = bold(J)^top bold(F)
$

Derivation: \
consider mechanical power in both joint space and cartesian space:

$
  "Power" & = bold(F) dot dot(bold(x))   && = bold(F)^top dot(bold(x)) \
  "Power" & = bold(tau) dot dot(bold(q)) && = bold(tau)^top dot(bold(q)) \
$

then, by the conservation of energy,

$
  bold(tau)^top dot(bold(q)) & = bold(F)^top dot(bold(x)) \
  bold(tau)^top dot(bold(q)) & = bold(F)^top (bold(J) dot(bold(q))) \
               bold(tau)^top & = bold(F)^top bold(J) \
                   bold(tau) & = bold(J)^top bold(F)
$

#pagebreak()
= Dynamics and Control

== Trajectory Planning

== Manipulator Dynamics

$
  M(bold(q)) dot.double(bold(q)) + V(bold(q), dot(bold(q))) + g(bold(q)) = bold(tau)
$

$M(bold(q))$ is an $n times n$ matrix representing the inertial properties; \
$V(bold(q), dot(bold(q)))$ is an $n$-dim vector representing the Coriolis and centrifugal forces; \
$g(bold(q))$ is an $n$-dim vector representing gravitational forces.

$M$ is positive-definite and symmetric, and thus invertible. \
$V$ can be derived from $M$.

*Newton Euler Formula*

$
  bold(F) & = m dot(bold(v)) \
        N & = attach(I, tl: c) dot(omega) + omega times attach(I, tl: c) omega \
$

$attach(I, tl: c)$ is the _inertia tensor_ of the body expressed in the body's center of mass frame ${c}$.

=== Friction


$
  M(bold(q)) dot.double(bold(q)) + V(bold(q), dot(bold(q))) + g(bold(q)) = bold(tau) - bold(tau)_f
$
where $bold(tau)_f$ is the friction torque, which can be modeled as a function of $bold(q)$ and $dot(bold(q))$.

== Manipulator Control

=== Second Order Linear Systems

E.g., *Mass-Spring System*

Frictionless:

$
  m dot.double(x) + k x = 0 \
  x = R cos(sqrt(k / m) t - phi)
$

With viscous friction $b$:

$
  m dot.double(x) + b dot(x) + k x = 0 \
$

Characteristic equation:

$
  m lambda^2 + b lambda + k = 0 \
  lambda_1, lambda_2 = (-b plus.minus sqrt(b^2 - 4 m k)) / (2 m)
$

- Underdamped: complex conjugate roots \
  $x = e^(p t) (c_1 cos(q t) + c_2 sin(q t))$ \
  where $lambda_(1,2) = p plus.minus q i$
- Critically damped: repeated real root \
  $x = (c_1 + c_2 t) e^(lambda t)$
- Overdamped: two real roots \
  $x = c_1 e^(lambda_1 t) + c_2 e^(lambda_2 t)$

In a control system that models a mass-spring-damper system,
$k_p = k$ acts as the _stiffness_ of the system... \
For some arbitrary choice of $k_p$, critical damping is achieved by $k_v = b = 2 sqrt(m k_p)$.

Note that this is a PD (proportional-derivative) controller.

=== Control Law Partitioning

One can partition the controller into two parts, a model-based compensator and a servo controller, s.t. the servo controller's parameters are completely independent of the non-design physical parameters.

+ Given system dynamics $m dot.double(x) + b dot(x) + k x = F$
+ Design model-based compensator:
  - delegate highest-order control ($f$): $F = m f + b dot(x) + k x$
  - system is reduced to unit mass ($dot.double(x) = f$)
+ Design servo controller
  - $f = -k_v dot(x) - k_p x$

I.e., \
$m dot.double(x) + b dot(x) + k x = F = m(-k_v dot(x) - k_p x) + b dot(x) + k x \
dot.double(x) + k_v dot(x) + k_p x = 0$

=== Nonzero Setpoint

Following a partitioned controllers, the servo controller can be trivially parameterized: \
$f = -k_v dot(x) + -k_p (x - x_d)$ \
where $x_d$ is the desired setpoint.

=== Trajectory Following

Once again, only the servo controller changes: \
$f = dot.double(x)_d -k_v (dot(x) - dot(x)_d) - k_p (x - x_d)$ \
where $x_d$, $dot(x)_d$, and $dot.double(x)_d$ are the desired position, velocity, and acceleration at the current time step.

Note that if we define the _tracking error_ as $e = x - x_d$, then the closed-loop dynamics of the error is \
$dot.double(e) + k_v dot(e) + k_p e = 0$ \
which is a mass-spring-damper system in of itself!

=== Motor Physics

For a permanent magnet DC motor:
- $tau_m = k_m i_a$
- $V_"emf" = k_e dot(theta)_m$

where $k_m$ is the motor's torque constant; $k_e$ is its electrical constant

A simple circuit model of one motor is
$
  L_a (dif i_a) / (dif t) + R_a i_a & = V_a - V_"emf" \
                                    & = V_a - k_e dot(theta)_m
$

...but let's assume the inductance $L_a$ is negligible:
$ R_a i_a = V_a - k_e dot(theta)_m $

For a rotary shaft (+ gear) we have its moment of inertia $I$ and viscous friction $b$. \
Consider a motor-load gear-gear system...

Motor-side dynamics:
$
  I_m dot.double(theta)_m = tau_m - b_m dot(theta)_m - F r_m
$

Load-side dynamics (no additional $tau$ as it is not motorized):
$
  I dot.double(theta) = F r - b dot(theta)
$

With $eta = r / r_m$, the combined dynamics can be expressed in load-side terms as

$
  (I + I_m eta^2) dot.double(theta) + (b + b_m eta^2) dot(theta) = tau
$
which once again is a mass-spring-damper system (driven by $tau$, with zero proportional component).

A partitioned control system:
- $tau = (I + I_m eta^2) f + (b + b_m eta^2) dot(theta)$
- $f = dot.double(theta)_d - k_v (dot(theta) - dot(theta)_d) - k_p (theta - theta_d)$
- set desired stiffness $k_p$, then $k_v = 2 sqrt(k_p)$

Finally, $tau_m = 1/eta tau$ and $tau_m = k_m i_a$ so
$
  V_a & = R_a i_a + k_e dot(theta)_m \
      & = R_a (tau / (k_m eta)) + k_e eta dot(theta)
$
A function of voltage in terms of velocity and desired torque.
