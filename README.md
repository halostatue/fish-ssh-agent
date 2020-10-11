# halostatue/fish-ssh-agent

Automatically initialize and load SSH agent identities.

Based on code I used in my zsh configuration files. Originally based on code
from Joseph M. Reagle (originally identified below, found in numerous places
across the web). http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html

Agent forwarding support is pulled from Oh My Zsh and is based on ideas from
Florent Thoumie and Jonas Pfenniger.

This version always assumes that there will be tmux agent forwarding, and
unlike the zsh version does not permit the specification of identities to add
to the agent; all identities with a `.pub` extension in `${HOME}/.ssh` will be
loaded at all times.

[![Version]]

## Installation

Install with [Fisher] (recommended):

```fish
fisher add halostatue/fish-ssh-agent
```

<details>
<summary>Not using a package manager?</summary>

---

Copy `conf.d/*.fish` to your fish configuration directory preserving the
directory structure.
</details>

### System Requirements

- [fish] 3.0+

## License

[MIT](LICENCE.md)

[fish shell]: https://fishshell.com "friendly interactive shell"
[Version]: https://img.shields.io/github/tag/halostatue/fish-ssh.svg?label=Version
[![Version]]: https://github.com/halostatue/fish-ssh/releases
[Fisher]: https://github.com/jorgebucaran/fisher
[fish]: https://github.com/fish-shell/fish-shell
