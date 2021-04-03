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

The final call to add SSH identities to ssh-agent can be modified by setting
`$halostatue_fish_ssh_agent_flags`. If not specified, defaults to
a platform-specific value:

- on macOS, it uses `-q -A -K`, which means that non-error output is
  suppressed; keys will be unlocked with passphrases from the keychain;
  if passphrases are required, will be stored in the keychain.
- on other platforms, it uses `-q`.

[![Version]]

## Installation

Install with [Fisher] (recommended):

```fish
# Fisher v3.x
fisher add halostatue/fish-ssh-agent

# Fisher v4.x: Dependencies must be specified explicitly.
fisher install halostatue/fish-ssh-agent
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

[fish shell]: https://fishshell.com 'friendly interactive shell'
[version]: https://img.shields.io/github/tag/halostatue/fish-ssh.svg?label=Version

[![Version]]: https://github.com/halostatue/fish-ssh/releases
[Fisher]: https://github.com/jorgebucaran/fisher
[fish]: https://github.com/fish-shell/fish-shell
