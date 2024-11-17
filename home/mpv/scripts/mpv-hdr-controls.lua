-- ~/.config/mpv/scripts/hdr_controls.lua
local mp = require('mp')

-- Table of tone mapping algorithms
local tone_mapping_options = {"bt.2390", "hable", "mobius"}
local current_tone_mapping = 1

-- Table of HDR peak values
local peak_values = {100, 200, 400, 800, 1000}
local current_peak = 1

-- Function to cycle tone mapping
function cycle_tone_mapping()
    current_tone_mapping = current_tone_mapping % #tone_mapping_options + 1
    local new_tone_mapping = tone_mapping_options[current_tone_mapping]
    mp.set_property("tone-mapping", new_tone_mapping)
    mp.osd_message(string.format("Tone Mapping: %s", new_tone_mapping))
end

-- Function to cycle HDR peak values
function cycle_peak_values()
    current_peak = current_peak % #peak_values + 1
    local new_peak = peak_values[current_peak]
    mp.set_property_number("target-peak", new_peak)
    mp.osd_message(string.format("HDR Peak: %d nits", new_peak))
end

-- Register key bindings
mp.add_key_binding("h", "cycle-tone-mapping", cycle_tone_mapping)
mp.add_key_binding("H", "cycle-peak-values", cycle_peak_values)
