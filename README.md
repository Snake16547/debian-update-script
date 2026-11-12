# Up — Debian update script

A minimal, dependency-free Bash updater for Debian and Ubuntu servers.

## Run

```bash
curl -fsSLo update.sh https://raw.githubusercontent.com/Snake16547/debian-update-script/main/update.sh
less update.sh  # Review before running
chmod +x update.sh
./update.sh
```

Run as root or as a user with sudo access. The script uses the system's existing APT sources and does **not** switch Debian releases.

## Options

| Command | Behavior |
| --- | --- |
| `./update.sh` | Update package lists, then full-upgrade |
| `./update.sh --remove` | Update and remove unused dependencies |
| `./update.sh --clean` | Update, autoremove, and autoclean |
| `./update.sh --dry-run` | Simulate full-upgrade; does not refresh package lists |
| `./update.sh --help` | Show help |
| `./update.sh --version` | Show version |

Supports Debian and Ubuntu derivatives that provide `apt-get` and `dpkg-query`. No Debian release number is hard-coded, so future releases can work without code changes as long as their APT behavior remains compatible.

**Important:** `full-upgrade` may install or remove packages to resolve dependencies. Review APT's proposed changes before confirming. Back up important servers before major upgrades. For a new Debian major release, follow Debian's official release notes and update repository sources separately.

The script does not automatically purge residual package configuration or change repository definitions.

## Development

```bash
bash -n update.sh
shellcheck update.sh
```

## Credits and licensing

Based on the original **Up** tool by Joe Collins (ezeelinux.com), credited in the script as GPL-2.0. The repository currently contains a GPL-3.0 LICENSE file; verify the original licensing terms and compatibility before redistributing modified versions.
