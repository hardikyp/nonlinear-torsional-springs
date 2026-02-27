# Simulation Variables Reference

This file documents the variables currently used in the repository's active MATLAB workflow (`structures/`, `core/`, `solver/`, `post/`, and driver scripts).

Unless noted otherwise, the model is 2D and each node has two translational DOFs (`nDof = 2`).

## Runtime selectors and top-level structs

| Variable | Type / Size | Where used | Meaning |
|---|---|---|---|
| `structType` | scalar | `main.m` | Menu choice for structure selection. |
| `simType` | scalar | `main.m` | Menu choice for solver selection. |
| `inputStructure` | struct | `main.m`, `test*.m`, `validate*.m` | Standardized structure/analysis input returned by `load*.m`. |
| `inputStructureName` | string | `main.m`, test/validate scripts | Label used in output file names. |
| `params` | struct | all solvers and post functions | Canonical input container. |
| `results` / `outParams` | struct | solver outputs, post functions | Input fields plus histories (loads, displacements, internal forces, nodal states). |

## Loader outputs (`structures/load*.m`)

| Variable | Type / Size | Meaning |
|---|---|---|
| `links` | `nBars x 2` | Bar connectivity (`[node_i, node_j]`). |
| `springs` | `nSpr x 3` | 3NTS connectivity (`[n1, n2, n3]`, center node is `n2`). |
| `coords` | `nNodes x 2` | Initial nodal coordinates `[x, y]`. |
| `restraint` | `nNodes x nDof` | Fixity map (`1` fixed, `0` free). |
| `force` | `nNodes x nDof` | Applied nodal loads in global components. |
| `A` | `nBars x 1` | Bar cross-sectional area. |
| `E` | `nBars x 1` | Bar Young's modulus. |
| `L`, `theta` | `nBars x 1` | Current bar length and orientation (`barInfo`). |
| `L0`, `theta0` | `nBars x 1` | Reference bar length and orientation. |
| `kT` | `nSpr x 1` | Base rotational spring stiffness (`k0` in enriched law). |
| `alpha0` | `nSpr x 1` | Reference spring angles (`springInfo`). |
| `nNodes`, `nDof`, `nBars`, `nSpr` | scalar | Problem dimensions. |
| `identity` | `nNodes x nDof` | Global DOF numbering with free DOFs first. |
| `nFree` | scalar | Number of free DOFs. |
| `reshapeIdx` | `(nNodes*nDof) x 1` | Permutation index for flattening/restoring nodal arrays. |
| `mapBars` | `nBars x (2*nDof)` | Global DOF map for each bar. |
| `mapSprings` | `nSpr x (3*nDof)` | Global DOF map for each spring. |

## DOF mapping and assembly helpers (`core/`)

| Variable | Type / Size | Meaning |
|---|---|---|
| `restraint` (vectorized) | `(nNodes*nDof) x 1` | Flattened fixity used in `numberDOF`. |
| `free_idx`, `rest_idx` | index vectors | Free/fixed DOF index sets. |
| `pSystem` | `(nNodes*nDof) x 1` | Global load vector from `loadVector`. |
| `Kff` | `nFree x nFree` | Free-free stiffness block (`partitionStiffness`). |
| `Ksf` | `(nFix) x nFree` | Restrained-free stiffness block (`partitionStiffness`). |
| `kSystem` | `(nNodes*nDof) x (nNodes*nDof)` | Assembled tangent stiffness matrix (`globalStiffness`). |
| `intF` | `(nNodes*nDof) x 2` | Current-iteration internal force contributions: column 1 bars, column 2 springs. |
| `axialF` | `nBars x (maxIncr+1)` | Running axial-force history used in geometric stiffness update. |

## Bar element variables (`core/bar*.m`, `core/geomStiffness.m`, `core/transformationMatrix.m`)

| Variable | Type / Size | Meaning |
|---|---|---|
| `D` | `nBars x 2` | Bar direction vectors (`coords(j,:) - coords(i,:)`). |
| `kLocal` | `4 x 4` | Local axial bar stiffness matrix. |
| `kGeom` | `4 x 4` | Geometric stiffness matrix from axial force. |
| `T` | `4 x 4` | Transformation matrix between local/global bar coordinates. |
| `dU` | `(nNodes*nDof) x 1` | Incremental nodal displacement between `coordsPrev` and `coords` in one iteration. |
| `dULocal` | `4 x 1` | Element displacement increment in local bar frame. |
| `natDef` | scalar | Axial natural deformation (`[-1 0 1 0] * dULocal`). |
| `barF` | scalar | Axial force state from previous iteration/increment used for `kGeom`. |
| `axialForce` | scalar | New axial force increment from `barForceRec`. |
| `fLocal` | `4 x 1` | Local element nodal force increment. |

## Spring geometry and constitutive variables (`core/spring*.m`, `core/gradientAlpha.m`, `core/hessianAlpha.m`, `core/enrichedSpringLaw.m`)

| Variable | Type / Size | Meaning |
|---|---|---|
| `r1`, `r2`, `r3` | `2 x 1` | Coordinates of the three nodes in one 3NTS element. |
| `a`, `b` | `2 x 1` | Vectors from center spring node to side nodes. |
| `L1`, `L2` | scalar | Norms of `a` and `b`. |
| `N` | `2 x 2` | 90-degree CCW rotation matrix `[0 -1; 1 0]`. |
| `C`, `S` | scalar | Dot and pseudo-cross terms used in angle evaluation. |
| `alpha` | scalar / `nSpr x 1` | Wrapped relative spring angle in `[0, 2*pi)`. |
| `J` | `6 x 1` | Gradient of `alpha` wrt spring nodal coordinates (`gradientAlpha`). |
| `H` | `6 x 6` | Hessian of `alpha` (`hessianAlpha`). |
| `alpha1`, `alpha2` | scalar | Transition angles for enriched spring law (currently `45 deg` and `315 deg` in `springStiffness`). |
| `k0` | scalar | Base spring stiffness parameter (input to enriched law). |
| `xi` | scalar | Branch-local transformed angle used in `tan`/`sec^2` branches. |
| `M` | scalar | Spring moment from enriched law. |
| `kT` (local) | scalar | Tangent spring stiffness returned by enriched law at current `alpha`. |
| `kSpring` | `6 x 6` | Consistent spring tangent matrix: `kT*(J*J') + M*H`. |
| `sprIntF` | `6 x 1` | Spring internal force contribution mapped into global vector. |

## Enriched spring energy variables (`core/enrichedSpringEnergy.m`)

| Variable | Type / Size | Meaning |
|---|---|---|
| `Es` | vector (`nSpr x 1`) | Strain energy per spring at current angle. |
| `L`, `M`, `R` | logical masks | Region masks for left barrier, linear region, right barrier. |
| `pl`, `pr` | vectors | Region scaling coefficients (`pi/alpha1`, `pi/(2*pi-alpha2)`). |

## Nonlinear solver state variables (`solver/*.m`)

| Variable | Type / Size | Meaning |
|---|---|---|
| `PRef` | `(nNodes*nDof) x 1` | Reference global load vector from prescribed nodal loads. |
| `maxIncr` | scalar | Maximum increments (load/displacement steps). |
| `maxIter`, `minIter` | scalar | Corrector iteration limits per increment. |
| `errTol`, `err` | scalar | Convergence tolerance and current normalized error. |
| `i`, `j` | scalar | Increment and iteration counters. |
| `R` | `nFree x 1` | Residual force on free DOFs (`external - internal`). |
| `lambda` | `maxIter x maxIncr` | Load-scaling parameters per iteration and increment. |
| `dU` | `(nNodes*nDof) x maxIter x maxIncr` | Incremental displacement corrections. |
| `dUR` | `nFree x maxIter x maxIncr` | Residual-driven displacement component (`Kff\\R`). |
| `dUP` | `nFree x maxIter x maxIncr` | Load-pattern displacement component (`Kff\\PRef`). |
| `U` | `(nNodes*nDof) x (maxIncr+1)` | Total displacement history in solver DOF ordering. |
| `dP` | `(nNodes*nDof) x maxIter x maxIncr` | Incremental load/reaction history. |
| `P` | `(nNodes*nDof) x (maxIncr+1)` | Total load/reaction history. |
| `alpha` | `nSpr x (maxIncr+1)` | Spring angle history. |
| `barIntForce`, `sprIntForce` | `(nNodes*nDof) x (maxIncr+1)` | Running internal force histories. |
| `intForce` | `(nNodes*nDof) x (maxIncr+1)` | Total internal force history (`bar + spring`). |
| `coordsPrev` | `nNodes x 2` | Previous-iteration coordinates for incremental force recovery. |
| `nodeLoc` | `nNodes x nDof x (maxIncr+1)` | Nodal positions per increment. |
| `nodeForce` | `nNodes x nDof x (maxIncr+1)` | Nodal loads/reactions per increment. |
| `numSteps` | scalar | Stored as `maxIncr` in output struct for plotting loops. |

## Solver-specific control variables

| Variable | Solver(s) | Meaning |
|---|---|---|
| `eta` | `solverALCM` | Arc-length scaling parameter in denominator term. |
| `arcLength` | `solverALCM` | Arc-length radius used for predictor step. |
| `dirSign` | `solverALCM`, `solverGDCM`, `solverAL_GDCM`, `solverDCM` | Sign flag to follow/reverse equilibrium path direction. |
| `loadFactor` | `solverLCM`, `solverGDCM`, `solverAL_GDCM` | Fixed step factor (or seed factor for adaptive updates). |
| `GSP` | `solverGDCM` | Generalized stiffness parameter history for adaptive scaling. |
| `gamma` | `solverAL_GDCM` | Exponent for auto-step scaling using `CSP`. |
| `CSP` | `solverAL_GDCM` | Current stiffness parameter history. |
| `autoLoadStep` | `solverAL_GDCM` | User choice for fixed vs automatic load stepping. |
| `ctrlUIdx` | `solverDCM` signature | Intended control DOF index for displacement control input (currently not used internally). |

## Post-processing variables (`post/`)

| Variable | Type / Size | Meaning |
|---|---|---|
| `externalWork` | `1 x (numSteps+1)` | Cumulative external work by trapezoidal integration of `P` over `U`. |
| `springEnergy` | `1 x (numSteps+1)` | Sum of per-spring energies from `enrichedSpringEnergy`. |
| `barEnergy` | `1 x (numSteps+1)` | Incremental bar internal work accumulation. |
| `internalWork` | `1 x (numSteps+1)` | Total internal energy (`barEnergy + springEnergy`). |
| `energyDiff` | `1 x (numSteps+1)` | Absolute mismatch between external and internal energy. |
| `relativeError` | scalar (%) | Max relative energy-balance error. |
| `barThickness` | scalar | Visualization scale proportional to mean undeformed bar length. |
| `triSize` | scalar | Support symbol size in rendering. |
| `videoFile` | string | Output path for deformation video. |
| `v` | `VideoWriter` | Video writer handle. |
| `dofList` | vector | Optional free-DOF list to plot in `plotForceDisp`. |

## Output struct fields expected by plotting functions

`plotStructure`, `plotForceDisp`, and `plotEnergy` require these fields in solver output:

- Geometry/state: `links`, `springs`, `restraint`, `force`, `L0`, `nodeLoc`, `nodeForce`, `numSteps`
- Response histories: `U`, `P`, `alpha`, `alpha0`, `kT`, `barIntForce`
- Metadata: `nFree`, `identity`

## Notes

- Arrays used as indices (`links`, `springs`, `mapBars`, `mapSprings`, `identity`) are MATLAB `double` values but logically integer IDs.
- Free DOFs are always ordered first in global vectors/matrices.
- In active nonlinear solvers, displacement history is stored in `U` (not `delta`).
