when isMainModule:

  echo "\e[H\ec\e[0m\e[2J\e[3J"
  echo """
  [▌ ] [ ▐] ☐☑☒ ⊠⊡⊞⊟ ⚞⚟☰≣≡ ✓✔✕✖ ❘❙❚ ⚪⚫

  Plant water level:
  ┌─────────────────────────┐
  │>100├▄▃▂─────────────────│
  │ 100├█████──█────█───────│
  │  50├█████─███─████──────│
  │  25├███████████████─────│
  │   5├████████████████▃▂██│
  │   0└────────────────────│
  │     12345678901234567890│
  └─────────────────────────┘



  Plant water level:
  >100├▄▃▂─────────────────
  100├█████──█────▄───────
    50├█████─███─████──────
    25├███████████████─────
    5├████████████████▃▂██
    0└────────◀ 1/99▶─▲1X▼
      [label              ]
      [value              ]


  y: min, max
  x: scale
  selected: x

  width, height
  yTicks: min, max/(barH * 8)   ,max

  val / (max/(barH * 8)) = 35 -> 35/8 = 4 r3 -> ████▃




  Plant water level:
  >100├────────────────────
  100├────***───**────────
    50├───*───*─*──*───────
    25├──*─────*────*──────
    5├─*────────────**────
    0└────────◀ 1/99▶─▲1X▼
      [label              ]
      [value              ]




                                  Plant water level:
                                  >100├▄▃▂▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
                                  100├█████▔▔█▔▔▔▔▄▔▔▔▔▔▔▔
                                    50├█████▔███▔████▔▔▔▔▔▔
                                    25├███████████████▔▔▔▔▔
                                    5├████████████████▃▂██
                                    0 ▔▔▔▔▔▔▔▔◀ 1/99▶▔▲1X▼
                                      [label              ]
                                      [value              ]




  Plant water level:
      ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
  >100├▄▃▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▏
  100├░░░██▁▁█▁▁▁▁▄▁▁▁▁▁▁▁▏
    50├░░░░░▁█░█▁██░█▁▁▁▁▁▁▏
    25├░░░░░█░░░█░░░░█▁▁▁▁▁▏
    5├░░░░░░░░░░░░░░░▁▁▁▁▁▏
    0├░░░░░░░░░░░░░░░█▃▂██
      ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
    ▔▔▔▔▔▔▔▔◀ 1/99▶ ▲1X▼
      [label              ]
      [value              ]



                                  Plant water level:
                                  >100├▄▃▂┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
                                  100├█████┄┄█┄┄┄┄▄┄┄┄┄┄┄┄
                                    50├█████┄███┄████┄┄┄┄┄┄
                                    25├███████████████┄┄┄┄┄
                                    5├████████████████▃▂██
                                    0 ████████████████████
                                      ▔▔▔▔▔▔▔▔◀ 1/99▶┄▲1X▼
                                      [label              ]
                                      [value              ]



  Plant water level:
  >100├▄▃▂┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  100├▓▓▓██┈┈█┈┈┈┈▄┈┈┈┈┈┈┈
    50├▒▒▒▓▓┈█▓█┈██▓█┈┈┈┈┈┈
    25├░░░▒▒█▓▒▓█▓▓▒▓█┈┈┈┈┈
    5├░░░░░░▒░▒▓▒▒░▒▓█▃▂██
    0└────────◀ 1/99▶┈▲1X▼
      [label              ]
      [value              ]



                                  Plant water level:
                                  >100├▄▃▂┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
                                  100├████┈┈█┈┈┈┈▄┈┈┈┈┈┈┈
                                    50├▓▓▓▓▓┈▓▓▓┈▓▓▓▃┈┈┈┈┈┈
                                    25├▒▒▒▒▒▒▒▒▒▒▒▒▒▒▃┈┈┈┈┈
                                    5├░░░░░░░░░░░░░░░░▃▂░░
                                    0└────────◀ 1/99▶┈▲1X▼
                                      [label              ]
                                      [value              ]



                                  Plant water level:
                                  >100├▄▃▂┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
                                  100├██████▄┈┈┈┈┈┈┈┈┈┈┈┈┈
                                    50├██████████▄▃▂┈┈┈┈┈┈┈
                                    25├███████████████┈┈┈┈┈
                                    5├████████████████▃▂▄█
                                    0 ◀ 1/99▶▲1X▼
                                      [label              ]
                                      [value              ]



  Plant water level:
  >100├▄▄▄┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  100├██████▄┈┈┈┈┈┈┈┈┈┈┈┈┈
    50├██████████▄▄▄┈┈┈┈┈┈┈
    25├███████████████┈┈┈┈┈
    5├████████████████▄▄▄█
    0 ◀ 1/99▶▲1X▼
      [label              ]
      [value              ]






                              Plant water level:
                              >100├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
                              100├┈┈┈┈◉◉◉┈┈┈◉◉┈┈┈┈┈┈┈┈
                                50├┈┈┈◉┈┈┈◉┈◉┈┈◉┈┈┈┈┈┈┈
                                25├┈┈◉┈┈┈┈┈◉┈┈┈┈◉┈┈┈┈┈┈
                                5├┈◉┈┈┈┈┈┈┈┈┈┈┈┈◉◉┈┈┈┈
                                0└────────────────────
                                  ◀ 1/99▶┈▲1X▼
                                  [label              ]
                                  [value              ]







  [⬒] Plant water level:
      ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
  >100├▄▃▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▏
    90├█████▁▁█▁▁▁▁▄▁▁▁▁▁▁▁▏
    70├█████▁███▁████▁▁▁▁▁▁▏
    50├███████████████▁▁▁▁▁▏
    30├████████████████▃▂██▏
    10├████████████████████
      ▔▔▔▔▔▔▔▔◀ 1/99▶ ▲1X▼
      [label              ]
      [avg:               ]
      [max:               ]
      [min:               ]



  [⬒] Drive space occupied:
      ▁▁▁▁
  >100├▁▁▁▁▏
    90├▁▃▁▁▏
    70├██▁█▏
    50├████▏
    30├████▏
    10├████
      │││┕Drive: sdc
      ││┕Drive: Data
      │┕Drive: System
      ┕Drive: sdb



  [⬒] Drive space occupied:
      ▁▁▁▁▁▁▁
  >100├▁▁▁▁▁▁▁▏
    90├▁▁▃▁▁▁▁▏
    70├█▁█▁▁▁█
    50├█▁█▁█▁█
    30├█▁█▁█▁█ 
    10├█▁█▁█▁█ 
      │ │ │ ┕Drive: sdc
      │ │ ┕Drive: Data
      │ ┕Drive: System
      ┕Drive: sdb

  [⬒] Drive space occupied:
  >100├
    90├  ▃       █       █    
    70├█ █   █▏  █     ▃ █    
    50├█ █ █ █▏▓ ▓     ▓ ▓   ▃ 
    30├█ █ █ █▏▓ ▓   ▓▏▓ ▓ ▃ ▓
    10├█▁█▁█▁█▁▒▁▒▁▒▁▒▁▒▁▒▁▒▁▒
        │ │ │ ┕Drive: sdc
        │ │ ┕Drive: Data
        │ ┕Drive: System
        ┕Drive: sdb

  [⬒] Drive space occupied:
  >100├┈┈┈┈┈┈┈┈┈┈┈┈┈               
    90├  ▃       █           █    
    70├█ █   █▏  █         ▃ █    
    50├█┈█┈█┈█┈▓┈▓┈┈┈▁   ▁ ▓ ▓   ▂    
    30├█ █ █ █▏▓ ▓   ▓   ▓ ▓ ▓ ▃ ▓
    10├█ █ █ █ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒
    ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
      │ │ │ ┕Drive: sdc
      │ │ ┕Drive: Data
      │ ┕Drive: System
      ┕Drive: sdb
      


  [⬒] Plant water level:
  >100├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  100├┈┈┈┈◉◉◉┈┈┈◉◉┈┈┈┈┈┈┈
    50├┈┈┈◉   ◉ ◉  ◉┈┈┈┈┈┈
    25├┈┈◉     ◉    ◉┈┈┈┈┈
    5├┈◉            ◉◉┈┈┈
    0├◉                ◉─
      ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
      ◀ 1/99▶┈▲1X▼
      [label              ]
      [value              ]




  [⬒] Plant water level:
  >100├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  100├┈┈┈┈▄▀▄┈┈┈▞▚┈┈┈┈┈┈┈
    50├┈┈┈▞   ▚ ▞  ▚┈┈┈┈┈┈
    25├┈┈▞     ▀    ▚┈┈┈┈┈
    5├┈▞            ▀▄┈┈┈
    0├▞               ▚
      ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
      ◀ 1/99▶┈▲1X▼
      [label              ]
      [value              ]

  val: (max / (barHeight * 2)): unit
      val / unit -> █
      (val mod unit) < unit -> ▀_
      (val mod unit) < unit -> ▄_

      if nextval > val:
          diff = nextval - val
          if diff < unit: discard
          if diff >= unit: ▞

      elif nextval < val:
          diff = val - nextval
          if diff < unit: discard
          if diff >= unit: ▚
  ▀ ▄




  [⬒] Plant water level:
      >100├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
      100├┈┈┈┈╻┃╻┈┈┈┃╻┈┈┈┈┈┈┈┈
        50├┈┈┈┃┃┃┃┃┈┃┃┃┃┈┈┈┈┈┈┈
        25├┈┈┃┃┃┃┃┃┃┃┃┃┃┃┈┈┈┈┈┈
        5├┈┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃╻┈┈┈
        0├┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┈┈
          ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
          ◀ 1/99▶┈▲1X▼
          [label              ]
          [value              ]



>100├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
 100├┈┈┈┈╻┃╻┈┈┈┈┈┈┈┈┈┈┈┈┈
  50├┈┈┈┃┃┃┃┃┈┈┈┈┈┈┈┈┈┈┈┈
  25├┈┈┃┃┃┃┃┃┃┈┈┈┈┈┈┈┈┈┈┈
   5├┈┈┃┃┃┃┃┃┃┈┈┈┈┈┈┈┈┈┈┈
   0├┈┈┃┃┃┃┃┃┃┈┈┈┈┈┈┈┈┈┈.,¸┈
  -5├╵│       ╵││││╵`'     ˘ˇ
 -25├          ╵││
 -50├            │

 ╹
  """

  echo "\e[0m"
  echo "[⬒] Plant water level: C256 \e[38;5;2m"
  echo "  >100├\e[48;5;233m                   \e[48;5;0m"
  echo "   100├\e[48;5;234m    ▄▀▄   ▞▚       \e[48;5;0m"
  echo "    50├\e[48;5;233m   ▞   ▚ ▞  ▚      \e[48;5;0m"
  echo "    25├\e[48;5;234m  ▞     ▀    ▚     \e[48;5;0m"
  echo "     5├\e[48;5;233m ▞            ▀▄   \e[48;5;0m"
  echo "     0├\e[48;5;234m▞               ▚  \e[48;5;0m"
  echo "      ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔\e[48;5;0m"
  echo "\e[0m"
  echo "      ◀ 1/99▶ ▲1X▼"
  echo "      [label              ]"
  echo "      [value              ]"
  echo "\e[0m"
  echo "\n"


  echo "\e[0m"
  echo "[⬒] Plant water level:     "
  echo "  \e[37m>100├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈"
  echo "   \e[37m100├┈┈┈┈\e[32m╻┃╻\e[37m┈┈┈\e[32m┃╻\e[37m┈┈┈┈┈┈┈┈"
  echo "    \e[37m50├┈┈┈\e[32m┃┃┃┃┃\e[37m┈\e[32m┃┃┃┃\e[37m┈┈┈┈┈┈┈"
  echo "    \e[37m25├┈┈\e[32m┃┃┃┃┃┃┃┃┃┃┃┃\e[37m┈┈┈┈┈┈"
  echo "     \e[37m5├┈\e[32m┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃╻\e[37m┈┈┈"
  echo "     \e[37m0├\e[32m┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃\e[37m┈┈"
  echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶┈▲1X▼        "
  echo "      [label              ]"
  echo "      [value              ]"
  echo "\n\n"

  echo "[⬒] Plant water level:     "
  echo "  \e[37m>100\e[36m├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈"
  echo "   \e[37m100\e[36m├┈┈┈┈\e[93m╻┃╻\e[36m┈┈┈\e[93m┃╻\e[36m┈┈┈┈┈┈┈┈"
  echo "    \e[37m50\e[36m├┈┈┈\e[93m┃┃┃┃┃\e[36m┈\e[93m┃┃┃┃\e[36m┈┈┈┈┈┈┈"
  echo "    \e[37m25\e[36m├┈┈\e[93m┃┃┃┃┃┃┃┃┃┃┃┃\e[36m┈┈┈┈┈┈"
  echo "     \e[37m5\e[36m├┈\e[93m┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃╻\e[36m┈┈┈"
  echo "     \e[37m0\e[36m├\e[93m┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃\e[36m┈┈"
  echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶┈▲1X▼        "
  echo "      [label              ]"
  echo "      [value              ]"
  echo "\n\n"

  echo "[⬒] Plant water level:     "
  echo "  \e[37m>100\e[36m├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈"
  echo "   \e[37m100\e[36m├┈┈┈┈\e[32m╻┃╻\e[36m┈┈┈\e[32m┃╻\e[36m┈┈┈┈┈┈┈┈"
  echo "    \e[37m50\e[36m├┈┈┈\e[32m┃┃┃┃┃\e[36m┈\e[32m┃┃┃┃\e[36m┈┈┈┈┈┈┈"
  echo "    \e[37m25\e[36m├┈┈\e[32m┃┃┃┃┃┃┃┃┃┃┃┃\e[36m┈┈┈┈┈┈"
  echo "     \e[37m5\e[36m├┈\e[32m┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃╻\e[36m┈┈┈"
  echo "     \e[37m0\e[36m├\e[32m┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃\e[36m┈┈"
  echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶┈▲1X▼        "
  echo "      [label              ]"
  echo "      [value              ]"
  echo "\n\n"


  echo "\e[48;5;0m\e[38;5;15m"
  echo "[⬒] Plant water level C256:     "
  #echo "  \e[38;5;15m├\e[48;5;233m┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈\e[48;5;0m"
  stdout.write "\e[38;5;82m"
  echo "   100├\e[48;5;234m    ╻┃╻   ┃╻        \e[48;5;0m"
  echo "    50├\e[48;5;233m   ┃┃┃┃┃  ┃┃┃       \e[48;5;0m"
  echo "    25├\e[48;5;234m  ┃┃┃┃┃┃┃┃┃┃┃┃      \e[48;5;0m"
  echo "     5├\e[48;5;233m ┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃╻   \e[48;5;0m"
  echo "     0├\e[48;5;234m┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃  \e[48;5;0m"
  echo "      ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "\e[38;5;15m       ◀ 1/99▶┈▲1X▼        "
  echo "      [label              ]"
  echo "      [value              ]"
  echo "\e0m\n\n"



  echo "[⬒] Plant water level:     "
  echo "  \e[37m>100\e[36m├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈"
  echo "   \e[37m100\e[36m├┈┈┈┈\e[32m▗▐▗\e[36m┈┈┈\e[32m▐▗\e[36m┈┈┈┈┈┈┈┈"
  echo "    \e[37m50\e[36m├┈┈┈\e[32m▐▐▐▐▐\e[36m┈\e[32m▐▐▐▐\e[36m┈┈┈┈┈┈┈"
  echo "    \e[37m25\e[36m├┈┈\e[32m▐▐▐▐▐▐▐▐▐▐▐▐\e[36m┈┈┈┈┈┈"
  echo "     \e[37m5\e[36m├┈\e[32m▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐▗\e[36m┈┈┈"
  echo "     \e[37m0\e[36m├\e[32m▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐\e[36m┈┈"
  echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶┈▲1X▼        "
  echo "      [label              ]"
  echo "      [value              ]"
  echo "\n\n"








  echo "\e[48;5;4m"
  echo "\e[48;5;4m[⬒] Plant water level C256:"
  #echo "      \e[38;5;15m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁"
  echo "  \e[38;5;15m>100\e[38;5;24m├\e[48;5;233m\e[38;5;82m▄▃▂                 \e[48;5;4m"
  echo "    \e[38;5;15m90\e[38;5;24m├\e[48;5;234m\e[38;5;82m█████  █    ▄       \e[48;5;4m"
  echo "    \e[38;5;15m70\e[38;5;24m├\e[48;5;233m\e[38;5;82m█████ ███ ████      \e[48;5;4m"
  echo "    \e[38;5;15m50\e[38;5;24m├\e[48;5;234m\e[38;5;82m███████████████     \e[48;5;4m"
  echo "    \e[38;5;15m30\e[38;5;24m├\e[48;5;233m\e[38;5;82m████████████████▃▂██\e[48;5;4m"
  echo "    \e[38;5;15m10\e[38;5;24m├\e[48;5;234m\e[38;5;82m████████████████████\e[48;5;4m"
  echo "      \e[48;5;4m\e[38;5;15m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶ ▲1X▼"
  echo "       [label              ]"
  echo "       [avg:               ]"
  echo "       [max:               ]"
  echo "       [min:               ] \e[0m"
  echo "\n\n"


  echo "\e[48;5;4m"
  echo "\e[48;5;4m[⬒] Plant water level C256:"
  #echo "      \e[38;5;15m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁"
  echo "  \e[38;5;15m>100\e[38;5;24m├\e[48;5;233m\e[38;5;82m▄\e[38;5;40m▃\e[38;5;82m▂\e[38;5;40m \e[38;5;82m \e[38;5;40m               \e[48;5;4m"
  echo "    \e[38;5;15m90\e[38;5;24m├\e[48;5;234m\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m  █    ▄       \e[48;5;4m"
  echo "    \e[38;5;15m70\e[38;5;24m├\e[48;5;233m\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m ███ ████      \e[48;5;4m"
  echo "    \e[38;5;15m50\e[38;5;24m├\e[48;5;234m\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m██████████     \e[48;5;4m"
  echo "    \e[38;5;15m30\e[38;5;24m├\e[48;5;233m\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m███████████▃▂██\e[48;5;4m"
  echo "    \e[38;5;15m10\e[38;5;24m├\e[48;5;234m\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m█\e[38;5;82m█\e[38;5;40m███████████████\e[48;5;4m"
  echo "      \e[48;5;4m\e[38;5;15m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶ ▲1X▼"
  echo "       [label              ]"
  echo "       [avg:               ]"
  echo "       [max:               ]"
  echo "       [min:               ] \e[0m"
  echo "\n\n"




  echo "\e[44m[⬒] Plant water level:"
  echo "      \e[94m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁"
  echo "  \e[37m>100\e[94m├\e[93m▄▃▂\e[94m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▏"
  echo "    \e[37m90\e[94m├\e[93m█████\e[94m▁▁\e[93m█\e[94m▁▁▁▁\e[93m▄\e[94m▁▁▁▁▁▁▁▏"
  echo "    \e[37m70\e[94m├\e[93m█████\e[94m▁\e[93m███\e[94m▁\e[93m████\e[94m▁▁▁▁▁▁▏"
  echo "    \e[37m50\e[94m├\e[93m███████████████\e[94m▁▁▁▁▁▏"
  echo "    \e[37m30\e[94m├\e[93m████████████████▃▂██▏"
  echo "    \e[37m10\e[94m├\e[93m████████████████████"
  echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶ ▲1X▼"
  echo "       [label              ]"
  echo "       [avg:               ]"
  echo "       [max:               ]"
  echo "       [min:               ] \e[0m"
  echo "\n\n"

  echo "\e[44m[⬒] Plant water level:"
  echo "      \e[94m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁"
  echo "  \e[37m>100\e[94m├\e[93m▄▃▂\e[94m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▏"
  echo "    \e[37m90\e[94m├\e[93m█▓█▓█\e[94m▁▁\e[93m▓\e[94m▁▁▁▁\e[93m▄\e[94m▁▁▁▁▁▁▁▏"
  echo "    \e[37m70\e[94m├\e[93m█▓█▓█\e[94m▁\e[93m█▓█\e[94m▁\e[93m█▓█▓\e[94m▁▁▁▁▁▁▏"
  echo "    \e[37m50\e[94m├\e[93m█▓█▓█▓█▓█▓█▓█▓█\e[94m▁▁▁▁▁▏"
  echo "    \e[37m30\e[94m├\e[93m█▓█▓█▓█▓█▓█▓█▓█▓▃▂█▓▏"
  echo "    \e[37m10\e[94m├\e[93m█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓▏"
  echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶ ▲1X▼"
  echo "       [label              ]"
  echo "       [avg:               ]"
  echo "       [max:               ]"
  echo "       [min:               ] \e[0m"
  echo "\n\n"

  echo "\e[44m[⬒] Plant water level:                \e[44m"
  echo "      \e[44m\e[32m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁ \e[44m"
  echo "  \e[37m>100\e[40m\e[32m├\e[93m▄▃▂\e[32m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁\e[44m▏"
  echo "    \e[37m90\e[40m\e[32m├\e[93m█▓█▓█\e[32m▁▁\e[93m▓\e[32m▁▁▁▁\e[93m▄\e[32m▁▁▁▁▁▁▁\e[44m▏"
  echo "    \e[37m70\e[40m\e[32m├\e[93m█▓█▓█\e[32m▁\e[93m█▓█\e[32m▁\e[93m█▓█▓\e[32m▁▁▁▁▁▁\e[44m▏"
  echo "    \e[37m50\e[40m\e[32m├\e[93m█▓█▓█▓█▓█▓█▓█▓█\e[32m▁▁▁▁▁\e[44m▏"
  echo "    \e[37m30\e[40m\e[32m├\e[93m█▓█▓█▓█▓█▓█▓█▓█▓▃▂█▓\e[44m▏"
  echo "    \e[37m10\e[40m\e[32m├\e[93m█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓\e[44m▏"
  echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔\e[44m"
  echo "       ◀ 1/99▶ ▲1X▼"
  echo "       [label              ]"
  echo "       [avg:               ]"
  echo "       [max:               ]"
  echo "       [min:               ] \e[0m"
  echo "\n\n"




  echo "\e[0m[⬒] Plant water level:"
  echo "      \e[34m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁"
  echo "  \e[37m>100\e[34m├\e[93m▄▃▂\e[34m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▏"
  echo "    \e[37m90\e[34m├\e[93m█▓█▓█\e[34m▁▁\e[93m▓\e[34m▁▁▁▁\e[93m▄\e[34m▁▁▁▁▁▁▁▏"
  echo "    \e[37m70\e[34m├\e[93m█▓█▓█\e[34m▁\e[93m█▓█\e[34m▁\e[93m█▓█▓\e[34m▁▁▁▁▁▁▏"
  echo "    \e[37m50\e[34m├\e[93m█▓█▓█▓█▓█▓█▓█▓█\e[34m▁▁▁▁▁▏"
  echo "    \e[37m30\e[34m├\e[93m█▓█▓█▓█▓█▓█▓█▓█▓▃▂█▓▏"
  echo "    \e[37m10\e[34m├\e[93m█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓▏"
  echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶ ▲1X▼"
  echo "       [label              ]"
  echo "       [avg:               ]"
  echo "       [max:               ]"
  echo "       [min:               ] \e[0m"
  echo "\n\n"

  echo "\e[0m[⬒] Plant water level:"
  echo "      \e[34m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁"
  echo "  \e[37m>100\e[34m├\e[32m▄▃▂\e[34m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▏"
  echo "    \e[37m90\e[34m├\e[32m█▓█▓█\e[34m▁▁\e[32m▓\e[34m▁▁▁▁\e[32m▄\e[34m▁▁▁▁▁▁▁▏"
  echo "    \e[37m70\e[34m├\e[32m█▓█▓█\e[34m▁\e[32m█▓█\e[34m▁\e[32m█▓█▓\e[34m▁▁▁▁▁▁▏"
  echo "    \e[37m50\e[34m├\e[32m█▓█▓█▓█▓█▓█▓█▓█\e[34m▁▁▁▁▁▏"
  echo "    \e[37m30\e[34m├\e[32m█▓█▓█▓█▓█▓█▓█▓█▓▃▂█▓▏"
  echo "    \e[37m10\e[34m├\e[32m█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓▏"
  echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       ◀ 1/99▶ ▲1X▼"
  echo "       [label              ]"
  echo "       [avg:               ]"
  echo "       [max:               ]"
  echo "       [min:               ] \e[0m"
  echo "\n\n"



  #echo " \e[34m\e[40m▐\e[44m\e[30m││││││\e[34m\e[40m▌││││   \e[0m"
  #echo " \e[34m\e[40m▐\e[44m\e[30m││││││\e[34m\e[40m▌││││   \e[0m"
  #echo "\n"
  #
  #echo " \e[40m\e[34m████▍▏▏▏▏▏▏▏▏\e[0m"
  #echo " \e[40m\e[34m████▍▏▏▏▏▏▏▏▏\e[0m"
  #echo "\n"

  echo " \e[40m\e[36m▉▉▉▉▉▉▉▉\e[34m▏▏▏▏▏▏▏▏\e[0m"
  echo " \e[40m\e[36m▉▉▉▉▉▉▉▉\e[34m▏▏▏▏▏▏▏▏\e[0m"
  echo "\n"

  echo " \e[40m\e[36m▉▉▉▉▉▉▉▉▌\e[34m▏▏▏▏▏▏▏▏\e[0m"
  echo " \e[40m\e[36m▉▉▉▉▉▉▉▉▌\e[34m▏▏▏▏▏▏▏▏\e[0m"
  echo "\n"

  #echo " \e[40m\e[34m▉▉▉▉▉▉▉▏▏▏▏▏▏▏\e[0m"
  #echo " \e[40m\e[34m▉▉▉▉▉▉▉▏▏▏▏▏▏▏\e[0m"
  #
  echo "\n\n"





  echo "\e[0m[⬒] Plant water level:"
  echo "      \e[34m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁"
  echo "  \e[37m>100\e[34m├\e[32m▄▄▂▂\e[34m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▏"
  echo "    \e[37m90\e[34m├\e[32m██▓▓\e[34m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▏"
  echo "    \e[37m70\e[34m├\e[32m██▓▓\e[34m▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▏"
  echo "    \e[37m50\e[34m├\e[32m██▓▓██▓▓\e[34m▁\e[32m███\e[34m▁\e[32m▓▓▓\e[34m▁\e[32m██\e[34m▁\e[32m▓▓\e[34m▁\e[32m█\e[34m▁\e[32m▓\e[34m▁▏"
  echo "    \e[37m30\e[34m├\e[32m██▓▓██▓▓\e[34m▁\e[32m███\e[34m▁\e[32m▓▓▓\e[34m▁\e[32m██\e[34m▁\e[32m▓▓\e[34m▁\e[32m█\e[34m▁\e[32m▓\e[34m▁▏"
  echo "    \e[37m10\e[34m├\e[32m██▓▓██▓▓\e[34m▁\e[32m███\e[34m▁\e[32m▓▓▓\e[34m▁\e[32m██\e[34m▁\e[32m▓▓\e[34m▁\e[32m█\e[34m▁\e[32m▓\e[34m▁▏"
  #echo "      \e[37m▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
  echo "       \e[30m\e[47m1 2 3 4   5   6  7  8  9 10\e[0m\n"
  echo ""
  echo "       ◀ 1/99▶ ▲1X▼"
  echo "       [label              ]"
  echo "       [avg:               ]"
  echo "       [max:               ]"
  echo "       [min:               ] \e[0m"
  echo """


  width (if -1: auto), gap, 
  character A/B for 16C runeBlockA, 
  runeEmpty column even/odd styles, 
  row even/odd styles
  row color or runeEmpty  not both

  markColor/markStyle for the graph marks and lines or style["input"] BG Black, FG green
  window style may be used too

  may use padding in cases window and controll bg colors different

  BW/16C/256C/RGB drawing modes; setMode("16C")
  proc set....

  DataSet2D =
   data: ref object of seq[int] / seq[float] #?
   divider: int # seq[int], repeat last divider: 24,7,4,12,2
   yName, xName: the name of y, x axes 

  draw should calculate graphX1, Y1, W, H, X2, Y2
  drawgraph should 
    calc first with divider, offset, 
    calc avg or valu
    setColor if current

    calc y marks from height, maxValue, minValue.

    ??? negative marks, baseline? avg line/mark?
    negative even/odd styles
   
  """

