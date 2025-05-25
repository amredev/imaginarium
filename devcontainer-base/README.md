# `devcontainer-base`

This docker image is meant to be used as a base for devcontainer definitions. It contains only the basic necessities:

- A non-root user `amredev` with `uid=1000`
- Terminal setup with `zsh` and `oh-my-zsh`
- Basic tools like `curl`, `git`, etc. (see the `Dockefile` for details)
