# Three.js Mathematics & Science Simulation Recipes

Ready-to-use numerical formulas, geometry algorithms, and Three.js implementation patterns for both mathematics and science concepts.

---

## 1. Pure & Applied Mathematics Recipes

### A. Linear Algebra: Matrix Transformations & Eigenvectors
- **Transformation**: Any point $\mathbf{x} = \begin{bmatrix} x \\ y \\ z \end{bmatrix}$ is mapped by matrix $A = \begin{bmatrix} a_{11} & a_{12} & a_{13} \\ a_{21} & a_{22} & a_{23} \\ a_{31} & a_{32} & a_{33} \end{bmatrix}$ via $\mathbf{x}' = A \mathbf{x}$.
- **Three.js Implementation**:
  ```javascript
  const matrixA = new THREE.Matrix4();
  // Set 3x3 transformation matrix elements
  matrixA.set(
    a11, a12, a13, 0,
    a21, a22, a23, 0,
    a31, a32, a33, 0,
    0,   0,   0,   1
  );

  // Apply to unit cube or unit sphere vertices
  const pos = baseGeometry.attributes.position;
  const transformedPos = currentGeometry.attributes.position;
  const v = new THREE.Vector3();

  for (let i = 0; i < pos.count; i++) {
    v.fromBufferAttribute(pos, i);
    // Smoothly interpolate between Identity and A: (1 - t) * I + t * A
    v.applyMatrix4(interpolatedMatrix);
    transformedPos.setXYZ(i, v.x, v.y, v.z);
  }
  transformedPos.needsUpdate = true;
  ```
- **Depth Levels**:
  - `Simple`: A unit cube or colorful sphere deforms smoothly, showing squashing, shearing, or rotating.
  - `Intermediate`: Basis vectors $\mathbf{\hat{i}}$ (red), $\mathbf{\hat{j}}$ (green), $\mathbf{\hat{k}}$ (blue) transform into columns of $A$. Signed determinant $\det(A)$ represents the volume of the parallelpiped.
  - `Advanced`: Eigenvectors ($A \mathbf{v} = \lambda \mathbf{v}$) highlighted as glowing invariant axes that maintain their direction during transformation while only scaling by $\lambda$. Visualizing real vs complex eigenvalues (pure stretch vs rotation-scaling).

---

### B. Multivariable Calculus: Gradient Descent on 3D Surfaces ($z = f(x, y)$)
- **Surface**: $z = \sin(x) \cos(y) + 0.1(x^2 + y^2)$.
- **Gradient**: $\nabla f = \left\langle \frac{\partial f}{\partial x}, \frac{\partial f}{\partial y} \right\rangle$.
- **Tangent Plane**: $z - z_0 = f_x(x_0, y_0)(x - x_0) + f_y(x_0, y_0)(y - y_0)$.
- **Particle Motion (Gradient Descent with Momentum)**:
  ```javascript
  const fx = Math.cos(ball.x) * Math.cos(ball.y) + 0.2 * ball.x;
  const fy = -Math.sin(ball.x) * Math.sin(ball.y) + 0.2 * ball.y;

  // Velocity update with learning rate eta and momentum alpha
  vx = alpha * vx - eta * fx;
  vy = alpha * vy - eta * fy;

  ball.x += vx * dt;
  ball.y += vy * dt;
  ball.z = surfaceFunc(ball.x, ball.y);
  ```
- **Depth Levels**:
  - `Simple`: A glowing bead rolling down terrain into a valley or basin of attraction.
  - `Intermediate`: Tangent plane at the bead's position; gradient vector $\nabla f$ arrow pointing uphill (direction of steepest ascent), $-\nabla f$ showing step direction.
  - `Advanced`: Contour lines (level sets $f(x, y) = c$) projected onto the $xy$-plane; Hessian matrix $H(f)$ determining local curvature (local minimum, maximum, or saddle point).

---

### C. Vector Fields: Divergence & Curl in 3D
- **Field**: $\mathbf{F}(x, y, z) = \langle P(x,y,z), Q(x,y,z), R(x,y,z) \rangle$.
- **Curl**: $\nabla \times \mathbf{F} = \left\langle \frac{\partial R}{\partial y} - \frac{\partial Q}{\partial z}, \, \frac{\partial P}{\partial z} - \frac{\partial R}{\partial x}, \, \frac{\partial Q}{\partial x} - \frac{\partial P}{\partial y} \right\rangle$.
- **Divergence**: $\nabla \cdot \mathbf{F} = \frac{\partial P}{\partial x} + \frac{\partial Q}{\partial y} + \frac{\partial R}{\partial z}$.
- **Three.js Arrow Grid**:
  ```javascript
  // Create 3D grid of arrows
  const arrowHelper = new THREE.ArrowHelper(dir, origin, length, colorHex, headLength, headWidth);
  ```
- **Depth Levels**:
  - `Simple`: Floating tracer particles moving through 3D space, showing whirlpools and fountains.
  - `Intermediate`: Grid of 3D arrows colored by field magnitude $\|\mathbf{F}\|$; sliders to adjust field coefficients.
  - `Advanced`: Microscopic paddle wheel measuring curl rotation rate and axis; expanding/contracting sphere measuring divergence flux.

---

### D. Complex Analysis & Topology: Riemann Surfaces & Manifolds
- **Riemann Surface of $w = \sqrt{z}$**:
  In polar coordinates $z = r e^{i\theta}$:
  $$x = r \cos\theta, \quad y = r \sin\theta, \quad u = \sqrt{r} \cos\left(\frac{\theta}{2}\right), \quad v = \sqrt{r} \sin\left(\frac{\theta}{2}\right)$$
  Plotting $(x, y, u)$ with $\theta \in [0, 4\pi]$ yields the famous self-intersecting multi-sheeted surface.
- **Möbius Strip**:
  $$x(u, v) = \left(1 + \frac{v}{2}\cos\frac{u}{2}\right)\cos u, \quad y(u, v) = \left(1 + \frac{v}{2}\cos\frac{u}{2}\right)\sin u, \quad z(u, v) = \frac{v}{2}\sin\frac{u}{2}$$
  with $u \in [0, 2\pi], v \in [-0.5, 0.5]$.
- **Depth Levels**:
  - `Simple`: An animated bug or normal vector traversing the Möbius strip, returning inverted to reveal that the surface has only one side.
  - `Intermediate`: Multi-sheeted branch surfaces color-coded by the phase $\text{Arg}(z)$, showing the branch cut line along the negative real axis.
  - `Advanced`: Conformal grid mapping showing that local angle intersections remain strictly $90^\circ$ everywhere except at the branch point singularity $z = 0$.

---

### E. Dynamical Systems & Chaos: Lorenz Attractor
- **Differential Equations**:
  $$\frac{dx}{dt} = \sigma (y - x), \quad \frac{dy}{dt} = x (\rho - z) - y, \quad \frac{dz}{dt} = x y - \beta z$$
- **Standard Parameters**: $\sigma = 10, \, \rho = 28, \, \beta = 8/3$.
- **RK4 Numerical Integrator**:
  ```javascript
  function getDerivatives(x, y, z) {
    return [
      sigma * (y - x),
      x * (rho - z) - y,
      x * y - beta * z
    ];
  }
  ```
- **Depth Levels**:
  - `Simple`: A glowing particle sketching a continuous butterfly ribbon in 3D without ever intersecting itself.
  - `Intermediate`: Two particles launched with a tiny difference ($\Delta x_0 = 10^{-4}$), demonstrating exponential trajectory divergence (The Butterfly Effect).
  - `Advanced`: Poincaré section plane $z = \rho - 1$ displaying discrete intersection points; live Lyapunov exponent calculation $\lambda \approx \frac{1}{t} \ln\frac{\|\Delta \mathbf{x}(t)\|}{\|\Delta \mathbf{x}_0\|}$.

---

## 2. Science Simulation Recipes

### A. Lorentz Force on Charged Particle ($\mathbf{F} = q(\mathbf{E} + \mathbf{v} \times \mathbf{B})$)
- **Helical Particle Update**:
  ```javascript
  const crossBx = vel.y * B.z - vel.z * B.y;
  const crossBy = vel.z * B.x - vel.x * B.z;
  const crossBz = vel.x * B.y - vel.y * B.x;

  const ax = (q / m) * (E.x + crossBx);
  const ay = (q / m) * (E.y + crossBy);
  const az = (q / m) * (E.z + crossBz);

  vel.addScaledVector(new THREE.Vector3(ax, ay, az), dt);
  pos.addScaledVector(vel, dt);
  ```

### B. Gravitational Keplerian & 3-Body Orbits
- **Newton's Law with Softening**:
  $$\mathbf{F}_{12} = \frac{G m_1 m_2}{(r^2 + \epsilon^2)^{3/2}} \mathbf{r}_{12}$$

### C. Wave Superposition & Double-Slit Interference
- **Wave Function**:
  $$\psi(\mathbf{r}, t) = A \cos(k r_1 - \omega t) + A \cos(k r_2 - \omega t)$$

---

## 3. General Three.js Best Practices for Math & Science

1. **Precision & Units**:
   - Rescale astronomical or atomic units to a comfortable Three.js viewport size (e.g. 1 to 20 units).
   - Display real physical/mathematical units in the UI readouts ($m, s, T, rad, \det A$).
2. **Dynamic Geometry Updates**:
   - For deforming surfaces or parametric meshes, mutate the `position` attribute in place and set `needsUpdate = true`.
   - Recompute normals (`geometry.computeVertexNormals()`) only when the mesh is illuminated with directional lighting.
3. **Double Buffering & Memory**:
   - Pre-allocate all `THREE.Vector3` instances used inside the animation loop to prevent memory allocation and garbage collection pauses.
