# Summon2Scale

<https://jman9092.itch.io/summon-to-scale>

This is a game made in Godot as part of the [GMTK Game Jam 2024](https://itch.io/jam/gmtk-2024), where we gave ourselves 48 hours to make a game based on the theme "Roles Reversed".

Made as a team of 6 - [@alifeee] (myself), [@FreyaCon], [@dicemaster5], [@Jman9092], [@roryferbrache], and [@kc-devacc]

[@alifeee]: https://github.com/alifeee
[@FreyaCon]: https://github.com/FreyaCon
[@dicemaster5]: https://github.com/dicemaster5
[@Jman9092]: https://github.com/Jman9092
[@roryferbrache]: https://github.com/roryferbrache
[@kc-devacc]: https://github.com/kc-devacc

![w1_Vgn](https://github.com/user-attachments/assets/946ec315-1a06-4a22-87ad-738b5eb43853)

## Scoreboard

There is a networked scoreboard as part of the game, the repo is: <https://github.com/alifeee/gmtk_scoreboard>

## Development

| Requirement | Version |
| ---- | ------- |
| Godot | 4.3.0 |

Open the project in Godot and run using F5.

### Exporting

To export, use Godot's export, in Project > Export > Export All... > Release.
This will place the built game in the `Export` folder.

### Serving locally

```bash
cd .\Export
python serve.py --root .
```

By default, it attempts to automatically open the page in browser, but this breaks. Manually open <http://localhost:8060>.
