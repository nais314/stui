#[
    based on: https://jonasjacek.github.io/colors/
    CSS color names used
]#
type Color256* = enum
    Black = 0,      #000000	rgb(0,0,0)	
    Maroon = 1,     #800000	rgb(128,0,0)
    Green = 2,      #008000	rgb(0,128,0)
    Olive = 3,      #808000	rgb(128,128,0)
    Navy = 4,       #000080	rgb(0,0,128)
    Purple = 5,     #800080	rgb(128,0,128)
    Teal = 6,       #008080	rgb(0,128,128)
    Silver = 7,     #c0c0c0	rgb(192,192,19
    Grey = 8,       #808080	rgb(128,128,12
    Red = 9,        #ff0000	rgb(255,0,0)
    Lime = 10,      #00ff00	rgb(0,255,0)
    Yellow = 11,    #ffff00	rgb(255,255,0)
    Blue = 12,      #0000ff	rgb(0,0,255)
    Fuchsia = 13,      #ff00ff	rgb(255,0,255)
    Aqua = 14,      #00ffff	rgb(0,255,255)	h
    White = 15,     #ffffff	rgb(255,255,255)
    Grey0 = 16,     #000000	rgb(0,0,0)
    NavyBlue = 17,  #00005f	rgb(0,0,95)	
    DarkBlue = 18,  #000087	rgb(0,0,135)
    Blue3 = 19,     #0000af	rgb(0,0,175)
    Blue32 = 20,    #0000d7	rgb(0,0,215)
    Blue1 = 21,     #0000ff	rgb(0,0,255)
    DarkGreen = 22, #005f00	rgb(0,95,0)
    DeepSkyBlue4 = 23,  #005f5f	rgb(0,95,95)	
    DeepSkyBlue42 = 24, #005f87	rgb(0,95,135)
    DeepSkyBlue43 = 25, #005faf	rgb(0,95,175)
    DodgerBlue3 = 26,   #005fd7	rgb(0,95,215)
    DodgerBlue2 = 27,   #005fff	rgb(0,95,255)
    Green4 = 28,        #008700	rgb(0,135,0)
    SpringGreen4 = 29,  #00875f	rgb(0,135,95)
    Turquoise4 = 30,    #008787	rgb(0,135,135)
    DeepSkyBlue3 = 31,  #0087af	rgb(0,135,175)
    DeepSkyBlue32 = 32, #0087d7	rgb(0,135,215)
    DodgerBlue = 33,   #0087ff	rgb(0,135,255)
    Green3 = 34,        #00af00	rgb(0,175,0)
    SpringGreen3 = 35,  #00af5f	rgb(0,175,95)
    DarkCyan = 36,      #00af87	rgb(0,175,135)
    LightSeaGreen = 37, #00afaf	rgb(0,175,175)
    DeepSkyBlue2 = 38,  #00afd7	rgb(0,175,215)
    DeepSkyBlue = 39,  #00afff	rgb(0,175,255)
    Green32 = 40,       #00d700	rgb(0,215,0)
    SpringGreen32 = 41, #00d75f	rgb(0,215,95)
    SpringGreen2 = 42,  #00d787	rgb(0,215,135)
    Cyan3 = 43,         #00d7af	rgb(0,215,175)
    DarkTurquoise = 44, #00d7d7	rgb(0,215,215)
    Turquoise2 = 45,    #00d7ff	rgb(0,215,255)
    Green1 = 46,        #00ff00	rgb(0,255,0)
    SpringGreen22 = 47, #00ff5f	rgb(0,255,95)	
    SpringGreen = 48,  #00ff87	rgb(0,255,135)
    MediumSpringGreen = 49, #00ffaf	rgb(0,255,175)
    Turquoise = 50,     #00ffd7	rgb(0,255,215)
    Cyan = 51,     #00ffff	rgb(0,255,255)
    DarkRed = 52,
    DeepPink4 = 53,
    Purple4 = 54,
    Purple42 = 55,
    Purple3 = 56,
    BlueViolet = 57,
    Orange4 = 58,
    Grey37 = 59,
    MediumPurple4 = 60,
    SlateBlue3 = 61,
    SlateBlue32 = 62,
    RoyalBlue = 63,
    Chartreuse4 = 64,
    DarkSeaGreen4 = 65,
    PaleTurquoise4 = 66,
    SteelBlue = 67,
    SteelBlue3 = 68,
    CornflowerBlue = 69,
    Chartreuse3 = 70,
    DarkSeaGreen42 = 71,
    CadetBlue = 72,
    CadetBlue2 = 73,
    SkyBlue3 = 74,
    SteelBlue1 = 75,
    Chartreuse32 = 76,
    PaleGreen32 = 77,
    SeaGreen3 = 78,
    Aquamarine3 = 79,
    MediumTurquoise = 80,
    SteelBlue12 = 81,
    Chartreuse2 = 82,
    SeaGreen2 = 83,
    SeaGreen = 84,
    SeaGreen12 = 85,
    Aquamarine = 86,
    DarkSlateGray2 = 87,
    DarkRed2 = 88,
    DeepPink43 = 89,
    DarkMagenta = 90,
    DarkMagenta2 = 91,
    DarkViolet = 92,
    Purple2 = 93,
    Orange42 = 94,
    LightPink4 = 95,
    Plum4 = 96,
    MediumPurple3 = 97,
    MediumPurple32 = 98,
    SlateBlue = 99,
    Yellow4 = 100,
    Wheat4 = 101,
    Grey53 = 102,
    LightSlateGrey = 103,
    MediumPurple = 104,
    LightSlateBlue = 105,
    YellowGreen = 106,
    DarkOliveGreen3 = 107,
    DarkSeaGreen = 108,
    LightSkyBlue3 = 109,
    LightSkyBlue32 = 110,
    SkyBlue2 = 111,
    Chartreuse22 = 112,
    DarkOliveGreen33 = 113,
    PaleGreen3 = 114,
    DarkSeaGreen3 = 115,
    DarkSlateGray3 = 116,
    SkyBlue = 117,
    Chartreuse = 118,
    LightGreen = 119,
    LightGreen2 = 120,
    PaleGreen = 121,
    Aquamarine12 = 122,
    LightCyan = 123,
    Red3 = 124,
    DeepPink42 = 125,
    MediumVioletRed = 126,
    Magenta3 = 127,
    DarkViolet2 = 128,
    Purple32 = 129,
    DarkOrange3 = 130,
    IndianRed = 131,
    HotPink3 = 132,
    MediumOrchid3 = 133,
    MediumOrchid = 134,
    MediumPurple2 = 135,
    DarkGoldenrod = 136,
    LightSalmon3 = 137,
    RosyBrown = 138,
    Grey63 = 139,
    MediumPurple22 = 140,
    MediumPurple1 = 141,
    Gold3 = 142,
    DarkKhaki = 143,
    NavajoWhite3 = 144,
    Grey69 = 145,
    LightSteelBlue3 = 146,
    LightSteelBlue = 147,
    Yellow3 = 148,
    DarkOliveGreen32 = 149,
    DarkSeaGreen32 = 150,
    DarkSeaGreen2 = 151,
    LightCyan3 = 152,
    LightSkyBlue = 153,
    GreenYellow = 154,
    DarkOliveGreen2 = 155,
    PaleGreen12 = 156,
    DarkSeaGreen22 = 157,
    DarkSeaGreen1 = 158,
    PaleTurquoise1 = 159,
    Red32 = 160,
    DeepPink3 = 161,
    DeepPink32 = 162,
    Magenta32 = 163,
    Magenta33 = 164,
    Magenta2 = 165,
    DarkOrange32 = 166,
    IndianRed2 = 167,
    HotPink32 = 168,
    HotPink2 = 169,
    Orchid = 170,
    MediumOrchid1 = 171,
    Orange3 = 172,
    LightSalmon32 = 173,
    LightPink3 = 174,
    Pink3 = 175,
    Plum3 = 176,
    #[ Violet ]# Plum = 177,
    Gold32 = 178,
    LightGoldenrod3 = 179,
    Tan = 180,
    MistyRose3 = 181,
    Thistle3 = 182,
    Plum2 = 183,
    Yellow32 = 184,
    Khaki3 = 185,
    LightGoldenrod2 = 186,
    LightYellow = 187,
    Grey84 = 188,
    LightSteelBlue1 = 189,
    Yellow2 = 190,
    DarkOliveGreen = 191,
    DarkOliveGreen12 = 192,
    DarkSeaGreen12 = 193,
    Honeydew = 194,
    LightCyan1 = 195,
    Red1 = 196,
    DeepPink2 = 197,
    DeepPink = 198,
    DeepPink12 = 199,
    Magenta22 = 200,
    Magenta = 201,
    OrangeRed = 202,
    IndianRed1 = 203,
    IndianRed12 = 204,
    HotPink = 205,
    HotPink11 = 206,
    MediumOrchid12 = 207,
    DarkOrange = 208,
    Salmon = 209,
    LightCoral = 210,
    PaleVioletRed1 = 211,
    Orchid2 = 212,
    Orchid1 = 213,
    Orange = 214,
    SandyBrown = 215,
    LightSalmon = 216,
    LightPink = 217,
    Pink = 218,
    Plum1 = 219,
    Gold = 220,
    LightGoldenrod22 = 221,
    LightGoldenrod222 = 222,
    NavajoWhite = 223,
    MistyRose = 224,
    Thistle = 225,
    Yellow1 = 226,
    LightGoldenrod = 227,
    Khaki = 228,
    Wheat = 229,
    Cornsilk = 230,
    Grey100 = 231,
    Grey3 = 232,
    Grey7 = 233,
    Grey11 = 234,
    Grey15 = 235,
    Grey19 = 236,
    Grey23 = 237,
    Grey27 = 238,
    Grey30 = 239,
    Grey35 = 240,
    Grey39 = 241,
    Grey42 = 242,
    Grey46 = 243,
    Grey50 = 244,
    Grey54 = 245,
    Grey58 = 246,
    Grey62 = 247,
    Grey66 = 248,
    Grey70 = 249,
    Grey74 = 250,
    Grey78 = 251,
    Grey82 = 252,
    Grey85 = 253,
    Grey89 = 254,
    Grey93 = 255











var colorNames256* = [
        ("Black" , 0),      #000000	rgb(0),0),0)	
        ("Maroon" , 1),     #800000	rgb(128),0),0)
        ("Green" , 2),      #008000	rgb(0),128),0)
        ("Olive" , 3),      #808000	rgb(128),128),0)
        ("Navy" , 4),       #000080	rgb(0),0),128)
        ("Purple" , 5),     #800080	rgb(128),0),128)
        ("Teal" , 6),       #008080	rgb(0),128),128)
        ("Silver" , 7),     #c0c0c0	rgb(192),192),19
        ("Grey" , 8),       #808080	rgb(128),128),12
        ("Red" , 9),        #ff0000	rgb(255),0),0)
        ("Lime" , 10),      #00ff00	rgb(0),255),0)
        ("Yellow" , 11),    #ffff00	rgb(255),255),0)
        ("Blue" , 12),      #0000ff	rgb(0),0),255)
        ("Fuchsia" , 13),      #ff00ff	rgb(255),0),255)
        ("Aqua" , 14),      #00ffff	rgb(0),255),255)	h
        ("White" , 15),     #ffffff	rgb(255),255),255)
        ("Grey0" , 16),     #000000	rgb(0),0),0)
        ("NavyBlue" , 17),  #00005f	rgb(0),0),95)	
        ("DarkBlue" , 18),  #000087	rgb(0),0),135)
        ("Blue3" , 19),     #0000af	rgb(0),0),175)
        ("Blue32" , 20),    #0000d7	rgb(0),0),215)
        ("Blue1" , 21),     #0000ff	rgb(0),0),255)
        ("DarkGreen" , 22), #005f00	rgb(0),95),0)
        ("DeepSkyBlue4" , 23),  #005f5f	rgb(0),95),95)	
        ("DeepSkyBlue42" , 24), #005f87	rgb(0),95),135)
        ("DeepSkyBlue43" , 25), #005faf	rgb(0),95),175)
        ("DodgerBlue3" , 26),   #005fd7	rgb(0),95),215)
        ("DodgerBlue2" , 27),   #005fff	rgb(0),95),255)
        ("Green4" , 28),        #008700	rgb(0),135),0)
        ("SpringGreen4" , 29),  #00875f	rgb(0),135),95)
        ("Turquoise4" , 30),    #008787	rgb(0),135),135)
        ("DeepSkyBlue3" , 31),  #0087af	rgb(0),135),175)
        ("DeepSkyBlue32" , 32), #0087d7	rgb(0),135),215)
        ("DodgerBlue" , 33),   #0087ff	rgb(0),135),255)
        ("Green3" , 34),        #00af00	rgb(0),175),0)
        ("SpringGreen3" , 35),  #00af5f	rgb(0),175),95)
        ("DarkCyan" , 36),      #00af87	rgb(0),175),135)
        ("LightSeaGreen" , 37), #00afaf	rgb(0),175),175)
        ("DeepSkyBlue2" , 38),  #00afd7	rgb(0),175),215)
        ("DeepSkyBlue" , 39),  #00afff	rgb(0),175),255)
        ("Green32" , 40),       #00d700	rgb(0),215),0)
        ("SpringGreen32" , 41), #00d75f	rgb(0),215),95)
        ("SpringGreen2" , 42),  #00d787	rgb(0),215),135)
        ("Cyan3" , 43),         #00d7af	rgb(0),215),175)
        ("DarkTurquoise" , 44), #00d7d7	rgb(0),215),215)
        ("Turquoise2" , 45),    #00d7ff	rgb(0),215),255)
        ("Green1" , 46),        #00ff00	rgb(0),255),0)
        ("SpringGreen22" , 47), #00ff5f	rgb(0),255),95)	
        ("SpringGreen" , 48),  #00ff87	rgb(0),255),135)
        ("MediumSpringGreen" , 49), #00ffaf	rgb(0),255),175)
        ("Turquoise" , 50),     #00ffd7	rgb(0),255),215)
        ("Cyan" , 51),     #00ffff	rgb(0),255),255)
        ("DarkRed" , 52),
        ("DeepPink4" , 53),
        ("Purple4" , 54),
        ("Purple42" , 55),
        ("Purple3" , 56),
        ("BlueViolet" , 57),
        ("Orange4" , 58),
        ("Grey37" , 59),
        ("MediumPurple4" , 60),
        ("SlateBlue3" , 61),
        ("SlateBlue32" , 62),
        ("RoyalBlue" , 63),
        ("Chartreuse4" , 64),
        ("DarkSeaGreen4" , 65),
        ("PaleTurquoise4" , 66),
        ("SteelBlue" , 67),
        ("SteelBlue3" , 68),
        ("CornflowerBlue" , 69),
        ("Chartreuse3" , 70),
        ("DarkSeaGreen42" , 71),
        ("CadetBlue" , 72),
        ("CadetBlue2" , 73),
        ("SkyBlue3" , 74),
        ("SteelBlue1" , 75),
        ("Chartreuse32" , 76),
        ("PaleGreen32" , 77),
        ("SeaGreen3" , 78),
        ("Aquamarine3" , 79),
        ("MediumTurquoise" , 80),
        ("SteelBlue12" , 81),
        ("Chartreuse2" , 82),
        ("SeaGreen2" , 83),
        ("SeaGreen" , 84),
        ("SeaGreen12" , 85),
        ("Aquamarine" , 86),
        ("DarkSlateGray2" , 87),
        ("DarkRed2" , 88),
        ("DeepPink43" , 89),
        ("DarkMagenta" , 90),
        ("DarkMagenta2" , 91),
        ("DarkViolet" , 92),
        ("Purple2" , 93),
        ("Orange42" , 94),
        ("LightPink4" , 95),
        ("Plum4" , 96),
        ("MediumPurple3" , 97),
        ("MediumPurple32" , 98),
        ("SlateBlue" , 99),
        ("Yellow4" , 100),
        ("Wheat4" , 101),
        ("Grey53" , 102),
        ("LightSlateGrey" , 103),
        ("MediumPurple" , 104),
        ("LightSlateBlue" , 105),
        ("YellowGreen" , 106),
        ("DarkOliveGreen3" , 107),
        ("DarkSeaGreen" , 108),
        ("LightSkyBlue3" , 109),
        ("LightSkyBlue32" , 110),
        ("SkyBlue2" , 111),
        ("Chartreuse22" , 112),
        ("DarkOliveGreen33" , 113),
        ("PaleGreen3" , 114),
        ("DarkSeaGreen3" , 115),
        ("DarkSlateGray3" , 116),
        ("SkyBlue" , 117),
        ("Chartreuse" , 118),
        ("LightGreen" , 119),
        ("LightGreen2" , 120),
        ("PaleGreen" , 121),
        ("Aquamarine12" , 122),
        ("LightCyan" , 123),
        ("Red3" , 124),
        ("DeepPink42" , 125),
        ("MediumVioletRed" , 126),
        ("Magenta3" , 127),
        ("DarkViolet2" , 128),
        ("Purple32" , 129),
        ("DarkOrange3" , 130),
        ("IndianRed" , 131),
        ("HotPink3" , 132),
        ("MediumOrchid3" , 133),
        ("MediumOrchid" , 134),
        ("MediumPurple2" , 135),
        ("DarkGoldenrod" , 136),
        ("LightSalmon3" , 137),
        ("RosyBrown" , 138),
        ("Grey63" , 139),
        ("MediumPurple22" , 140),
        ("MediumPurple1" , 141),
        ("Gold3" , 142),
        ("DarkKhaki" , 143),
        ("NavajoWhite3" , 144),
        ("Grey69" , 145),
        ("LightSteelBlue3" , 146),
        ("LightSteelBlue" , 147),
        ("Yellow3" , 148),
        ("DarkOliveGreen32" , 149),
        ("DarkSeaGreen32" , 150),
        ("DarkSeaGreen2" , 151),
        ("LightCyan3" , 152),
        ("LightSkyBlue" , 153),
        ("GreenYellow" , 154),
        ("DarkOliveGreen2" , 155),
        ("PaleGreen12" , 156),
        ("DarkSeaGreen22" , 157),
        ("DarkSeaGreen1" , 158),
        ("PaleTurquoise1" , 159),
        ("Red32" , 160),
        ("DeepPink3" , 161),
        ("DeepPink32" , 162),
        ("Magenta32" , 163),
        ("Magenta33" , 164),
        ("Magenta2" , 165),
        ("DarkOrange32" , 166),
        ("IndianRed2" , 167),
        ("HotPink32" , 168),
        ("HotPink2" , 169),
        ("Orchid" , 170),
        ("MediumOrchid1" , 171),
        ("Orange3" , 172),
        ("LightSalmon32" , 173),
        ("LightPink3" , 174),
        ("Pink3" , 175),
        ("Plum3" , 176),
        (#[ Violet ]# "Plum" , 177),
        ("Gold32" , 178),
        ("LightGoldenrod3" , 179),
        ("Tan" , 180),
        ("MistyRose3" , 181),
        ("Thistle3" , 182),
        ("Plum2" , 183),
        ("Yellow32" , 184),
        ("Khaki3" , 185),
        ("LightGoldenrod2" , 186),
        ("LightYellow" , 187),
        ("Grey84" , 188),
        ("LightSteelBlue1" , 189),
        ("Yellow2" , 190),
        ("DarkOliveGreen" , 191),
        ("DarkOliveGreen12" , 192),
        ("DarkSeaGreen12" , 193),
        ("Honeydew" , 194),
        ("LightCyan1" , 195),
        ("Red1" , 196),
        ("DeepPink2" , 197),
        ("DeepPink" , 198),
        ("DeepPink12" , 199),
        ("Magenta22" , 200),
        ("Magenta" , 201),
        ("OrangeRed" , 202),
        ("IndianRed1" , 203),
        ("IndianRed12" , 204),
        ("HotPink" , 205),
        ("HotPink11" , 206),
        ("MediumOrchid12" , 207),
        ("DarkOrange" , 208),
        ("Salmon" , 209),
        ("LightCoral" , 210),
        ("PaleVioletRed1" , 211),
        ("Orchid2" , 212),
        ("Orchid1" , 213),
        ("Orange" , 214),
        ("SandyBrown" , 215),
        ("LightSalmon" , 216),
        ("LightPink" , 217),
        ("Pink" , 218),
        ("Plum1" , 219),
        ("Gold" , 220),
        ("LightGoldenrod22" , 221),
        ("LightGoldenrod222" , 222),
        ("NavajoWhite" , 223),
        ("MistyRose" , 224),
        ("Thistle" , 225),
        ("Yellow1" , 226),
        ("LightGoldenrod" , 227),
        ("Khaki" , 228),
        ("Wheat" , 229),
        ("Cornsilk" , 230),
        ("Grey100" , 231),
        ("Grey3" , 232),
        ("Grey7" , 233),
        ("Grey11" , 234),
        ("Grey15" , 235),
        ("Grey19" , 236),
        ("Grey23" , 237),
        ("Grey27" , 238),
        ("Grey30" , 239),
        ("Grey35" , 240),
        ("Grey39" , 241),
        ("Grey42" , 242),
        ("Grey46" , 243),
        ("Grey50" , 244),
        ("Grey54" , 245),
        ("Grey58" , 246),
        ("Grey62" , 247),
        ("Grey66" , 248),
        ("Grey70" , 249),
        ("Grey74" , 250),
        ("Grey78" , 251),
        ("Grey82" , 252),
        ("Grey85" , 253),
        ("Grey89" , 254),
        ("Grey93" , 255)
    ]

when isMainModule:
    import strutils

    var test: Color256
    test = Gold
    echo test

    for i in 0..255:
        test = Color256(i)
        #echo alignLeft("test", 10) & "."
        stdout.write("\e[48;5;0m")
        #stdout.write("\e[38;5;" & $int(test) & "m " & "██████ " & '\n')
        stdout.write("\e[38;5;" & alignLeft( ($int(test) & "m " & "██████ " & $test), 44) & "  " & " | ")
        #stdout.write("\e[38;5;" & $int(test) & "m " & "██████ " & '\n')

        stdout.write("\e[48;5;15m")
        #stdout.write("\e[38;5;" & $int(test) & "m " & "██████ " & '\n')
        stdout.write("\e[38;5;" & alignLeft( ($int(test) & "m " & "██████ " & $test), 44) & "  " & "\n")
        #stdout.write("\e[38;5;" & $int(test) & "m " & "██████ " & '\n')
        stdout.write "\e[0m" 