# rpa-garages

<div align="center">

![GitHub Release](https://img.shields.io/github/v/release/RP-Alpha/rpa-garages?style=for-the-badge&logo=github&color=blue)
![GitHub commits](https://img.shields.io/github/commits-since/RP-Alpha/rpa-garages/latest?style=for-the-badge&logo=git&color=green)
![License](https://img.shields.io/github/license/RP-Alpha/rpa-garages?style=for-the-badge&color=orange)
![Downloads](https://img.shields.io/github/downloads/RP-Alpha/rpa-garages/total?style=for-the-badge&logo=github&color=purple)

**Vehicle Storage & Retrieval System**

</div>

---

## ✨ Features

- 🚗 **Storage** - Store and retrieve owned vehicles
- 🧑 **Valet Peds** - NPC interactions via Target
- 🔑 **Key Integration** - Auto-gives keys via rpa-vehiclekeys
- 📍 **Multi-Garage** - Support for multiple locations
- 🔐 **Permission System** - Admin garage management

---

## 📦 Dependencies

- `rpa-lib` (Required)
- `rpa-vehiclekeys` (Recommended)
- `ox_target` or `qb-target` (Recommended)

---

## 📥 Installation

1. Download the [latest release](https://github.com/RP-Alpha/rpa-garages/releases/latest)
2. Extract to your `resources` folder
3. Add to `server.cfg`:
   ```cfg
   ensure rpa-lib
   ensure rpa-garages
   ```

---

## ⚙️ Configuration

```lua
Config.Garages = {
    ['legion'] = {
        label = "Legion Square Parking",
        coords = vector3(215.0, -810.0, 30.0),
        spawnCoords = vector4(220.0, -800.0, 30.0, 90.0),
        vehicleType = 'car'  -- 'car', 'boat', 'air'
    }
}
```

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/RP-Alpha">RP-Alpha</a></sub>
</div>
