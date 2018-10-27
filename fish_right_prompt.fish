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

function prompt_vi_mode -d 'vi mode status indicator'
  set -l right_segment_separator \uE0B2
  switch $fish_bind_mode
      case default
        set_color $color_vi_mode_normal
        echo "$right_segment_separator"
        set_color -b $color_vi_mode_normal $color_vi_mode_indicator
        echo " N "
      case insert
        set_color $color_vi_mode_insert
        echo "$right_segment_separator"
        set_color -b $color_vi_mode_insert $color_vi_mode_indicator
        echo " I "
      case visual
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
