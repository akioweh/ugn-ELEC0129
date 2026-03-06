#import "/style.typ": theme
#show: theme

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

= Linalg
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

Remember to use the right-hand-rule to figure which way is the positive angle.

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
Multiple homogeneous transforms can be trivially converted to a single transforms by computing the product of the respective matrices.

Because the rotation matrix is orthogonal, these transformation matrices are relatively easy to invert:
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


= Physical Stuff

== Joints

_Revolute_: rotation about an axis.

_Prismatic_: translation along an axis.

== Denavit-Hartenberg Parameters

In D-H convention, the transformation from one frame to another is only represented by 4 parameters;
two degrees of freedom are removed (one translational, one rotational).\
This works because the D-H convention *restricts* how a frame can be placed relative to its adjacent frames (in a linkage setup).
With proper placement of frames, the convention can still capture any link geometry and model both revolute and prismatic joints.

Note that this course specifically uses the #link("https://en.wikipedia.org/wiki/Denavit%E2%80%93Hartenberg_parameters#Modified_DH_parameters")[_modified_ D-H parameters], and so will all the notes below.

=== Frame Placement

Frame $i$ rigidly attaches to link $i$. ($i$ is 1-indexed, but the robot base frame is frame $0$.)

One way to determine frame placements is by forward-progressing the constraints.
We start with some _sensible_#note-ref(<frame-0-placement>) placement of the base frame ${0}$, then for each subsequent frame ${i}$, its placement is constrained by how ${i-1}$ was placed.

#pad(left: 1em)[
  Let $x_i$, $y_i$, $z_i$ be the axes of frame ${i}$ (lines in 3d space with an arrow).\
  Let $L_i$ be _link_ $i$, and $J_i$ be _joint_ $i$.\
  Let $n_i$ be the _common normal_ between $z_(i-1)$ and $z_i$: the line perpendicular to (and intersecting) both $z_(i-1)$ and $z_i$ (and if they are parallel, any of them).
]

Frame axis assignment:
- $z_i$ is the axis of $J_i$ (the joint connecting $L_(i-1)$ and $L_i$)
  - for revolute, oriented so the positive angle follows the right-hand corkscrew rule
  - for prismatic, oriented in the positive direction
- $x_i$ is the parallel to $n_i$
  - oriented from ${i-1}$ to ${i}$
- $y_i$ can then be deduced uniquely
  - oriented following the right-hand rule

The origin of the frame ${i}_"org"$ is of course the intersection point of the axes.

#note(<frame-0-placement>)[

]

Consequential properties:
- $x_i$ is perpendicular to $z_(i-1)$
- $x_i$ intersects $z_(i-1)$

=== Transformations

After the frames are placed, the transformation $T_i$ from ${i-1}$ to ${i}$ can be represented by the 4 D-H parameters.

D-H parameters:
- $d_i$: offset along $z_(i-1)$ to $n_i$
- $theta_i$: angle from $x_(i-1)$ to $x_i$ about $z_(i-1)$
- $a_i$: length of $n_i$ $quad$ (aka. $r_i$)
- $alpha_i$: angle from $z_(i-1)$ to $z_i$ about $n_i$




