# Starship Prompt – Custom Themed Configuration

---

## Prerequisites

Before installing, make sure you have:

1. **Starship** installed  
   - **Linux/macOS**:
     ```bash
     curl -sS https://starship.rs/install.sh | sh
     ```
   - **Windows (PowerShell)**:
     ```powershell
     winget install --id Starship.Starship
     ```



2. **A Shell** that supports Starship. Bash, Zsh, Fish, or PowerShell (see [Starship docs](https://starship.rs) for more)
   - **Bash**:
     Add the following to the end of `~/.bashrc`:
     ```bash
     eval "$(starship init bash)"
     ```

   - **PowerShell**:
     Add the following to the end of your PowerShell configuration (find it by running `$PROFILE`):
     ```powershell
     Invoke-Expression (&starship init powershell)
     ```

3. **A Nerd Font** installed (for proper icon rendering)  
   - Recommended: [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)
   - After installing, set it as your terminal font (Windows Terminal, Alacritty, iTerm2, etc.).

---

## Configuration installation

### **Linux / macOS**

1. **Create or open** your Starship config file:
   ```bash
   mkdir -p ~/.config
   nano ~/.config/starship.toml
   ```

2. **Paste the [Starship Config](./starship/starship.toml) into ** `~/.config/starship.toml`:

3. **Reload your shell** for changes to take effect:  
   ```bash
   exec zsh
   # or
   exec bash
   ```

---

### **Windows (PowerShell)**

1. **Find your Starship config location**:  
   On Windows, the default config path is:
   ```
   %USERPROFILE%\.config\starship.toml
   ```

2. **Create the folder and file**:
   ```powershell
   mkdir $HOME\.config
   notepad $HOME\.config\starship.toml
   ```

3. **Paste the [Starship Config](./starship/starship.toml)** from the Linux/macOS section above into `starship.toml`.

4. **Restart PowerShell** to see your new prompt.

---

- **Icons not displaying?**
  - Install a Nerd Font and set it in your terminal profile.
  - Restart the terminal after changing the font.

- **Starship not loading?**
  - Ensure your shell init file loads Starship:
    - **Zsh**:
      ```bash
      eval "$(starship init zsh)"
      ```
    - **Bash**:
      ```bash
      eval "$(starship init bash)"
      ```
    - **PowerShell**:
      ```powershell
      Invoke-Expression (&starship init powershell)
      ```
