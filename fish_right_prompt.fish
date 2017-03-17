# right prompt for agnoster theme
# shows vim mode status

function prompt_vi_mode -d 'vi mode status indicator'
  set -l right_segment_separator \uE0B2
  switch $fish_bind_mode
      case default
        set_color green
        echo "$right_segment_separator"
        set_color -b green black
        echo " N "
      case insert
        set_color blue
        echo "$right_segment_separator"
        set_color -b blue black
        echo " I "
      case visual
        set_color red
        echo "$right_segment_separator"
        set_color -b red black
        echo " V "
    end
end

function fish_right_prompt -d 'Prints right prompt'
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    prompt_vi_mode
    set_color normal
  end
end
