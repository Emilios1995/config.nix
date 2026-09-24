# Laptop bootstrap (Omarchy)

The laptop is a thin client: a terminal, a tailnet, and a key. Everything else —
tmux, shell, tooling — lives on the Mac Studio ("desk") and stays there. Nothing on
the laptop is worth backing up.

It runs Omarchy (Arch + Hyprland), not macOS, and deliberately not Nix. Two
packages are all it needs.

Run `omarchy version` first: 4.x defaults to the foot terminal, 3.x to Alacritty.
That changes nothing below except which terminfo step 5 copies — the command is the
same either way.

## 1. Tailscale

Omarchy has this built in: menu → **Install > Service > Tailscale**. It installs the
package, enables `tailscaled`, runs `tailscale up`, and sets `--operator=$USER` so
the CLI works without sudo afterwards.

Sign in as **emilios1995@gmail.com** — the personal tailnet, not the work one.
`tailscale status` should list `emilios-mac-studio`.

Leave DNS on **DHCP** (Setup > Network > DNS). Pinning Cloudflare/Google there
rewrites `/etc/systemd/resolved.conf` and can fight MagicDNS, which is how the
`desk` hostname resolves.

## 2. mosh

```sh
omarchy pkg add mosh
```

Prefer this over raw pacman — it is Omarchy's own wrapper and checks the package
actually registered. mosh is in Arch `extra`; Omarchy does not ship it.

## 3. SSH config

```sh
cp ssh-config ~/.ssh/config
chmod 600 ~/.ssh/config
ssh desk    # password prompt is expected here; the key comes next
```

The `ServerAlive*` lines are redundant on Omarchy, which already sets keepalives in
`/etc/ssh/ssh_config.d/20-omarchy-keepalive.conf`. Harmless, and keeps the file
portable.

## 4. SSH key

```sh
ssh-keygen -t ed25519 -C "omarchy"
ssh-copy-id desk
```

`ssh-copy-id` prompts for the Studio's account password and appends the key itself.
The Studio allows password auth (`PasswordAuthentication` unset, `UsePAM yes`), which
is what makes this work before any key exists.

Do not try to move the key via the clipboard: `wl-copy` writes the laptop's Wayland
clipboard and `pbpaste` reads the Mac's — different machines, nothing crosses. If
`ssh-copy-id` is unavailable, read the `.pub` file out on the laptop and append it by
hand while sitting at the Studio.

Omarchy has no ssh-agent convention — no unit, no `SSH_AUTH_SOCK` export. If
retyping a passphrase gets old, set up `gcr-ssh-agent.socket` or a plain `ssh-agent`
user unit yourself.

## 5. Terminfo on the Studio

The Studio's ncurses knows nothing about `foot`. mosh passes `TERM` through, so
without this you land in a session with a broken terminal. From the laptop, in the
terminal you actually use:

```sh
infocmp -x | ssh desk -- tic -x -
```

It lands in `~/.terminfo` on the Studio — outside the Nix store, so rebuilds leave
it alone. Verify: `ssh desk infocmp $TERM > /dev/null && echo ok`.

Omarchy's `shell-integration-features = ...,ssh-env` papers over this for plain
`ssh`, but **not** for mosh, which it does not wrap.

## 6. Aliases

Append `bashrc-snippet` to `~/.bashrc`.

The absolute `--server` path is not optional: mosh starts mosh-server through a
non-interactive ssh shell, whose PATH does not include the Nix profile.

## 7. Verify, in order

1. `desk` connects and lands in tmux.
2. Close the lid or change networks, then reopen — the session resumes rather than
   dying. That is the whole reason for mosh.
3. Copy: in tmux, `v` to select, `y` to yank, then paste into a laptop browser.
   Works via OSC 52 (see `../home/tmux.nix` for why the tmux `Ms` override is
   needed). To test the terminal's half alone:
   `printf '\033]52;c;%s\a' "$(printf hello | base64)"`
   If that puts "hello" on the clipboard, the terminal is fine and any failure is
   tmux-side.

Terminal copy/paste is `Ctrl+Shift+C/V`, or Omarchy's `Super+C/V`, which
synthesizes those. Do not rebind either.

## When it breaks

- `sshdesk` — plain ssh, bypasses everything mosh-specific.
- Tailnet down: the Studio is on the LAN at `emilios-mac-studio.local`.
- The Studio's personal-tailnet node must have key expiry disabled. If that key
  expires while the laptop is the only way in, there is no way in.
