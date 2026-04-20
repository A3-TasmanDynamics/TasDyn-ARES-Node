# ARES-Node: Advanced Real-time Electronic Symbology
**Project Lead:** GamingPanthers
**Ecosystem:** Arma-Link Integration Suite
**Version:** 1.0.0
**Dependencies:** CBA_A3, DUI Squad Radar (Optional for color sync), ACE3

## I. MISSION STATEMENT
ARES-Node is a high-fidelity Command and Control (C2) and Blue Force Tracking (BFT) system. Designed to bridge the gap between individual situational awareness and high-level maneuver coordination, ARES-Node provides a "PhD-level" tactical interface that prioritizes data based on operational necessity.

## II. KEY CAPABILITIES
* **Dynamic Role-Based Symbology:** Utilizes NATO standard icons to differentiate Medics, Engineers, Pilots, and Armor units at a glance.
* **DUI Fireteam Synchronization:** Fully synced with the DUI Squad Radar color palette for instantaneous recognition of Red, Blue, Green, and Yellow fireteams.
* **Intelligent De-Cluttering:** * **Overview Mode:** Filters map to show only Group and Fireteam Leads.
    * **Tactical Mode:** Displays all unit icons while hiding text labels to preserve map clarity.
    * **Full C2 Mode:** Provides complete telemetry including unit names, team tags, and AGL (Above Ground Level) altitude reporting.
* **Electronic Warfare (EW) Simulation:** Implements "Last Known Position" (LKP) logic. Markers pulse and fade over 60 seconds if a unit is jammed or out of range, simulating real-world signal degradation.
* **Hardware Validation:** Requires active possession of C2-capable hardware (cTab, Android, MicroDAGR, or standard GPS).

## III. TECHNICAL SPECIFICATIONS
* **Logic Engine:** Optimized SQF using `HashMap` for O(1) lookup efficiency.
* **Network Footprint:** Zero. All markers are locally rendered via `createMarkerLocal` to ensure no impact on server bandwidth.
* **CBA Integration:** Custom sliders for zoom thresholds and network range located in Addon Options.

## IV. FIELD IMPLEMENTATION
1. Load the script/mod in your Arma 3 environment.
2. Ensure you have a GPS-enabled device in your assigned items.
3. Use the CBA Addon Options menu to calibrate zoom thresholds for specific terrain (e.g., Tanoa vs. Altis).
4. To simulate jamming on a specific node: 
   `this setVariable ["GPS_IsJammed", true, true];`

## V. DEVELOPER NOTES
ARES-Node is designed to function as the in-game situational awareness component of the broader 'Arma-Link' project, facilitating seamless coordination between field operators and tactical command elements.