# Comprehensive Karabiner-Elements JSON Configuration Reference

## Overview and Setup

**Karabiner-Elements** is a powerful keyboard customizer for macOS that allows complex input device modifications through JSON configuration files. The latest version **v15.3.0** (January 2025) provides extensive capabilities for remapping keys, creating complex shortcuts, and customizing input behavior.

**Configuration file location**: `~/.config/karabiner/karabiner.json`  
**Official documentation**: https://karabiner-elements.pqrs.org/docs/  
**GitHub repository**: https://github.com/pqrs-org/Karabiner-Elements

## Complete JSON Configuration Structure

The root configuration file contains two main sections: global settings and profiles. Each profile can contain multiple modification types and device-specific configurations.

```json
{
  "global": {
    "check_for_updates_on_startup": true,
    "show_in_menu_bar": true,
    "show_profile_name_in_menu_bar": false
  },
  "profiles": [
    {
      "name": "Default profile",
      "selected": true,
      "parameters": {
        "delay_milliseconds_before_open_device": 1000
      },
      "simple_modifications": [],
      "fn_function_keys": [],
      "complex_modifications": {
        "parameters": {},
        "rules": []
      },
      "virtual_hid_keyboard": {
        "keyboard_type": "ansi",
        "caps_lock_delay_milliseconds": 0,
        "keyboard_type_v2": "ansi"
      },
      "devices": []
    }
  ]
}
```

## Top-Level Keys and Their Purposes

### Global Configuration Object
The `global` object controls application-wide settings:
- **`check_for_updates_on_startup`**: Boolean controlling automatic update checks
- **`show_in_menu_bar`**: Boolean controlling menu bar icon visibility
- **`show_profile_name_in_menu_bar`**: Boolean showing active profile name in menu bar

### Profile Configuration Keys
Each profile object supports these keys:
- **`name`**: String identifier for the profile
- **`selected`**: Boolean indicating if this is the active profile
- **`parameters`**: Object containing timing and behavior parameters
- **`simple_modifications`**: Array of basic key-to-key remappings
- **`fn_function_keys`**: Array of function key remappings
- **`complex_modifications`**: Object containing advanced modification rules
- **`virtual_hid_keyboard`**: Object configuring virtual keyboard properties
- **`devices`**: Array of device-specific configurations

## Simple Modifications Syntax

Simple modifications provide straightforward key-to-key remapping without conditions or advanced features.

```json
"simple_modifications": [
  {
    "from": {
      "key_code": "caps_lock"
    },
    "to": [
      {
        "key_code": "escape"
      }
    ]
  },
  {
    "from": {
      "consumer_key_code": "f1"
    },
    "to": [
      {
        "consumer_key_code": "display_brightness_decrement"
      }
    ]
  }
]
```

## Complex Modifications Detailed Syntax

Complex modifications enable sophisticated input handling with conditions, multiple outputs, and timing controls.

### Rule Structure
```json
"complex_modifications": {
  "parameters": {
    "basic.simultaneous_threshold_milliseconds": 50,
    "basic.to_delayed_action_delay_milliseconds": 500,
    "basic.to_if_alone_timeout_milliseconds": 1000,
    "basic.to_if_held_down_threshold_milliseconds": 500
  },
  "rules": [
    {
      "description": "Change caps_lock to control when held, escape when tapped",
      "manipulators": []
    }
  ]
}
```

### Manipulator Types and Structure
The primary manipulator type is `"basic"`, which handles all keyboard and mouse input transformations:

```json
{
  "type": "basic",
  "from": {
    "key_code": "caps_lock",
    "modifiers": {
      "mandatory": ["left_shift"],
      "optional": ["any"]
    }
  },
  "to": [
    {
      "key_code": "left_control"
    }
  ],
  "to_if_alone": [
    {
      "key_code": "escape"
    }
  ],
  "to_if_held_down": [
    {
      "key_code": "left_control"
    }
  ],
  "to_after_key_up": [
    {
      "set_variable": {
        "name": "caps_lock_pressed",
        "value": 0
      }
    }
  ],
  "to_delayed_action": {
    "to_if_invoked": [
      {
        "key_code": "escape"
      }
    ],
    "to_if_canceled": [
      {
        "key_code": "vk_none"
      }
    ]
  },
  "conditions": [],
  "parameters": {
    "basic.to_if_alone_timeout_milliseconds": 250
  },
  "description": "Optional description"
}
```

## Complete Key Codes Reference

### Standard Keyboard Keys
**Letters**: `a` through `z`  
**Numbers**: `1` through `0`  
**Function keys**: `f1` through `f24`

### Modifier Keys
- **Command**: `left_command`, `right_command`, `command` (any)
- **Control**: `left_control`, `right_control`, `control` (any)
- **Option/Alt**: `left_option`, `right_option`, `option` (any)
- **Shift**: `left_shift`, `right_shift`, `shift` (any)
- **Function**: `fn`
- **Caps Lock**: `caps_lock`

### Navigation Keys
- **Arrows**: `up_arrow`, `down_arrow`, `left_arrow`, `right_arrow`
- **Page navigation**: `page_up`, `page_down`, `home`, `end`
- **Editing**: `delete_or_backspace`, `delete_forward`, `insert`

### Special Keys
- **Return/Enter**: `return_or_enter`
- **Tab**: `tab`
- **Space**: `spacebar`
- **Escape**: `escape`
- **Print Screen**: `print_screen`
- **Scroll Lock**: `scroll_lock`
- **Pause**: `pause`
- **Power**: `power`
- **Help**: `help`
- **Application**: `application`

### Punctuation and Symbol Keys
- `hyphen` (-), `equal_sign` (=)
- `open_bracket` ([), `close_bracket` (])
- `backslash` (\\), `slash` (/)
- `semicolon` (;), `quote` (')
- `grave_accent_and_tilde` (`), `comma` (,), `period` (.)

### International Keys
- `international1` through `international9`
- `lang1` through `lang9`
- `japanese_eisuu`, `japanese_kana`
- `japanese_pc_nfer`, `japanese_pc_xfer`, `japanese_pc_katakana`

### Keypad Keys
- **Numbers**: `keypad_0` through `keypad_9`
- **Operations**: `keypad_plus`, `keypad_hyphen`, `keypad_asterisk`, `keypad_slash`
- **Special**: `keypad_period`, `keypad_equal_sign`, `keypad_comma`, `keypad_enter`
- **Lock**: `keypad_num_lock`

### Consumer Key Codes (Media Keys)
- **Display**: `display_brightness_increment`, `display_brightness_decrement`
- **Keyboard illumination**: `illumination_increment`, `illumination_decrement`
- **Media playback**: `rewind`, `play_or_pause`, `fastforward`
- **Volume**: `mute`, `volume_increment`, `volume_decrement`
- **Mission Control**: `mission_control`, `launchpad`, `dashboard`
- **Other**: `eject`, `apple_display_brightness_increment`, `apple_display_brightness_decrement`

### Pointing Buttons
- `button1` through `button32` (mouse buttons)

### Virtual Keys
- `vk_none` - Disables the key
- `vk_consumer_brightness_up`, `vk_consumer_brightness_down`
- `vk_mission_control`, `vk_launchpad`, `vk_dashboard`
- `vk_consumer_illumination_up`, `vk_consumer_illumination_down`
- `vk_consumer_rewind`, `vk_consumer_play`, `vk_consumer_fastforward`
- `vk_consumer_mute`, `vk_consumer_volume_up`, `vk_consumer_volume_down`

## Event Types and Definitions

### From Event Definition
The `from` event supports multiple input types and modifier combinations:

```json
"from": {
  "key_code": "a",
  "consumer_key_code": "mute",
  "pointing_button": "button2",
  "any": "key_code",
  "modifiers": {
    "mandatory": ["left_command", "left_shift"],
    "optional": ["any"]
  },
  "simultaneous": [
    {"key_code": "j"},
    {"key_code": "k"}
  ],
  "simultaneous_options": {
    "detect_key_down_uninterruptedly": false,
    "key_down_order": "insensitive",
    "key_up_order": "insensitive",
    "key_up_when": "any",
    "to_after_key_up": [
      {"set_variable": {"name": "simultaneous_jk", "value": 0}}
    ]
  }
}
```

### To Event Definitions
The `to` event supports numerous output types:

#### Key Events
```json
{
  "key_code": "escape",
  "consumer_key_code": "play_or_pause",
  "pointing_button": "button3",
  "modifiers": ["left_command", "left_shift"],
  "lazy": false,
  "repeat": true,
  "halt": false,
  "hold_down_milliseconds": 100
}
```

#### Shell Commands
```json
{
  "shell_command": "open -a 'Visual Studio Code'"
}
```

#### Input Source Selection
```json
{
  "select_input_source": {
    "language": "en",
    "input_source_id": "com.apple.keylayout.US",
    "input_mode_id": "com.apple.inputmethod.Japanese.Hiragana"
  }
}
```

#### Variable Management
```json
{
  "set_variable": {
    "name": "my_mode",
    "value": 1,
    "key_up_value": 0
  }
}
```

#### Notification Messages
```json
{
  "set_notification_message": {
    "id": "mode_notification",
    "text": "Insert mode activated"
  }
}
```

#### Mouse Control
```json
{
  "mouse_key": {
    "x": 100,
    "y": -50,
    "vertical_wheel": -32,
    "horizontal_wheel": 0,
    "speed_multiplier": 2.0
  }
}
```

#### Sticky Modifiers
```json
{
  "sticky_modifier": {
    "left_command": "toggle",
    "left_control": "on",
    "left_option": "off",
    "left_shift": "toggle",
    "right_command": "toggle",
    "right_control": "toggle",
    "right_option": "toggle",
    "right_shift": "toggle",
    "fn": "toggle"
  }
}
```

#### Software Functions
```json
{
  "software_function": {
    "cg_event_double_click": {
      "button": 0
    },
    "iokit_power_management_sleep_system": {},
    "open_application": {
      "bundle_identifier": "com.apple.Safari",
      "file_paths": ["/Applications/Safari.app"]
    },
    "set_mouse_cursor_position": {
      "x": 500,
      "y": 300,
      "screen": 0
    }
  }
}
```

## Conditions and Filters Syntax

### Application Conditions
```json
{
  "type": "frontmost_application_if",
  "bundle_identifiers": [
    "^com\\.apple\\.Terminal$",
    "^com\\.googlecode\\.iterm2$",
    "^com\\.microsoft\\.VSCode$"
  ],
  "file_paths": [
    "/Applications/Terminal.app/Contents/MacOS/Terminal"
  ]
}
```

### Device Conditions
```json
{
  "type": "device_if",
  "identifiers": [
    {
      "vendor_id": 1452,
      "product_id": 832,
      "location_id": 336592896,
      "is_keyboard": true,
      "is_pointing_device": false,
      "is_built_in_keyboard": false
    }
  ]
}
```

### Variable Conditions
```json
{
  "type": "variable_if",
  "name": "vim_mode",
  "value": 1
}
```

### Input Source Conditions
```json
{
  "type": "input_source_if",
  "input_sources": [
    {
      "language": "^en$",
      "input_source_id": "^com\\.apple\\.keylayout\\.US$",
      "input_mode_id": "^com\\.apple\\.inputmethod\\.Japanese\\.Hiragana$"
    }
  ]
}
```

### Keyboard Type Conditions
```json
{
  "type": "keyboard_type_if",
  "keyboard_types": ["ansi", "iso", "jis"]
}
```

### Event Changed Conditions
```json
{
  "type": "event_changed_if",
  "value": true
}
```

## Variables and Parameters

### Global Parameters
```json
"parameters": {
  "basic.simultaneous_threshold_milliseconds": 50,
  "basic.to_delayed_action_delay_milliseconds": 500,
  "basic.to_if_alone_timeout_milliseconds": 1000,
  "basic.to_if_held_down_threshold_milliseconds": 500,
  "mouse_motion_to_scroll.speed": 100
}
```

### Parameter Descriptions
- **`basic.simultaneous_threshold_milliseconds`**: Maximum time between simultaneous key presses (default: 50)
- **`basic.to_if_alone_timeout_milliseconds`**: Maximum time for `to_if_alone` to trigger (default: 1000)
- **`basic.to_if_held_down_threshold_milliseconds`**: Minimum hold time for `to_if_held_down` (default: 500)
- **`basic.to_delayed_action_delay_milliseconds`**: Delay before `to_delayed_action` triggers (default: 500)

## Device-Specific Configurations

```json
"devices": [
  {
    "identifiers": {
      "vendor_id": 1452,
      "product_id": 635,
      "is_keyboard": true,
      "is_pointing_device": false
    },
    "ignore": false,
    "disable_built_in_keyboard_if_exists": false,
    "fn_function_keys": [],
    "manipulate_caps_lock_led": true,
    "simple_modifications": [],
    "treat_as_built_in_keyboard": false
  }
]
```

## Function Key Remapping

```json
"fn_function_keys": [
  {
    "from": {"key_code": "f1"},
    "to": [{"consumer_key_code": "display_brightness_decrement"}]
  },
  {
    "from": {"key_code": "f2"},
    "to": [{"consumer_key_code": "display_brightness_increment"}]
  },
  {
    "from": {"key_code": "f3"},
    "to": [{"apple_vendor_keyboard_key_code": "mission_control"}]
  },
  {
    "from": {"key_code": "f4"},
    "to": [{"apple_vendor_keyboard_key_code": "spotlight"}]
  },
  {
    "from": {"key_code": "f5"},
    "to": [{"consumer_key_code": "dictation"}]
  },
  {
    "from": {"key_code": "f6"},
    "to": [{"key_code": "f6"}]
  },
  {
    "from": {"key_code": "f7"},
    "to": [{"consumer_key_code": "rewind"}]
  },
  {
    "from": {"key_code": "f8"},
    "to": [{"consumer_key_code": "play_or_pause"}]
  },
  {
    "from": {"key_code": "f9"},
    "to": [{"consumer_key_code": "fast_forward"}]
  },
  {
    "from": {"key_code": "f10"},
    "to": [{"consumer_key_code": "mute"}]
  },
  {
    "from": {"key_code": "f11"},
    "to": [{"consumer_key_code": "volume_decrement"}]
  },
  {
    "from": {"key_code": "f12"},
    "to": [{"consumer_key_code": "volume_increment"}]
  }
]
```

## Mouse and Pointing Device Configurations

### Mouse Movement Control
```json
{
  "to": [
    {
      "mouse_key": {
        "x": 1000,
        "y": 0,
        "speed_multiplier": 1.0
      }
    }
  ]
}
```

### Scroll Wheel Control
```json
{
  "to": [
    {
      "mouse_key": {
        "vertical_wheel": -64,
        "horizontal_wheel": 0,
        "speed_multiplier": 1.5
      }
    }
  ]
}
```

### Mouse Button Remapping
```json
{
  "from": {
    "pointing_button": "button4"
  },
  "to": [
    {
      "key_code": "left_command",
      "modifiers": ["left_option"]
    }
  ]
}
```

## Virtual HID Keyboard Settings

```json
"virtual_hid_keyboard": {
  "keyboard_type": "ansi",
  "keyboard_type_v2": "ansi",
  "caps_lock_delay_milliseconds": 0,
  "country_code": 0,
  "mouse_key_xy_scale": 100
}
```

### Keyboard Types
- **`ansi`**: Standard US keyboard layout
- **`iso`**: European keyboard layout
- **`jis`**: Japanese keyboard layout

## Common Keyboard Shortcut Modifications

### Hyper Key (Caps Lock as Cmd+Ctrl+Opt+Shift)
```json
{
  "description": "Caps Lock → Hyper Key (⌃⌥⇧⌘)",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "caps_lock",
        "modifiers": {"optional": ["any"]}
      },
      "to": [
        {
          "key_code": "left_shift",
          "modifiers": ["left_command", "left_control", "left_option"]
        }
      ],
      "to_if_alone": [
        {"key_code": "escape"}
      ]
    }
  ]
}
```

### Vi-Style Arrow Keys
```json
{
  "description": "Vi style arrows",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "h",
        "modifiers": {
          "mandatory": ["left_control"],
          "optional": ["any"]
        }
      },
      "to": [{"key_code": "left_arrow"}]
    },
    {
      "type": "basic",
      "from": {
        "key_code": "j",
        "modifiers": {
          "mandatory": ["left_control"],
          "optional": ["any"]
        }
      },
      "to": [{"key_code": "down_arrow"}]
    },
    {
      "type": "basic",
      "from": {
        "key_code": "k",
        "modifiers": {
          "mandatory": ["left_control"],
          "optional": ["any"]
        }
      },
      "to": [{"key_code": "up_arrow"}]
    },
    {
      "type": "basic",
      "from": {
        "key_code": "l",
        "modifiers": {
          "mandatory": ["left_control"],
          "optional": ["any"]
        }
      },
      "to": [{"key_code": "right_arrow"}]
    }
  ]
}
```

### Application Launcher
```json
{
  "description": "Launch applications with Cmd+Space",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "t",
        "modifiers": {"mandatory": ["left_command", "left_control"]}
      },
      "to": [
        {"shell_command": "open -a Terminal"}
      ]
    },
    {
      "type": "basic",
      "from": {
        "key_code": "c",
        "modifiers": {"mandatory": ["left_command", "left_control"]}
      },
      "to": [
        {"shell_command": "open -a 'Visual Studio Code'"}
      ]
    }
  ]
}
```

## Advanced Techniques

### Leader Key Implementation
```json
{
  "description": "Space as leader key",
  "manipulators": [
    {
      "type": "basic",
      "from": {"key_code": "spacebar"},
      "to": [
        {"set_variable": {"name": "leader_active", "value": 1}}
      ],
      "to_if_alone": [
        {"key_code": "spacebar"}
      ],
      "to_delayed_action": {
        "to_if_invoked": [
          {"set_variable": {"name": "leader_active", "value": 0}}
        ],
        "to_if_canceled": [
          {"set_variable": {"name": "leader_active", "value": 0}}
        ]
      },
      "parameters": {
        "basic.to_delayed_action_delay_milliseconds": 500
      }
    },
    {
      "type": "basic",
      "from": {"key_code": "f"},
      "to": [
        {"shell_command": "open ~"},
        {"set_variable": {"name": "leader_active", "value": 0}}
      ],
      "conditions": [
        {"type": "variable_if", "name": "leader_active", "value": 1}
      ]
    }
  ]
}
```

### Simultaneous Key Detection
```json
{
  "description": "F+J to Enter",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "simultaneous": [
          {"key_code": "f"},
          {"key_code": "j"}
        ],
        "simultaneous_options": {
          "key_down_order": "insensitive",
          "key_up_order": "insensitive",
          "key_up_when": "any",
          "detect_key_down_uninterruptedly": false
        },
        "modifiers": {"optional": ["any"]}
      },
      "to": [
        {"key_code": "return_or_enter"}
      ]
    }
  ]
}
```

### Mode Switching
```json
{
  "description": "Toggle insert mode",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "i",
        "modifiers": {"mandatory": ["left_control"]}
      },
      "to": [
        {"set_variable": {"name": "insert_mode", "value": 1}},
        {"set_notification_message": {"id": "mode", "text": "Insert Mode"}}
      ],
      "conditions": [
        {"type": "variable_unless", "name": "insert_mode", "value": 1}
      ]
    },
    {
      "type": "basic",
      "from": {"key_code": "escape"},
      "to": [
        {"set_variable": {"name": "insert_mode", "value": 0}},
        {"set_notification_message": {"id": "mode", "text": "Normal Mode"}}
      ],
      "conditions": [
        {"type": "variable_if", "name": "insert_mode", "value": 1}
      ]
    }
  ]
}
```

### Key Sequences
```json
{
  "description": "Double tap shift for caps lock",
  "manipulators": [
    {
      "type": "basic",
      "from": {"key_code": "left_shift"},
      "to": [{"key_code": "left_shift"}],
      "to_if_alone": [
        {"set_variable": {"name": "shift_pressed_once", "value": 1}}
      ],
      "to_delayed_action": {
        "to_if_invoked": [
          {"set_variable": {"name": "shift_pressed_once", "value": 0}}
        ]
      },
      "parameters": {
        "basic.to_delayed_action_delay_milliseconds": 300
      },
      "conditions": [
        {"type": "variable_unless", "name": "shift_pressed_once", "value": 1}
      ]
    },
    {
      "type": "basic",
      "from": {"key_code": "left_shift"},
      "to": [{"key_code": "left_shift"}],
      "to_if_alone": [
        {"key_code": "caps_lock"},
        {"set_variable": {"name": "shift_pressed_once", "value": 0}}
      ],
      "conditions": [
        {"type": "variable_if", "name": "shift_pressed_once", "value": 1}
      ]
    }
  ]
}
```

## Undocumented and Lesser-Known Features

### Apple Vendor Keyboard Key Codes
These special key codes provide access to macOS-specific functions:
- `apple_vendor_keyboard_key_code`: "spotlight", "mission_control", "launchpad", "dashboard"
- `apple_vendor_top_case_key_code`: For MacBook-specific keys

### Advanced Simultaneous Options
- **`detect_key_down_uninterruptedly`**: When true, requires no other keys between simultaneous keys
- **`key_down_order`**: Can be "insensitive", "strict", or "strict_inverse"
- **`key_up_order`**: Controls release order requirements
- **`key_up_when`**: "any" releases on first key up, "all" waits for all keys

### Hidden Parameters
- **`basic.to_if_invoked_timeout_milliseconds`**: Timeout for delayed actions
- **`basic.to_if_canceled_timeout_milliseconds`**: Cancellation timeout
- **`mouse_motion_to_scroll.speed`**: Mouse wheel scroll speed multiplier

### CGEventDoubleClick
The `cg_event_double_click` software function can simulate double-clicks programmatically:
```json
{
  "software_function": {
    "cg_event_double_click": {
      "button": 0
    }
  }
}
```

### IOKit Power Management
Direct system power control:
```json
{
  "software_function": {
    "iokit_power_management_sleep_system": {}
  }
}
```

## Performance Optimization Tips

### Best Practices for Complex Configurations
1. **Minimize rule count**: Combine related modifications into single rules
2. **Order matters**: Place most frequently used rules first
3. **Use specific conditions**: Avoid broad "any" modifiers when possible
4. **Leverage variables**: Use variables to maintain state between modifications
5. **Profile separation**: Use different profiles for different workflows

### Debugging Techniques
1. **Karabiner-EventViewer**: Essential tool for monitoring key events
2. **Enable logging**: Check `/var/log/karabiner/` for detailed logs
3. **Test incrementally**: Add rules one at a time to isolate issues
4. **Variable monitoring**: Use EventViewer to track variable states

## File Structure and Backup

### Configuration Locations
- **Main config**: `~/.config/karabiner/karabiner.json`
- **Automatic backups**: `~/.config/karabiner/automatic_backups/`
- **Complex modifications assets**: `~/.config/karabiner/assets/complex_modifications/`
- **Log files**: `/var/log/karabiner/` and `~/Library/Logs/Karabiner-Elements/`

### Backup Strategy
Karabiner-Elements automatically creates backups when configurations change. Manual backups can be created by copying the configuration file before major changes.

This comprehensive guide covers all documented features of Karabiner-Elements v15.3.0 and provides the technical detail needed to generate complex keyboard configurations programmatically. The JSON syntax is strictly validated, so ensure proper formatting and valid key codes when creating configurations.
