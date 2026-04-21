#import "/style.typ": theme
#show: theme

#import "@preview/booktabs:0.0.4": *
#show: booktabs-default-table-style

#set page(height: auto) // mimic page-less format

#set math.mat(delim: "[")
#set math.vec(delim: "[")

#let note-counter = counter("notes")
#let note-ref(label) = context {
  link(label)[#super[#text(fill: rgb(255, 155, 200))[
    #note-counter.at(label).first()
  ]]]
}
#let note(label, body, number: false) = {
  note-counter.step()
  block([
    #if number {
      context note-counter.display()
    }
    #body
    #label
  ])
}


#title[notation hell :]

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

Rotation about $x$-axis by $theta$:
$mat(1, 0, 0; 0, cos(theta), -sin(theta); 0, sin(theta), cos(theta);)$.

Rotation about $y$-axis by $theta$:
$mat(cos(theta), 0, sin(theta); 0, 1, 0; -sin(theta), 0, cos(theta);)$.

Rotation about $z$-axis by $theta$:
$mat(cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0; 0, 0, 1;)$.

Rotation matrices are orthogonal: $attach(R, tl: B, bl: A) = attach(R, tl: A, bl: B)^(-1) = attach(R, tl: A, bl: B)^T$.

==== Roll-pitch-yaw Repr.

Aka. XYZ-fixed-angle representation.

Remember to use the right-hand corkscrew rule to figure which way is the positive angle.

*To finish watching Task 3.4.*

==== Euler Angles Repr.

*To watch, Task 3.5.*

==== Equivalent Angle-Axis Repro.

*To watch, Task 3.6.*

==== Euler Parameters Repr.

*To watch, Task 3.7.*

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


