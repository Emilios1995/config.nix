# Laptop bootstrap

The MacBook is a thin client: a terminal, a tailnet, and a key. Everything else —
tmux, shell, tooling — lives on the Mac Studio ("desk") and stays there. Nothing on
the laptop is worth backing up, so wiping it costs one evening of nothing.

Nix is deliberately NOT used here. The laptop is x86, Nix broke on it, and a thin
client does not need it. Homebrew covers the three things that must be local.

Read this from the Studio while the laptop is bare.

## 1. Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Installs the Xcode Command Line Tools first; slow. On Intel the prefix is
`/usr/local`, so run the `brew shellenv` lines it prints at the end.

## 2. Packages

```sh
brew bundle --file=Brewfile   # or: brew install --cask tailscale-app ghostty && brew install mosh
```

Launch Tailscale and sign in as **emilios1995@gmail.com** — the personal tailnet,
not the work one. `emilios-mac-studio` should show up in its device list.

## 3. SSH key

```sh
ssh-keygen -t ed25519 -C "macbook"
pbcopy < ~/.ssh/id_ed25519.pub
```

Then on the Studio, `pbpaste >> ~/.ssh/authorized_keys`.

## 4. SSH config

```sh
cp ssh-config ~/.ssh/config    # then check it over
chmod 600 ~/.ssh/config
ssh desk                       # must work before moving on
```

## 5. Ghostty terminfo on the Studio

Ghostty sets `TERM=xterm-ghostty`, which the Studio's ncurses does not ship. Run
this from the laptop, inside Ghostty:

```sh
infocmp -x | ssh desk -- tic -x -
```

It lands in `~/.terminfo` on the Studio — outside the Nix store, so rebuilds leave
it alone. Verify: `ssh desk infocmp xterm-ghostty > /dev/null && echo ok`.

## 6. Aliases

Append `zshrc-snippet` to `~/.zshrc`.

The absolute `--server` path is not optional: mosh starts mosh-server through a
non-interactive ssh shell, whose PATH does not include the Nix profile.

## 7. Verify, in order

1. `desk` connects and lands in tmux.
2. Close the lid or toggle Wi-Fi, then reopen — the session resumes rather than
   dying. That is the whole reason for mosh.
3. Copy: in tmux, `v` to select, `y` to yank, then Cmd+V into a laptop browser.
   Works via OSC 52 over mosh (see `../home/tmux.nix` for why the tmux `Ms`
   override is needed). If it fails, add `clipboard-write = allow` to
   `~/.config/ghostty/config` and reconnect.

## When it breaks

- `sshdesk` — plain ssh, bypasses everything mosh-specific.
- Tailnet down: the Studio is on the LAN at `emilios-mac-studio.local`.
- Before wiping the laptop again, confirm the Studio's personal-tailnet node has
  key expiry disabled. If that key expires while the laptop is the only way in,
  there is no way in.
