# 🏠 GTA Online Apartment Exchange Script

AutoHotkey script for automating property exchanges in GTA Online.

---

## 📋 Requirements

- Windows (Administrator privileges)
- AutoHotkey v1.1+
- GTA V/Online
- $5,000,000 in-game bank (for setup phase)
- 1920x1080 resolution recommended

---

## 🚀 Quick Start

1. Install [AutoHotkey](https://www.autohotkey.com/)
2. Run `nuevoscript.ahk` as Administrator
3. Place required images in `images/` folder

---

## 🎮 Controls

| Key | Function |
|-----|----------|
| **Numpad0** | Preparation Phase (setup 10 apartment slots) |
| **Numpad1** | Payback Phase (start money loop) |
| **Numpad2** | Enable Firewall (manual) |
| **Numpad3** | Disable Firewall (manual) |
| **Numpad4** | Reload Script |
| **Numpad5** | Exit Script |

---

## 📖 Usage

### Step 1: Preparation (Numpad0)
- Duration: ~15 minutes
- Cost: $5M
- Prepares 10 apartment slots by buying expensive apartments and swapping them to cheap ones while preserving value

### Step 2: Payback (Numpad1)
- Duration: ~80s per run
- Profit: ~$5.2M per run (~$3.9M/minute)
- Automates buying/selling prepared apartments in a loop

**Important**: Start both phases from Story Mode. Don't touch anything once started.

---

## 🔧 How It Works

1. Blocks Rockstar's save server IP (192.81.241.171) via Windows Firewall
2. Buys cheap apartments while firewall is active
3. Exits to Story Mode and disables firewall to save progress
4. Runs cleanup cycle (Online → Story Mode) to ensure clean save state
5. Repeats process

---

## 🛡️ Safety Features

- Auto-cleanup firewall rules on exit
- Image recognition for state verification
- Manual panic buttons (Numpad2/3)

---

## 📁 File Structure

```
├── nuevoscript.ahk
└── images/
    ├── map_button.bmp
    ├── joining_online_button.bmp
    ├── browser_tile.png
    ├── quick_actions_tile.bmp
    ├── return_to_map_button.bmp
    ├── retry_continue_buttons.bmp
    ├── trade_in_property_menu.bmp
    ├── interaction_menu.bmp
    └── interaction_menu2.bmp
```

---

## ⚖️ Disclaimer

For educational purposes only. The authors are not responsible for any consequences including but not limited to account bans, data loss, or violations of terms of service.
