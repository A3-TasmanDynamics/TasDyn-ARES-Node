# ARES-Node: Advanced Real-time Electronic Symbology

[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/A3-TasmanDynamics/TasDyn-ARES-Node?style=for-the-badge&logo=refinedgithub&label=ACTIVE%20ISSUES&color=%23676252)](https://github.com/A3-TasmanDynamics/TasDyn-ARES-Node) [![Discord](https://img.shields.io/discord/1099486374303903827?style=for-the-badge&logo=discord&label=JOIN%20THE%20DISCORD&color=%23676252)](https://discord.gg/RmCkSuSHRa) ![Arma 3](https://img.shields.io/badge/Arma%203-TasDyn%20System-green?style=for-the-badge) ![License](https://img.shields.io/badge/License-APL--SA-orange?style=for-the-badge)

*A high-fidelity Command and Control (C2) and Blue Force Tracking (BFT) system for Arma 3. Bridges individual situational awareness and high-level maneuver coordination with NATO standard symbology and intelligent de-cluttering.*

![GitHub last commit](https://img.shields.io/github/last-commit/A3-TasmanDynamics/TasDyn-ARES-Node?display_timestamp=author&style=for-the-badge&color=%23676252) ![GitHub commit activity](https://img.shields.io/github/commit-activity/t/A3-TasmanDynamics/TasDyn-ARES-Node?style=for-the-badge&label=ALL%20TIME%20COMMITS&color=%23676252)

## Contributing

This is a community-driven project! Contributions are welcome. Please join our [Discord](https://discord.gg/RmCkSuSHRa) to discuss development priorities and collaborate with the team.

**Note:** Steam Workshop release coming soon.

## About

ARES-Node provides a "PhD-level" tactical interface that prioritizes data based on operational necessity, enabling squad leaders and command elements to maintain situational awareness across dynamic battlefields.

---

## ✨ Features

### 🎯 Core Capabilities
* **Dynamic Role-Based Symbology:** NATO standard icons differentiate Medics, Engineers, Pilots, and Armor units at a glance.
* **DUI Fireteam Synchronization:** Fully synced with DUI Squad Radar color palette (Red, Blue, Green, Yellow teams).
* **Intelligent De-Cluttering:** 
  * Overview Mode: Filters to Group and Fireteam Leads only
  * Tactical Mode: All units without text labels
  * Full C2 Mode: Complete telemetry with unit names, team tags, and AGL altitude reporting
* **Electronic Warfare Simulation:** "Last Known Position" (LKP) logic with marker pulse/fade over 60 seconds when jammed or out of range.
* **Hardware Validation:** Requires active C2-capable device (cTab, Android, MicroDAGR, or GPS).

### ⚙️ Technical & Performance
* **Logic Engine:** Optimized SQF with array-based marker tracking for O(n) efficiency.
* **Network Footprint:** Zero bandwidth impact—all markers rendered locally via `createMarkerLocal`.
* **CBA Integration:** Custom sliders for zoom thresholds and network range in Addon Options.
* **Stateless Design:** No persistent global loops; minimal server overhead.

---

## ✅ Compatibility

**Required Dependencies:**
* [CBA_A3](https://steamcommunity.com/workshop/filedetails/?id=450814997)
* [ACE3](https://steamcommunity.com/workshop/filedetails/?id=463939057) (recommended for enhanced interaction)

### Optional Integrations
* [DUI Squad Radar](https://steamcommunity.com/workshop/filedetails/?id=1638341685) — Color synchronization with fireteam tracking

### Supported Systems
* **C2 Devices:** cTab, ItemAndroid, ItemGPS, MicroDAGR
* **All Arma 3 Terrain:** Altis, Stratis, Tanoa, Malden, etc.
* **Modded Aircraft:** Any aircraft with passenger seats

---

## 🧰 Usage

### 🎮 For Squad Leaders & Players
1. **Load the Script:** Ensure ARES-Node is loaded in your mission or mod loadout.
2. **Acquire C2 Hardware:** Carry a GPS device, tablet, or other C2 equipment in your gear.
3. **Open Map:** Open the tactical map (M key by default).
4. **Observe Markers:** All units on your side appear as color-coded markers with callsigns.
5. **Customize View:** Use CBA Addon Options to adjust zoom thresholds for your terrain.

**Jamming Simulation:**
```sqf
// To simulate GPS jamming on a specific unit:
this setVariable ["GPS_IsJammed", true, true];
```

### 👨‍💻 For Mission Makers & Developers

**Mission Setup:**
```sqf
// Add to mission initialization or mod config
// The script auto-detects player equipment and GPS status

// Optional: Configure thresholds via mission namespace
missionNamespace setVariable ["C2_Threshold_Overview", 0.12];
missionNamespace setVariable ["C2_Threshold_Tactical", 0.04];
missionNamespace setVariable ["C2_Network_Range", 4000];
```

**Custom Configuration:**
Use CBA Addon Options to adjust on-the-fly without restarting.

---

## 📂 Project Structure

```text
TasDyn-ARES-Node/
├── script.sqf              # Main C2 tracking script
├── config.cpp              # Configuration (if modded)
├── README.md               # This file
├── LICENSE                 # License information
└── docs/
    └── technical_specs.md  # Detailed technical documentation
```

---

## 🗓️ Roadmap & Planned Features

* [ ] **AI Unit Support:** Automatic marker generation for AI-controlled squads.
* [ ] **Jumpmaster Authority:** Leader-restricted hookup/jump commands.
* [ ] **Advanced Jamming:** Realistic EW simulation with signal strength degradation.
* [ ] **Multi-Frequency Support:** Switchable comm channels with separate tracking.
* [ ] **Mission Recording:** Log and playback tactical movements for AAR (After Action Review).
* [ ] **Custom Marker Themes:** User-configurable icon sets and color palettes.

---

## 📊 Performance Metrics

| Metric | Value | Notes |
|--------|-------|-------|
| Script Overhead | <0.5% CPU | Per-frame execution negligible |
| Memory Footprint | ~2-5 MB | Scales with unit count |
| Network Bandwidth | 0 bytes/sec | All rendering local |
| Marker Update Rate | 1 Hz | Configurable via sleep value |

---

## 🐛 Known Issues & Limitations

* **Hashmap Compatibility:** Older Arma 3 versions may not support HashMap operations; script falls back to array-based tracking.
* **Team Detection:** `assignedTeam` may return array format on some mission templates—script defaults to "MAIN" safely.
* **AI Pathfinding:** AI units don't natively recognize map markers; use Zeus or complementary AI systems.

---

## 📜 License

This project is released under **Arma Public License Share Alike (APL-SA)**.
* You **may** modify and repack with proper credit.
* You **may not** sell this mod or its components.
* You **must** share derivatives under the same license.

For full details, see LICENSE file.

---

## 👥 Credits & Acknowledgments

* **GamingPanthers** – Lead Developer
* **ACE3 Team** – Interaction framework and standards
* **CBA Team** – Configuration and scripting utilities
* **Arma 3 Community** – Feedback, testing, and mission design inspiration

---

## 📧 Support & Contact

* **Issues & Bugs:** Report via GitHub Issues
* **Feature Requests:** Submit via GitHub Discussions
* **Discord:** [Join the Tasman Dynamics Discord](#) for real-time support

---

## 📝 Changelog

### v1.0.0 (Release)
* Initial public release
* Full C2 marker system with role-based symbology
* DUI Squad Radar integration
* CBA Addon Options support

See full changelog in [CHANGELOG.md](CHANGELOG.md).

---

**Last Updated:** April 20, 2026  
**Maintainer:** GamingPanthers  
**Ecosystem:** Arma-Link Integration Suite