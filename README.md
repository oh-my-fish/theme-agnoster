## agnoster

A fish theme optimized for people who use:

* Solarized
* Git
* Mercurial (requires 'hg prompt')
* SVN
* Unicode-compatible fonts and terminals (I use iTerm2 + Menlo)
* Fish Vi-mode

For Mac users, I highly recommend iTerm 2 + Solarized Dark

![agnoster theme](https://f.cloud.github.com/assets/1765209/255379/452c668e-8c0b-11e2-8a8e-d1d13e57d15f.png)


#### Characteristics

* If the previous command failed (✘)
* User @ Hostname (if user is not DEFAULT_USER, which can then be set in your profile)
* Git/HG/SVN status
* Branch () or detached head (➦)
* Current branch / SHA1 in detached head state
* Dirty working directory (±, color change)
  * By default, git repos will show as dirty if there are untracked files. This can be changed by adding `set -g fish_git_prompt_untracked_files no` to your `config.fish`. This value is passed into `git status --untracked-files`, so any value git supports is valid for this command
* Current working directory
* Elevated (root) privileges (⚡)
* Current virtual environment (Python virtualenv and Nix Shell)
You will probably want to disable the default virtualenv prompt. Add to your [`init.fish`](https://github.com/oh-my-fish/oh-my-fish#dotfiles):
`set -gx VIRTUAL_ENV_DISABLE_PROMPT 1`
* Indicate vi mode.
* Source control blacklist. To disable source control prompts in certain directories, you can add the following to your `init.fish` or `config.fish`: `set -g scm_prompt_blacklist "/path/to/blacklist"`.

Ported from https://gist.github.com/agnoster/3712874.
