# Three-Node Torsional Spring (3NTS) Structural Analysis Toolkit

This repository contains a MATLAB framework for 2D bar-linkage structural analysis with three-node torsional springs (3NTS). The implementation combines axial bar elements, geometric nonlinearity, and an enriched rotational spring law that stiffens near angle limits.

## What the code does

- Builds hybrid bar-plus-3NTS models from structure loaders in `structures/`.
- Assembles tangent stiffness and internal force contributions in `core/`.
- Solves nonlinear response using multiple incremental-iterative schemes in `solver/`.
- Produces deformation videos and force/energy plots from `post/`.
- Includes benchmark and application scripts (`validate*.m`, `test*.m`).

## Repository layout

| Path | Purpose |
|---|---|
| `core/` | Element and assembly routines (`barForceRec`, `globalStiffness`, `springStiffness`, enriched spring law helpers, DOF mapping). |
| `solver/` | Nonlinear solution methods (`solverLCM`, `solverALCM`, `solverGDCM`, `solverAL_GDCM`, `solverDCM`). |
| `structures/` | Problem definitions returning a standardized `params` struct. |
| `post/` | Plotting and drawing helpers (`plotStructure`, `plotEnergy`, `plotForceDisp`). |
| `videos/` | Rendered deformation videos (`.mp4`). |
| `validateTestStructure.m`, `validateVertCol.m` | Validation scripts versus analytical references. |
| `testSquareUnit.m`, `testShallowArch.m`, `testFourBarUnit.m`, `testStackedSquares.m` | Scenario scripts for mechanism-level studies. |
| `variableReference.md` | Variable dictionary across loaders, core, solvers, and post-processing. |

## Requirements

- MATLAB R2022b or newer (tested with newer 2026-era scripts in this repository).
- Base MATLAB only for core solver execution.
- `sixBarLinkage.m` uses `fsolve` (`optimoptions`), so that script needs Optimization Toolbox.

## How to run

### Script-driven runs (recommended)

Run one of the prepared scripts directly in MATLAB after `cd` into the repo:

- `validateTestStructure`
- `validateVertCol`
- `testSquareUnit`
- `testStackedSquares`
- `testShallowArch`
- `testFourBarUnit`

These scripts add paths (`core`, `solver`, `structures`, `post`) and call a solver explicitly.

### Interactive run (`main.m`)

`main.m` still provides structure/solver menus and post-processing in one flow.

Current note: the menu text in `main.m` still references legacy solver names (`eigenValueAnalysis`, `elasticFirstOrder`, `eulerSolver`) that are not present in the current `solver/` folder. Active scripts in this repository use the newer solver files listed below.

## Available solvers in `solver/`

| Function | Method summary |
|---|---|
| `solverLCM` | Load Control Method (Newton-Raphson style correction with fixed load stepping). |
| `solverALCM` | Arc Length Control Method with predictor-corrector updates. |
| `solverGDCM` | Generalized Displacement Control Method with adaptive generalized stiffness parameter scaling. |
| `solverAL_GDCM` | Arc-length-like formulation with optional auto/fixed load stepping and stiffness-based scaling. |
| `solverDCM` | Displacement Control Method variant (currently implemented but uses symbols/functions not present elsewhere in the repo; treat as experimental). |

## Available structure loaders

- `loadTestStructure`
- `loadVertColumn`
- `loadCantileverTruss`
- `load2UnitCantileverTruss`
- `loadShallowArch`
- `loadWarrenTruss`
- `loadSquareUnit`
- `loadStackedSquaresSym`
- `loadStackedSquaresAsym`
- `loadColBars`

All loaders return the same `params` fields (geometry, boundary conditions, material, indexing maps), so they are interchangeable across solvers.

## Spring constitutive behavior

The 3NTS element in `core/springStiffness.m` computes the relative angle

`alpha = mod(atan2(S, C) + 2*pi, 2*pi)`

and applies an enriched piecewise law (`core/enrichedSpringLaw.m`):

- Linear response in the mid-range (`alpha1 <= alpha <= alpha2`).
- Nonlinear tangent hardening near the lower/upper limits using `tan`/`sec^2` branches.
- The tangent stiffness increases rapidly as `alpha` approaches `0` or `2*pi`.

This behavior is also used in spring energy post-processing (`core/enrichedSpringEnergy.m`, `post/plotEnergy.m`).

## Output products

- Deformation video: `videos/StructuralDeformation<CaseName>.mp4`
- Load-displacement figure: from `plotForceDisp`
- Energy balance figure: from `plotEnergy`

## Notes for extension

- Add new structures by following any `structures/load*.m` template and preserving field names in the returned `params` struct.
- Add new solvers by reusing `globalStiffness`, `partitionStiffness`, `barInfo`, `springInfo`, and the DOF mapping utilities.
- Use `variableReference.md` as the source of truth for array dimensions and naming conventions.

## Citation

If you publish results based on this repository, cite the associated technical note:

> Patil, H. Y., Filipov, E. T. Three-node torsional spring element formulation for the analysis of reconfigurable bar-linked structures. ASME Journal of Applied Mechanics (in press).
