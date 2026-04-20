// ARES-Node Debug Console Version
// Paste this into the debug console (Ctrl+D in mission)
// The marker array persists in missionNamespace

if (isNil "ARES_Node_Active") then {
    missionNamespace setVariable ["ARES_Node_Active", true];
    missionNamespace setVariable ["ARES_Node_Markers", []];
    missionNamespace setVariable ["ARES_Node_DisplayMode", "FULL_C2"];
    missionNamespace setVariable ["ARES_Node_LastZoom", 0];
    
    // Initialize CBA settings for zoom thresholds if CBA is available
    if (isClass (configFile >> "CfgPatches" >> "cba_main")) then {
        ["ARES_Node_Overview_Threshold", "SLIDER", ["Overview Zoom Threshold", "Zoom level below which Overview Mode activates"], ["ARES-Node", "C2 Settings"], [0.12, 0, 1, 2], 1] call CBA_Settings_fnc_register;
        ["ARES_Node_Tactical_Threshold", "SLIDER", ["Tactical Zoom Threshold", "Zoom level below which Tactical Mode activates"], ["ARES-Node", "C2 Settings"], [0.04, 0, 1, 2], 1] call CBA_Settings_fnc_register;
        ["ARES_Node_Network_Range", "SLIDER", ["Network Range", "Maximum transmission range in meters"], ["ARES-Node", "C2 Settings"], [4000, 500, 10000, 100], 1] call CBA_Settings_fnc_register;
    };
    
    systemChat "ARES-Node: Initialized. Starting C2 tracking...";
};

[] spawn {
    while {missionNamespace getVariable ["ARES_Node_Active", false]} do {
        private _activeMarkers = missionNamespace getVariable ["ARES_Node_Markers", []];
        private _maxRange = missionNamespace getVariable ["C2_Network_Range", 4000];
        private _overviewThreshold = missionNamespace getVariable ["ARES_Node_Overview_Threshold", 0.12];
        private _tacticalThreshold = missionNamespace getVariable ["ARES_Node_Tactical_Threshold", 0.04];

        // Multiple C2 devices check
        private _hasC2Device = (
            "ItemGPS" in assignedItems player ||
            "ItemcTab" in assignedItems player ||
            "ItemAndroid" in assignedItems player ||
            "ItemMicroDAGR" in assignedItems player
        );

        if (_hasC2Device) then {
            // Determine display mode based on map zoom with hysteresis to prevent flickering
            private _zoom = ctrlMapScale (findDisplay 12 displayCtrl 51);
            private _lastMode = missionNamespace getVariable ["ARES_Node_DisplayMode", "FULL_C2"];
            private _displayMode = _lastMode;
            private _hysteresis = 0.01; // Hysteresis margin to prevent rapid switching
            
            // Only switch mode if zoom crosses threshold + hysteresis margin
            if (_lastMode == "FULL_C2") then {
                if (_zoom > (_tacticalThreshold + _hysteresis)) then { _displayMode = "TACTICAL"; };
                if (_zoom > (_overviewThreshold + _hysteresis)) then { _displayMode = "OVERVIEW"; };
            };
            if (_lastMode == "TACTICAL") then {
                if (_zoom <= (_tacticalThreshold - _hysteresis)) then { _displayMode = "FULL_C2"; };
                if (_zoom > (_overviewThreshold + _hysteresis)) then { _displayMode = "OVERVIEW"; };
            };
            if (_lastMode == "OVERVIEW") then {
                if (_zoom <= (_overviewThreshold - _hysteresis)) then { _displayMode = "TACTICAL"; };
                if (_zoom <= (_tacticalThreshold - _hysteresis)) then { _displayMode = "FULL_C2"; };
            };
            
            missionNamespace setVariable ["ARES_Node_DisplayMode", _displayMode];

            {
                private _unit = _x;
                if (alive _unit && {side _unit == playerSide}) then {
                    
                    // Determine if this unit should be displayed based on mode
                    private _shouldDisplay = true;
                    if (_displayMode == "OVERVIEW") then {
                        // Overview: Only group and fireteam leads
                        private _group = group _unit;
                        _shouldDisplay = (_unit == leader _group);
                    };

                    if (_shouldDisplay) then {
                        private _group = group _unit;

                        private _roleIcon = "b_inf";
                        if (_unit getUnitTrait "Medic") then { _roleIcon = "b_med"; };
                        if (_unit getUnitTrait "ExplosiveSpecialist" || _unit getUnitTrait "Engineer") then { _roleIcon = "b_eng"; };
                        if (vehicle _unit != _unit) then {
                            _roleIcon = switch (true) do {
                                case (vehicle _unit isKindOf "Air"): { "b_air" };
                                case (vehicle _unit isKindOf "Tank"): { "b_armor" };
                                default { "b_motor_inf" };
                            };
                        };

                        private _markerEntry = _activeMarkers select {(_x select 1) == _unit};
                        private _mName = "";
                        private _lastUpdate = time;
                        
                        if (count _markerEntry > 0) then {
                            _mName = (_markerEntry select 0) select 0;
                            _lastUpdate = (_markerEntry select 0) select 2;
                        } else {
                            _mName = format ["c2_node_%1", hashValue _unit];
                            createMarkerLocal [_mName, getPosASL _unit];
                            _mName setMarkerShapeLocal "ICON";
                            _mName setMarkerSizeLocal [0.25, 0.25];
                            _activeMarkers pushBack [_mName, _unit, time];
                        };

                        private _isJammed = _unit getVariable ["GPS_IsJammed", false];
                        private _inRange = (player distance _unit < _maxRange);
                        
                        if (!_isJammed && _inRange) then {
                            _mName setMarkerPosLocal (getPosASL _unit);
                            _mName setMarkerDirLocal (getDir vehicle _unit);
                            _mName setMarkerAlphaLocal 1;
                            
                            private _myTeam = assignedTeam _unit;
                            private _mColor = "ColorWEST";
                            if (_myTeam isEqualType "") then {
                                _mColor = switch (_myTeam) do {
                                    case "RED": {"ColorRed"}; 
                                    case "BLUE": {"ColorBlue"}; 
                                    case "GREEN": {"ColorGreen"}; 
                                    case "YELLOW": {"ColorYellow"}; 
                                    default {"ColorWEST"}
                                };
                            } else {
                                _mColor = "ColorWEST";
                            };
                            _mName setMarkerColorLocal _mColor;
                            
                            _activeMarkers = _activeMarkers select {(_x select 1) != _unit};
                            _activeMarkers pushBack [_mName, _unit, time];
                        } else {
                            private _staleTime = time - _lastUpdate;
                            private _decay = (1 - (_staleTime / 60)) max 0.15;
                            _mName setMarkerAlphaLocal (_decay * (0.6 + (sin (time * 2) * 0.4)));
                            _mName setMarkerColorLocal "ColorGrey";
                        };

                        private _callsign = groupID _group;
                        private _unitName = name _unit;
                        
                        // Display mode-specific text
                        private _text = "";
                        if (_displayMode == "FULL_C2") then {
                            // Full C2: Show name, callsign, and AGL altitude
                            private _agl = (getPosASL _unit select 2) - (getTerrainHeightASL (getPosASL _unit));
                            _text = format ["%1 [%2] %3m", _unitName, _callsign, round _agl];
                        } else {
                            if (_displayMode == "TACTICAL") then {
                                // Tactical: Show only name and callsign, no text label
                                _text = "";
                            } else {
                                // Overview: Show only callsign
                                _text = _callsign;
                            };
                        };

                        _mName setMarkerTypeLocal _roleIcon;
                        _mName setMarkerTextLocal _text;
                    };
                    
                } else {
                    private _toDelete = _activeMarkers select {(_x select 1) == _unit};
                    {
                        deleteMarkerLocal ((_x) select 0);
                    } forEach _toDelete;
                    _activeMarkers = _activeMarkers select {(_x select 1) != _unit};
                };
            } forEach allUnits;
        } else {
            {
                (_x select 0) setMarkerAlphaLocal 0;
            } forEach _activeMarkers;
        };

        missionNamespace setVariable ["ARES_Node_Markers", _activeMarkers];
        sleep 1;
    };
};
