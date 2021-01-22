# right prompt for agnoster theme
# shows vim mode status

# ===========================
# Color setting

# You can set these variables in config.fish like:
# set -g color_dir_bg red
# If not set, default color from agnoster will be used.
# ===========================
set -q color_vi_mode_indicator; or set color_vi_mode_indicator black
set -q color_vi_mode_normal; or set color_vi_mode_normal green
set -q color_vi_mode_insert; or set color_vi_mode_insert blue 
set -q color_vi_mode_visual; or set color_vi_mode_visual red


# ===========================
# Cursor setting

# You can set these variables in config.fish like:
# set -g cursor_vi_mode_insert bar_blinking
# ===========================
set -q cursor_vi_mode_normal; or set cursor_vi_mode_normal box_steady
set -q cursor_vi_mode_insert; or set cursor_vi_mode_insert bar_steady
set -q cursor_vi_mode_visual; or set cursor_vi_mode_visual box_steady


function fish_cursor_name_to_code -a cursor_name -d "Translate cursor name to a cursor code"
  # these values taken from
  # https://github.com/gnachman/iTerm2/blob/master/sources/VT100Terminal.m#L1646
  # Beginning with the statement "case VT100CSI_DECSCUSR:"
  if [ $cursor_name = "box_blinking" ]
    echo 1
  else if [ $cursor_name = "box_steady" ]
    echo 2
  else if [ $cursor_name = "underline_blinking" ]
    echo 3
  else if [ $cursor_name = "underline_steady" ]
    echo 4
  else if [ $cursor_name = "bar_blinking" ]
    echo 5
  else if [ $cursor_name = "bar_steady" ]
    echo 6
  else
    echo 2
  end
end

function prompt_vi_mode -d 'vi mode status indicator'
  set -l right_segment_separator \uE0B2
  switch $fish_bind_mode
      case default
        set -l mode (fish_cursor_name_to_code $cursor_vi_mode_normal)
        echo -e "\e[\x3$mode q"
        set_color $color_vi_mode_normal
        echo "$right_segment_separator"
        set_color -b $color_vi_mode_normal $color_vi_mode_indicator
        echo " N "
      case insert
        set -l mode (fish_cursor_name_to_code $cursor_vi_mode_insert)
        echo -e "\e[\x3$mode q"
        set_color $color_vi_mode_insert
        echo "$right_segment_separator"
        set_color -b $color_vi_mode_insert $color_vi_mode_indicator
        echo " I "
      case visual
        set -l mode (fish_cursor_name_to_code $cursor_vi_mode_visual)
        echo -e "\e[\x3$mode q"
        set_color $color_vi_mode_visual
        echo "$right_segment_separator"
        set_color -b $color_vi_mode_visual $color_vi_mode_indicator
        echo " V "
    end
end

function fish_right_prompt -d 'Prints right prompt'
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    prompt_vi_mode
    set_color normal
  end
end
