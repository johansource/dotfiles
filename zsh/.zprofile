# Homebrew shellenv (sets PATH etc.)
if [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/Homebrew/bin/brew ]; then
  eval "$(/usr/local/Homebrew/bin/brew shellenv)"
fi

# User bins (Poetry etc.)
export PATH="$HOME/.local/bin:$PATH"

# Pnpm

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Pnpm end

# Pyenv (login shell init)

export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

# Pyenv end

# Java

if command -v brew >/dev/null 2>&1; then
  if brew --prefix openjdk >/dev/null 2>&1; then
    if [ -z "${JAVA_HOME:-}" ]; then
      export JAVA_HOME="$(brew --prefix openjdk)"
    fi
    case ":$PATH:" in
      *":$JAVA_HOME/bin:"*) ;;
      *) export PATH="$JAVA_HOME/bin:$PATH" ;;
    esac
  fi
fi

# Java end

# Android SDK

export ANDROID_HOME="$HOME/Library/Android/sdk"

for p in \
  "$ANDROID_HOME/platform-tools" \
  "$ANDROID_HOME/emulator" \
  "$ANDROID_HOME/tools" \
  "$ANDROID_HOME/tools/bin"
do
  case ":$PATH:" in
    *":$p:"*) ;;
    *) export PATH="$PATH:$p" ;;
  esac
done

# Android SDK end
