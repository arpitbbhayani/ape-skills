---
name: ape-visualize
description: Builds interactive, browser-based 3D Three.js visualizations of any mathematics or science concept as a single, self-contained HTML file. Takes a concept and a depth level (Simple, Intermediate, Advanced). Trigger on "ape visualize", "ape visualize math", "ape visualize science", "visualize math", "visualize science", "visualize concept", "ape simulate", or "/ape-visualize".
---

# Visualize Skill: Interactive 3D Math & Science Visualizer

Takes any concept from **mathematics or science** and creates an interactive, visually stunning, browser-based 3D visualization using Three.js, packaged as a single self-contained HTML file.

The visualization is grounded in real mathematical formulations and physical laws—not just decorative graphics, but a live, interactive simulation or geometric construction that users can rotate, zoom, tweak with sliders, and inspect in real time.

---

## Inputs

The user provides:
1. **Concept**: Any mathematics or science concept. For example:
   - **Math**: *Eigenvalues & Eigenvectors*, *3D Linear Transformations*, *Gradient Descent on Surfaces*, *Curl & Divergence of Vector Fields*, *Riemann Surfaces*, *Möbius Strip & Topology*, *Fourier Epicycles in 3D*, *Lorenz Attractor & Chaos*, *Spherical Harmonics*, *Minimal Surfaces (Helicoid/Catenoid)*.
   - **Science**: *Lorentz Force*, *Gravitational Orbits & Precession*, *Double-Slit Wave Interference*, *Maxwell-Boltzmann Distribution*, *VSEPR Molecular Geometry*, *Quantum Harmonic Oscillator*, *DNA Replication Fork*.
2. **Depth**: One of three simple depth levels (default to `Intermediate` if not specified):
   - **`Simple`** (Level 1 — Intuition & Big Picture)
   - **`Intermediate`** (Level 2 — Mechanics & Equations)
   - **`Advanced`** (Level 3 — Deep Dive & Rigorous Internals)

Regardless of the starting depth, every generated HTML document embeds an in-browser **Depth Selector** (`Simple` | `Intermediate` | `Advanced`) so the user can fluidly toggle between levels live.

---

## The Three Depth Levels (Simple Words)

The depth determines both the visual representation and the level of mathematical/physical rigor exposed:

| Depth | Target Audience | Core Focus | Visual Elements (Math & Science) | Interactive Controls | Telemetry & HUD |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`Simple`** | Beginners, general audience, visual learners | **Big-picture intuition** & visual metaphors. What does it look like? What is the main effect? | **Math**: Deforming shapes, flowing streamlines, animated paths, color gradients.<br>**Science**: Macro objects, smooth orbits, glowing wavefronts. No overwhelming formulas. | Play / Pause, Speed slider, 1–2 intuitive dials ("Morph", "Stretch", "Strength", "More / Less", scenario presets). | "What's happening?" card in plain English explaining the core takeaway and visual intuition. |
| **`Intermediate`** | Undergraduates, engineers, technical learners | **How it works mechanically** — governing rules, vectors, coordinates, and equations. | **Math**: Basis vectors ($\mathbf{\hat{i}}, \mathbf{\hat{j}}, \mathbf{\hat{k}}$), tangent planes, 3D vector arrow grids, coordinate axes, parameter curves.<br>**Science**: Force/velocity arrows, field lines, particle trails, component breakdowns. | Sliders with real variables and units (matrix components $a_{ij}$, surface curvature $k$, mass $m$, charge $q$, frequency $\omega$). | Live numerical telemetry (current coordinates, matrix determinant $\det(A)$, energy, flux) + live 2D canvas sparkline. Typeset formula. |
| **`Advanced`** | Researchers, math/physics majors, deep divers | **Rigorous math & deep mechanics** — differential equations, phase space, edge cases. | **Math**: Invariant eigenvector axes, differential forms, phase portraits ($\dot{x}$ vs $x$ or complex plane), branch cuts, geodesic curvature.<br>**Science**: Runge-Kutta trajectories, Hamiltonian drift, quantum probability clouds, perturbation indicators. | Precision mathematical dials (eigenvalue parameter $\lambda$, perturbation $\epsilon$, integration step $\Delta t$, non-linear coupling, boundary conditions). | Real-time phase-space canvas, conservation/drift monitor ($\Delta E / E_0$, $\det(A)$ conservation), matrix/tensor readout, raycaster probe on click. |

---

## Output Requirements

Always output a **single, self-contained HTML file** (`<concept>-visualization.html`) that works immediately upon opening in any web browser without any local server or build tools needed.

### Architecture of the HTML File
1. **Zero build step & Zero CORS**: Loads Three.js and OrbitControls via reliable CDN `<script>` tags using standard UMD format:
   ```html
   <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
   <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/controls/OrbitControls.js"></script>
   ```
2. **Modern Scientific & Mathematical Dark UI**: Clean OLED-dark glassmorphic design (`#090a0f` background, frosted glass panels with `backdrop-filter: blur(14px)`, subtle neon accents: Cyan `#00f0ff`, Mint `#00ff9d`, Amber `#ffb700`, Coral `#ff3366`, Violet `#b388ff`).
3. **HUD Components**:
   - **Header Bar**: Concept title, domain badge (`MATHEMATICS`, `PHYSICS`, etc.), and the **3-level Depth Switcher** (`Simple` | `Intermediate` | `Advanced`).
   - **Main 3D Viewport**: Responsive Three.js canvas with smooth orbit, pan, and zoom (`THREE.OrbitControls` with `enableDamping = true`).
   - **Controls Panel** (floating glass card):
     - Timeline / Animation: Play / Pause, Reset, Speed slider (0.1x to 3x).
     - Concept parameters tailored to the active depth.
     - Visual toggles: Coordinate Grid, Basis / Field Vectors, Trails / Curves, Labels, Tangent / Normal indicators.
     - Presets dropdown (e.g. "Identity", "Shear", "Pure Rotation", "Degenerate / Singular" for math; "Default", "Resonance", "Chaos" for science).
   - **Live Telemetry & Graph Panel**:
     - Live mathematical/physical readouts (determinant, eigenvalues, coordinates, velocity, energy).
     - Real-time 2D Canvas plot (sparkline, phase portrait, or function curve).
   - **Explanation & Equation Card**:
     - **Intuition**: Plain English summary of what is visible.
     - **Governing Equation**: Beautifully typeset formula (e.g. $A \mathbf{v} = \lambda \mathbf{v}$, or $\nabla \times \mathbf{F}$, or $\mathbf{F} = q(\mathbf{E} + \mathbf{v} \times \mathbf{B})$).
     - **Interactive Probe**: Raycaster to click/hover 3D elements and inspect their mathematical state.

---

## Domain Coverage: Mathematics & Science

### 1. Pure & Applied Mathematics

- **Linear Algebra**:
  - *Matrix Transformations*: Visualizing $T(\mathbf{x}) = A \mathbf{x}$ acting on a unit cube or unit sphere.
  - *Eigenvalues & Eigenvectors*: Visualizing lines that do not change direction under transformation, only stretch by $\lambda$.
  - *Determinant*: Geometric interpretation as the signed volume scaling factor of parallelpipeds.
  - *Singular Value Decomposition (SVD)*: Factoring $A = U \Sigma V^T$ as Rotation $\to$ Scaling $\to$ Rotation.
  - *Quadratic Forms & Conic Sections*: Visualizing $\mathbf{x}^T A \mathbf{x} = c$ ellipsoids, hyperboloids, and paraboloids.

- **Multivariable Calculus & Differential Geometry**:
  - *3D Scalar Surfaces & Tangent Planes*: $z = f(x, y)$ with tangent plane and normal vector $\mathbf{n} = \langle -f_x, -f_y, 1 \rangle$.
  - *Gradient Descent*: A particle rolling down the steepest descent path $-\nabla f(x, y)$ on a terrain.
  - *Vector Fields, Divergence & Curl*: 3D arrow fields with micro-paddle wheels showing curl ($\nabla \times \mathbf{F}$) and flux expanding from sources showing divergence ($\nabla \cdot \mathbf{F}$).
  - *Minimal Surfaces*: Catenoid, Helicoid, and Enneper's surface (surfaces with zero mean curvature $H = 0$).
  - *Curvature*: Gaussian curvature $K = \kappa_1 \kappa_2$ and principal curvature directions on 3D manifolds.

- **Complex Analysis & Topology**:
  - *Riemann Surfaces*: Multi-sheeted geometric representations of multi-valued complex functions ($w = \sqrt{z}$, $w = \ln z$).
  - *Conformal Mappings*: Grid lines in the complex plane mapped by $f(z) = z^2$ or $f(z) = e^z$, proving angle preservation.
  - *Möbius Strip & Klein Bottle*: Non-orientable surfaces, normal vector traversal returning flipped.
  - *Torus Knots & Stereographic Projections*: Projecting 4D spheres / Clifford Torus down to 3D space.

- **Dynamical Systems & Chaos**:
  - *Lorenz Attractor*: Butterfly-shaped strange attractor showing sensitive dependence on initial conditions.
  - *Phase-Space Portraits*: Plotting $(\theta, \dot{\theta})$ for non-linear pendulums, limit cycles, and strange attractors.
  - *3D Fourier Epicycles*: Epicyclic rotating phasor arms in 3D tracing arbitrary complex curves or knots.

### 2. Physical & Natural Sciences

- **Physics**:
  - *Electromagnetism*: Lorentz force ($q(\mathbf{E} + \mathbf{v} \times \mathbf{B})$), cyclotron motion, magnetic dipoles, Biot-Savart induction.
  - *Classical & Celestial Mechanics*: Keplerian planetary orbits, Lagrange points ($L_1-L_5$), chaotic 3-body gravitational interactions.
  - *Wave Mechanics & Optics*: Wavefront superposition, double-slit interference, thin-film diffraction, Snell's law refraction.
  - *Thermodynamics*: Maxwell-Boltzmann velocity distribution of colliding particles, Brownian motion.
  - *Quantum Mechanics*: Wave packet dispersion, harmonic oscillator probability density, spin precession in $B$-fields.

- **Chemistry & Molecular Biology**:
  - *VSEPR Theory*: 3D electron pair repulsion geometries (linear, tetrahedral, octahedral, trigonal bipyramidal).
  - *Crystal Lattices*: Unit cells (FCC, BCC, Simple Cubic, Diamond) with atom packing fractions.
  - *DNA & Cellular Dynamics*: Double-helix transcription fork, ion gradients in action potential propagation.

---

## Step-by-Step Generation Workflow

When the user requests a visualization:

### Step 1: Mathematical & Scientific Decomposition
1. Parse the concept and target depth (`Simple`, `Intermediate`, or `Advanced`).
2. Identify the core mathematical/physical invariants:
   - For **Math**: Invariant axes (eigenvectors), volume scaling ($\det A$), conservation of topological genus, orthogonality, gradient direction.
   - For **Science**: Conservation of energy/momentum, flux continuity, wave phase relationships.
3. Design how the 3 depth levels map to this concept:
   - **`Simple`**: Pure visual intuition, intuitive sliders, macro visual takeaway.
   - **`Intermediate`**: Explicit equations, vector arrows, coordinate grid, real mathematical variables.
   - **`Advanced`**: Differential equations, phase portraits, invariant monitors, numerical diagnostics.

### Step 2: Implement the Three.js Geometry & Simulation
1. **Mathematical Representation**:
   - For surfaces: Use `THREE.ParametricGeometry` or dynamically updated `THREE.PlaneGeometry` with vertex height displacement.
   - For vector fields: Use `THREE.InstancedMesh` with arrow geometries or arrays of `THREE.ArrowHelper` for efficiency.
   - For curves & trajectories: Use dynamic `THREE.BufferGeometry` with pre-allocated array buffers.
2. **Animation / Numerical Update Loop**:
   - Discrete updates per frame with clamped delta time (`Math.min(clock.getDelta(), 0.05)`).
   - Pre-allocate scratch vectors (`const _v1 = new THREE.Vector3()`) outside the render loop to prevent garbage collection stutter.

### Step 3: Wire Up Reactive Controls & HUD
1. Connect sliders to mathematical/physical state variables without recreating the 3D scene.
2. Provide presets so users can jump to famous cases (e.g. for linear algebra: *Shear*, *Reflection*, *Rotation*, *Projection / Singular*).
3. Connect the live 2D canvas to plot real-time telemetry (sparkline of coordinates or phase-space trajectory).
4. Implement the raycaster to allow clicking on 3D elements to inspect local values.

### Step 4: Write & Deliver the Single HTML File
Write the complete, self-contained HTML file directly to the workspace or artifact directory, ready to be double-clicked and viewed in any browser.
