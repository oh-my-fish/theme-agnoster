# name: Agnoster
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for FISH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).

## Set this options in your config.fish (if you want to :])
# set -g theme_display_user yes
# set -g theme_hide_hostname yes
# set -g theme_hide_hostname no
# set -g default_user your_normal_user
# set -g theme_svn_prompt_enabled yes
# set -g theme_mercurial_prompt_enabled yes



set -g current_bg NONE
set -g segment_separator \uE0B0
set -g right_segment_separator \uE0B0
set -q scm_prompt_blacklist; or set -g scm_prompt_blacklist
set -q max_package_count_visible_in_prompt; or set -g max_package_count_visible_in_prompt 10
# We support trimming the version only in simple cases, such as "1.2.3".
set -q try_to_trim_nix_package_version; or set -g try_to_trim_nix_package_version yes

# ===========================
# Color setting

# You can set these variables in config.fish like:
# set -g color_dir_bg red
# If not set, default color from agnoster will be used.
# ===========================

set -q color_virtual_env_bg; or set -g color_virtual_env_bg white
set -q color_virtual_env_str; or set -g color_virtual_env_str black
set -q color_user_bg; or set -g color_user_bg black
set -q color_user_str; or set -g color_user_str yellow
set -q color_dir_bg; or set -g color_dir_bg blue
set -q color_dir_str; or set -g color_dir_str black
set -q color_hg_changed_bg; or set -g color_hg_changed_bg yellow
set -q color_hg_changed_str; or set -g color_hg_changed_str black
set -q color_hg_bg; or set -g color_hg_bg green
set -q color_hg_str; or set -g color_hg_str black
set -q color_git_dirty_bg; or set -g color_git_dirty_bg yellow
set -q color_git_dirty_str; or set -g color_git_dirty_str black
set -q color_git_bg; or set -g color_git_bg green
set -q color_git_str; or set -g color_git_str black
set -q color_svn_bg; or set -g color_svn_bg green
set -q color_svn_str; or set -g color_svn_str black
set -q color_status_nonzero_bg; or set -g color_status_nonzero_bg black
set -q color_status_nonzero_str; or set -g color_status_nonzero_str red
set -q glyph_status_nonzero; or set -g glyph_status_nonzero "✘"
set -q color_status_superuser_bg; or set -g color_status_superuser_bg black
set -q color_status_superuser_str; or set -g color_status_superuser_str yellow
set -q glyph_status_superuser; or set -g glyph_status_superuser "🔒"
set -q color_status_jobs_bg; or set -g color_status_jobs_bg black
set -q color_status_jobs_str; or set -g color_status_jobs_str cyan
set -q glyph_status_jobs; or set -g glyph_status_jobs "⚡"
set -q color_status_private_bg; or set -g color_status_private_bg black
set -q color_status_private_str; or set -g color_status_private_str purple
set -q glyph_status_private; or set -g glyph_status_private "⚙"

# ===========================
# General VCS settings

set -q fish_vcs_branch_name_length; or set -g fish_vcs_branch_name_length 15

# ===========================
# Git settings
# set -g color_dir_bg red

set -q fish_git_prompt_untracked_files; or set -g fish_git_prompt_untracked_files normal

# ===========================
# Subversion settings

set -q theme_svn_prompt_enabled; or set -g theme_svn_prompt_enabled no

# ===========================
# Mercurial settings

set -q theme_mercurial_prompt_enabled; or set -g theme_mercurial_prompt_enabled no

# ===========================
# Helper methods
# ===========================

set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_char_dirtystate '±'
set -g __fish_git_prompt_char_cleanstate ''

function shorten_branch_name -a branch_name
  set new_branch_name $branch_name

  if test (string length $branch_name) -gt $fish_vcs_branch_name_length
    # Round up length before dot (+0.5)
    # Remove half the length of dots (-1)
    # -> Total offset: -0.5
    set pre_dots_length (math -s0 $fish_vcs_branch_name_length / 2 - 0.5)
    # Round down length after dot (-0.5)
    # Remove half the length of dots (-1)
    # -> Total offset: -1.5
    set post_dots_length (math -s0 $fish_vcs_branch_name_length / 2 - 1.5)
    set new_branch_name (string replace -r "(.{$pre_dots_length}).*(.{$post_dots_length})" '$1..$2' $branch_name)
  end

  echo $new_branch_name
end

function parse_git_dirty
  if [ $__fish_git_prompt_showdirtystate = "yes" ]
    set -l submodule_syntax
    set submodule_syntax "--ignore-submodules=dirty"
    set untracked_syntax "--untracked-files=$fish_git_prompt_untracked_files"
    set git_dirty (command git status --porcelain $submodule_syntax $untracked_syntax 2> /dev/null)
    if [ -n "$git_dirty" ]
        echo -n "$__fish_git_prompt_char_dirtystate"
    else
        echo -n "$__fish_git_prompt_char_cleanstate"
    end
  end
end

function cwd_in_scm_blacklist
  for entry in $scm_prompt_blacklist
    pwd | grep "^$entry" -
  end
end

# ===========================
# Segments functions
# ===========================

function prompt_segment -d "Function to draw a segment"
  set -l bg
  set -l fg
  if [ -n "$argv[1]" ]
    set bg $argv[1]
  else
    set bg normal
  end
  if [ -n "$argv[2]" ]
    set fg $argv[2]
  else
    set fg normal
  end
  if [ "$current_bg" != 'NONE' -a "$argv[1]" != "$current_bg" ]
    set_color -b $bg
    set_color $current_bg
    echo -n "$segment_separator "
    set_color -b $bg
    set_color $fg
  else
    set_color -b $bg
    set_color $fg
    echo -n " "
  end
  set current_bg $argv[1]
  if [ -n "$argv[3]" ]
    echo -n -s $argv[3] " "
  end
end

function prompt_finish -d "Close open segments"
  if [ -n $current_bg ]
    set_color normal
    set_color $current_bg
    echo -n "$segment_separator "
    set_color normal
  end
  set -g current_bg NONE
end


# ===========================
# Theme components
# ===========================

function prompt_virtual_env -d "Display Python or Nix virtual environment"
  set envs

  if test "$CONDA_DEFAULT_ENV"
    set envs $envs "conda[$CONDA_DEFAULT_ENV]"
  end

  if test "$VIRTUAL_ENV"
    set py_env (basename $VIRTUAL_ENV)
    set envs $envs "py[$py_env]"
  end

  # Support for `nix shell` command in nix 2.4+. Only the packages passed on the command line are
  # available in PATH, so it is useful to print them all.
  set nix_packages
  for p in $PATH
    set package_name_version (string match --regex '/nix/store/\w+-([^/]+)/.*' $p)[2]
    if test "$package_name_version"
      set package_name (string match --regex '^(.*)-(\d+(\.\d)+|unstable-20\d{2}-\d{2}-\d{2})' $package_name_version)[2]
      if test "$try_to_trim_nix_package_version" = "yes" -a -n "$package_name"
        set package $package_name
      else
        set package $package_name_version
      end
      if not contains $package $nix_packages
        set nix_packages $nix_packages $package
      end
    end
  end
  if test (count $nix_packages) -gt $max_package_count_visible_in_prompt
    set nix_packages $nix_packages[1..$max_package_count_visible_in_prompt] "..."
  end

  if [ "$IN_NIX_SHELL" = "impure" ]
    # Support for
    #   1) `nix-shell` command 
    #   2) `nix develop` command in nix 2.4+.
    # These commands are typically dumping too many packages into PATH for it be useful to print
    # them. Thus we only print "nix[impure]".
    set envs $envs "nix[impure]"
  else if test "$nix_packages"
    # Support for `nix-shell -p`. Would print "nix[foo bar baz]".
    # We check for this case after checking for "impure" because impure brings too many packages 
    # into PATH.
    set envs $envs "nix[$nix_packages]"
  else if test "$IN_NIX_SHELL"
    # Support for `nix-shell --pure`. Would print "nix[pure]".
    # We check for this case after checking for individual packages because it otherwise might 
    # confuse the user into believing when they are in a pure shell, after they have invoked 
    # `nix shell` from within it.
    set envs $envs "nix[$IN_NIX_SHELL]"
  end

  if test "$envs"
    prompt_segment $color_virtual_env_bg $color_virtual_env_str (string join " " $envs)
  end
end

function prompt_user -d "Display current user if different from $default_user"
  if [ "$theme_display_user" = "yes" ]
    if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
      set USER (whoami)
      get_hostname
      if [ $HOSTNAME_PROMPT ]
        set USER_PROMPT $USER@$HOSTNAME_PROMPT
      else
        set USER_PROMPT $USER
      end
      prompt_segment $color_user_bg $color_user_str $USER_PROMPT
    end
  else
    get_hostname
    if [ $HOSTNAME_PROMPT ]
      prompt_segment $color_user_bg $color_user_str $HOSTNAME_PROMPT
    end
  end
end

function get_hostname -d "Set current hostname to prompt variable $HOSTNAME_PROMPT if connected via SSH"
  set -g HOSTNAME_PROMPT ""
  if [ "$theme_hide_hostname" = "no" -o \( "$theme_hide_hostname" != "yes" -a -n "$SSH_CLIENT" \) ]
    set -g HOSTNAME_PROMPT (uname -n)
  end
end

function prompt_dir -d "Display the current directory"
  prompt_segment $color_dir_bg $color_dir_str (prompt_pwd)
end


function prompt_hg -d "Display mercurial state"
  not set -l root (fish_print_hg_root); and return

  set -l state
  set -l branch (cat $root/branch 2>/dev/null; or echo default)
  set -l bookmark (cat $root/bookmarks.current 2>/dev/null)
  set state (hg_get_state)
  set revision (command hg id -n)
  set branch_symbol \uE0A0
  set prompt_text "$branch_symbol $branch$bookmark:$revision"
  if [ "$state" = "0" ]
      prompt_segment $color_hg_changed_bg $color_hg_changed_str $prompt_text " ±"
  else
      prompt_segment $color_hg_bg $color_hg_str $prompt_text
  end
end

function hg_get_state -d "Get mercurial working directory state"
  if hg status | grep --quiet -e "^[A|M|R|!|?]"
    echo 0
  else
    echo 1
  end
end


function prompt_git -d "Display the current git state"
  set -l ref
  set -l dirty
  if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    set dirty (parse_git_dirty)
    set ref (command git symbolic-ref HEAD 2> /dev/null)
    if [ $status -gt 0 ]
      set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
      set ref "➦ $branch "
    end
    set branch_symbol \uE0A0
    set -l long_branch (echo $ref | sed "s#refs/heads/##")
    set -l branch (shorten_branch_name $long_branch)
    if [ "$dirty" != "" ]
      prompt_segment $color_git_dirty_bg $color_git_dirty_str "$branch_symbol $branch $dirty"
    else
      prompt_segment $color_git_bg $color_git_str "$branch_symbol $branch $dirty"
    end
  end
end


function prompt_svn -d "Display the current svn state"
  set -l ref
  if command svn info >/dev/null 2>&1
    set long_branch (svn_get_branch)
    set -l branch (shorten_branch_name $long_branch)
    set branch_symbol \uE0A0
    set revision (svn_get_revision)
    prompt_segment $color_svn_bg $color_svn_str "$branch_symbol $branch:$revision"
  end
end

function svn_get_branch -d "get the current branch name"
  svn info 2> /dev/null | awk -F/ \
      '/^URL:/ { \
        for (i=0; i<=NF; i++) { \
          if ($i == "branches" || $i == "tags" ) { \
            print $(i+1); \
            break;\
          }; \
          if ($i == "trunk") { print $i; break; } \
        } \
      }'
end

function svn_get_revision -d "get the current revision number"
  svn info 2> /dev/null | sed -n 's/Revision:\ //p'
end


function prompt_status -d "the symbols for a non zero exit status, root and background jobs"
    if [ $RETVAL -ne 0 ]
      prompt_segment $color_status_nonzero_bg $color_status_nonzero_str $glyph_status_nonzero
    end

    if [ "$fish_private_mode" ]
      prompt_segment $color_status_private_bg $color_status_private_str $glyph_status_private
    end

    # if superuser (uid == 0)
    set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
      prompt_segment $color_status_superuser_bg $color_status_superuser_str $glyph_status_superuser
    end

    # Jobs display
    if [ (jobs -l | wc -l) -gt 0 ]
      prompt_segment $color_status_jobs_bg $color_status_jobs_str $glyph_status_jobs
    end
end

# ===========================
# Apply theme
# ===========================

function fish_prompt
  set -g RETVAL $status
  prompt_status
  prompt_user
  prompt_dir
  prompt_virtual_env
  if [ (cwd_in_scm_blacklist | wc -c) -eq 0 ]
    type -q git; and prompt_git
    if [ "$theme_mercurial_prompt_enabled" = "yes" ]
      prompt_hg
    end
    if [ "$theme_svn_prompt_enabled" = "yes" ]
      prompt_svn
    end
  end
  prompt_finish
end
