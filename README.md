# Kalyx-System-Template
A template system config to fork, and start using Kalyx.

# Instructions for using the dev branch:
For people using and developing main Kalyx, you can use a git submodule to nest a editable version of Kalyx inside your repository, allowing you to pull request the main Kalyx project and make local edits.
1. Clone the repo
2. Add your fork to the submodules, make sure it gets clones into kalyx and make sure to change the url in the provided command: ``git submodule add https://github.com/Your/KalyxFork kalyx``
3. Near the top of the flake.nix change ``url = "https://github.com/Juiced-Devs/Kalyx";`` to ``url = "file:./kalyx?submodules=1";`` and below that line add ``type = "git";``
4. Delete flake.lock
5. Follow regular setup.
