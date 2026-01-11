# Recharts Flutter Port - Comprehensive Plan

## Overview

This document outlines the complete plan for porting [recharts](https://github.com/recharts/recharts) to Flutter. Recharts is a React charting library built on top of D3 with a declarative, component-based API.

**Goal:** Create a 1:1 Flutter port with the same declarative widget-based API, matching behavior, and comprehensive test coverage.

---

## Source Analysis

### Codebase Size

| Metric | Value |
|--------|-------|
| Total TypeScript/TSX in `src/` | ~40,000 lines |
| Test files | 240 files |
| Test LOC | ~50,000+ lines |

### Rendering Approach

Recharts uses **SVG** for all rendering:
- Root `<svg>` element via `Surface` component
- All chart elements rendered as SVG primitives (`<path>`, `<rect>`, `<circle>`, `<g>`, etc.)
- Tooltips rendered as HTML via React portals

**Flutter equivalent:** `CustomPainter` with Canvas drawing APIs. Conceptually similar but imperative rather than declarative at the paint level.

---

## Architecture Mapping

### Core Components

| Recharts Module | Purpose | Flutter Equivalent |
|-----------------|---------|-------------------|
| `chart/` | Chart orchestrators (CartesianChart, PolarChart) | Top-level chart widgets |
| `container/` | SVG surface, layers, event wrapper | `CustomPaint`, `Stack`, `GestureDetector` |
| `component/` | Tooltip, Legend, Label, Brush, Text | Flutter widgets layered above canvas |
| `cartesian/` | Line, Area, Bar, Scatter, Axes, Grid | Series configs + painters |
| `polar/` | Pie, Radar, RadialBar, polar axes | Polar series configs + painters |
| `shape/` | Primitive shapes (Curve, Rectangle, Sector) | Canvas draw methods |
| `state/` | Redux slices, selectors, middleware | Riverpod providers + notifiers |
| `context/` | React contexts for ambient state | Riverpod scoped providers |
| `animation/` | JS animation manager, easing | `AnimationController` + `CurvedAnimation` |
| `util/` | Math, scales, data transforms | Pure Dart utilities (1:1 port) |
| `synchronisation/` | Cross-chart tooltip sync | Shared Riverpod providers |

### State Management

Recharts uses Redux with ~15 slices:

| Redux Slice | Purpose |
|-------------|---------|
| `chartDataSlice` | Raw data, computed data, brush window indexes |
| `layoutSlice` | Layout type, width, height, margins, scale |
| `cartesianAxisSlice` | X/Y/Z axis settings (domain, scale, ticks, orientation) |
| `polarAxisSlice` | Angle/radius axis settings |
| `graphicalItemsSlice` | Registered series (Line, Bar, Area, Pie, etc.) |
| `tooltipSlice` | Tooltip interaction state, payloads, settings |
| `legendSlice` | Legend entries, hidden/active state |
| `brushSlice` | Brush window state, drag handles |
| `optionsSlice` | Chart-level options (name, event types) |
| `rootPropsSlice` | Main chart props (baseValue, syncId, stackOffset) |
| `referenceElementsSlice` | ReferenceLine, ReferenceArea, ReferenceDot settings |
| `polarOptionsSlice` | Polar-specific options (startAngle, endAngle) |
| `errorBarSlice` | Error bar settings |
| `zIndexSlice` | Z-index registry for layering |

**Flutter mapping with Riverpod:**
- One provider family per "slice" concept
- Computed providers replace Redux selectors
- Controller classes replace middleware (expose methods like `onPointerMove`, `onPointerTap`)

### Event/Interaction Flow

```
Recharts:
1. DOM event (mouse/touch/keyboard)
2. RechartsWrapper captures event
3. Redux middleware processes event
4. Middleware calls selectors to compute active index/coordinate
5. Middleware dispatches tooltip state updates
6. Tooltip component re-renders from Redux state

Flutter:
1. GestureDetector/Listener captures event
2. ChartInteractionController processes event
3. Controller calls computed providers for hit testing
4. Controller updates tooltip provider state
5. Tooltip widget rebuilds from provider
```

---

## Technology Stack

| Concern | Recharts (React) | Flutter |
|---------|------------------|---------|
| Rendering | SVG elements | `CustomPainter` + Canvas |
| State management | Redux (~15 slices) | Riverpod |
| Animations | Custom JS animation manager + easing | `AnimationController` + `Tween` |
| Hit testing/gestures | DOM events + middleware | `GestureDetector` / `Listener` |
| Tooltips | Positioned HTML/SVG overlays | `Overlay` / `Stack` + `Positioned` |
| Responsive sizing | `ResizeObserver` wrapper | `LayoutBuilder` |
| Text rendering | SVG `<text>` | `TextPainter` |
| Legends | React components | Flutter widgets |
| Declarative composition | JSX children | Widget tree with `children` list |

---

## API Design

### Declarative Widget-Based API

The Flutter port will maintain the same declarative composition pattern:

**Recharts (JSX):**
```jsx
<LineChart width={400} height={300} data={data}>
  <XAxis dataKey="name" />
  <YAxis />
  <Line dataKey="value" stroke="#8884d8" />
  <Tooltip />
  <Legend />
</LineChart>
```

**Flutter:**
```dart
LineChart(
  width: 400,
  height: 300,
  data: data,
  children: [
    XAxis(dataKey: 'name'),
    YAxis(),
    LineSeries(dataKey: 'value', stroke: Color(0xFF8884D8)),
    ChartTooltip(),
    ChartLegend(),
  ],
)
```

### Imperative Aspects (Internal Only)

These are handled internally, not exposed to users:

| Aspect | Implementation |
|--------|----------------|
| Animation controllers | Owned by StatefulWidget, passed via providers |
| Tooltip state updates | Riverpod notifiers triggered by gesture callbacks |
| Brush drag handling | GestureDetector → provider state updates |

---

## Testing Strategy

### Test Parity with Recharts

Tests should be **1:1 ports** from recharts test suite where applicable:
- Same inputs
- Same expected outputs
- Same test file structure

### Test Types by Layer

| Layer | Test Type | Tools | Source |
|-------|-----------|-------|--------|
| Core math/utils | Unit tests | `flutter_test` | Port from `test/util/` |
| Scales | Unit tests | `flutter_test` | Port from `test/util/scale/` |
| State (Riverpod) | Unit tests | `flutter_test` + `riverpod` | Port from `test/state/selectors/` |
| Geometry computation | Unit tests | `flutter_test` | Port from `ChartUtils.spec.tsx`, `PolarUtils.spec.ts` |
| Painters | Golden tests | `golden_toolkit` | New - compare against reference screenshots |
| Interactions | Widget tests | `flutter_test` | Simulate gestures, assert state changes |
| Integration | Widget + golden | Both | Full chart rendering with data |

### Test Directory Structure

Mirror recharts structure:
```
test/
├── core/
│   ├── utils/
│   │   ├── data_utils_test.dart
│   │   ├── cartesian_utils_test.dart
│   │   └── polar_utils_test.dart
│   └── scale/
│       ├── linear_scale_test.dart
│       └── band_scale_test.dart
├── cartesian/
│   ├── line_test.dart
│   ├── area_test.dart
│   └── bar_test.dart
├── polar/
│   ├── pie_test.dart
│   └── radar_test.dart
├── components/
│   ├── tooltip_test.dart
│   └── legend_test.dart
├── state/
│   ├── axis_selectors_test.dart
│   └── tooltip_selectors_test.dart
└── helper/
    └── test_utils.dart
```

---

## Phased Implementation Plan

### Phase 0: Foundations (Effort: M-L)

**Goals:**
- Define core data models mirroring Recharts types
- Create `ChartController` / `ChartScope` concept
- Port core math & scale utilities
- Set up project structure and test infrastructure

**Deliverables:**
- Library skeleton: `lib/src/{core,cartesian,polar,components,state}`
- Ported utilities: `DataUtils`, `CartesianUtils`, `PolarUtils`
- Basic scale abstractions (linear, band, point)
- Stub `ChartWidget` with fixed size and empty `CustomPaint`

**Tests:**
- Unit tests for all ported utilities (1:1 from recharts)

**Dependencies:** None

---

### Phase 1: Static Cartesian Rendering (Effort: L)

**Goals:**
- Implement `CartesianChartWidget`
- Compute layout (plot area vs margins)
- Construct axis scales from settings and data
- Implement axis and series painters

**Deliverables:**
- `LineSeries`, `AreaSeries`, `BarSeries` config classes
- `XAxis`, `YAxis` config classes
- `CartesianGrid` config
- `CartesianChartPainter` that draws axes + all series
- Riverpod providers: `linePointsProvider`, `areaPointsProvider`, `barRectsProvider`, `cartesianScalesProvider`, `chartLayoutProvider`

**Tests:**
- Unit tests for layout computation
- Unit tests for scale construction
- Golden tests for static Line/Area/Bar charts

**Dependencies:** Phase 0

---

### Phase 2: Tooltip & Basic Interactions (Effort: M-L)

**Goals:**
- Implement axis-based tooltip (hover trigger only initially)
- Port Cartesian hit-testing logic
- Implement tooltip payload aggregation
- Create tooltip overlay widget
- Draw cursor/highlight in painter

**Deliverables:**
- `ChartInteractionController` with `onPointerMove`, `onPointerTap`, `onPointerExit`
- `TooltipController` or unified controller methods
- `TooltipOverlay` widget with default content
- Builder callback for custom tooltips
- Cursor/highlight drawing (axis line, active dot)
- Riverpod providers: `tooltipStateProvider`, `activeIndexProvider`, `activeCoordinateProvider`, `tooltipPayloadProvider`

**Tests:**
- Unit tests for hit-testing logic
- Widget tests for gesture → state updates
- Golden tests for tooltip rendering

**Dependencies:** Phase 1

---

### Phase 3: Cartesian Animations (Effort: M)

**Goals:**
- Add animated transitions for data changes
- Design generic animation helper
- Implement interpolation between old/new geometries
- Port easing curves from recharts

**Deliverables:**
- `ChartAnimationController` wrapper
- Animated `CartesianChartPainter` responding to animation progress
- Ported easing curves from `easing.ts`
- Interpolation logic for points/paths (from `AreaWithAnimation` patterns)

**Tests:**
- Unit tests for easing functions
- Unit tests for interpolation logic
- Widget tests for animation triggering

**Dependencies:** Phase 1 (can be done in parallel with Phase 2)

---

### Phase 4: Polar Charts (Effort: L)

**Goals:**
- Implement polar layout & scales
- Port polar coordinate utilities
- Implement Pie, RadialBar, Radar series
- Implement polar-aware tooltip

**Deliverables:**
- `PolarChartWidget` or extended `ChartWidget` with radial layout
- `PieSeries`, `RadialBarSeries`, `RadarSeries` configs and painters
- `PolarAngleAxis`, `PolarRadiusAxis`, `PolarGrid`
- Polar hit-testing using `inRangeOfSector`
- Riverpod providers: `polarScalesProvider`, `sectorGeometryProvider`

**Tests:**
- Unit tests for polar coordinate math
- Unit tests for `inRangeOfSector` hit testing
- Golden tests for Pie, Radar, RadialBar charts

**Dependencies:** Phase 0 (polar utils), Phase 2 (tooltip infrastructure)

---

### Phase 5: Extended Features (Effort: M-L)

**Goals:**
- Implement Legend with toggle functionality
- Implement Brush with panorama mini-chart
- Implement Reference elements
- Implement responsive behavior

**Deliverables:**
- `ChartLegend` widget with series toggling
- `ChartBrush` widget with mini-chart and drag handles
- `ReferenceLine`, `ReferenceArea`, `ReferenceDot` drawing
- `ResponsiveChart` wrapper using `LayoutBuilder`
- Riverpod providers: `legendEntriesProvider`, `brushWindowProvider`

**Tests:**
- Widget tests for legend toggling
- Widget tests for brush drag behavior
- Golden tests for reference elements
- Widget tests for responsive resizing

**Dependencies:** Phase 1-2 (Cartesian foundation)

---

### Phase 6: Advanced Charts (Effort: L-XL)

**Goals:**
- Implement Scatter with ZAxis and symbol shapes
- Implement Funnel with trapezoid geometry
- Implement Treemap with squarified layout algorithm
- Implement Sunburst with radial partition layout
- Implement Sankey with node/link routing

**Deliverables:**
- `ScatterSeries` with `ZAxis` support and symbol shapes
- `FunnelSeries` with trapezoid geometry
- `TreemapChart` with layout algorithm
- `SunburstChart` with radial partition layout
- `SankeyChart` with node/link layout and path shapes

**Tests:**
- Unit tests for layout algorithms
- Golden tests for each chart type
- Interaction tests for tooltips

**Dependencies:** Phase 0-2 foundation

---

### Phase 7: Synchronization & Polish (Effort: M)

**Goals:**
- Implement cross-chart synchronization (`syncId`)
- Implement z-index layering control
- Performance optimization
- API polish and documentation

**Deliverables:**
- `ChartSyncBus` or shared Riverpod provider for synced tooltips
- Flexible layering control via `Stack` ordering
- Performance optimizations (path batching, memoization)
- Complete API documentation

**Tests:**
- Integration tests for synced charts
- Performance benchmarks

**Dependencies:** Phase 2 (tooltip/interaction system)

---

## Complexity Summary

| Phase | Scope | Effort | Cumulative |
|-------|-------|--------|------------|
| 0 | Foundations | M | M |
| 1 | Static Cartesian | L | M-L |
| 2 | Tooltip & Interactions | M-L | L |
| 3 | Animations | M | L |
| 4 | Polar Charts | L | L-XL |
| 5 | Extended Features | M-L | XL |
| 6 | Advanced Charts | L-XL | XXL |
| 7 | Sync & Polish | M | XXL |

**Effort key:** S = 1-2 days, M = 3-5 days, L = 1-2 weeks, XL = 2-4 weeks

---

## Flutter-Specific Challenges

### 1. Text Measurement & Rotation

**Problem:** Recharts uses SVG `<text>` with CSS; Flutter requires `TextPainter` for measurement and manual layout.

**Solution:**
- Create `ChartTextPainter` utility class
- Handle rotated axis labels with transform matrices
- Pre-measure text to compute axis dimensions

### 2. Tooltip Overlay Positioning

**Problem:** Recharts uses `createPortal` to escape SVG clipping.

**Solution:**
- Use `Stack` for chart-local overlays
- Use `OverlayEntry` for global overlays if needed
- Transform chart coordinates to overlay coordinates accounting for padding/safe areas

### 3. Clipping for Animations

**Problem:** Recharts uses SVG `clipPath` for clip-based animations (e.g., area reveal).

**Solution:**
- Use `canvas.clipRect`/`clipPath` in painter
- Minimize path recalculation during animations

### 4. High Point Count Performance

**Problem:** Browsers handle many SVG segments well; Flutter Canvas needs optimization.

**Solution:**
- Use `Path` batching instead of individual draw calls
- Single painter for many points (e.g., scatter) vs many painters
- Consider `drawPoints` for large point sets

### 5. Customization Hooks

**Problem:** React accepts elements or render functions for customization (dot, label, tooltip.content).

**Solution:**
- Use builder callbacks: `Widget Function(BuildContext, SeriesDatum)`
- Prioritize common customization use cases first

### 6. Keyboard Accessibility

**Problem:** Recharts supports keyboard navigation via middleware.

**Solution:**
- Wire `Focus` and `Shortcuts` to chart widget
- Implement keyboard state machine similar to `KeyboardTooltipActionPayload`

### 7. Brush & Panorama

**Problem:** Two charts sharing data and state (main + mini panorama).

**Solution:**
- Single `ChartScope` with sub-layouts
- Or explicit child chart widget reading from parent providers

### 8. Scale/Tick Parity

**Problem:** Recharts uses D3 scales; small differences in tick rounding could appear.

**Solution:**
- Port scale algorithms carefully
- Test against recharts output for edge cases

---

## Utilities to Port Directly

These are pure functions with no DOM dependencies - port 1:1 to Dart:

### Geometry & Coordinates
- `CartesianUtils.ts` - `rectWithPoints`, `rectWithCoords`, `getAngledRectangleWidth`
- `PolarUtils.ts` - `RADIAN`, `degreeToRadian`, `radianToDegree`, `polarToCartesian`, `getMaxRadius`, `inRangeOfSector`

### Scales
- `RechartsScale.ts` - scale abstraction with `domain()`, `range()`, `bandwidth`, `ticks`, `map()`
- `getNiceTickValues.ts` - tick calculation

### Data Utilities
- `DataUtils.ts` - `interpolate`, `isNumber`, `isNil`, `getEveryNth`
- `getSliced.ts`, `round.ts`

### Stacking
- `util/stacks/*` - stack group computation, domain across stacks

### Tooltip
- `util/tooltip/*` - payload combination, domain computation
- `getActiveCoordinate.ts`, `getAxisTypeBasedOnLayout.ts`

---

## Project Structure

```
recharts_flutter/
├── lib/
│   ├── recharts_flutter.dart          # Main export
│   └── src/
│       ├── core/
│       │   ├── utils/
│       │   │   ├── data_utils.dart
│       │   │   ├── cartesian_utils.dart
│       │   │   └── polar_utils.dart
│       │   ├── scale/
│       │   │   ├── scale.dart
│       │   │   ├── linear_scale.dart
│       │   │   ├── band_scale.dart
│       │   │   └── point_scale.dart
│       │   └── types/
│       │       ├── chart_data.dart
│       │       ├── axis_types.dart
│       │       └── series_types.dart
│       ├── cartesian/
│       │   ├── cartesian_chart.dart
│       │   ├── axis/
│       │   │   ├── x_axis.dart
│       │   │   ├── y_axis.dart
│       │   │   └── cartesian_axis_painter.dart
│       │   ├── series/
│       │   │   ├── line_series.dart
│       │   │   ├── area_series.dart
│       │   │   ├── bar_series.dart
│       │   │   └── scatter_series.dart
│       │   └── grid/
│       │       └── cartesian_grid.dart
│       ├── polar/
│       │   ├── polar_chart.dart
│       │   ├── axis/
│       │   │   ├── polar_angle_axis.dart
│       │   │   └── polar_radius_axis.dart
│       │   └── series/
│       │       ├── pie_series.dart
│       │       ├── radar_series.dart
│       │       └── radial_bar_series.dart
│       ├── components/
│       │   ├── tooltip/
│       │   │   ├── chart_tooltip.dart
│       │   │   └── default_tooltip_content.dart
│       │   ├── legend/
│       │   │   ├── chart_legend.dart
│       │   │   └── default_legend_content.dart
│       │   └── brush/
│       │       └── chart_brush.dart
│       └── state/
│           ├── providers/
│           │   ├── chart_data_provider.dart
│           │   ├── layout_provider.dart
│           │   ├── axis_provider.dart
│           │   ├── series_provider.dart
│           │   ├── tooltip_provider.dart
│           │   └── legend_provider.dart
│           └── models/
│               ├── chart_state.dart
│               ├── tooltip_state.dart
│               └── interaction_state.dart
├── test/
│   ├── core/
│   │   ├── utils/
│   │   └── scale/
│   ├── cartesian/
│   ├── polar/
│   ├── components/
│   ├── state/
│   └── helper/
├── example/
│   └── lib/
│       └── main.dart
├── PORTING_PLAN.md
├── AGENTS.md
└── pubspec.yaml
```

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  golden_toolkit: ^0.15.0
  flutter_lints: ^3.0.0
```

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Over-committing to full feature parity | Document v1 scope clearly; defer Treemap/Sankey/Sunburst |
| Drift from recharts behavior | 1:1 test porting; visual regression tests |
| Customization API complexity | Start with common use cases; add builders incrementally |
| Performance with large datasets | Benchmark early; batch paths; use `drawPoints` |

---

## Success Criteria

### Phase 0-1 Complete
- [ ] Static Line, Area, Bar charts render correctly
- [ ] Golden tests pass matching reference images
- [ ] Core utility tests pass (1:1 from recharts)

### Phase 2-3 Complete
- [ ] Axis-based tooltip works with hover
- [ ] Animations play on data change
- [ ] Interaction tests pass

### Phase 4-5 Complete
- [ ] Pie, Radar, RadialBar charts render correctly
- [ ] Legend toggles series visibility
- [ ] Brush controls data window

### Full Port Complete
- [ ] All chart types from recharts supported
- [ ] Test coverage matches recharts
- [ ] API documentation complete
- [ ] Example app demonstrates all features
