<#
    PitWise - telemetrie, strategie & AI zavodni inzenyr pro sim racing (Assetto Corsa / ACC)
    ==========================================================================================
    Cte zivou telemetrii z herni SDILENE PAMETI (acpmf_physics/graphics/static) - bez zasahu do hry.
    Prehledny dashboard se sidebar navigaci. Zavodni inzenyr mluvi do "radia" (TTS) a umi AI konverzaci.
    v1.3: cesky hlas (auto-detekce), osobni rekordy per trat+vuz, export relace do souboru.
    v1.4: vlastni inzenyr (jmeno/povaha/instrukce/hlas/rychlost), zive grafy telemetrie,
          mapa trati (uci se z pozice vozu, uklada se per trat), zastupce na plose.
    v1.5: inzenyr v 7 jazycich (cs/en/de/es/fr/it/pl), odemknuti OneCore hlasu (Jakub!),
          instalace rozpoznavani reci pro mikrofon, bohatsi Prehled (STAV, pedaly, pozice),
          plynulejsi UI (100 ms tick), urgentni hlasky prerusuji frontu reci.
    v1.6: VLASTNI mikrofon bez Windows rozpoznavani - nahravani pres winmm (16 kHz WAV)
          + offline prepis Whisper (whisper.cpp, umi cestinu i vsech 7 jazyku);
          rozpoznavac se stahne jednim tlacitkem v Nastaveni (~80 MB, oficialni zdroje).
    v1.7: VYSILACKA - globalni push-to-talk klavesa (drzis = mluvis, funguje i ve hre;
          namapovatelna na tlacitko volantu pres MOZA Pit House) + whisper-server na pozadi
          (model porad v pameti = prepis a odpoved v realnem case).
    v1.8: bind vysilacky i v Nastaveni; PIPER prirozeny cesky hlas (volitelne stazeni);
          AI odpovedi maji prednost pred frontou hlasek; presnejsi prepis (zavodni slovnik);
          referencni kola GT3 pro zname trate; G-metr, opotrebeni gum, stopa rizeni.
    v1.9: OSOBNOST se projevi i v hlaskach (drsnak/kamos/analytik maji vlastni texty cs+en);
          zadne tiche selhani: "nerozumel jsem" rika nahlas, zaseknuty API dotaz se resetuje
          (watchdog 35 s), chyby API s detailem; radio log i do souboru %APPDATA%\PitWise\radio.log;
          po ulozeni inzenyra hned promluvi (slysis novou osobnost).
    v2.0: LOKALNI INZENYR - odpovida na otazky OKAMZITE z telemetrie i BEZ API klice
          (palivo/kola/pneu/casy/box/pozice, cesky i anglicky, respektuje povahu);
          pri chybe API prevezme odpoved lokalni rezim (nikdy ticho); tlacitka stahovani
          ukazuji stav NAINSTALOVANO; pill v hlavicce ukazuje faze vysilacky (REC/prepis/
          premysli); pojistka proti nahodnemu tuknuti vysilacky; cistejsi radio log.
    v2.1: ZIVA DELTA na nejlepsi kolo (normalizedCarPosition@248, profil best kola,
          prubezne +/- behem jizdy); HEATMAPA rychlosti na mape trati (cervena pomalu
          / zelena rychle, uklada se s mapou); barevny RPM bar s adaptivnim rozsahem;
          rychlost reci funguje i pro Piper (length_scale); radiovy beep pred hlaskou;
          FIX kodovani prepisu z whisper-serveru (curl -> soubor -> UTF-8, konec "Ĺ˝erej");
          tlacitko "Vylepsit prepis cestiny" = vetsi model small (190 MB, presnejsi CZ).
    v2.2: INZENYR SLEDUJE TRAT - zlute/modre vlajky (ACC), detekce kontaktu a bouracky
          z pretizeni + poklesu rychlosti (reakce podle povahy: drsnak "Kurva! Co to bylo?!");
          hlasovy povel "naplanuj box" / "zrus box"; AI si DOMYSLI zkomoleny prepis misto
          nadavani; STRATEGIE: plan stintu (kola, boxy, tankovani) + FIX casovych zavodu
          (sessionTimeLeft je v ms); prepinani hlasu FUNGUJE (Piper polozka v seznamu).
    v2.3: AUTO-DETEKCE HRY (proces + sdilena pamet) - pill ukazuje "PRIPOJENO - ACC" apod.;
          AC vs ACC se rozlisuje samo (spravne souradnice/vlajky); ZAKLADNI podpora
          rFactor 2 / Le Mans Ultimate (rychlost/RPM/kvalt/palivo/pedaly/mapa/G; vyzaduje
          rF2 Shared Memory plugin - bez nej pill poradi); AMS2/iRacing na roadmape.
    v2.4: VYSILACKA PRIMO NA TLACITKO VOLANTU (winmm joystick, capture chyta klavesu
          i tlacitko - co prijde driv; drzis tlacitko = mluvis); prepis o level vys:
          po modelu small nabidne tlacitko MEDIUM (~540 MB, nejpresnejsi cestina,
          odpoved o par vterin pomalejsi - vedoma volba).
    v2.4.1: FIX POMALE ODPOVEDI - medium model sezral latenci vysilacky; vychozi je ted
          RYCHLY rezim (small) i kdyz je medium stazeny, tlacitko v Nastaveni prepina
          RYCHLY <-> MAXIMALNI (restart serveru); beam search 5 -> 3 (rychlejsi prepis).
    v2.5: NASTAVENI INZENYRA PLATI HNED (jmeno/povaha/popis se aplikuji pri psani,
          Ulozit uz jen potvrzuje); HLASKY NA MIRU - AI vygeneruje cely balicek radiovych
          hlasek podle tveho popisu (pri Ulozit, s API klicem; bez popisu zpet vestavene);
          beam search zpet na 5 (small model to utahne = presnejsi rozpoznani vet).
    v2.6: DVOJJAZYCNE UI - anglictina vychozi, cestina prepinacem v sidebaru
          (Apply-UiLang: preklad vsech prvku okna + comb + dynamickych textu za behu).
    v2.7: OVLADANI KOMENTARU - checklist co komentuje (kola/palivo/gumy/vlajky/kontakty/
          odpocet/rekordy) + upovidanost (jen dulezite / normalne / upovidany);
          HLASOVE POVELY poslouchaji: "bud ticho" / "mluv min" / "mluv vic" / "mluv";
          logo znacka v sidebaru aplikace; profilovka logo+nazev pod sebou.
    v2.8: KONEC PAPOUSKOVANI (kouc prokluzu max 3x/sezeni, cooldown 90 s);
          TEMPO KOUC (drz rytmus / pridej / uber - jednou za 3 kola);
          HLIDKA GUM (setrime/zereme, vydrz vs. kola do cile - jednou za 4 kola);
          polovina zavodu, pochvala konzistence; lokalni inzenyr umi "setrime gumy?",
          "vydrzi pneumatiky?", "mam zrychlit/zpomalit?" s jasnym verdiktem.
    v2.9: HLAS RADIA PODLE STAZENYCH JAZYKU - seznam Hlas radia ukazuje vsechny stazene
          Piper hlasy + hlasy Windows a primo v nem nabizi dalsi jazyky ke stazeni
          (po stazeni se hlas sam vybere a inzenyr se ohlasi); vyber hlasu plati hned;
          nazvy jazyku nativne (Cestina/Deutsch/Русский...) v obou jazycich UI;
          docisteni michane cestiny/anglictiny (stavy stahovani, mikrofon, vysilacka).
    v2.10-2.11 (soubezna vetev): zavodni komentator (lock-up, niceni gum, predjeti,
          souboje), single-instance mutex, F1 23 UDP telemetrie, treninkovy a
          kvalifikacni program.
    v2.12: ZIVE SNIMANI SEKTORU V HLAVICCE - pas 10 bunek (zelena/zluta/cervena vs.
          nejlepsi kolo) + ZIVA PROJEKCE CASU KOLA (unikat: nejlepsi cas +/- dosavadni
          ztrata uz behem kola); MAPA CHYB (unikat: smyky, kontakty a bloky kol se
          pripinaji na misto na trati - zluta/cervena/modra tecka na vsech mapach);
          FULLSCREEN BEZ DER - Prehled dlazdice na tretiny, Strategie roztazena
          + nova karta MAPA na strategii.
    v2.13: PRIROZENA REC - inzenyr necte emoji a jednotky rika cely ("litr" ne "l",
          "kilometr za hodinu" ne "km/h"); tester balicek + navod JAK OTESTOVAT.
    v2.14: HISTORIE KOL - kazde dokoncene kolo se ulozi (cas + telemetricka stopa),
          da se kdykoli rozkliknout a POROVNAT dve kola mezi sebou (rychlost i plyn/brzda
          po delce trati, delta casu, kde nesu vic/min rychlosti). Uklada se per trat+vuz.
    v2.15: KONEC MICHANI JAZYKU - proaktivni hlasky (pevne i kouc) mluvi jen cs/en (uplne
          prelozene), auto jazyk se drzi cs/en; AUTO HLAS se ridi jazykem inzenyra
          (cesky = Windows Jakub, anglicky = Piper Alan), takze hlas vzdy sedi s textem.
    v2.16: PRIROZENY HLAS JAKO CHATGPT - cloudove neuralni TTS (ElevenLabs / OpenAI) v
          Nastaveni: vyber provozovatele + klic, inzenyr pak mluvi jako zivy clovek.
          Potreba internet + vlastni klic (mala platba). Offline hlas zustava jako zaloha.
    v2.17: DRSNAK ROAST (na klipy) - pri nabourani/tuknuti/hvezdicce te drsnak brutalne
          a vtipne sjede (nikdy dvakrat stejne: "Dej vypoved", "Tvuj pojistovak te miluje"...).
          Demo obcas samo udela incident, takze roast slo natocit rovnou z Demo rezimu.
    Windows 10/11 + PowerShell 5.1. Admin neni potreba.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# === VERZE APLIKACE (release.ps1 ji bumpuje automaticky) ===
$script:AppVersion = '2.19.3'
# manifest aktualizaci (version.json na GitHubu) - odsud si appka zjisti novou verzi
$script:UpdateManifestUrl = 'https://raw.githubusercontent.com/jetamdadak01-cell/pitwise-releases/main/version.json'

# JEDINA INSTANCE: dve bezici PitWise by si michaly radio, hlas i mapy
$script:SingleMutex = New-Object System.Threading.Mutex($false, 'PitWiseSingleInstance')
if (-not $script:SingleMutex.WaitOne(0)) {
    [System.Windows.Forms.MessageBox]::Show("PitWise is already running - the second instance won't start (radio and voice would clash)." + [Environment]::NewLine + "PitWise uz bezi - druhou instanci nespoustim (radio a hlas by se michaly).", 'PitWise', 'OK', 'Information') | Out-Null
    exit
}

if (-not ('ACSM' -as [type])) {
    Add-Type @"
using System;
using System.IO.MemoryMappedFiles;
public static class ACSM {
    static byte[] Read(string name) {
        string[] names = { name, "Local\\" + name };
        foreach (var n in names) { try {
            using (var mmf = MemoryMappedFile.OpenExisting(n, MemoryMappedFileRights.Read))
            using (var acc = mmf.CreateViewStream(0, 0, MemoryMappedFileAccess.Read)) {
                int len = (int)acc.Length; byte[] b = new byte[len]; acc.Read(b, 0, len); return b; } } catch { } }
        return null; }
    public static byte[] Physics()  { return Read("acpmf_physics"); }
    public static byte[] Graphics() { return Read("acpmf_graphics"); }
    public static byte[] Static()   { return Read("acpmf_static"); }
    public static byte[] Any(string name) { return Read(name); }
}
"@
}
if (-not ('Mci' -as [type])) {
    Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class Mci {
    [DllImport("winmm.dll", CharSet = CharSet.Auto)]
    static extern int mciSendString(string cmd, StringBuilder ret, int retLen, IntPtr cb);
    public static string Send(string cmd) {
        var sb = new StringBuilder(256);
        int rc = mciSendString(cmd, sb, sb.Capacity, IntPtr.Zero);
        return rc == 0 ? sb.ToString() : ("ERR" + rc);
    }
}
public static class PW32 {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
public static class WaveIn {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
    public struct WAVEINCAPS {
        public short wMid; public short wPid; public int vDriverVersion;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string szPname;
        public int dwFormats; public short wChannels; public short wReserved1;
    }
    [DllImport("winmm.dll", CharSet = CharSet.Auto)]
    static extern int waveInGetNumDevs();
    [DllImport("winmm.dll", CharSet = CharSet.Auto)]
    static extern int waveInGetDevCaps(int uDeviceID, ref WAVEINCAPS pwic, int cbwic);
    public static int Count() { return waveInGetNumDevs(); }
    public static string Name(int i) {
        var c = new WAVEINCAPS();
        return waveInGetDevCaps(i, ref c, Marshal.SizeOf(c)) == 0 ? c.szPname : "";
    }
}
public static class Joy {
    [StructLayout(LayoutKind.Sequential)]
    public struct JOYINFOEX {
        public int dwSize; public int dwFlags;
        public int dwXpos; public int dwYpos; public int dwZpos; public int dwRpos; public int dwUpos; public int dwVpos;
        public int dwButtons; public int dwButtonNumber; public int dwPOV; public int dwReserved1; public int dwReserved2;
    }
    [DllImport("winmm.dll")]
    static extern int joyGetPosEx(int uJoyID, ref JOYINFOEX pji);
    // vrati bitmasku stisknutych tlacitek zarizeni, -1 kdyz zarizeni neexistuje
    public static int Buttons(int id) {
        JOYINFOEX ji = new JOYINFOEX();
        ji.dwSize = Marshal.SizeOf(typeof(JOYINFOEX));
        ji.dwFlags = 0x80; // JOY_RETURNBUTTONS
        if (joyGetPosEx(id, ref ji) != 0) return -1;
        return ji.dwButtons;
    }
}
"@
}

# ============================================================
#  BARVY + POMOCNICI
# ============================================================
$cBg     = [System.Drawing.Color]::FromArgb(14, 16, 22)
$cSide   = [System.Drawing.Color]::FromArgb(18, 21, 29)
$cCard   = [System.Drawing.Color]::FromArgb(24, 28, 37)
$cCard2  = [System.Drawing.Color]::FromArgb(32, 37, 48)
$cBorder = [System.Drawing.Color]::FromArgb(46, 53, 68)
$cAccent = [System.Drawing.Color]::FromArgb(52, 226, 132)
$cAmber  = [System.Drawing.Color]::FromArgb(235, 200, 90)
$cRed    = [System.Drawing.Color]::FromArgb(232, 96, 96)
$cBlue   = [System.Drawing.Color]::FromArgb(80, 160, 240)
$cViolet = [System.Drawing.Color]::FromArgb(170, 120, 230)
$cText   = [System.Drawing.Color]::FromArgb(233, 237, 245)
$cMuted  = [System.Drawing.Color]::FromArgb(150, 158, 173)

function Lighten($col, $amt) {
    [System.Drawing.Color]::FromArgb([math]::Min(255,$col.R+$amt),[math]::Min(255,$col.G+$amt),[math]::Min(255,$col.B+$amt))
}
function Set-RoundRegion { param($ctrl, [int]$radius = 14)
    try {
        $gp = New-Object System.Drawing.Drawing2D.GraphicsPath
        $d = [math]::Max(2, $radius*2); $w = [math]::Max($d, $ctrl.Width); $h = [math]::Max($d, $ctrl.Height)
        $gp.AddArc(0,0,$d,$d,180,90); $gp.AddArc($w-$d,0,$d,$d,270,90); $gp.AddArc($w-$d,$h-$d,$d,$d,0,90); $gp.AddArc(0,$h-$d,$d,$d,90,90); $gp.CloseFigure()
        $ctrl.Region = New-Object System.Drawing.Region($gp)
    } catch { }
}
function New-Card { param($parent, $x, $y, $w, $h, $titleText, $accent)
    if (-not $accent) { $accent = $script:cAccent }
    $pnl = New-Object System.Windows.Forms.Panel
    $pnl.Location = New-Object System.Drawing.Point($x, $y); $pnl.Size = New-Object System.Drawing.Size($w, $h)
    $pnl.BackColor = $script:cCard; Set-RoundRegion $pnl 14
    $bar = New-Object System.Windows.Forms.Panel
    $bar.Location = New-Object System.Drawing.Point(15,13); $bar.Size = New-Object System.Drawing.Size(3,14); $bar.BackColor = $accent
    $pnl.Controls.Add($bar)
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $titleText.ToUpper(); $lbl.ForeColor = $script:cMuted
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9, [System.Drawing.FontStyle]::Bold)
    $lbl.Location = New-Object System.Drawing.Point(25,10); $lbl.AutoSize = $true
    $pnl.Controls.Add($lbl)
    $parent.Controls.Add($pnl)
    return $pnl
}
function Style-Btn { param($b, $bg, $fg, [int]$radius = 8)
    $b.FlatStyle = 'Flat'; $b.FlatAppearance.BorderSize = 0; $b.BackColor = $bg; $b.ForeColor = $fg
    $b.FlatAppearance.MouseOverBackColor = (Lighten $bg 22); $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    if ($radius -gt 0) { Set-RoundRegion $b $radius; $b.Add_Resize({ Set-RoundRegion $this 8 }) | Out-Null }
}
function New-Val { param($parent, $x, $y, $font, $color, $text = "--")
    $l = New-Object System.Windows.Forms.Label
    $l.Text = $text; $l.ForeColor = $color; $l.Font = $font
    $l.Location = New-Object System.Drawing.Point($x, $y); $l.AutoSize = $true
    $parent.Controls.Add($l); return $l
}
function Format-LapTime([int]$ms) {
    if ($ms -le 0) { return "--:--.---" }
    $m = [math]::Floor($ms/60000); $s = [math]::Floor(($ms%60000)/1000); $mm = $ms%1000
    return ("{0}:{1:00}.{2:000}" -f $m, $s, $mm)
}

# ============================================================
#  NASTAVENI + INZENYR STAV
# ============================================================
$script:DataDir = Join-Path $env:APPDATA 'PitWise'
try { if (-not (Test-Path $script:DataDir)) { New-Item -ItemType Directory -Path $script:DataDir -Force | Out-Null } } catch { }
$script:SettingsPath = Join-Path $script:DataDir 'settings.json'
$script:Settings = @{ ApiKey = ''; Model = 'claude-haiku-4-5'; EngineerOn = $true; EngName = 'Engineer'; EngStyle = 0; EngCustom = ''; Voice = ''; Rate = 1; EngLang = 'en'; PttKey = 0; PttJoyId = -1; PttJoyBtn = -1; WhisPrefer = 'small'; CustomPhrases = @{}; UiLang = 'en'; Verbosity = 1; CoLaps = 1; CoFuel = 1; CoTyres = 1; CoFlags = 1; CoContact = 1; CoCount = 1; CoPb = 1; CloudEngine = 'off'; CloudKey = ''; CloudVoice = ''; CloudModel = ''; CloudKey2 = ''; MicDev = -1 }
$script:RadioMuted = $false   # "bud ticho" hlasovym povelem (hlasky stoji, na otazky dal odpovida)
$script:UiEn = $true   # jazyk UI: 'en' vychozi, 'cs' prepinacem v sidebaru

$script:Tts = $null; $script:VoiceCz = $false; $script:VoiceName = ''
try {
    Add-Type -AssemblyName System.Speech -ErrorAction Stop
    $script:Tts = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $script:Tts.Rate = 1; $script:Tts.Volume = 100
    $czv = $script:Tts.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.Name -like 'cs*' } | Select-Object -First 1
    if ($czv) { $script:Tts.SelectVoice($czv.VoiceInfo.Name); $script:VoiceCz = $true }
    $script:VoiceName = $script:Tts.Voice.Name
} catch { $script:Tts = $null }

$script:Eng = @{ LastLap = 0; RadioCheck = $false; FuelWarned = $false; FuelCritical = $false; LastTyreWarn = [DateTime]::MinValue; SaidLapsLeft = @{}; LastSpotL = [DateTime]::MinValue; LastSpotR = [DateTime]::MinValue; LastSlip = [DateTime]::MinValue; WasInPit = $false; LastPaceAt = 0; LastTyreTalk = 0; ConsistAt = 0; SlipCount = 0; LastLock = [DateTime]::MinValue; LockCount = 0; AbuseSec = 0.0; AbuseSaid = 0; LastPos = 0; PosStableAt = [DateTime]::MinValue; BattleSince = [DateTime]::MinValue; BattleSide = ''; LastBattle = [DateTime]::MinValue; LastSession = -99; PrcSaid = @{}; QSaid = @{}; QLastLap = 0; Mood = 0.0; RaceDone = $false; StartPos = 0; MoodBest = 0; MoodPos = 0; MoodLap = 0; LastOff = [DateTime]::MinValue; OffCount = 0; LastGapAt = 0; LastBanter = [DateTime]::MinValue; BanterGap = 0; BcastSaid = $false }
$script:WearHist = New-Object System.Collections.ArrayList   # (kolo, min. opotrebeni) - trend gum
$script:ChatHistory = New-Object System.Collections.ArrayList

# Async stav pro AI dotaz (aby UI nezamrzalo)
$script:AskState = [hashtable]::Synchronized(@{ Busy = $false; Done = $false; Ok = $false; Result = '' })
$script:AskPS = $null; $script:AskRS = $null
$script:AskWorker = {
    param($state, $key, $bodyJson)
    try {
        $headers = @{ 'x-api-key' = $key; 'anthropic-version' = '2023-06-01'; 'content-type' = 'application/json' }
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyJson)
        # Invoke-WebRequest + rucni UTF-8 dekodovani (Invoke-RestMethod v PS 5.1 rozbije diakritiku, kdyz chybi charset)
        $resp = Invoke-WebRequest -Uri 'https://api.anthropic.com/v1/messages' -Method Post -Headers $headers -Body $bytes -TimeoutSec 25 -UseBasicParsing
        $obj = [System.Text.Encoding]::UTF8.GetString($resp.RawContentStream.ToArray()) | ConvertFrom-Json
        $txt = ($obj.content | Where-Object { $_.type -eq 'text' } | Select-Object -First 1).text
        $state.Result = $txt; $state.Ok = $true
    } catch {
        $msg = $_.Exception.Message
        try { $sr = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream()); $msg += ' | ' + $sr.ReadToEnd() } catch { }
        $state.Result = ('ERR:' + $msg); $state.Ok = $false
    }
    $state.Done = $true; $state.Busy = $false
}

# ============================================================
#  TELEMETRIE (mimo UI vlakno)
# ============================================================
$script:Tel = [hashtable]::Synchronized(@{
    Running = $true; Demo = $false; Connected = $false; Status = 0
    SpeedKmh = 0.0; Rpm = 0; Gear = 1; Fuel = 0.0; MaxFuel = 0.0
    Gas = 0.0; Brake = 0.0; Steer = 0.0
    AccLat = 0.0; AccLon = 0.0
    TyreWear = @(0.0,0.0,0.0,0.0)
    TyrePress = @(0.0,0.0,0.0,0.0)
    WheelSlip = @(0.0,0.0,0.0,0.0)
    NearLeft = $false; NearRight = $false; NearDist = 99.0; NearClosing = 0.0; OffTrack = $false
    TyresOut = 0; Damage = 0.0; HasDamage = $false   # kola mimo trat (0-4) + celkove poskozeni vozu (AC/ACC/F1)
    # SOUPERI (F1 UDP / iRacing / ACC broadcast API): posledni kolo + rozestup na auto pred/za
    RivOk = $false; RivAheadMs = 0; RivAheadGap = -1.0; RivBehindMs = 0; RivBehindGap = -1.0
    AccBcast = 0   # 0 = vypnuto v broadcasting.json, 1 = cekam na spojeni, 2 = pripojeno (rozestupy jedou)
    PosX = 0.0; PosZ = 0.0; PosOk = $false
    NormPos = -1.0
    Session = -1; Position = 0; Flag = 0
    TyreTemp = @(0.0,0.0,0.0,0.0)
    CurrentTimeMs = 0; LastTimeMs = 0; BestTimeMs = 0
    CompletedLaps = 0; NumberOfLaps = 0; SessionTimeLeft = -1.0; IsInPit = 0
    CarModel = ''; Track = ''
    Sim = ''; SimName = ''
})
$script:TelPS = $null; $script:TelRS = $null

$script:TelWorker = {
    param($T)
    # diagnostika workeru (start + prvni chyby) - jde do %APPDATA%\PitWise\tel-err.log
    $telErrLog = Join-Path $env:APPDATA 'PitWise\tel-err.log'
    try { Add-Content -Path $telErrLog -Value ("[{0}] worker START (demo={1})" -f (Get-Date -Format 'HH:mm:ss'), $T.Demo) -Encoding UTF8 } catch { }
    $telErrN = 0
    $rng = New-Object System.Random
    $dLapStart = [DateTime]::Now
    $dFuel = 22.0; $dLaps = 0; $dRaceLaps = 15; $dLapLen = 30.0
    function _Str($b, $off, $chars) {
        try { $s = [System.Text.Encoding]::Unicode.GetString($b, $off, $chars*2); $i = $s.IndexOf([char]0); if ($i -ge 0) { $s = $s.Substring(0, $i) }; return $s.Trim() } catch { return '' }
    }
    function _Ascii($b, $off, $chars) {
        try { $s = [System.Text.Encoding]::ASCII.GetString($b, $off, $chars); $i = $s.IndexOf([char]0); if ($i -ge 0) { $s = $s.Substring(0, $i) }; return $s.Trim() } catch { return '' }
    }
    # detekce bezici hry podle procesu (obnovuje se kazde ~3 s)
    $simAt = [DateTime]::MinValue
    $procAcc = $false; $procAc = $false; $procRf2 = $false; $procF1 = $false
    $prevPX = 0.0; $prevPZ = 0.0   # pro smer jizdy (radar ACC)
    $prevNearDist = 99.0           # pro zaviraci rychlost soupere
    $irSig = -1; $irV = $null; $irYamlSig = -1; $procIr = $false   # iRacing cache
    # --- F1 23: UDP telemetrie (port 20777, format 2023) ---
    $f1Udp = $null
    try { $f1Udp = New-Object System.Net.Sockets.UdpClient(20777); $f1Udp.Client.Blocking = $false } catch { $f1Udp = $null }
    $f1Ep = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
    $f1LastRx = [DateTime]::MinValue
    $f1Best = 0; $f1TrackLen = 0.0
    $f1Tracks = @{ 0='Melbourne';1='Paul Ricard';2='Shanghai';3='Sakhir';4='Barcelona';5='Monaco';6='Montreal';7='Silverstone';8='Hockenheim';9='Hungaroring';10='Spa';11='Monza';12='Singapore';13='Suzuka';14='Abu Dhabi';15='Austin';16='Interlagos';17='Red Bull Ring';18='Sochi';19='Mexico';20='Baku';21='Sakhir Short';22='Silverstone Short';23='Austin Short';24='Suzuka Short';25='Hanoi';26='Zandvoort';27='Imola';28='Portimao';29='Jeddah';30='Miami';31='Las Vegas';32='Losail' }
    # --- ACC BROADCASTING API: oficialni UDP rozhrani hry = pozice/casy/rozestupy CELEHO pole ---
    $accUdp = $null; $accReg = $false
    $accLastTry = [DateTime]::MinValue; $accLastRx = [DateTime]::MinValue
    $accCars = @{}   # carIndex -> @(pozice, trackPozice, spline 0-1, kola, posledniKoloMs)
    $accCfgPort = 0; $accCfgPwd = ''; $accCfgAt = [DateTime]::MinValue
    $accEp = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
    while ($T.Running) {
        try {
            if ($T.Demo) {
                $now = [DateTime]::Now; $el = ($now - $dLapStart).TotalSeconds
                if ($el -ge $dLapLen) {
                    $dLaps++
                    $lapMs = [int]($dLapLen*1000 + $rng.Next(-600, 900)); $T.LastTimeMs = $lapMs
                    if ($T.BestTimeMs -le 0 -or $lapMs -lt $T.BestTimeMs) { $T.BestTimeMs = $lapMs }
                    $dFuel -= (1.9 + $rng.NextDouble()*0.4); if ($dFuel -lt 3.0) { $dFuel = 22.0 }
                    if ($dLaps -gt ($dRaceLaps + 1)) { $dLaps = 0; $dFuel = 22.0; $T.BestTimeMs = 0 }   # demo: zavod se opakuje (ukaze pozavodni mod, pak restart)
                    $dLapStart = $now; $el = 0
                }
                $ph = $el / $dLapLen; $spd = 120.0 + 100.0 * [math]::Sin($ph * 2 * [math]::PI); if ($spd -lt 0) { $spd = 5 }
                $T.SpeedKmh = $spd; $T.Rpm = [int](2500 + 4800 * ($spd/220.0)); $T.Gear = [int](2 + [math]::Floor($spd/45.0))
                $acc = [math]::Cos($ph * 2 * [math]::PI)
                $T.Gas = [math]::Max(0.0, [math]::Min(1.0, 0.55 + 0.55*$acc)); $T.Brake = [math]::Max(0.0, [math]::Min(1.0, -1.1*$acc))
                $T.Steer = 0.4 * [math]::Sin($ph * 6 * [math]::PI)
                $T.AccLat = 1.8 * [math]::Sin($ph * 6 * [math]::PI); $T.AccLon = 1.2 * $acc
                # demo: obcasny incident v RYCHLE casti kola (strida kontakt/crash) -> drsnak roast slo natocit rovnou z dema
                # (siroke okno, aby ho worker/UI tick spolehlive chytil; cooldown 10 s v detekci zajisti jen 1 hlasku)
                if ($ph -ge 0.24 -and $ph -lt 0.28 -and $dLaps -ge 1) {
                    if (($dLaps % 2) -eq 0) { $spd = [math]::Max(120.0, $spd - 30.0); $T.AccLat = 7.0; $T.AccLon = 2.0; $T.Brake = 0.2 }   # kontakt (ťuknutí)
                    else { $spd = [math]::Max(90.0, $spd - 60.0); $T.AccLat = 14.0; $T.AccLon = -3.0; $T.Brake = 0.1 }                     # crash (náraz)
                    $T.SpeedKmh = $spd
                }
                $w = [math]::Max(80.0, 100.0 - $dLaps * 0.8)
                # POZOR: carka vaze silneji nez minus -> aritmetika v poli MUSI byt v zavorkach,
                # jinak "@($w, $w - 0.5, ...)" = pole minus pole = vyjimka a zbytek bloku se preskoci
                $T.TyreWear = @($w, ($w - 0.5), ($w + 0.3), ($w - 0.2))
                # demo: souboj kolo na kolo (radar 5 s), smyk zadku, zablokovana kola pri brzdeni
                $T.NearRight = ($ph -ge 0.30 -and $ph -lt 0.46); $T.NearLeft = $false
                $T.NearDist = if ($T.NearRight) { 2.5 } else { 99.0 }
                $T.NearClosing = if ($T.NearRight) { 1.2 } else { 0.0 }
                if ($ph -ge 0.90 -and $ph -lt 0.95) { $T.WheelSlip = @(0.3, 0.3, 2.6, 2.4) }            # oversteer
                elseif ($ph -ge 0.55 -and $ph -lt 0.60) { $T.WheelSlip = @(2.8, 2.6, 0.4, 0.4) }        # lock-up (brzdi se)
                else { $T.WheelSlip = @(0.2, 0.2, 0.3, 0.3) }
                # demo: KOLA MIMO TRAT (trat-limity) + POSKOZENI - aby sly otestovat bez hry
                $T.HasDamage = $true
                if ($ph -ge 0.62 -and $ph -lt 0.66) { $T.TyresOut = 4; $T.OffTrack = $true } else { $T.TyresOut = 0; $T.OffTrack = $false }   # siroko ven
                if ($ph -ge 0.70 -and $ph -lt 0.74 -and $dLaps -ge 1) { $T.Damage = 3.0 } else { $T.Damage = 0.0 }                            # skok poskozeni
                $T.TyrePress = @(27.9, 28.1, 27.2, 27.4)
                $tt2 = $ph * 2 * [math]::PI
                $T.PosX = (300.0 + 80.0*[math]::Cos(3*$tt2)) * [math]::Cos($tt2)
                $T.PosZ = (200.0 + 50.0*[math]::Sin(2*$tt2)) * [math]::Sin($tt2)
                $T.PosOk = $true
                $T.NormPos = $ph
                $T.Fuel = [math]::Round($dFuel, 1); $T.MaxFuel = 65.0; $T.CompletedLaps = $dLaps; $T.NumberOfLaps = $dRaceLaps
                $T.SessionTimeLeft = -1.0; $T.CurrentTimeMs = [int]($el * 1000); $T.IsInPit = 0
                $T.Session = 2
                # demo: pozice se meni - po 1. kole predjedes (3->2), po 3. kole te predjedou (2->3)
                $T.Position = if ((($dLaps % 4) -eq 1) -or (($dLaps % 4) -eq 2)) { 2 } else { 3 }
                # demo: SOUPERI - auto pred nami jezdi o ~0.4 s rychleji, auto za nami pomaleji; rozestupy dychaji
                $T.RivOk = $true
                $T.RivAheadMs = 29050; $T.RivBehindMs = 30250
                $T.RivAheadGap = [math]::Round(4.5 + 1.5 * [math]::Sin($el / 9.0), 1)
                $T.RivBehindGap = [math]::Round(2.2 + 0.8 * [math]::Cos($el / 7.0), 1)
                $T.Flag = if ($el -ge 12 -and $el -lt 15) { 2 } else { 0 }   # demo: zluta 3 s v kazdem kole
                $tb = 78 + 12 * [math]::Sin($ph * 6)
                $T.TyreTemp = @([math]::Round($tb+2,0),[math]::Round($tb+3,0),[math]::Round($tb,0),[math]::Round($tb+1,0))
                $T.CarModel = 'DEMO / Ukazka vozu'; $T.Track = 'Sim Track'; $T.Status = 2; $T.Connected = $true
                $T.Sim = 'demo'; $T.SimName = 'Demo'
            } else {
                if ((([DateTime]::Now) - $simAt).TotalSeconds -gt 3) {
                    $simAt = [DateTime]::Now
                    try {
                        $pn = @(Get-Process -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ProcessName)
                        $procAcc = [bool]($pn | Where-Object { $_ -like 'AC2-Win64*' } | Select-Object -First 1)
                        $procAc  = [bool]($pn | Where-Object { $_ -in @('acs', 'acs_x86', 'AssettoCorsa') } | Select-Object -First 1)
                        $procRf2 = [bool]($pn | Where-Object { $_ -match '^(rFactor2|LMU|LeMans|Le Mans)' } | Select-Object -First 1)
                        $procF1  = [bool]($pn | Where-Object { $_ -like 'F1_2*' -or $_ -like 'F1_23*' -or $_ -like 'F123*' } | Select-Object -First 1)
                        $procIr  = [bool]($pn | Where-Object { $_ -like 'iRacingSim*' } | Select-Object -First 1)
                    } catch { }
                }
                # --- ACC BROADCASTING: registrace + prijem (jen kdyz bezi ACC proces) ---
                if ($procAcc) {
                    # port + heslo z broadcasting.json (cti 1x za 30 s - user mohl soubor zmenit / restartovat hru)
                    if ((([DateTime]::Now) - $accCfgAt).TotalSeconds -gt 30) {
                        $accCfgAt = [DateTime]::Now
                        try {
                            $bcf = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Assetto Corsa Competizione\Config\broadcasting.json'
                            if (Test-Path $bcf) {
                                $cj = (Get-Content $bcf -Raw -ErrorAction Stop) | ConvertFrom-Json
                                $accCfgPort = 0
                                if ($null -ne $cj.udpListenerPort) { $accCfgPort = [int]$cj.udpListenerPort }
                                if ($accCfgPort -eq 0 -and $null -ne $cj.updListenerPort) { $accCfgPort = [int]$cj.updListenerPort }   # "upd" = oficialni preklep ACC
                                $accCfgPwd = if ($null -ne $cj.connectionPassword) { [string]$cj.connectionPassword } else { '' }
                            }
                        } catch { }
                    }
                    if ($accCfgPort -gt 0) {
                        if (-not $accUdp) { try { $accUdp = New-Object System.Net.Sockets.UdpClient(0); $accUdp.Client.Blocking = $false } catch { $accUdp = $null } }
                        if ($accUdp -and -not $accReg -and (([DateTime]::Now) - $accLastTry).TotalSeconds -gt 5) {
                            $accLastTry = [DateTime]::Now
                            try {
                                # REGISTER_COMMAND_APPLICATION: [1][protokol 4][string jmeno][string heslo][int interval ms][string cmdHeslo]
                                $nmB = [System.Text.Encoding]::UTF8.GetBytes('PitWise'); $pwB = [System.Text.Encoding]::UTF8.GetBytes([string]$accCfgPwd)
                                $rq = New-Object System.Collections.ArrayList
                                [void]$rq.Add([byte]1); [void]$rq.Add([byte]4)
                                foreach ($bb in [BitConverter]::GetBytes([uint16]$nmB.Length)) { [void]$rq.Add($bb) }; foreach ($bb in $nmB) { [void]$rq.Add($bb) }
                                foreach ($bb in [BitConverter]::GetBytes([uint16]$pwB.Length)) { [void]$rq.Add($bb) }; foreach ($bb in $pwB) { [void]$rq.Add($bb) }
                                foreach ($bb in [BitConverter]::GetBytes([int]250)) { [void]$rq.Add($bb) }
                                foreach ($bb in [BitConverter]::GetBytes([uint16]0)) { [void]$rq.Add($bb) }
                                $rqB = [byte[]]$rq.ToArray()
                                [void]$accUdp.Send($rqB, $rqB.Length, '127.0.0.1', $accCfgPort)
                            } catch { }
                        }
                        if ($accUdp) {
                            try {
                                $agd = 0
                                while ($accUdp.Available -gt 0 -and $agd -lt 200) {
                                    $agd++
                                    $dgA = $accUdp.Receive([ref]$accEp)
                                    if ($dgA.Length -lt 2) { continue }
                                    $mtA = [int]$dgA[0]
                                    if ($mtA -eq 1) {   # REGISTRATION_RESULT: connId int32@1, success byte@5
                                        if ($dgA.Length -ge 7 -and [int]$dgA[5] -eq 1) { $accReg = $true; $accLastRx = [DateTime]::Now }
                                    } elseif ($mtA -eq 3) {   # REALTIME_CAR_UPDATE (jedno auto)
                                        if ($dgA.Length -ge 51) {
                                            $ciA = [int][BitConverter]::ToUInt16($dgA, 1)
                                            $posA = [int][BitConverter]::ToUInt16($dgA, 22)
                                            $tposA = [int][BitConverter]::ToUInt16($dgA, 26)
                                            $splA = [double][BitConverter]::ToSingle($dgA, 28)
                                            $lapsA2 = [int][BitConverter]::ToUInt16($dgA, 32)
                                            # lastLap.laptimeMs lezi az ZA bestSessionLap (Lap = 13 B + 4*splitCount)
                                            $scA = [int]$dgA[46]   # bestSessionLap.splitCount (38 + 8)
                                            $oL = 38 + 13 + 4 * $scA
                                            $lmA = 0
                                            if ($dgA.Length -ge ($oL + 4)) { $lmA = [BitConverter]::ToInt32($dgA, $oL) }
                                            if ($lmA -lt 0 -or $lmA -gt 2000000000) { $lmA = 0 }   # int32.max = zadny zajety cas
                                            $accCars[$ciA] = @($posA, $tposA, $splA, $lapsA2, $lmA)
                                            $accLastRx = [DateTime]::Now
                                        }
                                    } else { $accLastRx = [DateTime]::Now }   # entry list/track data = spojeni zije
                                }
                            } catch { }
                        }
                        if ($accReg -and (([DateTime]::Now) - $accLastRx).TotalSeconds -gt 10) { $accReg = $false; $accCars.Clear() }   # menu / hra vypnuta
                        $T.AccBcast = if ($accReg) { 2 } else { 1 }
                    } else { $T.AccBcast = 0 }
                } elseif ([int]$T.AccBcast -ne 0 -or $accReg) { $accReg = $false; $accCars.Clear(); $T.AccBcast = 0 }
                $p = [ACSM]::Physics()
                # --- F1 23 (UDP): vyprazdni socket; data pouzij, jen kdyz nebezi AC/ACC ---
                $applyF1 = (-not $p)
                if ($f1Udp) {
                    try {
                        while ($f1Udp.Available -gt 0) {
                            $dg = $f1Udp.Receive([ref]$f1Ep)
                            if ($dg.Length -lt 29) { continue }
                            $fmt = [BitConverter]::ToUInt16($dg, 0)
                            if ($fmt -lt 2022 -or $fmt -gt 2024) { continue }
                            $f1LastRx = [DateTime]::Now
                            if (-not $applyF1) { continue }
                            $pk = [int]$dg[6]; $ci0 = [int]$dg[27]   # packetId, playerCarIndex
                            switch ($pk) {
                                6 {  # CarTelemetry (60 B/auto): rychlost, pedaly, kvalt, RPM, teploty, tlaky
                                    $b = 29 + $ci0 * 60
                                    if ($dg.Length -ge ($b + 60)) {
                                        $T.SpeedKmh = [double][BitConverter]::ToUInt16($dg, $b)
                                        $T.Gas = [BitConverter]::ToSingle($dg, $b + 2); $T.Steer = [BitConverter]::ToSingle($dg, $b + 6); $T.Brake = [BitConverter]::ToSingle($dg, $b + 10)
                                        $T.Gear = [int][sbyte]$dg[$b + 15] + 1   # F1: -1=R,0=N -> nase: 0=R,1=N
                                        $T.Rpm = [int][BitConverter]::ToUInt16($dg, $b + 16)
                                        # F1 poradi kol = RL,RR,FL,FR -> nase FL,FR,RL,RR
                                        $T.TyreTemp = @([double]$dg[$b+32],[double]$dg[$b+33],[double]$dg[$b+30],[double]$dg[$b+31])
                                        $T.TyrePress = @([BitConverter]::ToSingle($dg,$b+48),[BitConverter]::ToSingle($dg,$b+52),[BitConverter]::ToSingle($dg,$b+40),[BitConverter]::ToSingle($dg,$b+44))
                                    }
                                }
                                2 {  # LapData (50 B/auto): casy, pozice, kolo, box, lapDistance
                                    $b = 29 + $ci0 * 50
                                    if ($dg.Length -ge ($b + 50)) {
                                        $ll = [int][BitConverter]::ToUInt32($dg, $b)
                                        $T.LastTimeMs = $ll
                                        if ($ll -gt 0 -and ($f1Best -le 0 -or $ll -lt $f1Best)) { $f1Best = $ll }
                                        $T.BestTimeMs = $f1Best
                                        $T.CurrentTimeMs = [int][BitConverter]::ToUInt32($dg, $b + 4)
                                        $ld = [BitConverter]::ToSingle($dg, $b + 18)
                                        $T.NormPos = if ($f1TrackLen -gt 100 -and $ld -ge 0) { [math]::Min(1.0, $ld / $f1TrackLen) } else { -1.0 }
                                        $myPosF = [int]$dg[$b + 30]
                                        $T.Position = $myPosF
                                        $T.CompletedLaps = [math]::Max(0, [int]$dg[$b + 31] - 1)
                                        $T.IsInPit = if ([int]$dg[$b + 32] -gt 0) { 1 } else { 0 }
                                        # SOUPERI: rozestup na auto pred = deltaToCarInFront (uint16 ms @14) primo ze hry;
                                        # auto za nami najdeme podle pozice - JEHO delta @14 je rozestup na nas
                                        $gA = [int][BitConverter]::ToUInt16($dg, $b + 14)
                                        $T.RivAheadGap = if ($myPosF -gt 1 -and $gA -gt 0 -and $gA -lt 300000) { $gA / 1000.0 } else { -1.0 }
                                        $aMs = 0; $bMs = 0; $gB = -1.0
                                        $nCars = [int][math]::Floor(($dg.Length - 29) / 50)
                                        for ($ri = 0; $ri -lt 22 -and $ri -lt $nCars; $ri++) {
                                            if ($ri -eq $ci0) { continue }
                                            $rb = 29 + $ri * 50
                                            $rp = [int]$dg[$rb + 30]
                                            if ($rp -le 0) { continue }
                                            if ($rp -eq ($myPosF - 1)) { $aMs = [int][BitConverter]::ToUInt32($dg, $rb) }
                                            elseif ($rp -eq ($myPosF + 1)) {
                                                $bMs = [int][BitConverter]::ToUInt32($dg, $rb)
                                                $gBr = [int][BitConverter]::ToUInt16($dg, $rb + 14)
                                                if ($gBr -gt 0 -and $gBr -lt 300000) { $gB = $gBr / 1000.0 }
                                            }
                                        }
                                        $T.RivAheadMs = $aMs; $T.RivBehindMs = $bMs; $T.RivBehindGap = $gB
                                        $T.RivOk = ($aMs -gt 0 -or $bMs -gt 0 -or $T.RivAheadGap -ge 0)
                                    }
                                }
                                7 {  # CarStatus (55 B/auto): palivo, vlajky
                                    $b = 29 + $ci0 * 55
                                    if ($dg.Length -ge ($b + 55)) {
                                        $T.Fuel = [BitConverter]::ToSingle($dg, $b + 5)
                                        $T.MaxFuel = [BitConverter]::ToSingle($dg, $b + 9)
                                        $fl = [int][sbyte]$dg[$b + 28]
                                        $T.Flag = if ($fl -eq 3) { 2 } else { 0 }   # 3 = zluta
                                    }
                                }
                                1 {  # Session: typ, trat, delka, pocet kol
                                    if ($dg.Length -ge 40) {
                                        $T.NumberOfLaps = [int]$dg[32]
                                        $f1TrackLen = [double][BitConverter]::ToUInt16($dg, 33)
                                        $st = [int]$dg[35]
                                        $T.Session = if ($st -ge 1 -and $st -le 4) { 0 } elseif ($st -ge 5 -and $st -le 9) { 1 } elseif ($st -ge 10 -and $st -le 12) { 2 } elseif ($st -eq 13) { 3 } else { -1 }
                                        $tid = [int][sbyte]$dg[36]
                                        if ($f1Tracks.ContainsKey($tid)) { $T.Track = [string]$f1Tracks[$tid] }
                                    }
                                }
                                0 {  # Motion (60 B/auto): pozice na mape, G sily, radar okolnich aut
                                    $b = 29 + $ci0 * 60
                                    if ($dg.Length -ge ($b + 60)) {
                                        $px = [BitConverter]::ToSingle($dg, $b); $pz = [BitConverter]::ToSingle($dg, $b + 8)
                                        if (-not [single]::IsNaN($px) -and ([math]::Abs($px) + [math]::Abs($pz)) -gt 0.01) { $T.PosX = $px; $T.PosZ = $pz; $T.PosOk = $true }
                                        $T.AccLat = [BitConverter]::ToSingle($dg, $b + 36); $T.AccLon = [BitConverter]::ToSingle($dg, $b + 40)
                                        # radar: ostatni auta (22) podle smeru jizdy (worldVelocity hrace)
                                        $T.NearLeft = $false; $T.NearRight = $false; $T.NearDist = 99.0
                                        $hvx = [BitConverter]::ToSingle($dg, $b + 12); $hvz = [BitConverter]::ToSingle($dg, $b + 20)
                                        $hl = [math]::Sqrt($hvx*$hvx + $hvz*$hvz)
                                        if ($hl -gt 5) {
                                            $hvx = $hvx / $hl; $hvz = $hvz / $hl
                                            for ($oi = 0; $oi -lt 22; $oi++) {
                                                if ($oi -eq $ci0) { continue }
                                                $ob = 29 + $oi * 60
                                                if ($dg.Length -lt ($ob + 60)) { break }
                                                $ox = [BitConverter]::ToSingle($dg, $ob); $oz = [BitConverter]::ToSingle($dg, $ob + 8)
                                                if (([math]::Abs($ox) + [math]::Abs($oz)) -le 0.01) { continue }
                                                $rx = $ox - $px; $rz = $oz - $pz
                                                $d = [math]::Sqrt($rx*$rx + $rz*$rz)
                                                if ($d -lt 8.0) {
                                                    $lon = $rx*$hvx + $rz*$hvz
                                                    if ([math]::Abs($lon) -lt 6.0) {
                                                        $lat = $rx*$hvz - $rz*$hvx
                                                        if ($lat -gt 0.5) { $T.NearLeft = $true } elseif ($lat -lt -0.5) { $T.NearRight = $true }   # znamenko empiricky dle ACC (user hlasil prohozene strany)
                                                        if ($d -lt $T.NearDist) { $T.NearDist = $d }
                                                        if ($prevNearDist -lt 90) { $T.NearClosing = [math]::Round((($prevNearDist - $d) * 10.0) * 0.4 + [double]$T.NearClosing * 0.6, 2) }
                                                        $prevNearDist = $d
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                10 {  # CarDamage (42 B/auto): opotrebeni gum (% ojeti -> nase % zbyva)
                                    $b = 29 + $ci0 * 42
                                    if ($dg.Length -ge ($b + 42)) {
                                        $wRL = [BitConverter]::ToSingle($dg, $b); $wRR = [BitConverter]::ToSingle($dg, $b + 4)
                                        $wFL = [BitConverter]::ToSingle($dg, $b + 8); $wFR = [BitConverter]::ToSingle($dg, $b + 12)
                                        $T.TyreWear = @((100 - $wFL), (100 - $wFR), (100 - $wRL), (100 - $wRR))
                                    }
                                }
                            }
                        }
                    } catch { }
                }
                $f1Fresh = ((([DateTime]::Now) - $f1LastRx).TotalSeconds -lt 3)
                $rf2 = $null
                if (-not $p -and -not $f1Fresh) { $rf2 = [ACSM]::Any('$rFactor2SMMP_Telemetry$') }
                if ($rf2 -and $rf2.Length -ge 600) {
                    # --- rFactor 2 / Le Mans Ultimate (zakladni podpora; vyzaduje rF2 Shared Memory plugin) ---
                    $T.Connected = $true; $T.Sim = 'rf2'; $T.SimName = 'rFactor 2 / LMU'
                    $nveh = [BitConverter]::ToInt32($rf2, 12)
                    if ($nveh -gt 0 -and $nveh -le 128) {
                        $b = 16   # zacatek mVehicles[0]
                        $lapN = [BitConverter]::ToInt32($rf2, $b + 20); if ($lapN -ge 0 -and $lapN -lt 10000) { $T.CompletedLaps = $lapN }
                        $cm = _Ascii $rf2 ($b + 32) 64; if ($cm) { $T.CarModel = $cm }
                        $tn = _Ascii $rf2 ($b + 96) 64; if ($tn) { $T.Track = $tn }
                        $mx = [BitConverter]::ToDouble($rf2, $b + 160); $mz = [BitConverter]::ToDouble($rf2, $b + 176)
                        if (-not [double]::IsNaN($mx) -and [math]::Abs($mx) -lt 100000 -and [math]::Abs($mz) -lt 100000 -and ([math]::Abs($mx) + [math]::Abs($mz)) -gt 0.01) { $T.PosX = $mx; $T.PosZ = $mz; $T.PosOk = $true } else { $T.PosOk = $false }
                        $vx = [BitConverter]::ToDouble($rf2, $b + 184); $vy = [BitConverter]::ToDouble($rf2, $b + 192); $vz = [BitConverter]::ToDouble($rf2, $b + 200)
                        $spd = [math]::Sqrt($vx*$vx + $vy*$vy + $vz*$vz) * 3.6
                        if (-not [double]::IsNaN($spd) -and $spd -ge 0 -and $spd -lt 600) { $T.SpeedKmh = $spd }
                        $ax = [BitConverter]::ToDouble($rf2, $b + 208); $az = [BitConverter]::ToDouble($rf2, $b + 224)
                        if (-not [double]::IsNaN($ax)) { $T.AccLat = $ax / 9.81 }; if (-not [double]::IsNaN($az)) { $T.AccLon = $az / 9.81 }
                        $gr = [BitConverter]::ToInt32($rf2, $b + 352); if ($gr -ge -1 -and $gr -le 10) { $T.Gear = $gr + 1 }   # rf2: -1=R,0=N -> nase: 0=R,1=N
                        $rpm = [BitConverter]::ToDouble($rf2, $b + 356); if (-not [double]::IsNaN($rpm) -and $rpm -ge 0 -and $rpm -lt 30000) { $T.Rpm = [int]$rpm }
                        $ga = [BitConverter]::ToDouble($rf2, $b + 388); $br = [BitConverter]::ToDouble($rf2, $b + 396); $st = [BitConverter]::ToDouble($rf2, $b + 404)
                        if (-not [double]::IsNaN($ga)) { $T.Gas = $ga }; if (-not [double]::IsNaN($br)) { $T.Brake = $br }; if (-not [double]::IsNaN($st)) { $T.Steer = $st }
                        $fu = [BitConverter]::ToDouble($rf2, $b + 524); if (-not [double]::IsNaN($fu) -and $fu -ge 0 -and $fu -lt 500) { $T.Fuel = $fu }
                        # co rf2 telemetry MMF nema: casy kol, vlajky, pocet kol zavodu, pozice v poli
                        $T.CurrentTimeMs = 0; $T.LastTimeMs = 0; $T.BestTimeMs = 0
                        $T.NumberOfLaps = 0; $T.SessionTimeLeft = -1.0; $T.Position = 0; $T.Flag = 0; $T.NormPos = -1.0; $T.IsInPit = 0
                        $T.TyreTemp = @(0.0,0.0,0.0,0.0); $T.TyreWear = @(0.0,0.0,0.0,0.0); $T.MaxFuel = 0.0
                        $T.Status = 2; $T.Session = -1
                    }
                }
                elseif (-not $p -and $f1Fresh) {
                    # F1 23 zije - pole uz naplnil UDP parser vyse
                    $T.Connected = $true; $T.Sim = 'f123'; $T.SimName = 'F1 23'
                    if (-not $T.CarModel -or $T.CarModel -eq '') { $T.CarModel = 'F1' }
                    $T.Status = 2
                }
                elseif (-not $p -and ($ir = [ACSM]::Any('IRSDKMemMapFileName')) -and $ir.Length -gt 112) {
                    # --- iRacing: irsdk sdilena pamet (samopopisny format - hlavicka + definice promennych) ---
                    $irStatus = [BitConverter]::ToInt32($ir, 4)
                    if ($irStatus -ge 1) {
                        $numVars = [BitConverter]::ToInt32($ir, 24); $varHdrOff = [BitConverter]::ToInt32($ir, 28)
                        $numBuf = [BitConverter]::ToInt32($ir, 32)
                        # mapu offsetu promennych stavim jen pri zmene poctu promennych (cache)
                        if ($irSig -ne ($numVars * 100000 + $varHdrOff) -and $numVars -gt 0 -and $numVars -lt 3000) {
                            $irSig = $numVars * 100000 + $varHdrOff
                            $irV = @{}
                            for ($vi = 0; $vi -lt $numVars; $vi++) {
                                $rb = $varHdrOff + $vi * 144
                                if (($rb + 144) -gt $ir.Length) { break }
                                $vn = [System.Text.Encoding]::ASCII.GetString($ir, $rb + 16, 32); $zi = $vn.IndexOf([char]0); if ($zi -ge 0) { $vn = $vn.Substring(0, $zi) }
                                $irV[$vn] = @([BitConverter]::ToInt32($ir, $rb), [BitConverter]::ToInt32($ir, $rb + 4))   # typ, offset
                            }
                        }
                        # nejnovejsi datovy buffer (nejvyssi tickCount)
                        $bo = -1; $bt = -1
                        for ($bi = 0; $bi -lt [math]::Min(4, $numBuf); $bi++) {
                            $tc = [BitConverter]::ToInt32($ir, 48 + $bi * 16)
                            if ($tc -gt $bt) { $bt = $tc; $bo = [BitConverter]::ToInt32($ir, 52 + $bi * 16) }
                        }
                        if ($bo -gt 0 -and $irV) {
                            function _IrF([string]$nm) { if ($irV.ContainsKey($nm)) { $v = $irV[$nm]; if ($v[0] -eq 4) { return [BitConverter]::ToSingle($ir, $bo + $v[1]) } elseif ($v[0] -eq 5) { return [BitConverter]::ToDouble($ir, $bo + $v[1]) } }; return $null }
                            function _IrI([string]$nm) { if ($irV.ContainsKey($nm)) { $v = $irV[$nm]; if ($v[0] -eq 2 -or $v[0] -eq 3) { return [BitConverter]::ToInt32($ir, $bo + $v[1]) } elseif ($v[0] -eq 1) { return [int]$ir[$bo + $v[1]] } }; return $null }
                            $T.Connected = $true; $T.Sim = 'iracing'; $T.SimName = 'iRacing'; $T.Status = 2
                            $sv = _IrF 'Speed'; if ($null -ne $sv) { $T.SpeedKmh = [math]::Max(0, $sv * 3.6) }
                            $rv = _IrF 'RPM'; if ($null -ne $rv) { $T.Rpm = [int]$rv }
                            $gv2 = _IrI 'Gear'; if ($null -ne $gv2) { $T.Gear = $gv2 + 1 }   # -1=R,0=N -> nase 0=R,1=N
                            $tv = _IrF 'Throttle'; if ($null -ne $tv) { $T.Gas = $tv }
                            $bv2 = _IrF 'Brake'; if ($null -ne $bv2) { $T.Brake = $bv2 }
                            $fv = _IrF 'FuelLevel'; if ($null -ne $fv) { $T.Fuel = $fv }
                            $lv = _IrI 'LapCompleted'; if ($null -ne $lv -and $lv -ge 0) { $T.CompletedLaps = $lv }
                            $llv = _IrF 'LapLastLapTime'; if ($null -ne $llv -and $llv -gt 0) { $T.LastTimeMs = [int]($llv * 1000) }
                            $lbv = _IrF 'LapBestLapTime'; if ($null -ne $lbv -and $lbv -gt 0) { $T.BestTimeMs = [int]($lbv * 1000) }
                            $lcv = _IrF 'LapCurrentLapTime'; if ($null -ne $lcv -and $lcv -ge 0) { $T.CurrentTimeMs = [int]($lcv * 1000) }
                            $ndp = _IrF 'LapDistPct'; if ($null -ne $ndp -and $ndp -ge 0 -and $ndp -le 1) { $T.NormPos = [double]$ndp } else { $T.NormPos = -1.0 }
                            $pv = _IrI 'PlayerCarPosition'; if ($null -ne $pv -and $pv -ge 0) { $T.Position = $pv }
                            # SOUPERI z CarIdx poli (64 aut): pozice, posledni kolo, F2Time = odstup v sekundach
                            function _IrFA([string]$nm, [int]$ix) { if ($irV.ContainsKey($nm)) { $v = $irV[$nm]; if ($v[0] -eq 4) { return [BitConverter]::ToSingle($ir, $bo + $v[1] + 4 * $ix) } }; return $null }
                            function _IrIA([string]$nm, [int]$ix) { if ($irV.ContainsKey($nm)) { $v = $irV[$nm]; if ($v[0] -eq 2 -or $v[0] -eq 3) { return [BitConverter]::ToInt32($ir, $bo + $v[1] + 4 * $ix) } }; return $null }
                            $T.RivOk = $false
                            if ($pv -gt 0 -and $irV.ContainsKey('CarIdxPosition')) {
                                $aIx = -1; $bIx = -1; $meIx = -1
                                for ($ci = 0; $ci -lt 64; $ci++) {
                                    $cp = _IrIA 'CarIdxPosition' $ci
                                    if ($null -eq $cp -or $cp -le 0) { continue }
                                    if ($cp -eq $pv) { $meIx = $ci }
                                    elseif ($cp -eq ($pv - 1)) { $aIx = $ci }
                                    elseif ($cp -eq ($pv + 1)) { $bIx = $ci }
                                }
                                $aMs2 = 0; $bMs2 = 0; $gA2 = -1.0; $gB2 = -1.0
                                if ($aIx -ge 0) {
                                    $al = _IrFA 'CarIdxLastLapTime' $aIx; if ($null -ne $al -and $al -gt 0) { $aMs2 = [int]($al * 1000) }
                                    $f2a = _IrFA 'CarIdxF2Time' $aIx; $f2m = if ($meIx -ge 0) { _IrFA 'CarIdxF2Time' $meIx } else { $null }
                                    if ($null -ne $f2a -and $null -ne $f2m -and $f2m -gt $f2a -and ($f2m - $f2a) -lt 3600) { $gA2 = [double]($f2m - $f2a) }
                                }
                                if ($bIx -ge 0) {
                                    $bl = _IrFA 'CarIdxLastLapTime' $bIx; if ($null -ne $bl -and $bl -gt 0) { $bMs2 = [int]($bl * 1000) }
                                    $f2b = _IrFA 'CarIdxF2Time' $bIx; $f2m2 = if ($meIx -ge 0) { _IrFA 'CarIdxF2Time' $meIx } else { $null }
                                    if ($null -ne $f2b -and $null -ne $f2m2 -and $f2b -gt $f2m2 -and ($f2b - $f2m2) -lt 3600) { $gB2 = [double]($f2b - $f2m2) }
                                }
                                $T.RivAheadMs = $aMs2; $T.RivBehindMs = $bMs2; $T.RivAheadGap = $gA2; $T.RivBehindGap = $gB2
                                $T.RivOk = ($aMs2 -gt 0 -or $bMs2 -gt 0)
                            }
                            $opv = _IrI 'OnPitRoad'; if ($null -ne $opv) { $T.IsInPit = $opv }
                            $pts = _IrI 'PlayerTrackSurface'; if ($null -ne $pts) { $T.OffTrack = ($pts -eq 0) }   # 0=OffTrack (samopopisne, bez hadani offsetu)
                            $lav = _IrF 'LatAccel'; if ($null -ne $lav) { $T.AccLat = $lav / 9.81 }
                            $lov = _IrF 'LongAccel'; if ($null -ne $lov) { $T.AccLon = $lov / 9.81 }
                            # spotter primo ze hry: 2=vlevo, 3=vpravo, 4=oba, 5=2 vlevo, 6=2 vpravo
                            $clr = _IrI 'CarLeftRight'
                            $T.NearLeft = ($clr -in 2, 4, 5); $T.NearRight = ($clr -in 3, 4, 6)
                            $T.NearDist = if ($T.NearLeft -or $T.NearRight) { 3.0 } else { 99.0 }
                            # vlajky (bitfield): zluta/caution -> 2, modra -> 1
                            $flv2 = _IrI 'SessionFlags'
                            if ($null -ne $flv2) { $T.Flag = if ($flv2 -band 0xC108) { 2 } elseif ($flv2 -band 0x20) { 1 } else { 0 } }
                            # teploty gum (stredni pas karkasy)
                            $tFL = _IrF 'LFtempCM'; $tFR = _IrF 'RFtempCM'; $tRL = _IrF 'LRtempCM'; $tRR = _IrF 'RRtempCM'
                            if ($null -ne $tFL) { $T.TyreTemp = @([math]::Round($tFL,0),[math]::Round($tFR,0),[math]::Round($tRL,0),[math]::Round($tRR,0)) }
                            # opotrebeni (0-1 -> %)
                            $wFL = _IrF 'LFwearM'; if ($null -ne $wFL) { $wFR = _IrF 'RFwearM'; $wRL = _IrF 'LRwearM'; $wRR = _IrF 'RRwearM'; $T.TyreWear = @([math]::Round($wFL*100,0),[math]::Round($wFR*100,0),[math]::Round($wRL*100,0),[math]::Round($wRR*100,0)) }
                            $T.PosOk = $false   # iRacing nedava svetove souradnice - mapa se nekresli, sektory ale jedou (LapDistPct)
                            # YAML session info: trat, auto, max palivo, typ seance (jen pri zmene)
                            $siu = [BitConverter]::ToInt32($ir, 12)
                            if ($siu -ne $irYamlSig) {
                                $irYamlSig = $siu
                                try {
                                    $ylen = [BitConverter]::ToInt32($ir, 16); $yoff = [BitConverter]::ToInt32($ir, 20)
                                    if ($ylen -gt 0 -and ($yoff + $ylen) -le $ir.Length) {
                                        $yaml = [System.Text.Encoding]::UTF8.GetString($ir, $yoff, [math]::Min($ylen, 200000))
                                        if ($yaml -match 'TrackDisplayName:\s*(.+)') { $T.Track = $Matches[1].Trim() }
                                        if ($yaml -match 'DriverCarFuelMaxLtr:\s*([\d\.]+)') { $T.MaxFuel = [double]$Matches[1] }
                                        if ($yaml -match 'CarScreenName:\s*(.+)') { $T.CarModel = $Matches[1].Trim() }
                                        $snv = _IrI 'SessionNum'
                                        if ($null -ne $snv) {
                                            $mm = [regex]::Matches($yaml, 'SessionNum:\s*(\d+)[\s\S]{0,200}?SessionType:\s*(\w[\w ]*)')
                                            foreach ($m1 in $mm) {
                                                if ([int]$m1.Groups[1].Value -eq $snv) {
                                                    $sty = $m1.Groups[2].Value
                                                    $T.Session = if ($sty -match 'Practice|Testing|Warmup') { 0 } elseif ($sty -match 'Qualify') { 1 } elseif ($sty -match 'Race') { 2 } else { -1 }
                                                    break
                                                }
                                            }
                                        }
                                    }
                                } catch { }
                            }
                        }
                    } else { $T.Connected = $false; $T.Status = 0; $T.Sim = ''; $T.SimName = 'iRacing startuje...' }
                }
                elseif (-not $p) {
                    $T.Connected = $false; $T.Status = 0; $T.Sim = ''
                    $T.SimName = $(if ($procF1) { 'F1 23: zapni UDP telemetrii (Nastaveni > Telemetrie, port 20777)' } elseif ($procRf2) { 'LMU/rF2 bez SM pluginu' } elseif ($procIr) { 'iRacing startuje...' } elseif ($procAcc) { 'ACC startuje...' } else { '' })
                    if ((([DateTime]::Now) - $f1LastRx).TotalSeconds -gt 30) { $f1Best = 0 }   # reset best mimo session
                }
                else {
                    $T.Connected = $true
                    $T.Sim = $(if ($procAcc) { 'acc' } elseif ($procAc) { 'ac' } else { 'ac' })
                    $T.SimName = $(if ($procAcc) { 'ACC' } else { 'Assetto Corsa' })
                    $T.RivOk = $false   # AC/ACC shared memory casy souperu nedava (poctive; radar ano)
                    $T.Fuel = [BitConverter]::ToSingle($p, 12); $T.Gear = [BitConverter]::ToInt32($p, 16)
                    $T.Rpm = [BitConverter]::ToInt32($p, 20); $T.SpeedKmh = [BitConverter]::ToSingle($p, 28)
                    $T.Gas = [BitConverter]::ToSingle($p, 4); $T.Brake = [BitConverter]::ToSingle($p, 8); $T.Steer = [BitConverter]::ToSingle($p, 24)
                    $T.AccLat = [BitConverter]::ToSingle($p, 44); $T.AccLon = [BitConverter]::ToSingle($p, 52)
                    $T.WheelSlip = @([BitConverter]::ToSingle($p,56),[BitConverter]::ToSingle($p,60),[BitConverter]::ToSingle($p,64),[BitConverter]::ToSingle($p,68))
                    $T.TyrePress = @([BitConverter]::ToSingle($p,88),[BitConverter]::ToSingle($p,92),[BitConverter]::ToSingle($p,96),[BitConverter]::ToSingle($p,100))
                    $T.TyreWear = @([BitConverter]::ToSingle($p,120),[BitConverter]::ToSingle($p,124),[BitConverter]::ToSingle($p,128),[BitConverter]::ToSingle($p,132))
                    $T.TyreTemp = @([math]::Round([BitConverter]::ToSingle($p,152),0),[math]::Round([BitConverter]::ToSingle($p,156),0),[math]::Round([BitConverter]::ToSingle($p,160),0),[math]::Round([BitConverter]::ToSingle($p,164),0))
                    # POSKOZENI + KOLA MIMO TRAT (sdileny AC/ACC physics struct; offsety dokumentovane, NEOVERENE zivou hrou):
                    #   carDamage[5] float @224 (front/rear/left/right/centre) ; numberOfTyresOut int @244
                    if ($p.Length -ge 248) {
                        $dmgSum = [BitConverter]::ToSingle($p,224) + [BitConverter]::ToSingle($p,228) + [BitConverter]::ToSingle($p,232) + [BitConverter]::ToSingle($p,236)
                        if (-not [double]::IsNaN($dmgSum) -and $dmgSum -ge 0 -and $dmgSum -lt 100000) { $T.Damage = [double]$dmgSum; $T.HasDamage = $true }
                        $tout = [BitConverter]::ToInt32($p,244)
                        if ($tout -ge 0 -and $tout -le 4) { $T.TyresOut = $tout; $T.OffTrack = ($tout -ge 3) }   # presne pro AC i ACC (bez heuristiky)
                    }
                    $g = [ACSM]::Graphics()
                    if ($g) {
                        $T.Status = [BitConverter]::ToInt32($g, 4); $T.CompletedLaps = [BitConverter]::ToInt32($g, 132)
                        $T.Session = [BitConverter]::ToInt32($g, 8); $T.Position = [BitConverter]::ToInt32($g, 136)
                        $T.CurrentTimeMs = [BitConverter]::ToInt32($g, 140); $T.LastTimeMs = [BitConverter]::ToInt32($g, 144)
                        $T.BestTimeMs = [BitConverter]::ToInt32($g, 148); $T.SessionTimeLeft = [BitConverter]::ToSingle($g, 152)
                        $T.IsInPit = [BitConverter]::ToInt32($g, 160); $T.NumberOfLaps = [BitConverter]::ToInt32($g, 172)
                        # normalizovana pozice na trati 0..1 (AC: normalizedCarPosition @248) - pro zivou deltu
                        if ($g.Length -ge 252) {
                            $npv = [BitConverter]::ToSingle($g, 248)
                            if (-not [single]::IsNaN($npv) -and $npv -ge 0.0 -and $npv -le 1.0) { $T.NormPos = [double]$npv } else { $T.NormPos = -1.0 }
                        }
                        # vlajky (ACC: flag int @1224; AC tuto cast nema - za koncem structu jsou nuly = zadna vlajka)
                        if ($g.Length -ge 1228) {
                            $flv = [BitConverter]::ToInt32($g, 1224)
                            if ($flv -ge 0 -and $flv -le 8) { $T.Flag = $flv } else { $T.Flag = 0 }
                        }
                        # pozice vozu - ROZHODUJE DETEKOVANA HRA, ne heuristika!
                        # (v ACC je @252 activeCars a @260 vyska 1. auta - AC filtr to omylem bral
                        #  jako platnou pozici, mapa z ACC pak byla jen par nesmyslnych bodu)
                        $T.PosOk = $false
                        if ($T.Sim -ne 'acc' -and $g.Length -ge 264) {
                            # AC: carCoordinates float[3] @252
                            $px = [BitConverter]::ToSingle($g, 252); $pz = [BitConverter]::ToSingle($g, 260)
                            if (-not [single]::IsNaN($px) -and -not [single]::IsNaN($pz) -and ([math]::Abs($px) -lt 100000) -and ([math]::Abs($pz) -lt 100000) -and (([math]::Abs($px) + [math]::Abs($pz)) -gt 0.01)) {
                                $T.PosX = $px; $T.PosZ = $pz; $T.PosOk = $true
                            }
                        }
                        # ACC: souradnice aut carCoordinates[60][3] @256, carID[60] @976, playerCarID @1216
                        $T.NearLeft = $false; $T.NearRight = $false; $T.NearDist = 99.0
                        if ($T.Sim -eq 'acc' -and -not $T.PosOk -and $g.Length -ge 1220) {
                            $myId = [BitConverter]::ToInt32($g, 1216)
                            $idx = 0
                            for ($ci = 0; $ci -lt 60; $ci++) { if ([BitConverter]::ToInt32($g, 976 + $ci * 4) -eq $myId) { $idx = $ci; break } }
                            $px = [BitConverter]::ToSingle($g, 256 + $idx * 12); $pz = [BitConverter]::ToSingle($g, 264 + $idx * 12)
                            if (-not [single]::IsNaN($px) -and -not [single]::IsNaN($pz) -and ([math]::Abs($px) -lt 100000) -and ([math]::Abs($pz) -lt 100000) -and (([math]::Abs($px) + [math]::Abs($pz)) -gt 0.01)) {
                                $T.PosX = $px; $T.PosZ = $pz; $T.PosOk = $true
                                # RADAR (ACC): auta blize nez 8 m -> vlevo/vpravo podle smeru jizdy
                                # smer = vektor pohybu hrace mezi dvema vzorky (staci >0.3 m)
                                $hdx = $px - $prevPX; $hdz = $pz - $prevPZ
                                $hlen = [math]::Sqrt($hdx*$hdx + $hdz*$hdz)
                                if ($hlen -gt 0.3 -and $T.SpeedKmh -gt 30) {
                                    $hdx = $hdx / $hlen; $hdz = $hdz / $hlen
                                    $nCars = [BitConverter]::ToInt32($g, 252); if ($nCars -lt 0 -or $nCars -gt 60) { $nCars = 60 }
                                    for ($ci = 0; $ci -lt $nCars; $ci++) {
                                        if ($ci -eq $idx) { continue }
                                        $ox = [BitConverter]::ToSingle($g, 256 + $ci * 12); $oz = [BitConverter]::ToSingle($g, 264 + $ci * 12)
                                        if ([single]::IsNaN($ox) -or (([math]::Abs($ox) + [math]::Abs($oz)) -le 0.01)) { continue }
                                        $rx = $ox - $px; $rz = $oz - $pz
                                        $d = [math]::Sqrt($rx*$rx + $rz*$rz)
                                        if ($d -lt 8.0) {
                                            $lon = $rx*$hdx + $rz*$hdz            # dopredu/dozadu
                                            if ([math]::Abs($lon) -lt 6.0) {      # vedle nas (ne pred/za)
                                                $lat = $rx*$hdz - $rz*$hdx        # kolmo: >0 = vpravo
                                                if ($lat -gt 0.5) { $T.NearLeft = $true } elseif ($lat -lt -0.5) { $T.NearRight = $true }   # stejna konvence jako ACC (F1 overit zivym testem)
                                                if ($d -lt $T.NearDist) { $T.NearDist = $d }
                                                # zaviraci rychlost nejblizsiho auta (m/s, + = stahuje nas)
                                                if ($prevNearDist -lt 90) { $T.NearClosing = [math]::Round((($prevNearDist - $d) * 10.0) * 0.4 + [double]$T.NearClosing * 0.6, 2) }
                                                $prevNearDist = $d
                                            }
                                        }
                                    }
                                }
                                $prevPX = $px; $prevPZ = $pz
                            }
                        }
                    }
                    $s = [ACSM]::Static()
                    if ($s) { $T.CarModel = _Str $s 68 33; $T.Track = _Str $s 134 33; $T.MaxFuel = [BitConverter]::ToSingle($s, 414) }
                    # SOUPERI z ACC broadcast API: auto na pozici +-1, jeho posledni kolo + rozestup
                    # (gap = rozdil progresu [kola + spline] x cas kola = odhad v sekundach)
                    if ($accReg -and $accCars.Count -gt 1 -and [int]$T.Position -gt 0) {
                        $myP2 = [int]$T.Position
                        $meA = $null; $ahA = $null; $bhA = $null
                        foreach ($cv in @($accCars.Values)) {
                            $pp = [int]$cv[0]; if ($pp -le 0) { $pp = [int]$cv[1] }   # pozice, jinak track position
                            if ($pp -eq $myP2) { $meA = $cv } elseif ($pp -eq ($myP2 - 1)) { $ahA = $cv } elseif ($pp -eq ($myP2 + 1)) { $bhA = $cv }
                        }
                        $lapSec = if ([int]$T.BestTimeMs -gt 0) { [int]$T.BestTimeMs / 1000.0 } elseif ([int]$T.LastTimeMs -gt 0) { [int]$T.LastTimeMs / 1000.0 } else { 0.0 }
                        $gA3 = -1.0; $gB3 = -1.0; $aM3 = 0; $bM3 = 0
                        if ($ahA) { $aM3 = [int]$ahA[4] }
                        if ($bhA) { $bM3 = [int]$bhA[4] }
                        if ($meA -and $lapSec -gt 20) {
                            $meProg = [double]$meA[3] + [double]$meA[2]
                            if ($ahA) { $d3 = ([double]$ahA[3] + [double]$ahA[2]) - $meProg; if ($d3 -gt 0 -and $d3 -lt 30) { $gA3 = [math]::Round($d3 * $lapSec, 1) } }
                            if ($bhA) { $d4 = $meProg - ([double]$bhA[3] + [double]$bhA[2]); if ($d4 -gt 0 -and $d4 -lt 30) { $gB3 = [math]::Round($d4 * $lapSec, 1) } }
                        }
                        $T.RivAheadMs = $aM3; $T.RivBehindMs = $bM3; $T.RivAheadGap = $gA3; $T.RivBehindGap = $gB3
                        $T.RivOk = ($aM3 -gt 0 -or $bM3 -gt 0 -or $gA3 -ge 0 -or $gB3 -ge 0)
                    }
                }
            }
        } catch {
            if ($telErrN -lt 10) {
                $telErrN++
                try { Add-Content -Path $telErrLog -Value ("[{0}] {1} || {2}" -f (Get-Date -Format 'HH:mm:ss'), $_.Exception.Message, $_.InvocationInfo.PositionMessage.Replace("`n", ' ~ ')) -Encoding UTF8 } catch { }
            }
        }
        Start-Sleep -Milliseconds 100
    }
}
function Start-Telemetry {
    if ($script:TelPS) { return }
    $script:TelRS = [runspacefactory]::CreateRunspace(); $script:TelRS.ApartmentState = 'MTA'; $script:TelRS.Open()
    $script:TelPS = [powershell]::Create(); $script:TelPS.Runspace = $script:TelRS
    [void]$script:TelPS.AddScript($script:TelWorker).AddArgument($script:Tel); [void]$script:TelPS.BeginInvoke()
}
function Stop-Telemetry {
    $script:Tel.Running = $false
    if ($script:TelPS) { try { $script:TelPS.Dispose() } catch { }; $script:TelPS = $null }
    if ($script:TelRS) { try { $script:TelRS.Close(); $script:TelRS.Dispose() } catch { }; $script:TelRS = $null }
}

# ============================================================
#  OKNO + SIDEBAR + HEADER
# ============================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "PitWise"; $form.ClientSize = New-Object System.Drawing.Size(1280, 720)
$form.StartPosition = "CenterScreen"; $form.BackColor = $cBg
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9); $form.FormBorderStyle = "Sizable"; $form.MaximizeBox = $true
$form.MinimumSize = New-Object System.Drawing.Size(1040, 700)
$script:IsFullscreen = $false
$script:PrevBounds = $null
function Toggle-Fullscreen {
    if (-not $script:IsFullscreen) {
        $script:PrevBounds = $form.Bounds
        $form.FormBorderStyle = 'None'; $form.WindowState = 'Maximized'; $form.TopMost = $chkTop.Checked
        $script:IsFullscreen = $true
    } else {
        $form.WindowState = 'Normal'; $form.FormBorderStyle = 'Sizable'
        if ($script:PrevBounds) { $form.Bounds = $script:PrevBounds }
        $script:IsFullscreen = $false
    }
}

# --- Sidebar ---
$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Location = New-Object System.Drawing.Point(0,0); $sidebar.Size = New-Object System.Drawing.Size(210, 720); $sidebar.BackColor = $cSide
$form.Controls.Add($sidebar)

# logo znacka (tachometr + vlny) kreslena primo - stejny motiv jako PitWise.ico
$pnlLogo = New-Object System.Windows.Forms.Panel
$pnlLogo.Location = New-Object System.Drawing.Point(16, 16); $pnlLogo.Size = New-Object System.Drawing.Size(44, 44); $pnlLogo.BackColor = $cSide
$sidebar.Controls.Add($pnlLogo)
$pnlLogo.Add_Paint({
    param($s, $e)
    try {
        $g = $e.Graphics; $g.SmoothingMode = 'AntiAlias'
        $cx = 19.0; $cy = 26.0; $R = 13.0
        $rect = New-Object System.Drawing.RectangleF(($cx - $R), ($cy - $R), (2 * $R), (2 * $R))
        $pen = New-Object System.Drawing.Pen($script:cBorder, 4); $pen.StartCap = 'Round'; $pen.EndCap = 'Round'
        $g.DrawArc($pen, $rect, 135, 270); $pen.Dispose()
        $pen = New-Object System.Drawing.Pen($script:cAccent, 4); $pen.StartCap = 'Round'; $pen.EndCap = 'Round'
        $g.DrawArc($pen, $rect, 135, 115); $pen.Dispose()
        $ang = -48.0 * [math]::PI / 180.0
        $nx = $cx + [math]::Cos($ang) * ($R - 1); $ny = $cy + [math]::Sin($ang) * ($R - 1)
        $pen = New-Object System.Drawing.Pen($script:cText, 3); $pen.StartCap = 'Round'; $pen.EndCap = 'Round'
        $g.DrawLine($pen, [single]$cx, [single]$cy, [single]$nx, [single]$ny); $pen.Dispose()
        $br = New-Object System.Drawing.SolidBrush($script:cAccent)
        $g.FillEllipse($br, ($cx - 3.5), ($cy - 3.5), 7, 7); $br.Dispose()
        $pen = New-Object System.Drawing.Pen($script:cAccent, 2.5); $pen.StartCap = 'Round'; $pen.EndCap = 'Round'
        $w1 = 6.0; $rect = New-Object System.Drawing.RectangleF(($nx - $w1), ($ny - $w1), (2 * $w1), (2 * $w1))
        $g.DrawArc($pen, $rect, -95, 95)
        $w2 = 11.0; $rect = New-Object System.Drawing.RectangleF(($nx - $w2), ($ny - $w2), (2 * $w2), (2 * $w2))
        $g.DrawArc($pen, $rect, -95, 95); $pen.Dispose()
    } catch { }
})
$logo = New-Object System.Windows.Forms.Label
$logo.Text = "PitWise"; $logo.ForeColor = $cAccent
$logo.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$logo.Location = New-Object System.Drawing.Point(62, 12); $logo.AutoSize = $true
$sidebar.Controls.Add($logo)
$logoSub = New-Object System.Windows.Forms.Label
$logoSub.Text = "sim racing engineer"; $logoSub.ForeColor = $cMuted
$logoSub.Font = New-Object System.Drawing.Font("Segoe UI", 8); $logoSub.Location = New-Object System.Drawing.Point(64, 45); $logoSub.AutoSize = $true
$sidebar.Controls.Add($logoSub)

$script:Pages = @{}
$script:NavBtns = @{}
function Show-Page($name) {
    foreach ($k in @($script:Pages.Keys)) { $script:Pages[$k].Visible = ($k -eq $name) }
    foreach ($k in @($script:NavBtns.Keys)) {
        $b = $script:NavBtns[$k]
        if ($k -eq $name) { $b.BackColor = $script:cCard; $b.ForeColor = $script:cAccent }
        else { $b.BackColor = $script:cSide; $b.ForeColor = $script:cText }
    }
    $script:CurPage = $name
    if ($script:NavTitles -and $script:NavTitles[$name]) { $lblTitle.Text = $script:NavTitles[$name] }
}
function New-Nav($text, $name, $y) {
    $b = New-Object System.Windows.Forms.Button
    $b.Text = "    " + $text; $b.TextAlign = 'MiddleLeft'
    $b.FlatStyle = 'Flat'; $b.FlatAppearance.BorderSize = 0
    $b.Size = New-Object System.Drawing.Size(202, 46); $b.Location = New-Object System.Drawing.Point(4, $y)
    $b.BackColor = $script:cSide; $b.ForeColor = $script:cText
    $b.Font = New-Object System.Drawing.Font("Segoe UI", 10.5); $b.Cursor = 'Hand'
    $b.FlatAppearance.MouseOverBackColor = (Lighten $script:cSide 12)
    $b.Add_Click([scriptblock]::Create("Show-Page '$name'"))
    $sidebar.Controls.Add($b); $script:NavBtns[$name] = $b; return $b
}
New-Nav "Prehled"    "dash" 90  | Out-Null
New-Nav "Telemetrie" "tele" 136 | Out-Null
New-Nav "Mapa trati" "map" 182 | Out-Null
New-Nav "Historie kol" "hist" 228 | Out-Null
New-Nav "Strategie"  "strat" 274 | Out-Null
New-Nav "Zavodni inzenyr" "eng" 320 | Out-Null
New-Nav "Nastaveni"  "set" 366 | Out-Null
New-Nav "Zpetna vazba" "fb" 412 | Out-Null

$cmbUi = New-Object System.Windows.Forms.ComboBox
$cmbUi.Location = New-Object System.Drawing.Point(16, 632); $cmbUi.Size = New-Object System.Drawing.Size(178, 24); $cmbUi.DropDownStyle = 'DropDownList'
$cmbUi.BackColor = $cCard2; $cmbUi.ForeColor = $cText; $cmbUi.FlatStyle = 'Flat'
foreach ($n in @('English','Čeština','Slovenčina','Deutsch','Polski','Español','Français','Italiano','Português')) { [void]$cmbUi.Items.Add($n) }
$sidebar.Controls.Add($cmbUi)
$chkTop = New-Object System.Windows.Forms.CheckBox
$chkTop.Text = "Vzdy navrchu"; $chkTop.ForeColor = $cMuted
$chkTop.Location = New-Object System.Drawing.Point(18, 668); $chkTop.AutoSize = $true
$sidebar.Controls.Add($chkTop)
$lblVer = New-Object System.Windows.Forms.Label
$lblVer.Text = ("v" + $script:AppVersion); $lblVer.ForeColor = [System.Drawing.Color]::FromArgb(90, 96, 110)
$lblVer.Font = New-Object System.Drawing.Font("Segoe UI", 7.5); $lblVer.Location = New-Object System.Drawing.Point(20, 698); $lblVer.AutoSize = $true
$sidebar.Controls.Add($lblVer)

# --- Header ---
$header = New-Object System.Windows.Forms.Panel
$header.Location = New-Object System.Drawing.Point(210, 0); $header.Size = New-Object System.Drawing.Size(1070, 64); $header.BackColor = $cBg
$form.Controls.Add($header)
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Prehled"; $lblTitle.ForeColor = $cText
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
$lblTitle.Location = New-Object System.Drawing.Point(20, 16); $lblTitle.AutoSize = $true
$header.Controls.Add($lblTitle)

$pill = New-Object System.Windows.Forms.Panel
$pill.Location = New-Object System.Drawing.Point(750, 16); $pill.Size = New-Object System.Drawing.Size(190, 34); $pill.BackColor = $cCard; Set-RoundRegion $pill 12
$header.Controls.Add($pill)
$lblPill = New-Object System.Windows.Forms.Label
$lblPill.Text = "cekam na hru"; $lblPill.ForeColor = $cMuted; $lblPill.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9, [System.Drawing.FontStyle]::Bold)
$lblPill.TextAlign = "MiddleCenter"; $lblPill.Dock = "Fill"; $pill.Controls.Add($lblPill)

$btnDemo = New-Object System.Windows.Forms.Button
$btnDemo.Text = "Demo"; $btnDemo.Location = New-Object System.Drawing.Point(952, 16); $btnDemo.Size = New-Object System.Drawing.Size(100, 34)
$btnDemo.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold); Style-Btn $btnDemo $cCard2 $cText
$header.Controls.Add($btnDemo)
# ZIVE SNIMANI SEKTORU v hlavicce: 10 bunek (zelena = rychleji, cervena = pomaleji nez nejlepsi kolo)
# + ZIVA PROJEKCE CASU KOLA (nejlepsi kolo +/- dosavadni ztraty na hranicich sektoru) - na kazde strance
$pnlSecStrip = New-Object System.Windows.Forms.Panel
$pnlSecStrip.Location = New-Object System.Drawing.Point(238, 12); $pnlSecStrip.Size = New-Object System.Drawing.Size(496, 42)
$pnlSecStrip.BackColor = $cBg
$header.Controls.Add($pnlSecStrip)
$hdrDiv = New-Object System.Windows.Forms.Panel
$hdrDiv.Location = New-Object System.Drawing.Point(210, 63); $hdrDiv.Size = New-Object System.Drawing.Size(1070, 1); $hdrDiv.BackColor = $cBorder
$form.Controls.Add($hdrDiv)

# --- Content area (drzi stranky) ---
$content = New-Object System.Windows.Forms.Panel
$content.Location = New-Object System.Drawing.Point(210, 64); $content.Size = New-Object System.Drawing.Size(1070, 656); $content.BackColor = $cBg
$form.Controls.Add($content)
function New-Page($name) {
    $p = New-Object System.Windows.Forms.Panel
    $p.Location = New-Object System.Drawing.Point(0,0); $p.Size = New-Object System.Drawing.Size(1070, 656); $p.BackColor = $cBg; $p.Visible = $false
    $content.Controls.Add($p); $script:Pages[$name] = $p; return $p
}
$pageDash  = New-Page "dash"
$pageTele  = New-Page "tele"
$pageMap   = New-Page "map"
$pageHist  = New-Page "hist"
$pageStrat = New-Page "strat"
$pageEng   = New-Page "eng"
$pageSet   = New-Page "set"
$pageFb    = New-Page "fb"
# --- ZPETNA VAZBA: uzivatel napise, co zlepsit; ulozi se lokalne + posle e-mailem/webhookem ---
$cardFb = New-Card $pageFb 16 16 720 570 "ZPETNA VAZBA" $cAccent
$lblFbInfo = New-Object System.Windows.Forms.Label
$lblFbInfo.Text = "Co bys zlepsil? Napis mi cokoliv - chyby, napady, prani. Ctu vse."
$lblFbInfo.ForeColor = $cText; $lblFbInfo.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lblFbInfo.Location = New-Object System.Drawing.Point(24, 44); $lblFbInfo.Size = New-Object System.Drawing.Size(672, 24)
$cardFb.Controls.Add($lblFbInfo)
$txtFb = New-Object System.Windows.Forms.TextBox
$txtFb.Location = New-Object System.Drawing.Point(24, 80); $txtFb.Size = New-Object System.Drawing.Size(672, 340)
$txtFb.Multiline = $true; $txtFb.ScrollBars = "Vertical"
$txtFb.BackColor = $cCard2; $txtFb.ForeColor = $cText; $txtFb.BorderStyle = "FixedSingle"
$txtFb.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$cardFb.Controls.Add($txtFb)
$lblFbEmail = New-Object System.Windows.Forms.Label
$lblFbEmail.Text = "Tvuj e-mail (nepovinne, kdyz chces odpoved):"
$lblFbEmail.ForeColor = $cMuted; $lblFbEmail.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$lblFbEmail.Location = New-Object System.Drawing.Point(24, 432); $lblFbEmail.AutoSize = $true
$cardFb.Controls.Add($lblFbEmail)
$txtFbEmail = New-Object System.Windows.Forms.TextBox
$txtFbEmail.Location = New-Object System.Drawing.Point(24, 456); $txtFbEmail.Size = New-Object System.Drawing.Size(360, 28)
$txtFbEmail.BackColor = $cCard2; $txtFbEmail.ForeColor = $cText; $txtFbEmail.BorderStyle = "FixedSingle"
$cardFb.Controls.Add($txtFbEmail)
$btnFbSend = New-Object System.Windows.Forms.Button
$btnFbSend.Text = "Odeslat zpetnou vazbu"; $btnFbSend.Size = New-Object System.Drawing.Size(220, 40)
$btnFbSend.Location = New-Object System.Drawing.Point(24, 500); $btnFbSend.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
Style-Btn $btnFbSend $cAccent $cBg
$cardFb.Controls.Add($btnFbSend)
$lblFbStatus = New-Object System.Windows.Forms.Label
$lblFbStatus.Text = ""; $lblFbStatus.ForeColor = $cAccent; $lblFbStatus.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$lblFbStatus.Location = New-Object System.Drawing.Point(260, 512); $lblFbStatus.Size = New-Object System.Drawing.Size(440, 24)
$cardFb.Controls.Add($lblFbStatus)
$script:FeedbackUrl = 'https://pitwise.net/api/feedback'   # Cloudflare Pages Function -> KV
# Feedback NIKDY neotevira jinou aplikaci: kdyz se odeslani nepovede, zprava se ulozi do fronty
# (%APPDATA%\PitWise\feedback-queue.json) a appka ji posle sama pri dalsim startu.
$script:FbQueuePath = Join-Path $script:DataDir 'feedback-queue.json'
function Send-FeedbackItem($item) {
    if (-not $script:FeedbackUrl) { return $false }
    try {
        $resp = Invoke-RestMethod -Uri $script:FeedbackUrl -Method Post -Body ($item | ConvertTo-Json) -ContentType 'application/json' -TimeoutSec 8
        return [bool]($resp -and $resp.ok)   # jen skutecne potvrzeni funkce ({ok:true}), ne nahodne 200 od statickeho webu
    } catch { return $false }
}
function Get-FbQueue {
    try {
        if (Test-Path $script:FbQueuePath) {
            $q = Get-Content $script:FbQueuePath -Raw -Encoding UTF8 | ConvertFrom-Json
            $out = @()
            foreach ($o in @($q)) { if ($o.message) { $out += @{ message = [string]$o.message; email = [string]$o.email; app = [string]$o.app; ver = [string]$o.ver; at = [string]$o.at } } }
            return , $out
        }
    } catch { }
    return , @()
}
function Save-FbQueue($items) {
    try { [IO.File]::WriteAllText($script:FbQueuePath, (ConvertTo-Json @($items) -Depth 4), (New-Object System.Text.UTF8Encoding($false))) } catch { }
}
function Flush-FbQueue {
    # posle cekajici feedbacky (max 5 na jeden pokus, at nezdrzuje); neuspesne zustavaji ve fronte
    $q = Get-FbQueue
    if (-not $q -or $q.Count -eq 0) { return }
    $rest = @(); $sent = 0
    foreach ($it in $q) {
        if ($sent -ge 5) { $rest += $it; continue }
        if (Send-FeedbackItem $it) { $sent++ } else { $rest += $it }
    }
    Save-FbQueue $rest
    if ($sent -gt 0) { try { Add-Radio ((Tr 'Odeslal jsem ulozenou zpetnou vazbu: ' 'Sent queued feedback: ') + $sent) } catch { } }
}
$btnFbSend.Add_Click({
    $msg = $txtFb.Text.Trim()
    if (-not $msg) { $lblFbStatus.ForeColor = $cAmber; $lblFbStatus.Text = (Tr 'Napis prosim nejdriv zpravu.' 'Please write a message first.'); return }
    $mail = $txtFbEmail.Text.Trim()
    try {
        $fbFile = Join-Path $script:DataDir 'feedback.txt'
        Add-Content -Path $fbFile -Value ("[{0}] {1}`r`n{2}`r`n----`r`n" -f (Get-Date -Format 'yyyy-MM-dd HH:mm'), $(if ($mail) { $mail } else { 'no-email' }), $msg) -Encoding UTF8
    } catch { }
    $item = @{ message = $msg; email = $mail; app = 'PitWise'; ver = [string]$script:AppVersion; at = (Get-Date -Format 'yyyy-MM-dd HH:mm') }
    $lblFbStatus.ForeColor = $cViolet; $lblFbStatus.Text = (Tr 'Odesilam...' 'Sending...')
    try { $lblFbStatus.Refresh() } catch { }
    $sent = Send-FeedbackItem $item
    $txtFb.Clear(); $txtFbEmail.Clear()
    if ($sent) {
        # zkusime doposlat i pripadne starsi cekajici zpravy
        try { Flush-FbQueue } catch { }
        $lblFbStatus.ForeColor = $cAccent; $lblFbStatus.Text = (Tr 'Diky moc! Zpetna vazba odeslana.' 'Thanks a lot! Feedback sent.')
    } else {
        $q = Get-FbQueue; $q += $item; Save-FbQueue $q
        $lblFbStatus.ForeColor = $cAccent; $lblFbStatus.Text = (Tr 'Diky! Ulozeno - odeslu automaticky, az bude spojeni.' 'Thanks! Saved - I will send it automatically when online.')
    }
})
function Enable-DoubleBuffer($c) {
    try { $c.GetType().GetProperty('DoubleBuffered', ([System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic)).SetValue($c, $true, $null) } catch { }
}

# ============================================================
#  STRANKA: PREHLED (telemetrie + kola)
# ============================================================
$cardLive = New-Card $pageDash 16 16 372 250 "ZIVA TELEMETRIE" $cAccent
$lblSpeed = New-Val $cardLive 18 34 (New-Object System.Drawing.Font("Consolas", 40, [System.Drawing.FontStyle]::Bold)) $cText "0"
New-Val $cardLive 22 104 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted "km/h" | Out-Null
$lblGear = New-Val $cardLive 252 30 (New-Object System.Drawing.Font("Consolas", 46, [System.Drawing.FontStyle]::Bold)) $cAccent "N"
New-Val $cardLive 252 112 (New-Object System.Drawing.Font("Segoe UI", 8)) $cMuted "stupen" | Out-Null
# pedaly - svisle bary (P plyn, B brzda)
$pedGBg = New-Object System.Windows.Forms.Panel
$pedGBg.Location = New-Object System.Drawing.Point(324, 34); $pedGBg.Size = New-Object System.Drawing.Size(13, 76); $pedGBg.BackColor = $cCard2
$cardLive.Controls.Add($pedGBg)
$pedGFill = New-Object System.Windows.Forms.Panel; $pedGFill.BackColor = $cAccent; $pedGBg.Controls.Add($pedGFill)
$pedBBg = New-Object System.Windows.Forms.Panel
$pedBBg.Location = New-Object System.Drawing.Point(344, 34); $pedBBg.Size = New-Object System.Drawing.Size(13, 76); $pedBBg.BackColor = $cCard2
$cardLive.Controls.Add($pedBBg)
$pedBFill = New-Object System.Windows.Forms.Panel; $pedBFill.BackColor = $cRed; $pedBBg.Controls.Add($pedBFill)
New-Val $cardLive 325 112 (New-Object System.Drawing.Font("Segoe UI", 8)) $cMuted "P" | Out-Null
New-Val $cardLive 345 112 (New-Object System.Drawing.Font("Segoe UI", 8)) $cMuted "B" | Out-Null
$lblRpm = New-Val $cardLive 18 132 (New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)) $cMuted "RPM 0"
$rpmBg = New-Object System.Windows.Forms.Panel
$rpmBg.Location = New-Object System.Drawing.Point(18, 152); $rpmBg.Size = New-Object System.Drawing.Size(336, 12); $rpmBg.BackColor = $cCard2
Set-RoundRegion $rpmBg 5; $cardLive.Controls.Add($rpmBg)
$rpmFill = New-Object System.Windows.Forms.Panel; $rpmFill.BackColor = $cAccent; $rpmBg.Controls.Add($rpmFill)
$script:RpmMax = 8000.0   # sam se prizpusobi nejvyssim videnym otackam
New-Val $cardLive 18 174 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Teploty gum (C)" | Out-Null
$fTy = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
$lblTyFL = New-Val $cardLive 28 196 $fTy $cText "FL --"; $lblTyFR = New-Val $cardLive 200 196 $fTy $cText "FR --"
$lblTyRL = New-Val $cardLive 28 218 $fTy $cText "RL --"; $lblTyRR = New-Val $cardLive 200 218 $fTy $cText "RR --"

$cardLap = New-Card $pageDash 16 280 372 300 "CASY KOL" $cBlue
New-Val $cardLap 18 34 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Aktualni kolo" | Out-Null
$lblCur = New-Val $cardLap 18 54 (New-Object System.Drawing.Font("Consolas", 26, [System.Drawing.FontStyle]::Bold)) $cText "--:--.---"
$fL = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)
$lblLast = New-Val $cardLap 18 106 $fL $cMuted "Posledni:  --:--.---"
$lblBest = New-Val $cardLap 18 134 $fL $cAccent "Nejlepsi:  --:--.---"
New-Val $cardLap 18 172 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Delta na nejlepsi kolo (ziva behem jizdy)" | Out-Null
$lblDelta = New-Val $cardLap 18 194 (New-Object System.Drawing.Font("Consolas", 22, [System.Drawing.FontStyle]::Bold)) $cMuted "--"
$lblPB = New-Val $cardLap 18 238 $fL $cViolet "Rekord:    --:--.---"
$lblRef = New-Val $cardLap 18 266 $fL $cBlue "Reference: --:--.---"
New-Val $cardLap 240 272 (New-Object System.Drawing.Font("Segoe UI", 7)) $cMuted "(GT3, orientacni)" | Out-Null

# --- STAV: kolo / pozice / palivo / sezeni na prvni pohled ---
$cardStat = New-Card $pageDash 404 16 370 170 "STAV" $cBlue
$fSt = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)
$lblStKolo = New-Val $cardStat 18 42 $fSt $cText "Kolo:    --"
$lblStPos  = New-Val $cardStat 195 42 $fSt $cText "Poz:  --"
$lblStFuel = New-Val $cardStat 18 72 $fSt $cAmber "Palivo:  -- L"
$lblStSess = New-Val $cardStat 18 102 $fSt $cMuted "Sezeni:  --"
$lblStPit  = New-Val $cardStat 195 102 $fSt $cMuted "Box:  ne"
$lblStCar  = New-Val $cardStat 18 134 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "--"
$lblStCar.Size = New-Object System.Drawing.Size(334, 18); $lblStCar.AutoSize = $false

$cardLaps = New-Card $pageDash 404 202 370 438 "PREHLED KOL" $cViolet
$txtLaps = New-Object System.Windows.Forms.TextBox
$txtLaps.Multiline = $true; $txtLaps.ReadOnly = $true; $txtLaps.ScrollBars = "Vertical"
$txtLaps.Location = New-Object System.Drawing.Point(16, 40); $txtLaps.Size = New-Object System.Drawing.Size(340, 330)
$txtLaps.BackColor = $cCard2; $txtLaps.ForeColor = $cText; $txtLaps.BorderStyle = "None"; $txtLaps.Font = New-Object System.Drawing.Font("Consolas", 10)
$cardLaps.Controls.Add($txtLaps)
$lblSummary = New-Val $cardLaps 18 382 (New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)) $cText "Nejlepsi --   Prumer --"
$lblConsist = New-Val $cardLaps 18 406 (New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)) $cMuted "Konzistence: --"

# --- 3. sloupec Prehledu: MINI MAPA + CHAT S INZENYREM ---
$cardMiniMap = New-Card $pageDash 790 16 264 280 "MAPA" $cBlue
$pnlMiniMap = New-Object System.Windows.Forms.Panel
$pnlMiniMap.Location = New-Object System.Drawing.Point(14, 36); $pnlMiniMap.Size = New-Object System.Drawing.Size(236, 230); $pnlMiniMap.BackColor = $cCard2
Enable-DoubleBuffer $pnlMiniMap; $cardMiniMap.Controls.Add($pnlMiniMap)
$pnlMiniMap.Add_Paint({
    param($s, $e)
    Draw-TrackMap $e.Graphics $s.ClientSize.Width $s.ClientSize.Height $true
})

$cardMiniChat = New-Card $pageDash 790 312 264 328 "INZENYR (RADIO)" $cRed
$txtRadioMini = New-Object System.Windows.Forms.TextBox
$txtRadioMini.Multiline = $true; $txtRadioMini.ReadOnly = $true; $txtRadioMini.ScrollBars = "Vertical"
$txtRadioMini.Location = New-Object System.Drawing.Point(14, 36); $txtRadioMini.Size = New-Object System.Drawing.Size(236, 210)
$txtRadioMini.BackColor = $cCard2; $txtRadioMini.ForeColor = $cText; $txtRadioMini.BorderStyle = "None"; $txtRadioMini.Font = New-Object System.Drawing.Font("Consolas", 8)
$cardMiniChat.Controls.Add($txtRadioMini)
$txtAskMini = New-Object System.Windows.Forms.TextBox
$txtAskMini.Location = New-Object System.Drawing.Point(14, 254); $txtAskMini.Size = New-Object System.Drawing.Size(166, 24)
$txtAskMini.BackColor = $cCard2; $txtAskMini.ForeColor = $cText; $txtAskMini.BorderStyle = "FixedSingle"
$cardMiniChat.Controls.Add($txtAskMini)
$btnAskMini = New-Object System.Windows.Forms.Button
$btnAskMini.Text = "Poslat"; $btnAskMini.Location = New-Object System.Drawing.Point(186, 253); $btnAskMini.Size = New-Object System.Drawing.Size(64, 26)
Style-Btn $btnAskMini ([System.Drawing.Color]::FromArgb(40,167,90)) $cText
$cardMiniChat.Controls.Add($btnAskMini)
$lblMiniHint = New-Val $cardMiniChat 14 288 (New-Object System.Drawing.Font("Segoe UI", 7.5)) $cMuted "Enter = odeslat. Nebo drz klavesu vysilacky a mluv."
$lblMiniHint.Size = New-Object System.Drawing.Size(236, 30); $lblMiniHint.AutoSize = $false

# ============================================================
#  STRANKA: TELEMETRIE (zive grafy - poslednich 30 s)
# ============================================================
$script:TrSpeed = New-Object System.Collections.ArrayList
$script:TrGas   = New-Object System.Collections.ArrayList
$script:TrBrake = New-Object System.Collections.ArrayList
$script:TrSteer = New-Object System.Collections.ArrayList

$cardG1 = New-Card $pageTele 16 16 758 270 "RYCHLOST - POSLEDNICH 30 S" $cAccent
$lblTrSpeed = New-Val $cardG1 620 8 (New-Object System.Drawing.Font("Consolas", 13, [System.Drawing.FontStyle]::Bold)) $cText "-- km/h"
$pnlG1 = New-Object System.Windows.Forms.Panel
$pnlG1.Location = New-Object System.Drawing.Point(16, 38); $pnlG1.Size = New-Object System.Drawing.Size(726, 214); $pnlG1.BackColor = $cCard2
Enable-DoubleBuffer $pnlG1; $cardG1.Controls.Add($pnlG1)
$pnlG1.Add_Paint({
    param($s, $e)
    try {
        $g = $e.Graphics; $g.SmoothingMode = 'AntiAlias'
        $w = $s.ClientSize.Width; $h = $s.ClientSize.Height
        $penGrid = New-Object System.Drawing.Pen($script:cBorder)
        for ($i = 1; $i -le 3; $i++) { $y = [int]($h*$i/4); $g.DrawLine($penGrid, 0, $y, $w, $y) }
        $penGrid.Dispose()
        $vals = @($script:TrSpeed.ToArray())
        if ($vals.Count -ge 2) {
            $max = ([double]($vals | Measure-Object -Maximum).Maximum) * 1.15; if ($max -lt 20) { $max = 20 }
            $pf = New-Object 'System.Drawing.PointF[]' $vals.Count
            for ($i = 0; $i -lt $vals.Count; $i++) {
                $pf[$i] = New-Object System.Drawing.PointF([float]($w * $i / 299.0), [float]($h - 6 - ([double]$vals[$i]/$max)*($h-12)))
            }
            $pen = New-Object System.Drawing.Pen($script:cAccent, 2.2); $g.DrawLines($pen, $pf); $pen.Dispose()
            $fnt = New-Object System.Drawing.Font("Consolas", 8); $br = New-Object System.Drawing.SolidBrush($script:cMuted)
            $g.DrawString(("max {0:0} km/h" -f ($max/1.15)), $fnt, $br, 6, 4); $fnt.Dispose(); $br.Dispose()
        }
    } catch { }
})

$cardG2 = New-Card $pageTele 16 302 520 278 "PLYN / BRZDA / RIZENI (fialova)" $cAmber
$lblTrPedals = New-Val $cardG2 330 8 (New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)) $cText "P --%  B --%"
$pnlG2 = New-Object System.Windows.Forms.Panel
$pnlG2.Location = New-Object System.Drawing.Point(16, 38); $pnlG2.Size = New-Object System.Drawing.Size(488, 222); $pnlG2.BackColor = $cCard2
Enable-DoubleBuffer $pnlG2; $cardG2.Controls.Add($pnlG2)
$pnlG2.Add_Paint({
    param($s, $e)
    try {
        $g = $e.Graphics; $g.SmoothingMode = 'AntiAlias'
        $w = $s.ClientSize.Width; $h = $s.ClientSize.Height
        $penGrid = New-Object System.Drawing.Pen($script:cBorder)
        $g.DrawLine($penGrid, 0, [int]($h/2), $w, [int]($h/2)); $penGrid.Dispose()
        foreach ($ser in @(@($script:TrGas, $script:cAccent), @($script:TrBrake, $script:cRed), @($script:TrSteer, $script:cViolet))) {
            $vals = @($ser[0].ToArray())
            if ($vals.Count -ge 2) {
                $pf = New-Object 'System.Drawing.PointF[]' $vals.Count
                for ($i = 0; $i -lt $vals.Count; $i++) {
                    $v = [double]$vals[$i]; if ($v -lt 0) { $v = 0 }; if ($v -gt 1) { $v = 1 }
                    $pf[$i] = New-Object System.Drawing.PointF([float]($w * $i / 299.0), [float]($h - 5 - $v*($h-10)))
                }
                $pen = New-Object System.Drawing.Pen($ser[1], 2); $g.DrawLines($pen, $pf); $pen.Dispose()
            }
        }
    } catch { }
})

# --- G-metr (pretizeni) ---
$cardG3 = New-Card $pageTele 552 302 222 278 "PRETIZENI" $cRed
$pnlG3 = New-Object System.Windows.Forms.Panel
$pnlG3.Location = New-Object System.Drawing.Point(16, 38); $pnlG3.Size = New-Object System.Drawing.Size(190, 190); $pnlG3.BackColor = $cCard2
Enable-DoubleBuffer $pnlG3; $cardG3.Controls.Add($pnlG3)
$lblGMeter = New-Val $cardG3 18 236 (New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)) $cText "bok 0.0G  podel 0.0G"
$pnlG3.Add_Paint({
    param($s, $e)
    try {
        $g = $e.Graphics; $g.SmoothingMode = 'AntiAlias'
        $w = $s.ClientSize.Width; $h = $s.ClientSize.Height
        $cx = $w/2.0; $cy = $h/2.0; $maxG = 2.5; $rMax = ([math]::Min($w,$h)/2.0) - 6
        $penGrid = New-Object System.Drawing.Pen($script:cBorder)
        foreach ($gv in @(1.0, 2.0)) { $r = $rMax * $gv / $maxG; $g.DrawEllipse($penGrid, [float]($cx-$r), [float]($cy-$r), [float](2*$r), [float](2*$r)) }
        $g.DrawLine($penGrid, [int]$cx, 4, [int]$cx, $h-4); $g.DrawLine($penGrid, 4, [int]$cy, $w-4, [int]$cy)
        $penGrid.Dispose()
        $lat = [double]$script:Tel.AccLat; $lon = [double]$script:Tel.AccLon
        if ($lat -lt -$maxG) { $lat = -$maxG }; if ($lat -gt $maxG) { $lat = $maxG }
        if ($lon -lt -$maxG) { $lon = -$maxG }; if ($lon -gt $maxG) { $lon = $maxG }
        $dx = $cx + ($lat/$maxG) * $rMax; $dy = $cy - ($lon/$maxG) * $rMax
        $br = New-Object System.Drawing.SolidBrush($script:cRed)
        $g.FillEllipse($br, [float]($dx-6), [float]($dy-6), 12, 12); $br.Dispose()
        $penD = New-Object System.Drawing.Pen($script:cText, 1.5)
        $g.DrawEllipse($penD, [float]($dx-6), [float]($dy-6), 12, 12); $penD.Dispose()
    } catch { }
})

# --- MINI-SEKTORY: delta na nejlepsi kolo po usecich trati (Jerry z toho radi, kde zrychlit) ---
$cardSec = New-Card $pageTele 16 586 758 60 "MINI-SEKTORY - DELTA NA NEJLEPSI KOLO" $cViolet
$script:SecLbls = @()
$fSec = New-Object System.Drawing.Font("Consolas", 9, [System.Drawing.FontStyle]::Bold)
for ($si = 0; $si -lt 10; $si++) {
    $lb = New-Val $cardSec (18 + $si * 73) 32 $fSec $cMuted ("S{0} --" -f ($si + 1))
    $script:SecLbls += $lb
}
$cardMap = New-Card $pageMap 16 16 1038 624 "MAPA TRATI" $cBlue
$pnlMap = New-Object System.Windows.Forms.Panel
$pnlMap.Location = New-Object System.Drawing.Point(16, 38); $pnlMap.Size = New-Object System.Drawing.Size(1006, 542); $pnlMap.BackColor = $cCard2
Enable-DoubleBuffer $pnlMap; $cardMap.Controls.Add($pnlMap)
$lblMapInfo = New-Val $cardMap 18 588 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Mapa se nakresli sama behem prvniho kola. Barva = rychlost (cervena pomalu, zelena rychle)."
# sdilene kresleni mapy - pouziva velka stranka Mapa trati i mini mapa na Prehledu
function Draw-TrackMap($g, [int]$w, [int]$h, [bool]$mini = $false) {
    try {
        $g.SmoothingMode = 'AntiAlias'
        $n = $script:MapPts.Count
        if ($n -lt 2) {
            $fnt = New-Object System.Drawing.Font("Segoe UI", $(if ($mini) { 8.5 } else { 10.5 }))
            $br = New-Object System.Drawing.SolidBrush($script:cMuted)
            $msg = if ($script:Tel.Demo -or $script:Tel.PosOk) { Tr 'Vyjed na trat - mapa se kresli sama.' 'Get on track - the map draws itself.' } else { Tr 'Mapa: cekam na pozici vozu ze hry.' 'Map: waiting for car position from the game.' }
            $g.DrawString($msg, $fnt, $br, 14, 14); $fnt.Dispose(); $br.Dispose(); return
        }
        $pad = if ($mini) { 26 } else { 70 }
        $ribW = if ($mini) { 5 } else { 9 }
        $heatW = if ($mini) { 1.6 } else { 2.5 }
        $minx = [double]::MaxValue; $maxx = [double]::MinValue; $minz = [double]::MaxValue; $maxz = [double]::MinValue
        foreach ($p in $script:MapPts) { $x = [double]$p[0]; $z = [double]$p[1]
            if ($x -lt $minx) { $minx = $x }; if ($x -gt $maxx) { $maxx = $x }
            if ($z -lt $minz) { $minz = $z }; if ($z -gt $maxz) { $maxz = $z } }
        $spx = [math]::Max(1.0, $maxx - $minx); $spz = [math]::Max(1.0, $maxz - $minz)
        $sc = [math]::Min(($w - $pad) / $spx, ($h - $pad) / $spz)
        $ox = ($w - $spx * $sc) / 2.0; $oy = ($h - $spz * $sc) / 2.0
        $cnt = $n; if ($script:MapComplete) { $cnt = $n + 1 }
        $pf = New-Object 'System.Drawing.PointF[]' $cnt
        for ($i = 0; $i -lt $n; $i++) { $p = $script:MapPts[$i]
            $pf[$i] = New-Object System.Drawing.PointF([float]($ox + ([double]$p[0] - $minx) * $sc), [float]($oy + ([double]$p[1] - $minz) * $sc)) }
        if ($script:MapComplete) { $pf[$n] = $pf[0] }
        $penRib = New-Object System.Drawing.Pen((Lighten $script:cCard2 48), $ribW)
        $penRib.LineJoin = 'Round'; $penRib.StartCap = 'Round'; $penRib.EndCap = 'Round'
        $g.DrawLines($penRib, $pf); $penRib.Dispose()
        # heatmapa rychlosti: cervena = pomalu (brzdne zony), zelena = rychle
        $vmin = [double]::MaxValue; $vmax = 0.0
        foreach ($p in $script:MapPts) { if ($p.Count -gt 2) { $v = [double]$p[2]; if ($v -gt 1 -and $v -lt $vmin) { $vmin = $v }; if ($v -gt $vmax) { $vmax = $v } } }
        if ($vmax -gt ($vmin + 10)) {
            $heatPens = @(
                (New-Object System.Drawing.Pen($script:cRed, $heatW)),
                (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(240,150,80), $heatW)),
                (New-Object System.Drawing.Pen($script:cAmber, $heatW)),
                (New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(160,220,90), $heatW)),
                (New-Object System.Drawing.Pen($script:cAccent, $heatW))
            )
            for ($i = 0; $i -lt ($n - 1); $i++) {
                $v = 0.0; $p = $script:MapPts[$i]; if ($p.Count -gt 2) { $v = [double]$p[2] }
                $b = [int][math]::Floor((($v - $vmin) / ($vmax - $vmin)) * 4.999)
                if ($b -lt 0) { $b = 0 }; if ($b -gt 4) { $b = 4 }
                $g.DrawLine($heatPens[$b], $pf[$i], $pf[$i + 1])
            }
            if ($script:MapComplete) { $g.DrawLine($heatPens[2], $pf[$n - 1], $pf[0]) }
            foreach ($hp in $heatPens) { $hp.Dispose() }
        } else {
            $penMid = New-Object System.Drawing.Pen($script:cBlue, $(if ($mini) { 1.5 } else { 2 })); $penMid.LineJoin = 'Round'
            $g.DrawLines($penMid, $pf); $penMid.Dispose()
        }
        # start/cil
        $brS = New-Object System.Drawing.SolidBrush($script:cText)
        $g.FillEllipse($brS, $pf[0].X - 3, $pf[0].Y - 3, 6, 6); $brS.Dispose()
        # MAPA CHYB: piny udalosti - zluta smyk, cervena kontakt, modra blok kol
        if ($script:EventPins.Count -gt 0) {
            $pinR = if ($mini) { 2.6 } else { 4.2 }
            $brPin = @{
                1 = New-Object System.Drawing.SolidBrush($script:cAmber)
                2 = New-Object System.Drawing.SolidBrush($script:cRed)
                3 = New-Object System.Drawing.SolidBrush($script:cBlue)
            }
            $penPin = New-Object System.Drawing.Pen($script:cBg, 1)
            foreach ($pin in $script:EventPins) {
                $px = [float]($ox + ([double]$pin[0] - $minx) * $sc); $py = [float]($oy + ([double]$pin[1] - $minz) * $sc)
                if ($px -lt -20 -or $px -gt ($w + 20) -or $py -lt -20 -or $py -gt ($h + 20)) { continue }
                $t = [int]$pin[2]; if (-not $brPin.ContainsKey($t)) { $t = 1 }
                $g.FillEllipse($brPin[$t], $px - $pinR, $py - $pinR, 2 * $pinR, 2 * $pinR)
                $g.DrawEllipse($penPin, $px - $pinR, $py - $pinR, 2 * $pinR, 2 * $pinR)
            }
            foreach ($bp in $brPin.Values) { $bp.Dispose() }
            $penPin.Dispose()
        }
        # auto ted
        if ($script:Tel.PosOk -or $script:Tel.Demo) {
            $dotR = if ($mini) { 4 } else { 6 }
            $cx = [float]($ox + ([double]$script:Tel.PosX - $minx) * $sc); $cy = [float]($oy + ([double]$script:Tel.PosZ - $minz) * $sc)
            $brC = New-Object System.Drawing.SolidBrush($script:cRed)
            $g.FillEllipse($brC, $cx - $dotR, $cy - $dotR, 2*$dotR, 2*$dotR); $brC.Dispose()
            $penC = New-Object System.Drawing.Pen($script:cText, 1.5)
            $g.DrawEllipse($penC, $cx - $dotR, $cy - $dotR, 2*$dotR, 2*$dotR); $penC.Dispose()
        }
    } catch { }
}
$pnlMap.Add_Paint({
    param($s, $e)
    Draw-TrackMap $e.Graphics $s.ClientSize.Width $s.ClientSize.Height $false
})

# ============================================================
#  STRANKA: STRATEGIE
# ============================================================
$cardStrat = New-Card $pageStrat 16 16 420 564 "STRATEGIE PALIVA + STINTY" $cAmber
$fS = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)
$lblFuel     = New-Val $cardStrat 20 44  $fS $cText  "Palivo:            -- L"
$lblFuelLap  = New-Val $cardStrat 20 74  $fS $cText  "Spotreba / kolo:   -- L"
$lblFuelLast = New-Val $cardStrat 20 104 $fS $cMuted "Vydrzi jeste:      -- kol"
$lblRaceLeft = New-Val $cardStrat 20 134 $fS $cMuted "Do konce zavodu:   -- kol"
$lblRefuel   = New-Val $cardStrat 20 164 $fS $cAmber  "Dotankovat:        -- L"
$lblStops    = New-Val $cardStrat 20 194 (New-Object System.Drawing.Font("Consolas", 13, [System.Drawing.FontStyle]::Bold)) $cText "Zastavky v boxu:   --"
$sepS = New-Object System.Windows.Forms.Panel
$sepS.Location = New-Object System.Drawing.Point(20, 232); $sepS.Size = New-Object System.Drawing.Size(384, 1); $sepS.BackColor = $cBorder
$cardStrat.Controls.Add($sepS)
New-Val $cardStrat 20 244 (New-Object System.Drawing.Font("Segoe UI Semibold", 9, [System.Drawing.FontStyle]::Bold)) $cMuted "PLAN STINTU" | Out-Null
# TABULKA STINTU: presne hodnoty k zadani do pit menu hry (kolik litru PRIDAT, gumy menit/nechat)
$lvStints = New-Object System.Windows.Forms.ListView
$lvStints.View = 'Details'; $lvStints.FullRowSelect = $true; $lvStints.HeaderStyle = 'Nonclickable'
$lvStints.Location = New-Object System.Drawing.Point(20, 268); $lvStints.Size = New-Object System.Drawing.Size(384, 168)
$lvStints.BackColor = $cCard2; $lvStints.ForeColor = $cText; $lvStints.BorderStyle = 'None'
$lvStints.Font = New-Object System.Drawing.Font("Consolas", 9)
[void]$lvStints.Columns.Add((Tr 'Stint' 'Stint'), 52)
[void]$lvStints.Columns.Add((Tr 'Kola' 'Laps'), 84)
[void]$lvStints.Columns.Add((Tr 'Pridat' 'Add fuel'), 92)
[void]$lvStints.Columns.Add((Tr 'Gumy' 'Tyres'), 76)
[void]$lvStints.Columns.Add((Tr 'Konec' 'End'), 66)
$cardStrat.Controls.Add($lvStints)
$txtStints = New-Object System.Windows.Forms.TextBox
$txtStints.Multiline = $true; $txtStints.ReadOnly = $true; $txtStints.ScrollBars = "Vertical"
$txtStints.Location = New-Object System.Drawing.Point(20, 442); $txtStints.Size = New-Object System.Drawing.Size(384, 80)
$txtStints.BackColor = $cCard2; $txtStints.ForeColor = $cText; $txtStints.BorderStyle = "None"; $txtStints.Font = New-Object System.Drawing.Font("Consolas", 9.5)
$cardStrat.Controls.Add($txtStints)
$lblStratNote = New-Val $cardStrat 20 532 (New-Object System.Drawing.Font("Segoe UI", 8)) $cMuted "Stinty prepocitavam prubezne z tve realne spotreby. Rekni 'naplanuj box' do vysilacky."

$cardHw = New-Card $pageStrat 452 16 322 330 "SEZENI" $cBlue
$lblHw = New-Val $cardHw 20 46 (New-Object System.Drawing.Font("Segoe UI", 9.5)) $cMuted "--"
$lblHw.Size = New-Object System.Drawing.Size(288, 150); $lblHw.AutoSize = $false
$btnStint = New-Object System.Windows.Forms.Button
$btnStint.Text = "Inzenyr: pripravit setup stintu (ACC)"; $btnStint.Location = New-Object System.Drawing.Point(20, 204); $btnStint.Size = New-Object System.Drawing.Size(282, 32)
$btnStint.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold); Style-Btn $btnStint ([System.Drawing.Color]::FromArgb(40,167,90)) $cText
$cardHw.Controls.Add($btnStint)
$btnExport = New-Object System.Windows.Forms.Button
$btnExport.Text = "Ulozit relaci do souboru"; $btnExport.Location = New-Object System.Drawing.Point(20, 242); $btnExport.Size = New-Object System.Drawing.Size(282, 30)
$btnExport.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold); Style-Btn $btnExport $cCard2 $cText
$cardHw.Controls.Add($btnExport)
$lblExpStatus = New-Val $cardHw 20 280 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted ""
$lblExpStatus.Size = New-Object System.Drawing.Size(282, 44); $lblExpStatus.AutoSize = $false
# mapa s piny chyb i na strategii (kde planujes box, vidis kde ztracis)
$cardStratMap = New-Card $pageStrat 452 362 322 218 "MAPA" $cBlue
$pnlStratMap = New-Object System.Windows.Forms.Panel
$pnlStratMap.Location = New-Object System.Drawing.Point(12, 34); $pnlStratMap.Size = New-Object System.Drawing.Size(298, 172)
$pnlStratMap.BackColor = $cCard
$cardStratMap.Controls.Add($pnlStratMap)
Enable-DoubleBuffer $pnlStratMap
$pnlStratMap.Add_Paint({ param($s, $e) Draw-TrackMap $e.Graphics $s.Width $s.Height $true })

# ============================================================
#  STRANKA: HISTORIE KOL - proklikni kolo, porovnej dve kola mezi sebou
# ============================================================
$script:HistBusy = $false
$cardHistList = New-Card $pageHist 16 16 344 624 "HISTORIE KOL" $cViolet
$lstHist = New-Object System.Windows.Forms.ListBox
$lstHist.Location = New-Object System.Drawing.Point(16, 42); $lstHist.Size = New-Object System.Drawing.Size(312, 424)
$lstHist.BackColor = $cCard2; $lstHist.ForeColor = $cText; $lstHist.BorderStyle = "None"
$lstHist.Font = New-Object System.Drawing.Font("Consolas", 10); $lstHist.IntegralHeight = $false
$cardHistList.Controls.Add($lstHist)
$lblHistCmpTxt = New-Val $cardHistList 16 476 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Porovnat s:"
$cmbHistCmp = New-Object System.Windows.Forms.ComboBox
$cmbHistCmp.Location = New-Object System.Drawing.Point(16, 496); $cmbHistCmp.Size = New-Object System.Drawing.Size(312, 24); $cmbHistCmp.DropDownStyle = 'DropDownList'
$cmbHistCmp.BackColor = $cCard2; $cmbHistCmp.ForeColor = $cText; $cmbHistCmp.FlatStyle = 'Flat'
$cardHistList.Controls.Add($cmbHistCmp)
$lblHistInfo = New-Val $cardHistList 16 530 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted ""
$lblHistInfo.Size = New-Object System.Drawing.Size(312, 84); $lblHistInfo.AutoSize = $false

$cardHistSpeed = New-Card $pageHist 376 16 678 300 "RYCHLOST PO DELCE KOLA" $cAccent
$lblHistLap = New-Val $cardHistSpeed 360 8 (New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)) $cText ""
$lblHistLap.Size = New-Object System.Drawing.Size(308, 22); $lblHistLap.AutoSize = $false; $lblHistLap.TextAlign = 'MiddleRight'
$pnlHistSpeed = New-Object System.Windows.Forms.Panel
$pnlHistSpeed.Location = New-Object System.Drawing.Point(16, 40); $pnlHistSpeed.Size = New-Object System.Drawing.Size(646, 244); $pnlHistSpeed.BackColor = $cCard2
Enable-DoubleBuffer $pnlHistSpeed; $cardHistSpeed.Controls.Add($pnlHistSpeed)

$cardHistPedals = New-Card $pageHist 376 328 678 312 "PLYN / BRZDA PO DELCE KOLA" $cAmber
$pnlHistPedals = New-Object System.Windows.Forms.Panel
$pnlHistPedals.Location = New-Object System.Drawing.Point(16, 40); $pnlHistPedals.Size = New-Object System.Drawing.Size(646, 256); $pnlHistPedals.BackColor = $cCard2
Enable-DoubleBuffer $pnlHistPedals; $cardHistPedals.Controls.Add($pnlHistPedals)

function Get-HistTrace([int]$idx) {
    if ($idx -lt 0 -or $idx -ge $script:LapHistory.Count) { return $null }
    return $script:LapHistory[$idx].trace
}
function Resolve-CmpIdx {
    if ($script:HistCmp -eq -2) { return (Get-HistBestIdx) }
    if ($script:HistCmp -ge 0 -and $script:HistCmp -lt $script:LapHistory.Count) { return $script:HistCmp }
    return -1
}
function Refresh-HistList {
    $script:HistBusy = $true
    try {
        $selKeep = $script:HistSel
        $lstHist.Items.Clear()
        $bestIdx = Get-HistBestIdx
        for ($i = 0; $i -lt $script:LapHistory.Count; $i++) {
            $r = $script:LapHistory[$i]; $star = if ($i -eq $bestIdx) { '*' } else { ' ' }
            [void]$lstHist.Items.Add(("{0} {1} {2,3}   {3}" -f $star, (Tr 'Kolo' 'Lap'), [int]$r.n, (Format-LapTime ([int]$r.ms))))
        }
        $cmbHistCmp.Items.Clear()
        [void]$cmbHistCmp.Items.Add((Tr 'Nejlepsi kolo' 'Best lap'))
        [void]$cmbHistCmp.Items.Add((Tr '(nic)' '(none)'))
        for ($i = 0; $i -lt $script:LapHistory.Count; $i++) { [void]$cmbHistCmp.Items.Add(("{0} {1,3}   {2}" -f (Tr 'Kolo' 'Lap'), [int]$script:LapHistory[$i].n, (Format-LapTime ([int]$script:LapHistory[$i].ms)))) }
        $cmbHistCmp.SelectedIndex = if ($script:HistCmp -eq -2) { 0 } elseif ($script:HistCmp -eq -1) { 1 } elseif ($script:HistCmp -ge 0) { [math]::Min($script:HistCmp + 2, $cmbHistCmp.Items.Count - 1) } else { 0 }
        if ($selKeep -ge 0 -and $selKeep -lt $lstHist.Items.Count) { $lstHist.SelectedIndex = $selKeep }
    } finally { $script:HistBusy = $false }
    Update-HistInfo
}
function Update-HistInfo {
    $pri = Get-HistTrace $script:HistSel
    if (-not $pri) { $lblHistLap.Text = ''; $lblHistInfo.Text = (Tr 'Vyber kolo v seznamu vlevo.' 'Pick a lap from the list on the left.'); return }
    $r = $script:LapHistory[$script:HistSel]
    $txt = ("{0} {1}: {2}" -f (Tr 'Kolo' 'Lap'), [int]$r.n, (Format-LapTime ([int]$r.ms)))
    $cmpIdx = Resolve-CmpIdx
    $info = ''
    if ($cmpIdx -ge 0 -and $cmpIdx -ne $script:HistSel) {
        $rc = $script:LapHistory[$cmpIdx]
        $d = ([int]$r.ms - [int]$rc.ms) / 1000.0; $sign = if ($d -ge 0) { '+' } else { '' }
        $txt += ("    {0}{1:0.000} s  vs {2} {3}" -f $sign, $d, (Tr 'kolo' 'lap'), [int]$rc.n)
        $cmp = Get-HistTrace $cmpIdx
        if ($cmp -and $cmp.Count -eq $pri.Count) {
            $seg = @(0.0, 0.0, 0.0); $cnt = @(0, 0, 0)
            for ($i = 0; $i -lt $pri.Count; $i++) { $sg = [int][math]::Min(2, [math]::Floor($i * 3.0 / $pri.Count)); $seg[$sg] += ([double]$pri[$i][1] - [double]$cmp[$i][1]); $cnt[$sg]++ }
            $names = if ($script:UiEn) { @('1st third', '2nd third', '3rd third') } else { @('1. tretina', '2. tretina', '3. tretina') }
            $parts = @()
            for ($sg = 0; $sg -lt 3; $sg++) { if ($cnt[$sg] -gt 0) { $avg = $seg[$sg] / $cnt[$sg]; $parts += ("{0}: {1}{2:0} km/h" -f $names[$sg], $(if ($avg -ge 0) { '+' } else { '' }), $avg) } }
            $info = ((Tr 'Rychlost vs porovnavane kolo' 'Speed vs compared lap') + ":`r`n" + ($parts -join "`r`n"))
        }
    } else {
        $info = (Tr 'Cas kola. Dole vyber, s cim porovnat.' 'Lap time. Choose what to compare with below.')
    }
    $lblHistLap.Text = $txt
    $lblHistInfo.Text = $info
}
function Draw-HistGraph($g, [int]$w, [int]$h, [string]$kind) {
    try {
        $g.SmoothingMode = 'AntiAlias'
        $penGrid = New-Object System.Drawing.Pen($script:cBorder)
        for ($i = 1; $i -le 3; $i++) { $y = [int]($h * $i / 4); $g.DrawLine($penGrid, 0, $y, $w, $y) }
        $penGrid.Dispose()
        $pri = Get-HistTrace $script:HistSel
        if (-not $pri -or $pri.Count -lt 2) {
            $fnt = New-Object System.Drawing.Font("Segoe UI", 10.5); $br = New-Object System.Drawing.SolidBrush($script:cMuted)
            $g.DrawString((Tr 'Vyber kolo vlevo - stopa se vykresli tady.' 'Pick a lap on the left - its trace draws here.'), $fnt, $br, 14, 14); $fnt.Dispose(); $br.Dispose(); return
        }
        $cmpIdx = Resolve-CmpIdx
        $cmp = if ($cmpIdx -ge 0 -and $cmpIdx -ne $script:HistSel) { Get-HistTrace $cmpIdx } else { $null }
        if ($kind -eq 'speed') {
            $mx2 = 1.0
            foreach ($p in $pri) { if ([double]$p[1] -gt $mx2) { $mx2 = [double]$p[1] } }
            if ($cmp) { foreach ($p in $cmp) { if ([double]$p[1] -gt $mx2) { $mx2 = [double]$p[1] } } }
            $mx2 = $mx2 * 1.1
            if ($cmp) {
                $pf = New-Object 'System.Drawing.PointF[]' $cmp.Count
                for ($i = 0; $i -lt $cmp.Count; $i++) { $pf[$i] = New-Object System.Drawing.PointF([float]($w * $i / [double]($cmp.Count - 1)), [float]($h - 6 - ([double]$cmp[$i][1] / $mx2) * ($h - 12))) }
                $pen = New-Object System.Drawing.Pen($script:cBlue, 2); $g.DrawLines($pen, $pf); $pen.Dispose()
            }
            $pf = New-Object 'System.Drawing.PointF[]' $pri.Count
            for ($i = 0; $i -lt $pri.Count; $i++) { $pf[$i] = New-Object System.Drawing.PointF([float]($w * $i / [double]($pri.Count - 1)), [float]($h - 6 - ([double]$pri[$i][1] / $mx2) * ($h - 12))) }
            $pen = New-Object System.Drawing.Pen($script:cAccent, 2.4); $g.DrawLines($pen, $pf); $pen.Dispose()
            $fnt = New-Object System.Drawing.Font("Consolas", 8); $brm = New-Object System.Drawing.SolidBrush($script:cMuted)
            $g.DrawString(("max {0:0} km/h" -f ($mx2 / 1.1)), $fnt, $brm, 6, ($h - 16)); $fnt.Dispose(); $brm.Dispose()
        } else {
            if ($cmp) {
                $pf = New-Object 'System.Drawing.PointF[]' $cmp.Count
                for ($i = 0; $i -lt $cmp.Count; $i++) { $v = [double]$cmp[$i][2]; if ($v -lt 0) { $v = 0 }; if ($v -gt 1) { $v = 1 }; $pf[$i] = New-Object System.Drawing.PointF([float]($w * $i / [double]($cmp.Count - 1)), [float]($h - 6 - $v * ($h - 12))) }
                $pen = New-Object System.Drawing.Pen($script:cBlue, 1.4); $g.DrawLines($pen, $pf); $pen.Dispose()
            }
            foreach ($ser in @(@(2, $script:cAccent), @(3, $script:cRed))) {
                $pf = New-Object 'System.Drawing.PointF[]' $pri.Count
                for ($i = 0; $i -lt $pri.Count; $i++) { $v = [double]$pri[$i][$ser[0]]; if ($v -lt 0) { $v = 0 }; if ($v -gt 1) { $v = 1 }; $pf[$i] = New-Object System.Drawing.PointF([float]($w * $i / [double]($pri.Count - 1)), [float]($h - 6 - $v * ($h - 12))) }
                $pen = New-Object System.Drawing.Pen($ser[1], 2.2); $g.DrawLines($pen, $pf); $pen.Dispose()
            }
        }
        $fnt = New-Object System.Drawing.Font("Consolas", 8)
        $brP = New-Object System.Drawing.SolidBrush($script:cAccent); $g.DrawString((Tr 'vybrane kolo' 'selected lap'), $fnt, $brP, 8, 4); $brP.Dispose()
        if ($cmp) { $brC = New-Object System.Drawing.SolidBrush($script:cBlue); $g.DrawString((Tr 'porovnavane' 'compared'), $fnt, $brC, 108, 4); $brC.Dispose() }
        $fnt.Dispose()
    } catch { }
}
$pnlHistSpeed.Add_Paint({ param($s, $e) Draw-HistGraph $e.Graphics $s.ClientSize.Width $s.ClientSize.Height 'speed' })
$pnlHistPedals.Add_Paint({ param($s, $e) Draw-HistGraph $e.Graphics $s.ClientSize.Width $s.ClientSize.Height 'pedals' })
$lstHist.Add_SelectedIndexChanged({
    if ($script:HistBusy) { return }
    $script:HistSel = [int]$lstHist.SelectedIndex
    Update-HistInfo; $pnlHistSpeed.Invalidate(); $pnlHistPedals.Invalidate()
})
$cmbHistCmp.Add_SelectedIndexChanged({
    if ($script:HistBusy) { return }
    $ix = $cmbHistCmp.SelectedIndex
    $script:HistCmp = if ($ix -le 0) { -2 } elseif ($ix -eq 1) { -1 } else { $ix - 2 }
    Update-HistInfo; $pnlHistSpeed.Invalidate(); $pnlHistPedals.Invalidate()
})

# ============================================================
#  STRANKA: ZAVODNI INZENYR
# ============================================================
$cardRadio = New-Card $pageEng 16 16 470 564 "RADIO" $cRed
$txtRadio = New-Object System.Windows.Forms.TextBox
$txtRadio.Multiline = $true; $txtRadio.ReadOnly = $true; $txtRadio.ScrollBars = "Vertical"
$txtRadio.Location = New-Object System.Drawing.Point(16, 40); $txtRadio.Size = New-Object System.Drawing.Size(438, 508)
$txtRadio.BackColor = $cCard2; $txtRadio.ForeColor = $cText; $txtRadio.BorderStyle = "None"; $txtRadio.Font = New-Object System.Drawing.Font("Consolas", 9.5)
$cardRadio.Controls.Add($txtRadio)
# pravy klik -> Kopirovat: zpravy inzenyra (radio log) jde vybrat i zkopirovat cele
$script:cmRadio = New-Object System.Windows.Forms.ContextMenuStrip
$miRadCopy = $script:cmRadio.Items.Add('Kopírovat / Copy')
$miRadCopy.Add_Click({ $tb = $script:cmRadio.SourceControl; if ($tb) { try { $s = if ($tb.SelectedText) { $tb.SelectedText } else { $tb.Text }; if ($s) { [System.Windows.Forms.Clipboard]::SetText($s) } } catch { } } })
$miRadCopyAll = $script:cmRadio.Items.Add('Kopírovat vše / Copy all')
$miRadCopyAll.Add_Click({ $tb = $script:cmRadio.SourceControl; if ($tb -and $tb.Text) { try { [System.Windows.Forms.Clipboard]::SetText($tb.Text) } catch { } } })
$txtRadio.ContextMenuStrip = $script:cmRadio
$txtRadioMini.ContextMenuStrip = $script:cmRadio

$cardChat = New-Card $pageEng 502 16 272 564 "OVLADANI" $cAccent
$chkEngineer = New-Object System.Windows.Forms.CheckBox
$chkEngineer.Text = "Inzenyr mluvi (hlas)"; $chkEngineer.ForeColor = $cText; $chkEngineer.Checked = $true
$chkEngineer.Location = New-Object System.Drawing.Point(18, 44); $chkEngineer.AutoSize = $true
$cardChat.Controls.Add($chkEngineer)
$btnTestRadio = New-Object System.Windows.Forms.Button
$btnTestRadio.Text = "Test radia"; $btnTestRadio.Location = New-Object System.Drawing.Point(18, 74); $btnTestRadio.Size = New-Object System.Drawing.Size(236, 30)
Style-Btn $btnTestRadio $cCard2 $cText; $cardChat.Controls.Add($btnTestRadio)

New-Val $cardChat 18 122 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Zeptej se inzenyra:" | Out-Null
$txtAsk = New-Object System.Windows.Forms.TextBox
$txtAsk.Location = New-Object System.Drawing.Point(18, 144); $txtAsk.Size = New-Object System.Drawing.Size(236, 26); $txtAsk.Multiline = $true; $txtAsk.Height = 60
$txtAsk.BackColor = $cCard2; $txtAsk.ForeColor = $cText; $txtAsk.BorderStyle = "FixedSingle"
$cardChat.Controls.Add($txtAsk)
$btnAsk = New-Object System.Windows.Forms.Button
$btnAsk.Text = "Poslat do radia"; $btnAsk.Location = New-Object System.Drawing.Point(18, 214); $btnAsk.Size = New-Object System.Drawing.Size(236, 32)
$btnAsk.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold); Style-Btn $btnAsk ([System.Drawing.Color]::FromArgb(40,167,90)) $cText
$cardChat.Controls.Add($btnAsk)
$btnMic = New-Object System.Windows.Forms.Button
$btnMic.Text = "Mluvit (mikrofon)"; $btnMic.Location = New-Object System.Drawing.Point(18, 254); $btnMic.Size = New-Object System.Drawing.Size(236, 30)
Style-Btn $btnMic $cViolet $cText; $cardChat.Controls.Add($btnMic)
$lblEngStatus = New-Val $cardChat 18 296 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted ""
$lblEngStatus.Size = New-Object System.Drawing.Size(172, 20); $lblEngStatus.AutoSize = $false
# hodnoceni posledni rady (jde do trvale pameti - AI se z toho uci); jazykove neutralni +1/-1
$btnFbUp = New-Object System.Windows.Forms.Button
$btnFbUp.Text = "+1"; $btnFbUp.Location = New-Object System.Drawing.Point(196, 292); $btnFbUp.Size = New-Object System.Drawing.Size(28, 24)
Style-Btn $btnFbUp $cCard2 $cAccent; $cardChat.Controls.Add($btnFbUp)
$btnFbDown = New-Object System.Windows.Forms.Button
$btnFbDown.Text = "-1"; $btnFbDown.Location = New-Object System.Drawing.Point(226, 292); $btnFbDown.Size = New-Object System.Drawing.Size(28, 24)
Style-Btn $btnFbDown $cCard2 $cRed; $cardChat.Controls.Add($btnFbDown)
$btnFbUp.Add_Click({ if (Rate-LastAnswer $true) { Add-Radio (Tr '(Rada oznacena jako dobra - inzenyr si to pamatuje.)' '(Answer marked good - the engineer remembers.)') } else { Add-Radio (Tr '(Zatim zadna odpoved k hodnoceni.)' '(No answer to rate yet.)') } })
$btnFbDown.Add_Click({ if (Rate-LastAnswer $false) { Add-Radio (Tr '(Rada oznacena jako spatna - inzenyr se pristi vyhne.)' '(Answer marked bad - the engineer will avoid that.)') } else { Add-Radio (Tr '(Zatim zadna odpoved k hodnoceni.)' '(No answer to rate yet.)') } })
New-Val $cardChat 18 324 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Co komentuje:" | Out-Null
$clbCallouts = New-Object System.Windows.Forms.CheckedListBox
$clbCallouts.Location = New-Object System.Drawing.Point(18, 344); $clbCallouts.Size = New-Object System.Drawing.Size(236, 100)
$clbCallouts.BackColor = $cCard2; $clbCallouts.ForeColor = $cText; $clbCallouts.BorderStyle = 'None'; $clbCallouts.CheckOnClick = $true
$clbCallouts.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
$cardChat.Controls.Add($clbCallouts)
New-Val $cardChat 18 452 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Jak casto mluvi:" | Out-Null
$cmbVerb = New-Object System.Windows.Forms.ComboBox
$cmbVerb.Location = New-Object System.Drawing.Point(120, 448); $cmbVerb.Size = New-Object System.Drawing.Size(134, 24); $cmbVerb.DropDownStyle = 'DropDownList'
$cmbVerb.BackColor = $cCard2; $cmbVerb.ForeColor = $cText; $cmbVerb.FlatStyle = 'Flat'
$cardChat.Controls.Add($cmbVerb)
New-Val $cardChat 18 484 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Klavesa vysilacky (i ve hre):" | Out-Null
$txtPtt = New-Object System.Windows.Forms.TextBox
$txtPtt.Location = New-Object System.Drawing.Point(18, 506); $txtPtt.Size = New-Object System.Drawing.Size(150, 24); $txtPtt.ReadOnly = $true
$txtPtt.BackColor = $cCard2; $txtPtt.ForeColor = $cText; $txtPtt.BorderStyle = "FixedSingle"; $txtPtt.Text = "(klikni a stiskni klavesu)"
$txtPtt.Cursor = [System.Windows.Forms.Cursors]::Hand
$cardChat.Controls.Add($txtPtt)
$btnPttClear = New-Object System.Windows.Forms.Button
$btnPttClear.Text = "Zrusit"; $btnPttClear.Location = New-Object System.Drawing.Point(176, 505); $btnPttClear.Size = New-Object System.Drawing.Size(78, 26)
Style-Btn $btnPttClear $cCard2 $cMuted; $cardChat.Controls.Add($btnPttClear)

# ============================================================
#  STRANKA: NASTAVENI
# ============================================================
$cardSet = New-Card $pageSet 16 16 370 344 "AI BONUS (VOLITELNE)" $cViolet
New-Val $cardSet 20 44 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted "Anthropic API klic:" | Out-Null
$setKey = New-Object System.Windows.Forms.TextBox
$setKey.Location = New-Object System.Drawing.Point(20, 66); $setKey.Size = New-Object System.Drawing.Size(330, 26)
$setKey.BackColor = $cCard2; $setKey.ForeColor = $cText; $setKey.UseSystemPasswordChar = $true; $setKey.BorderStyle = "FixedSingle"
$cardSet.Controls.Add($setKey)
New-Val $cardSet 20 104 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted "Model (rychly = nizka latence i cena):" | Out-Null
$setModel = New-Object System.Windows.Forms.ComboBox
$setModel.Location = New-Object System.Drawing.Point(20, 126); $setModel.Size = New-Object System.Drawing.Size(330, 26); $setModel.DropDownStyle = "DropDownList"
[void]$setModel.Items.Add("lokalni (okamzity, zdarma, bez API)"); [void]$setModel.Items.Add("claude-haiku-4-5"); [void]$setModel.Items.Add("claude-sonnet-4-6"); [void]$setModel.Items.Add("claude-opus-4-8")
$cardSet.Controls.Add($setModel)
$setVoice = New-Object System.Windows.Forms.CheckBox
$setVoice.Text = "Inzenyr mluvi nahlas (hlas do radia)"; $setVoice.ForeColor = $cText; $setVoice.Checked = $true
$setVoice.Location = New-Object System.Drawing.Point(20, 166); $setVoice.AutoSize = $true; $cardSet.Controls.Add($setVoice)
$btnSaveSet = New-Object System.Windows.Forms.Button
$btnSaveSet.Text = "Ulozit"; $btnSaveSet.Location = New-Object System.Drawing.Point(20, 200); $btnSaveSet.Size = New-Object System.Drawing.Size(140, 32)
$btnSaveSet.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold); Style-Btn $btnSaveSet ([System.Drawing.Color]::FromArgb(40,167,90)) $cText
$cardSet.Controls.Add($btnSaveSet)
# kontrola klicu: overi Anthropic + cloud hlas (vc. zbyvajici kvoty ElevenLabs) a rekne PRESNOU chybu
$btnKeyCheck = New-Object System.Windows.Forms.Button
$btnKeyCheck.Text = "Zkontrolovat klice"; $btnKeyCheck.Location = New-Object System.Drawing.Point(172, 200); $btnKeyCheck.Size = New-Object System.Drawing.Size(182, 32)
Style-Btn $btnKeyCheck $cCard2 $cText; $cardSet.Controls.Add($btnKeyCheck)
$lblSetStatus = New-Val $cardSet 20 240 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted ""
$lblSetStatus.Size = New-Object System.Drawing.Size(334, 40); $lblSetStatus.AutoSize = $false
$setNote = New-Val $cardSet 20 284 (New-Object System.Drawing.Font("Segoe UI", 8)) ([System.Drawing.Color]::FromArgb(120,120,128)) "KLIC NENI POTREBA - bez nej odpovida vestaveny lokalni inzenyr (offline, zdarma). S klicem (console.anthropic.com) odpovida chytrejsi AI. Klic zustava jen na tvem disku."
$setNote.Size = New-Object System.Drawing.Size(330, 54); $setNote.AutoSize = $false

# --- Tvuj inzenyr (osobnost + hlas) ---
$cardPers = New-Card $pageSet 402 16 372 564 "TVUJ INZENYR" $cAccent
New-Val $cardPers 18 42 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted "Jmeno inzenyra (jak se predstavi v radiu):" | Out-Null
$perName = New-Object System.Windows.Forms.TextBox
$perName.Location = New-Object System.Drawing.Point(18, 64); $perName.Size = New-Object System.Drawing.Size(336, 26)
$perName.BackColor = $cCard2; $perName.ForeColor = $cText; $perName.BorderStyle = "FixedSingle"
$cardPers.Controls.Add($perName)
New-Val $cardPers 18 100 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted "Povaha:" | Out-Null
$perStyle = New-Object System.Windows.Forms.ComboBox
$perStyle.Location = New-Object System.Drawing.Point(18, 122); $perStyle.Size = New-Object System.Drawing.Size(336, 26); $perStyle.DropDownStyle = "DropDownList"
[void]$perStyle.Items.Add("Profesional - klidny a strucny")
[void]$perStyle.Items.Add("Drsnak - uprimny, zadne servitky")
[void]$perStyle.Items.Add("Kamos - pohodovy, povzbuzuje")
[void]$perStyle.Items.Add("Analytik - mluvi v cislech a datech")
$cardPers.Controls.Add($perStyle)
New-Val $cardPers 18 160 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted "Vlastni instrukce (volitelne, cesky):" | Out-Null
$perCustom = New-Object System.Windows.Forms.TextBox
$perCustom.Location = New-Object System.Drawing.Point(18, 182); $perCustom.Size = New-Object System.Drawing.Size(336, 52); $perCustom.Multiline = $true
$perCustom.BackColor = $cCard2; $perCustom.ForeColor = $cText; $perCustom.BorderStyle = "FixedSingle"
$cardPers.Controls.Add($perCustom)
New-Val $cardPers 18 244 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted "Hlas radia:" | Out-Null
$perVoice = New-Object System.Windows.Forms.ComboBox
$perVoice.Location = New-Object System.Drawing.Point(18, 266); $perVoice.Size = New-Object System.Drawing.Size(336, 26); $perVoice.DropDownStyle = "DropDownList"
$cardPers.Controls.Add($perVoice)
New-Val $cardPers 18 302 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted "Jazyk inzenyra (hlasky i AI odpovedi):" | Out-Null
$perLang = New-Object System.Windows.Forms.ComboBox
$perLang.Location = New-Object System.Drawing.Point(18, 324); $perLang.Size = New-Object System.Drawing.Size(336, 26); $perLang.DropDownStyle = "DropDownList"
$script:LangCodes = @('auto','cs','en','de','es','fr','it','pl','sk','pt','nl','hu','tr','sv','da','no','fi','ro','ru','uk','el','sr','hr','sl','ca','is','vi','zh','ar','fa')
# nazvy jazyku v jejich vlastnim jazyce - stejne v ceskem i anglickem UI, zadne michani
$script:LangNative = @{ cs = 'Čeština'; en = 'English'; de = 'Deutsch'; es = 'Español'; fr = 'Français'; it = 'Italiano'; pl = 'Polski'; sk = 'Slovenčina'; pt = 'Português'; nl = 'Nederlands'; hu = 'Magyar'; tr = 'Türkçe'; sv = 'Svenska'; da = 'Dansk'; 'no' = 'Norsk'; fi = 'Suomi'; ro = 'Română'; ru = 'Русский'; uk = 'Українська'; el = 'Ελληνικά'; sr = 'Srpski'; hr = 'Hrvatski'; sl = 'Slovenščina'; ca = 'Català'; 'is' = 'Íslenska'; vi = 'Tiếng Việt'; zh = '中文'; ar = 'العربية'; fa = 'فارسی' }
function Tr([string]$cs, [string]$en) {
    $l = [string]$script:Settings.UiLang
    if ($l -eq 'cs') { return $cs }
    if (-not $l -or $l -eq 'en') { return $en }
    $d = $script:UiTr[$l]
    if ($d -and $d.ContainsKey($en)) { return $d[$en] }
    return $en
}
[void]$perLang.Items.Add("(automaticky podle hlasu)")
foreach ($lc in ($script:LangCodes | Select-Object -Skip 1)) { [void]$perLang.Items.Add([string]$script:LangNative[$lc]) }
$cardPers.Controls.Add($perLang)
New-Val $cardPers 18 360 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted "Rychlost reci (pomalu <-> rychle):" | Out-Null
$perRate = New-Object System.Windows.Forms.TrackBar
$perRate.Location = New-Object System.Drawing.Point(14, 380); $perRate.Size = New-Object System.Drawing.Size(344, 40)
$perRate.Minimum = -5; $perRate.Maximum = 5; $perRate.Value = 1; $perRate.TickFrequency = 1; $perRate.BackColor = $cCard
$cardPers.Controls.Add($perRate)
$btnPersTest = New-Object System.Windows.Forms.Button
$btnPersTest.Text = "Vyzkouset hlas"; $btnPersTest.Location = New-Object System.Drawing.Point(18, 426); $btnPersTest.Size = New-Object System.Drawing.Size(336, 28)
Style-Btn $btnPersTest $cCard2 $cText; $cardPers.Controls.Add($btnPersTest)
$btnSavePers = New-Object System.Windows.Forms.Button
$btnSavePers.Text = "Ulozit inzenyra"; $btnSavePers.Location = New-Object System.Drawing.Point(18, 460); $btnSavePers.Size = New-Object System.Drawing.Size(336, 30)
$btnSavePers.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold); Style-Btn $btnSavePers ([System.Drawing.Color]::FromArgb(40,167,90)) $cText
$cardPers.Controls.Add($btnSavePers)
$lblPersStatus = New-Val $cardPers 18 494 (New-Object System.Drawing.Font("Segoe UI", 9)) $cMuted ""
$persNote = New-Val $cardPers 18 516 (New-Object System.Drawing.Font("Segoe UI", 8)) ([System.Drawing.Color]::FromArgb(120,120,128)) "Jmeno, povaha, jazyk a instrukce se promitnou do AI odpovedi i hlasek. Dalsi jazyky hlasu stahnes primo v seznamu Hlas radia."
$persNote.Size = New-Object System.Drawing.Size(336, 40); $persNote.AutoSize = $false

# --- Aplikace ---
$cardApp = New-Card $pageSet 16 362 370 296 "APLIKACE" $cBlue
$btnDesktop = New-Object System.Windows.Forms.Button
$btnDesktop.Text = "Pridat zastupce na plochu"; $btnDesktop.Location = New-Object System.Drawing.Point(20, 40); $btnDesktop.Size = New-Object System.Drawing.Size(330, 24)
Style-Btn $btnDesktop $cCard2 $cText; $cardApp.Controls.Add($btnDesktop)
$btnUnlockVoices = New-Object System.Windows.Forms.Button
$btnUnlockVoices.Text = "Odemknout dalsi hlasy Windows (admin)"; $btnUnlockVoices.Location = New-Object System.Drawing.Point(20, 68); $btnUnlockVoices.Size = New-Object System.Drawing.Size(330, 24)
Style-Btn $btnUnlockVoices $cCard2 $cText; $cardApp.Controls.Add($btnUnlockVoices)
$btnInstallSr = New-Object System.Windows.Forms.Button
$btnInstallSr.Text = "Stahnout rozpoznavani reci (~80 MB)"; $btnInstallSr.Location = New-Object System.Drawing.Point(20, 96); $btnInstallSr.Size = New-Object System.Drawing.Size(330, 24)
Style-Btn $btnInstallSr $cCard2 $cText; $cardApp.Controls.Add($btnInstallSr)
# katalog prirozenych hlasu - kazdy jazyk svuj
New-Val $cardApp 20 128 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Prirozeny hlas inzenyra - stahni svuj jazyk:" | Out-Null
$cmbVoiceDl = New-Object System.Windows.Forms.ComboBox
$cmbVoiceDl.Location = New-Object System.Drawing.Point(20, 148); $cmbVoiceDl.Size = New-Object System.Drawing.Size(230, 24); $cmbVoiceDl.DropDownStyle = 'DropDownList'
$cmbVoiceDl.BackColor = $cCard2; $cmbVoiceDl.ForeColor = $cText; $cmbVoiceDl.FlatStyle = 'Flat'
# POZOR: $script:VoiceCatalog je definovan az nize v souboru - combo se plni hned za jeho definici
$cardApp.Controls.Add($cmbVoiceDl)
$btnGetPiper = New-Object System.Windows.Forms.Button
$btnGetPiper.Text = "Stahnout"; $btnGetPiper.Location = New-Object System.Drawing.Point(256, 147); $btnGetPiper.Size = New-Object System.Drawing.Size(94, 26)
Style-Btn $btnGetPiper $cCard2 $cText; $cardApp.Controls.Add($btnGetPiper)
$lblDeskStatus = New-Val $cardApp 20 178 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted ""
$lblDeskStatus.Size = New-Object System.Drawing.Size(330, 16); $lblDeskStatus.AutoSize = $false
New-Val $cardApp 20 204 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Klavesa vysilacky:" | Out-Null
$txtPttSet = New-Object System.Windows.Forms.TextBox
$txtPttSet.Location = New-Object System.Drawing.Point(150, 201); $txtPttSet.Size = New-Object System.Drawing.Size(124, 22); $txtPttSet.ReadOnly = $true
$txtPttSet.BackColor = $cCard2; $txtPttSet.ForeColor = $cText; $txtPttSet.BorderStyle = "FixedSingle"; $txtPttSet.Text = "(klikni + stiskni)"
$txtPttSet.Cursor = [System.Windows.Forms.Cursors]::Hand
$cardApp.Controls.Add($txtPttSet)
$btnPttClear2 = New-Object System.Windows.Forms.Button
$btnPttClear2.Text = "Zrusit"; $btnPttClear2.Location = New-Object System.Drawing.Point(280, 200); $btnPttClear2.Size = New-Object System.Drawing.Size(70, 24)
Style-Btn $btnPttClear2 $cCard2 $cMuted; $cardApp.Controls.Add($btnPttClear2)
# vyber snimaneho mikrofonu (winmm waveIn zarizeni; -1 = vychozi Windows)
New-Val $cardApp 20 236 (New-Object System.Drawing.Font("Segoe UI", 8.5)) $cMuted "Mikrofon:" | Out-Null
$cmbMicDev = New-Object System.Windows.Forms.ComboBox
$cmbMicDev.Location = New-Object System.Drawing.Point(90, 232); $cmbMicDev.Size = New-Object System.Drawing.Size(260, 24); $cmbMicDev.DropDownStyle = 'DropDownList'
$cmbMicDev.BackColor = $cCard2; $cmbMicDev.ForeColor = $cText; $cmbMicDev.FlatStyle = 'Flat'
$cardApp.Controls.Add($cmbMicDev)
# diagnostika: sepise stav vysilacky/hlasu do souboru na plochu (na poslani, kdyz neco nefunguje)
$btnDiag = New-Object System.Windows.Forms.Button
$btnDiag.Text = "Diagnostika (soubor na plochu)"; $btnDiag.Location = New-Object System.Drawing.Point(20, 262); $btnDiag.Size = New-Object System.Drawing.Size(330, 24)
Style-Btn $btnDiag $cCard2 $cText; $cardApp.Controls.Add($btnDiag)

# --- PRIROZENY HLAS (CLOUD AI) - jako ChatGPT: ElevenLabs / OpenAI, potreba klic + internet ---
$cardCloud = New-Card $pageSet 402 588 372 104 "PRIROZENY HLAS (CLOUD - JAKO CHATGPT)" $cViolet
$cmbCloud = New-Object System.Windows.Forms.ComboBox
$cmbCloud.Location = New-Object System.Drawing.Point(16, 30); $cmbCloud.Size = New-Object System.Drawing.Size(104, 24); $cmbCloud.DropDownStyle = 'DropDownList'
$cmbCloud.BackColor = $cCard2; $cmbCloud.ForeColor = $cText; $cmbCloud.FlatStyle = 'Flat'
[void]$cmbCloud.Items.Add('Vypnuto'); [void]$cmbCloud.Items.Add('ElevenLabs'); [void]$cmbCloud.Items.Add('OpenAI')
$cardCloud.Controls.Add($cmbCloud)
$setCloudKey = New-Object System.Windows.Forms.TextBox
$setCloudKey.Location = New-Object System.Drawing.Point(126, 30); $setCloudKey.Size = New-Object System.Drawing.Size(150, 24)
$setCloudKey.BackColor = $cCard2; $setCloudKey.ForeColor = $cText; $setCloudKey.UseSystemPasswordChar = $true; $setCloudKey.BorderStyle = "FixedSingle"
$cardCloud.Controls.Add($setCloudKey)
$btnCloudTest = New-Object System.Windows.Forms.Button
$btnCloudTest.Text = "Test"; $btnCloudTest.Location = New-Object System.Drawing.Point(282, 30); $btnCloudTest.Size = New-Object System.Drawing.Size(74, 26)
Style-Btn $btnCloudTest ([System.Drawing.Color]::FromArgb(40,167,90)) $cText; $cardCloud.Controls.Add($btnCloudTest)
# 2. radek: vyber HLASU - ElevenLabs nacte tvoje hlasy z API, OpenAI ma pevny seznam
$lblCloudVoice = New-Val $cardCloud 16 68 (New-Object System.Drawing.Font("Segoe UI", 8)) $cMuted "Hlas:"
$cmbCloudVoice = New-Object System.Windows.Forms.ComboBox
$cmbCloudVoice.Location = New-Object System.Drawing.Point(126, 64); $cmbCloudVoice.Size = New-Object System.Drawing.Size(168, 24); $cmbCloudVoice.DropDownStyle = 'DropDownList'
$cmbCloudVoice.BackColor = $cCard2; $cmbCloudVoice.ForeColor = $cText; $cmbCloudVoice.FlatStyle = 'Flat'
$cardCloud.Controls.Add($cmbCloudVoice)
$btnCloudVoices = New-Object System.Windows.Forms.Button
$btnCloudVoices.Text = "Nacist"; $btnCloudVoices.Location = New-Object System.Drawing.Point(300, 63); $btnCloudVoices.Size = New-Object System.Drawing.Size(56, 26)
Style-Btn $btnCloudVoices $cCard2 $cText; $cardCloud.Controls.Add($btnCloudVoices)
$script:CloudVoiceMap = @{}
# pravy klik -> Vlozit: password pole samo nenabizi "paste", proto vlastni kontextove menu
$script:cmCloudKey = New-Object System.Windows.Forms.ContextMenuStrip
$miCloudPaste = $script:cmCloudKey.Items.Add('Vložit / Paste')
$miCloudPaste.Add_Click({ $tb = $script:cmCloudKey.SourceControl; if ($tb) { try { $tb.SelectedText = [System.Windows.Forms.Clipboard]::GetText() } catch { } } })
$miCloudClear = $script:cmCloudKey.Items.Add('Vymazat / Clear')
$miCloudClear.Add_Click({ $tb = $script:cmCloudKey.SourceControl; if ($tb) { $tb.Clear() } })
$setCloudKey.ContextMenuStrip = $script:cmCloudKey
$pageSet.AutoScroll = $true   # karta presahuje vysku stranky v okenim rezimu -> scrollovatelne
$ttCloud = New-Object System.Windows.Forms.ToolTip
$ttCloud.AutoPopDelay = 15000; $ttCloud.InitialDelay = 300
$cloudHint = "Prirozeny neuralni hlas jako ChatGPT (potreba internet + vlastni klic, mala platba za znaky)." + [Environment]::NewLine + "ElevenLabs: nejprirozenejsi, umi cesky - klic z elevenlabs.io (je i free tier)." + [Environment]::NewLine + "OpenAI: hlas jako ChatGPT - klic z platform.openai.com. Bez klice mluvi offline hlas."
$fbHint = "Zalozni klic druheho provozovatele. Kdyz hlavni (napr. ElevenLabs) selze - vypadek, spatny klic, dosly kredit - Jerry tise prepne sem (OpenAI). Vloz sem OPACNY klic nez nahore. Volitelne."
$ttCloud.SetToolTip($cmbCloud, $cloudHint); $ttCloud.SetToolTip($setCloudKey, $cloudHint); $ttCloud.SetToolTip($btnCloudTest, $cloudHint)

# ============================================================
#  LOGIKA
# ============================================================
function Load-Settings {
    try {
        if (Test-Path $script:SettingsPath) {
            $raw = Get-Content $script:SettingsPath -Raw -ErrorAction Stop
            if ($raw) { $o = $raw | ConvertFrom-Json -ErrorAction Stop
                if ($o.ApiKey) { $script:Settings.ApiKey = [string]$o.ApiKey }
                if ($o.Model)  { $script:Settings.Model  = [string]$o.Model }
                if ($null -ne $o.EngineerOn) { $script:Settings.EngineerOn = [bool]$o.EngineerOn }
                if ($o.EngName) { $script:Settings.EngName = [string]$o.EngName }
                if ($null -ne $o.EngStyle) { $script:Settings.EngStyle = [int]$o.EngStyle }
                if ($null -ne $o.EngCustom) { $script:Settings.EngCustom = [string]$o.EngCustom }
                if ($null -ne $o.Voice) { $script:Settings.Voice = [string]$o.Voice }
                if ($null -ne $o.Rate) { $script:Settings.Rate = [int]$o.Rate }
                if ($o.EngLang) { $script:Settings.EngLang = [string]$o.EngLang }
                if ($null -ne $o.PttKey) { $script:Settings.PttKey = [int]$o.PttKey }
                if ($null -ne $o.MicDev) { $script:Settings.MicDev = [int]$o.MicDev }
                if ($null -ne $o.PttJoyId) { $script:Settings.PttJoyId = [int]$o.PttJoyId }
                if ($null -ne $o.PttJoyBtn) { $script:Settings.PttJoyBtn = [int]$o.PttJoyBtn }
                if ($o.WhisPrefer) { $script:Settings.WhisPrefer = [string]$o.WhisPrefer }
                if ($o.CustomPhrases) { $cp = @{}; foreach ($pp in $o.CustomPhrases.PSObject.Properties) { $cp[$pp.Name] = [string]$pp.Value }; $script:Settings.CustomPhrases = $cp }
                if ($o.UiLang) { $script:Settings.UiLang = [string]$o.UiLang }
                if ($null -ne $o.Verbosity) { $script:Settings.Verbosity = [int]$o.Verbosity }
                foreach ($ck in @('CoLaps','CoFuel','CoTyres','CoFlags','CoContact','CoCount','CoPb')) { if ($null -ne $o.$ck) { $script:Settings[$ck] = [int]$o.$ck } }
                if ($o.CloudEngine) { $script:Settings.CloudEngine = [string]$o.CloudEngine }
                if ($o.CloudKey) { $script:Settings.CloudKey = [string]$o.CloudKey }
                if ($null -ne $o.CloudVoice) { $script:Settings.CloudVoice = [string]$o.CloudVoice }
                if ($null -ne $o.CloudModel) { $script:Settings.CloudModel = [string]$o.CloudModel }
                if ($null -ne $o.CloudKey2) { $script:Settings.CloudKey2 = [string]$o.CloudKey2 } }
        }
    } catch { }
}
function Save-Settings { try { ($script:Settings | ConvertTo-Json) | Set-Content -Path $script:SettingsPath -Encoding UTF8 -ErrorAction Stop } catch { } }

# --- Osobni rekordy (trat + vuz -> nejlepsi kolo v ms), prezije restart ---
$script:BestsPath = Join-Path $script:DataDir 'bests.json'
$script:Bests = @{}
function Load-Bests {
    try {
        if (Test-Path $script:BestsPath) {
            $o = Get-Content $script:BestsPath -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            foreach ($p in $o.PSObject.Properties) { $script:Bests[$p.Name] = [int]$p.Value }
        }
    } catch { }
}
function Save-Bests { try { ($script:Bests | ConvertTo-Json) | Set-Content -Path $script:BestsPath -Encoding UTF8 -ErrorAction Stop } catch { } }
function Get-PBKey { ("{0}|{1}" -f $script:Tel.Track, $script:Tel.CarModel) }
# --- Zapamatovana spotreba (trat + vuz -> litry/kolo): strategie a kvala plan funguji od 1. kola ---
$script:FplPath = Join-Path $script:DataDir 'fuel.json'
$script:FplSaved = @{}
function Load-Fpl {
    try {
        if (Test-Path $script:FplPath) {
            $o = Get-Content $script:FplPath -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            foreach ($p in $o.PSObject.Properties) { $script:FplSaved[$p.Name] = [double]$p.Value }
        }
    } catch { }
}
function Save-Fpl { try { ($script:FplSaved | ConvertTo-Json) | Set-Content -Path $script:FplPath -Encoding UTF8 -ErrorAction Stop } catch { } }

# ============================================================
#  TRVALA PAMET INZENYRA O JEZDCI (driver-memory.json)
#  - statistiky kariery (crashe, PB, vyhry...), VZTAH k jezdci (-1..1),
#    poznamky co si inzenyr zapamatoval, hodnoceni rad (feedback)
#  - drzi se PRES SEANCE -> osobnost se vyviji, inzenyr si te pamatuje
# ============================================================
$script:DrvMemPath = Join-Path $script:DataDir 'driver-memory.json'
$script:DrvMem = @{ Sessions = 0; Races = 0; Wins = 0; Podiums = 0; Crashes = 0; Contacts = 0; Spins = 0; Offtracks = 0; Locks = 0; PBs = 0; TotalLaps = 0; LastCrashes = 0; LastSpins = 0; Rapport = 0.0; LastSeen = ''; Notes = @(); FbGood = 0; FbBad = 0; FbLog = @() }
$script:DrvMem0 = @{ C = 0; S = 0 }   # stav pri startu seance (pro "minule jsi...")
$script:LastAnswer = ''                # posledni odpoved inzenyra (pro hodnoceni rad)
function Load-DrvMem {
    try {
        if (Test-Path $script:DrvMemPath) {
            $o = Get-Content $script:DrvMemPath -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            foreach ($p in $o.PSObject.Properties) {
                if ($p.Name -eq 'Notes') { $script:DrvMem.Notes = @($p.Value | ForEach-Object { [string]$_ }) }
                elseif ($p.Name -eq 'FbLog') { $script:DrvMem.FbLog = @($p.Value | ForEach-Object { @{ q = [string]$_.q; a = [string]$_.a; ok = [bool]$_.ok; t = [string]$_.t } }) }
                elseif ($p.Name -eq 'Rapport') { $script:DrvMem.Rapport = [double]$p.Value }
                elseif ($p.Name -eq 'LastSeen') { $script:DrvMem.LastSeen = [string]$p.Value }
                elseif ($script:DrvMem.ContainsKey($p.Name)) { $script:DrvMem[$p.Name] = [int]$p.Value }
            }
        }
    } catch { }
    $script:DrvMem0 = @{ C = [int]$script:DrvMem.Crashes; S = [int]$script:DrvMem.Spins }
}
function Save-DrvMem { try { ($script:DrvMem | ConvertTo-Json -Depth 5) | Set-Content -Path $script:DrvMemPath -Encoding UTF8 -ErrorAction Stop } catch { } }
function Adjust-Rapport([double]$d) { $script:DrvMem.Rapport = [math]::Max(-1.0, [math]::Min(1.0, [double]$script:DrvMem.Rapport + $d)) }
function Add-DrvNote([string]$note) {
    if (-not $note) { return }
    $note = $note.Trim(); if (-not $note) { return }
    if ($note.Length -gt 200) { $note = $note.Substring(0, 200) }
    if (@($script:DrvMem.Notes) -contains $note) { return }
    $script:DrvMem.Notes = @(@($script:DrvMem.Notes) + $note | Select-Object -Last 30)
    Save-DrvMem
}
# hodnoceni posledni rady: "dobra/spatna rada" hlasem nebo tlacitkem -> AI se z toho uci (jde do promptu)
function Rate-LastAnswer([bool]$ok) {
    if (-not $script:LastAnswer) { return $false }
    $e = @{ q = [string]$script:LastQ; a = [string]$script:LastAnswer; ok = $ok; t = (Get-Date -Format 'yyyy-MM-dd') }
    $script:DrvMem.FbLog = @(@($script:DrvMem.FbLog) + $e | Select-Object -Last 20)
    if ($ok) { $script:DrvMem.FbGood = [int]$script:DrvMem.FbGood + 1; Adjust-Rapport 0.02 }
    else { $script:DrvMem.FbBad = [int]$script:DrvMem.FbBad + 1; Adjust-Rapport -0.01 }
    Save-DrvMem
    return $true
}
# kratky EN souhrn profilu jezdce pro AI prompt (+ pouceni ze spatne hodnocenych rad)
function Get-DriverProfileText {
    $m = $script:DrvMem
    $t = ("sessions together={0}, races={1}, wins={2}, podiums={3}, personal bests={4}, career laps={5}, crashes={6}, contacts={7}, spins={8}, relationship with you (-1 cold .. +1 trusts you)={9:0.00}" -f `
        [int]$m.Sessions, [int]$m.Races, [int]$m.Wins, [int]$m.Podiums, [int]$m.PBs, [int]$m.TotalLaps, [int]$m.Crashes, [int]$m.Contacts, [int]$m.Spins, [double]$m.Rapport)
    $nts = @($m.Notes | Select-Object -Last 8)
    if ($nts.Count -gt 0) { $t += '; things you remember about the driver: ' + ($nts -join ' | ') }
    $bad = @($m.FbLog | Where-Object { -not [bool]$_.ok } | Select-Object -Last 3)
    if ($bad.Count -gt 0) { $t += '; the driver DISLIKED these past answers of yours, do better than this: ' + (($bad | ForEach-Object { '"' + [string]$_.a + '"' }) -join ' | ') }
    if (([int]$m.FbGood + [int]$m.FbBad) -gt 0) { $t += ("; answer ratings so far: {0} good / {1} bad" -f [int]$m.FbGood, [int]$m.FbBad) }
    return $t
}
# osobni pozdrav pri radio checku - podle povahy, VZTAHU a toho, co si pamatuje z minula. Vraci @(en,cs) nebo $null
function Get-WelcomeBack {
    $m = $script:DrvMem
    if ([int]$m.Sessions -lt 2) { return $null }
    $r = [double]$m.Rapport; $n = [int]$m.Sessions; $lastC = [int]$m.LastCrashes + [int]$m.LastSpins
    switch ([int]$script:Settings.EngStyle) {
        1 { # drsnak: pamatuje si tvoje prohresky, ale kdyz si ho ziskas, prizna to
            if ($lastC -ge 2) { return @(("Session {0}. Last time you binned it {1} times. Today we try WITHOUT the bodywork bill, deal?" -f $n, $lastC), ("Seance číslo {0}. Minule jsi to zabalil {1}krát. Dneska to zkusíme BEZ faktury za karosérii, jo?" -f $n, $lastC)) }
            if ($r -ge 0.4) { return @(("Session {0}. You know what? I am actually starting to enjoy working with you. Tell no one." -f $n), ("Seance {0}. Víš co? Už mě to s tebou začíná bavit. Nikomu to neříkej." -f $n)) }
            if ($r -le -0.4) { return @(("You again. Session {0}. Fine - prove me wrong today." -f $n), ("Zase ty. Seance {0}. Fajn - dneska mi dokaž, že se pletu." -f $n)) }
            return @(("Session {0}. I remember everything, you know. Every single spin." -f $n), ("Seance {0}. Já si pamatuju všechno, víš to? Každý hodiny." -f $n))
        }
        2 { # kamos: hreje ho spolecna historie
            if ([int]$m.PBs -gt 0) { return @(("Welcome back, mate! Session {0} together and {1} personal bests so far - today we add another one!" -f $n, [int]$m.PBs), ("Vítej zpátky, kámo! Už {0}. seance spolu a {1} osobáků - dneska přidáme další!" -f $n, [int]$m.PBs)) }
            return @(("Welcome back, mate! Session {0} together - good to have you on the radio again." -f $n), ("Vítej zpátky, kámo! Už {0}. seance spolu - rád tě zase slyším." -f $n))
        }
        3 { # analytik: cita karieru
            return @(("Session {0}. Career data loaded: {1} laps, {2} personal bests, {3} incidents on file." -f $n, [int]$m.TotalLaps, [int]$m.PBs, ([int]$m.Crashes + [int]$m.Spins)), ("Seance {0}. Kariérní data načtena: {1} kol, {2} osobních rekordů, {3} incidentů v záznamu." -f $n, [int]$m.TotalLaps, [int]$m.PBs, ([int]$m.Crashes + [int]$m.Spins)))
        }
        default { # profik: strucne, ale da najevo ze te zna
            if (([int]$m.Wins + [int]$m.Podiums) -gt 0) { return @(("Session {0}. Your record stands at {1} wins, {2} podiums. Let us add to it." -f $n, [int]$m.Wins, [int]$m.Podiums), ("Seance {0}. Tvoje bilance: {1} výher, {2} pódií. Jdeme ji vylepšit." -f $n, [int]$m.Wins, [int]$m.Podiums)) }
            return @(("Session {0}. History loaded, I know how you drive. Let us work." -f $n), ("Seance {0}. Historie načtena, vím, jak jezdíš. Jdeme na to." -f $n))
        }
    }
}

# --- ZIVA DELTA: profil nejlepsiho kola (pozice na trati -> cas) a prubezne srovnani ---
$script:PitPlan = $false   # "naplanuj box" hlasovym povelem
$script:StintSig = ''      # podpis tabulky stintu (prekresleni jen pri zmene)
$script:LapProf = New-Object System.Collections.ArrayList   # aktualni kolo: (normPos, ms)
$script:PrevLapProf = $null                                  # prave dokoncene kolo (pred smazanim)
$script:BestProf = $null                                     # profil nejlepsiho kola
$script:LapProfLastNp = -1.0
$script:BestProfIdx = 0
function Update-LiveDelta {
    $T = $script:Tel
    $np = [double]$T.NormPos
    if ($np -lt 0 -or $np -gt 1) { return $null }
    # wrap = zacatek noveho kola: schovej dokonceny profil a zacni znovu
    if ($script:LapProfLastNp -gt 0.9 -and $np -lt 0.1) {
        $script:PrevLapProf = $script:LapProf.Clone()
        $script:LapProf.Clear()
        $script:BestProfIdx = 0
    }
    if ($script:LapProf.Count -eq 0 -or $np -gt $script:LapProfLastNp) {
        # (normPos, ms, rychlost, plyn, brzda) - poslední 3 pro historii/porovnání kol
        [void]$script:LapProf.Add(@($np, [int]$T.CurrentTimeMs, [double]$T.SpeedKmh, [double]$T.Gas, [double]$T.Brake))
    }
    $script:LapProfLastNp = $np
    # srovnani s profilem nejlepsiho kola
    if (-not $script:BestProf -or $script:BestProf.Count -lt 10) { return $null }
    $i = $script:BestProfIdx
    if ($i -ge $script:BestProf.Count) { $i = 0 }
    if ([double]$script:BestProf[$i][0] -gt $np) { $i = 0 }   # np skocil zpet (reset/box)
    while (($i + 1) -lt $script:BestProf.Count -and [double]$script:BestProf[$i + 1][0] -le $np) { $i++ }
    $script:BestProfIdx = $i
    $bms = [int]$script:BestProf[$i][1]
    if ($bms -le 0 -or [int]$T.CurrentTimeMs -le 0) { return $null }
    return ([int]$T.CurrentTimeMs - $bms) / 1000.0
}

# ============================================================
#  HISTORIE KOL: kazde dokoncene kolo se ulozi (cas + telemetricka stopa
#  prevzorkovana po delce trati) -> da se kdykoli rozkliknout a porovnat.
# ============================================================
$script:LapHistory = New-Object System.Collections.ArrayList   # zaznamy @{ n; ms; t; trace=@(@(pos,speed,gas,brake)) }
$script:HistDir = Join-Path $script:DataDir 'history'
try { if (-not (Test-Path $script:HistDir)) { New-Item -ItemType Directory -Path $script:HistDir -Force | Out-Null } } catch { }
$script:HistKey = ''
$script:HistSel = -1     # vybrane kolo (index v LapHistory), -1 = zadne
$script:HistCmp = -2     # s cim porovnat: -2 = nejlepsi kolo, -1 = nic, jinak index
$script:HistBins = 120   # kolik bodu po delce kola (spolecna osa X pro porovnani)
function Get-HistFile {
    $k = ($script:HistKey -replace '[^\w\-]', '_'); if (-not $k) { $k = 'unknown' }
    Join-Path $script:HistDir ($k + '.json')
}
# prevzorkovat syrovy profil (normPos rostouci) na pevny pocet bodu -> porovnatelne mezi koly
function Resample-Trace($prof) {
    $out = @()
    if (-not $prof -or $prof.Count -lt 3) { return $out }
    $n = $prof.Count; $j = 0
    for ($b = 0; $b -lt $script:HistBins; $b++) {
        $target = $b / [double]($script:HistBins - 1)
        while (($j + 1) -lt $n -and [double]$prof[$j + 1][0] -le $target) { $j++ }
        $p = $prof[$j]
        $out += ,@([math]::Round($target, 3), [math]::Round([double]$p[2], 1), [math]::Round([double]$p[3], 3), [math]::Round([double]$p[4], 3))
    }
    return $out
}
function Add-LapToHistory([int]$lapMs, $prof) {
    if ($lapMs -le 0 -or -not $prof -or $prof.Count -lt 10) { return }
    $trace = Resample-Trace $prof
    if ($trace.Count -lt 10) { return }
    $rec = @{ n = ([int]$script:Tel.CompletedLaps); ms = $lapMs; t = (Get-Date -Format 'HH:mm'); trace = $trace }
    [void]$script:LapHistory.Add($rec)
    # v pameti drzime rozumny pocet (nejlepsi + poslednich N)
    while ($script:LapHistory.Count -gt 60) { $script:LapHistory.RemoveAt(0) }
    Save-History
}
function Save-History {
    try {
        if (-not $script:HistKey) { return }
        # na disk: nejlepsich par + poslednich par (cap 40), at soubor neroste donekonecna
        $arr = @($script:LapHistory)
        if ($arr.Count -gt 40) {
            $sorted = @($arr | Sort-Object { [int]$_.ms })
            $keep = @{}; foreach ($r in ($sorted | Select-Object -First 10)) { $keep[$r] = $true }
            foreach ($r in ($arr[($arr.Count-30)..($arr.Count-1)])) { $keep[$r] = $true }
            $arr = @($arr | Where-Object { $keep[$_] })
        }
        (ConvertTo-Json $arr -Depth 6 -Compress) | Set-Content -Path (Get-HistFile) -Encoding UTF8 -ErrorAction Stop
    } catch { }
}
function Load-History {
    $script:LapHistory.Clear(); $script:HistSel = -1
    try {
        $f = Get-HistFile
        if (Test-Path $f) {
            $arr = Get-Content $f -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            foreach ($r in @($arr)) {
                $tr = @(); foreach ($p in @($r.trace)) { $tr += ,@([double]$p[0], [double]$p[1], [double]$p[2], [double]$p[3]) }
                if ($tr.Count -ge 10) { [void]$script:LapHistory.Add(@{ n = [int]$r.n; ms = [int]$r.ms; t = [string]$r.t; trace = $tr }) }
            }
        }
    } catch { }
}
# nejlepsi kolo z historie (index) - pro vychozi porovnani
function Get-HistBestIdx {
    $bi = -1; $bms = [int]::MaxValue
    for ($i = 0; $i -lt $script:LapHistory.Count; $i++) { $m = [int]$script:LapHistory[$i].ms; if ($m -gt 0 -and $m -lt $bms) { $bms = $m; $bi = $i } }
    return $bi
}

# --- Referencni kola znamych trati (orientacni, kategorie GT3) ---
$script:RefLaps = @(
    @{ m = 'nordschleife';   ms = 495000; n = 'Nordschleife' },
    @{ m = 'nurburgring';    ms = 114000; n = 'Nurburgring GP' },
    @{ m = 'monza';          ms = 108000; n = 'Monza' },
    @{ m = 'spa';            ms = 138000; n = 'Spa' },
    @{ m = 'imola';          ms = 102000; n = 'Imola' },
    @{ m = 'mugello';        ms = 108000; n = 'Mugello' },
    @{ m = 'silverstone';    ms = 119000; n = 'Silverstone' },
    @{ m = 'barcelona';      ms = 105000; n = 'Barcelona' },
    @{ m = 'brands';         ms =  84000; n = 'Brands Hatch' },
    @{ m = 'red_?bull';      ms =  88000; n = 'Red Bull Ring' },
    @{ m = 'zandvoort';      ms =  97000; n = 'Zandvoort' },
    @{ m = 'laguna';         ms =  82000; n = 'Laguna Seca' },
    @{ m = 'vallelunga';     ms =  94000; n = 'Vallelunga' },
    @{ m = 'magione';        ms =  75000; n = 'Magione' }
)
function Get-RefLap {
    $trk = ([string]$script:Tel.Track).ToLower()
    if (-not $trk) { return $null }
    foreach ($r in $script:RefLaps) { if ($trk -match $r.m) { return $r } }
    return $null
}

# --- Hlas: uzivateluv vyber > cesky auto-detect > vychozi ---
function Apply-Voice {
    if (-not $script:Tts) { return }
    try {
        $target = $null
        if ($script:Settings.Voice) {
            $v = $script:Tts.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Name -eq $script:Settings.Voice } | Select-Object -First 1
            if ($v) { $target = $v.VoiceInfo }
        }
        if (-not $target) {
            $v = $script:Tts.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.Name -like 'cs*' } | Select-Object -First 1
            if ($v) { $target = $v.VoiceInfo }
        }
        if ($target) { $script:Tts.SelectVoice($target.Name) }
        $script:VoiceCz = ($script:Tts.Voice.Culture.Name -like 'cs*')
        $script:VoiceName = $script:Tts.Voice.Name
        $r = [int]$script:Settings.Rate; if ($r -lt -10) { $r = -10 }; if ($r -gt 10) { $r = 10 }
        $script:Tts.Rate = $r
    } catch { }
    # kdo bude mluvit: vyber uzivatele ma prednost; auto = Piper, kdyz je
    $vSel = [string]$script:Settings.Voice
    if ($vSel -like '__piper:*') {
        # konkretni stazeny Piper hlas (napr. __piper:de_DE-thorsten-medium)
        $mPath = Find-PiperModel $vSel.Substring(8)
        if ($mPath -and $script:Piper) { $script:Piper.Model = $mPath; $script:UsePiper = $true }
        else { $script:UsePiper = [bool]$script:Piper }
    }
    elseif ($vSel -eq '__piper__') { $script:UsePiper = [bool]$script:Piper }
    elseif ($vSel) { $script:UsePiper = $false }
    else {
        # AUTO: hlas se ridi jazykem inzenyra, aby hlas VZDY sedel s textem (zadny nemecky hlas na anglicky text)
        $el = Get-CalloutLang
        $script:UsePiper = $false
        if ($el -eq 'cs') {
            # cesky: preferuj Windows hlas (Jakub) - prirozenejsi nez Piper Jirka; jinak Piper Jirka
            $sapiCs = $null
            if ($script:Tts) { try { $sapiCs = $script:Tts.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.Name -like 'cs*' } | Select-Object -First 1 } catch { } }
            if ($sapiCs) { try { $script:Tts.SelectVoice($sapiCs.VoiceInfo.Name); $script:VoiceName = $sapiCs.VoiceInfo.Name; $script:VoiceCz = $true } catch { }; $script:UsePiper = $false }
            elseif ($script:Piper) { $mcs = Find-PiperLang 'cs'; if ($mcs) { $script:Piper.Model = $mcs; $script:UsePiper = $true } }
        } else {
            # anglicky (a vse ostatni proaktivni): preferuj Piper (Alan), jinak Windows en hlas
            if ($script:Piper) { $men = Find-PiperLang 'en'; if ($men) { $script:Piper.Model = $men; $script:UsePiper = $true } else { $script:UsePiper = $true } }
            if (-not $script:UsePiper -and $script:Tts) { try { $sen = $script:Tts.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.TwoLetterISOLanguageName -eq 'en' } | Select-Object -First 1; if ($sen) { $script:Tts.SelectVoice($sen.VoiceInfo.Name); $script:VoiceName = $sen.VoiceInfo.Name; $script:VoiceCz = $false } } catch { } }
        }
    }
}
function Get-VoiceText {
    $pfx = Tr 'Hlas: ' 'Voice: '
    if (Cloud-On) {
        $prov = if ([string]$script:Settings.CloudEngine -eq 'openai') { 'OpenAI' } else { 'ElevenLabs' }
        return ($pfx + (Tr 'prirozeny cloud - ' 'natural cloud - ') + $prov)
    }
    if ($script:UsePiper -and $script:Piper) { return ($pfx + 'Piper - ' + (Get-PiperLabel $script:Piper.Model)) }
    if (-not $script:Tts) { return ($pfx + (Tr 'nedostupny (chybi Windows TTS)' 'unavailable (no Windows TTS)')) }
    $cul = ''
    try { $c2 = $script:Tts.Voice.Culture.TwoLetterISOLanguageName; if ($script:LangNative[$c2]) { $cul = ' (' + [string]$script:LangNative[$c2] + ')' } } catch { }
    return ($pfx + $script:VoiceName + $cul)
}
function Update-VoiceInfo { $lblPersStatus.Text = Get-VoiceText; $lblPersStatus.ForeColor = $cMuted }
function Update-AppButtons {
    # co uz je nainstalovane, to se nenabizi znovu - jen potvrdi (nebo nabidne upgrade)
    if ($script:Whisper) {
        $wdir = Split-Path $script:Whisper.Model -Parent
        $hasMedium = [bool](Get-ChildItem $wdir -Filter 'ggml-medium*.bin' -File -ErrorAction SilentlyContinue | Select-Object -First 1)
        $hasSmall = [bool](Get-ChildItem $wdir -Filter 'ggml-small*.bin' -File -ErrorAction SilentlyContinue | Select-Object -First 1)
        $mn = [System.IO.Path]::GetFileName($script:Whisper.Model)
        $E = $script:UiEn
        if ($hasMedium -and $hasSmall) {
            # oba modely: tlacitko prepina RYCHLY <-> MAXIMALNI
            $btnInstallSr.Enabled = $true
            if ($mn -match 'medium') { $btnInstallSr.Text = $(if ($E) { "Transcription: MAX (slower) - switch to FAST" } else { "Prepis: MAXIMALNI (pomalejsi) - prepni na RYCHLY" }) }
            else { $btnInstallSr.Text = $(if ($E) { "Transcription: FAST (small) - switch to MAX" } else { "Prepis: RYCHLY (small) - prepni na MAXIMALNI" }) }
        }
        elseif ($mn -match 'small') { $btnInstallSr.Enabled = $true; $btnInstallSr.Text = $(if ($E) { "Max accuracy - medium model (~540 MB)" } else { "Maximalni cestina - medium (~540 MB)" }) }
        elseif ($mn -match 'medium|large') { $btnInstallSr.Enabled = $false; $btnInstallSr.Text = $(if ($E) { "Transcription: MAXIMUM (medium)" } else { "Prepis reci: MAXIMUM (medium)" }) }
        else { $btnInstallSr.Enabled = $true; $btnInstallSr.Text = $(if ($E) { "Improve transcription (~190 MB)" } else { "Vylepsit prepis cestiny (~190 MB)" }) }
    }
    else { $btnInstallSr.Enabled = $true; $btnInstallSr.Text = $(if ($script:UiEn) { "Download speech recognition (~80 MB)" } else { "Stahnout rozpoznavani reci (~80 MB)" }) }
    # tlacitko katalogu hlasu je stale aktivni (stahuje vybrany jazyk); jen popisek podle jazyka UI
    $btnGetPiper.Enabled = $true; $btnGetPiper.Text = $(if ($script:UiEn) { "Download" } else { "Stahnout" })
    $hasCz = $false
    if ($script:Tts) { try { $hasCz = [bool]($script:Tts.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.Name -like 'cs*' } | Select-Object -First 1) } catch { } }
    if ($hasCz) { $btnUnlockVoices.Enabled = $false; $btnUnlockVoices.Text = $(if ($script:UiEn) { "Windows voices: UNLOCKED (Czech OK)" } else { "Hlasy Windows: ODEMCENO (cestina OK)" }) }
}
function Update-PttDisplay {
    $d = ''
    if ([int]$script:Settings.PttKey -gt 0) { try { $d = ("{0}" -f ([System.Windows.Forms.Keys][int]$script:Settings.PttKey)) } catch { $d = 'key' } }
    elseif ([int]$script:Settings.PttJoyBtn -ge 0) { $d = ("{0} {1}" -f $(if ($script:UiEn) { 'Wheel: button' } else { 'Volant: tlacitko' }), ([int]$script:Settings.PttJoyBtn + 1)) }
    if ($d) { $txtPtt.Text = $d; $txtPttSet.Text = $d }
    elseif ($script:UiEn) { $txtPtt.Text = "(click, then key/wheel button)"; $txtPttSet.Text = "(click + press)" }
    else { $txtPtt.Text = "(klikni, pak klavesa/volant)"; $txtPttSet.Text = "(klikni + stiskni)" }
}
function Set-PttKey([int]$vk) {
    $script:Settings.PttKey = $vk
    if ($vk -ne 0) { $script:Settings.PttJoyId = -1; $script:Settings.PttJoyBtn = -1 }
    else { $script:Settings.PttJoyId = -1; $script:Settings.PttJoyBtn = -1 }
    Save-Settings; Update-PttDisplay
}
function Set-PttJoy([int]$id, [int]$btn) {
    $script:Settings.PttJoyId = $id; $script:Settings.PttJoyBtn = $btn; $script:Settings.PttKey = 0
    Save-Settings; Update-PttDisplay
}

# --- Mapa trati: uci se z pozice vozu, po dokoncenem kole se ulozi per trat ---
$script:MapsDir = Join-Path $script:DataDir 'maps'
try { if (-not (Test-Path $script:MapsDir)) { New-Item -ItemType Directory -Path $script:MapsDir -Force | Out-Null } } catch { }
$script:MapPts = New-Object System.Collections.ArrayList
$script:MapComplete = $false; $script:MapKey = ''
# MAPA CHYB: udalosti pripnute na misto na trati (1 = smyk zadku, 2 = kontakt/crash, 3 = blok kol)
$script:EventPins = New-Object System.Collections.ArrayList
function Add-EventPin([int]$type) {
    try {
        $T = $script:Tel
        if (-not ($T.PosOk -or $T.Demo)) { return }
        if ($script:EventPins.Count -ge 400) { return }
        [void]$script:EventPins.Add(@([double]$T.PosX, [double]$T.PosZ, $type))
    } catch { }
}
function Get-MapFile { Join-Path $script:MapsDir ((($script:MapKey -replace '[^\w\-]', '_')) + '.json') }
function Load-Map {
    $script:MapPts.Clear(); $script:MapComplete = $false
    try {
        $f = Get-MapFile
        if (Test-Path $f) {
            $arr = Get-Content $f -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            foreach ($p in $arr) {
                $spd = 0.0; if ($p.Count -gt 2) { $spd = [double]$p[2] }   # stare mapy rychlost nemaji
                [void]$script:MapPts.Add(@([double]$p[0], [double]$p[1], $spd))
            }
            if ($script:MapPts.Count -gt 50) { $script:MapComplete = $true }
        }
    } catch { }
}
function Save-Map {
    try {
        if ($script:MapPts.Count -lt 20 -or -not $script:MapKey) { return }
        $arr = @(); foreach ($p in $script:MapPts) { $spd = 0.0; if ($p.Count -gt 2) { $spd = [math]::Round([double]$p[2],0) }; $arr += ,@([math]::Round([double]$p[0],1), [math]::Round([double]$p[1],1), $spd) }
        (ConvertTo-Json $arr -Compress) | Set-Content -Path (Get-MapFile) -Encoding UTF8 -ErrorAction Stop
    } catch { }
}
function Update-Map {
    $T = $script:Tel
    if (-not ($T.Demo -or [int]$T.Status -ge 2)) { return }
    if (-not $T.PosOk) { return }
    $mk = [string]$T.Track; if (-not $mk) { return }
    if ($mk -ne $script:MapKey) { $script:MapKey = $mk; Load-Map }
    if (-not $script:MapComplete -and [double]$T.SpeedKmh -gt 10) {
        $x = [double]$T.PosX; $z = [double]$T.PosZ
        $n = $script:MapPts.Count
        if ($n -eq 0) { [void]$script:MapPts.Add(@($x, $z, [math]::Round([double]$T.SpeedKmh, 0))) }
        else {
            $lp = $script:MapPts[$n-1]; $dx = $x - [double]$lp[0]; $dz = $z - [double]$lp[1]
            if (($dx*$dx + $dz*$dz) -gt 9.0) {
                if ($n -gt 100) {
                    $fp = $script:MapPts[0]; $ddx = $x - [double]$fp[0]; $ddz = $z - [double]$fp[1]
                    if (($ddx*$ddx + $ddz*$ddz) -lt 150.0) { $script:MapComplete = $true; Save-Map; Add-Radio (Tr '(Mapa trati je hotova a ulozena.)' '(Track map complete and saved.)') }
                }
                if (-not $script:MapComplete) {
                    [void]$script:MapPts.Add(@($x, $z, [math]::Round([double]$T.SpeedKmh, 0)))
                    if ($script:MapPts.Count -gt 8000) { $script:MapComplete = $true; Save-Map }
                    elseif ($script:MapPts.Count % 100 -eq 0) { Save-Map }   # prubezne ukladani i behem kola
                }
            }
        }
    }
}

# --- Windows vylepseni (potrebuji admin - vyskoci UAC) ---
function Unlock-MoreVoices {
    try {
        Start-Process powershell -Verb RunAs -WindowStyle Hidden -ArgumentList '-NoProfile','-Command',"reg copy 'HKLM\SOFTWARE\Microsoft\Speech_OneCore\Voices\Tokens' 'HKLM\SOFTWARE\Microsoft\Speech\Voices\Tokens' /s /f; reg copy 'HKLM\SOFTWARE\Microsoft\Speech_OneCore\Voices\Tokens' 'HKLM\SOFTWARE\WOW6432Node\Microsoft\Speech\Voices\Tokens' /s /f" -Wait
        $lblDeskStatus.Text = Tr 'Hotovo - restartuj PitWise, hlasy se objevi.' 'Done - restart PitWise and the voices appear.'; $lblDeskStatus.ForeColor = $cAccent
    } catch { $lblDeskStatus.Text = Tr 'Zruseno / chyba (potrebuje potvrzeni admina).' 'Cancelled / error (needs admin approval).'; $lblDeskStatus.ForeColor = $cAmber }
}
# --- Zastupce na plose ---
function New-DesktopShortcut {
    try {
        $exe = ''
        try { $m = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName; if ($m -match 'PitWise\.exe$') { $exe = $m } } catch { }
        if (-not $exe -and $PSScriptRoot) { $c = Join-Path $PSScriptRoot 'PitWise.exe'; if (Test-Path $c) { $exe = $c } }
        if (-not $exe) { $lblDeskStatus.Text = Tr 'Nenasel jsem PitWise.exe.' 'PitWise.exe not found.'; $lblDeskStatus.ForeColor = $cRed; return }
        $lnk = Join-Path ([Environment]::GetFolderPath('Desktop')) 'PitWise.lnk'
        $ws = New-Object -ComObject WScript.Shell
        $s = $ws.CreateShortcut($lnk)
        $s.TargetPath = $exe; $s.WorkingDirectory = (Split-Path $exe -Parent)
        $ico = Join-Path (Split-Path $exe -Parent) 'PitWise.ico'; if (Test-Path $ico) { $s.IconLocation = $ico }
        $s.Description = 'PitWise - sim racing telemetry and race engineer'
        $s.Save()
        $lblDeskStatus.Text = Tr 'Zastupce vytvoren na plose.' 'Shortcut created on the desktop.'; $lblDeskStatus.ForeColor = $cAccent
    } catch { $lblDeskStatus.Text = Tr 'Chyba pri vytvareni zastupce.' 'Error creating shortcut.'; $lblDeskStatus.ForeColor = $cRed }
}

function Export-Session {
    if ($script:LapList.Count -eq 0) { $lblExpStatus.Text = Tr 'Zadna dokoncena kola - neni co ulozit.' 'No completed laps - nothing to save.'; $lblExpStatus.ForeColor = $cAmber; return }
    try {
        $dir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PitWise'
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        $file = Join-Path $dir ((Tr 'PitWise_relace_{0}.txt' 'PitWise_session_{0}.txt') -f (Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'))
        $best = [int]($script:LapList | Measure-Object -Minimum).Minimum
        $avg  = [int](($script:LapList | Measure-Object -Average).Average)
        $lines = New-Object System.Collections.ArrayList
        [void]$lines.Add((Tr 'PitWise - zaznam relace   ' 'PitWise - session log   ') + (Get-Date -Format 'dd.MM.yyyy HH:mm'))
        [void]$lines.Add(((Tr 'Trat: {0}   Vuz: {1}' 'Track: {0}   Car: {1}') -f $script:Tel.Track, $script:Tel.CarModel))
        [void]$lines.Add(("=" * 46))
        for ($i = 0; $i -lt $script:LapList.Count; $i++) {
            $ms = [int]$script:LapList[$i]; $mark = if ($ms -eq $best) { Tr '  *nejlepsi' '  *best' } else { "" }
            [void]$lines.Add(((Tr 'Kolo {0,2}   {1}{2}' 'Lap {0,2}    {1}{2}') -f ($i+1), (Format-LapTime $ms), $mark))
        }
        [void]$lines.Add(("=" * 46))
        [void]$lines.Add(((Tr 'Nejlepsi: {0}   Prumer: {1}' 'Best: {0}   Average: {1}') -f (Format-LapTime $best), (Format-LapTime $avg)))
        if ($script:LapList.Count -ge 2) {
            $mean = ($script:LapList | Measure-Object -Average).Average; $var = 0.0
            foreach ($x in $script:LapList) { $var += [math]::Pow(($x-$mean),2) }
            [void]$lines.Add(((Tr 'Konzistence: +/- {0:0.00} s' 'Consistency: +/- {0:0.00} s') -f ([math]::Sqrt($var/$script:LapList.Count)/1000.0)))
        }
        $fpl = Get-FuelPerLap
        if ($fpl -gt 0) { [void]$lines.Add(((Tr 'Spotreba paliva: {0:0.0} L / kolo' 'Fuel use: {0:0.0} L / lap') -f $fpl)) }
        Set-Content -Path $file -Value ($lines -join "`r`n") -Encoding UTF8 -ErrorAction Stop
        $lblExpStatus.Text = Tr 'Ulozeno do Dokumenty\PitWise' 'Saved to Documents\PitWise'; $lblExpStatus.ForeColor = $cAccent
        Add-Radio ((Tr '(Relace ulozena: ' '(Session saved: ') + $file + ")")
    } catch { $lblExpStatus.Text = Tr 'Chyba pri ukladani.' 'Error while saving.'; $lblExpStatus.ForeColor = $cRed }
}

$script:LapList = New-Object System.Collections.ArrayList
$script:FuelUsed = New-Object System.Collections.ArrayList
$script:LastSeenLaps = 0; $script:FuelAtLapStart = $null
function Reset-Session {
    $script:LapList.Clear(); $script:FuelUsed.Clear()
    $script:TrSpeed.Clear(); $script:TrGas.Clear(); $script:TrBrake.Clear(); $script:TrSteer.Clear()
    $script:LapProf.Clear(); $script:PrevLapProf = $null; $script:BestProf = $null; $script:BestProfIdx = 0; $script:LapProfLastNp = -1.0; $script:LiveDelta = $null
    $script:LastSeenLaps = [int]$script:Tel.CompletedLaps; $script:FuelAtLapStart = [double]$script:Tel.Fuel
    $txtLaps.Text = ""; $lblSummary.Text = Tr 'Nejlepsi --   Prumer --' 'Best --   Average --'; $lblConsist.Text = Tr 'Konzistence: --' 'Consistency: --'
    $script:Eng.LastLap = [int]$script:Tel.CompletedLaps; $script:Eng.FuelWarned = $false; $script:Eng.FuelCritical = $false; $script:Eng.SaidLapsLeft = @{}
    $script:Eng.LastPaceAt = 0; $script:Eng.LastTyreTalk = 0; $script:Eng.ConsistAt = 0; $script:Eng.SlipCount = 0
    $script:Eng.LockCount = 0; $script:Eng.AbuseSec = 0.0; $script:Eng.AbuseSaid = 0
    $script:Eng.LastPos = 0; $script:Eng.BattleSide = ''
    $script:Eng.Mood = 0.0; $script:Eng.RaceDone = $false; $script:Eng.StartPos = 0; $script:Eng.MoodLap = 0
    $script:Eng.OffCount = 0; $script:Eng.LastGapAt = 0
    $script:WearHist.Clear()
    $script:SecEntry = @(0) * 10; $script:SecMin = @(0.0) * 10; $script:SecLastIdx = -1
    $script:SecBest = $null; $script:SecBestMin = $null; $script:SecBestLapMs = 0; $script:SecDeltas = $null
    $script:EventPins.Clear()
}
function TyreColor([double]$t) { if ($t -le 0) { return $script:cMuted }; if ($t -lt 70) { return $script:cBlue }; if ($t -le 95) { return $script:cAccent }; return $script:cRed }
function Get-FuelPerLap {
    if ($script:FuelUsed.Count -gt 0) { return (($script:FuelUsed | Measure-Object -Average).Average) }
    # jeste zadne zmerene kolo -> zapamatovana spotreba z minula (stejna trat + vuz)
    $k = Get-PBKey
    if ($k -ne '|' -and $script:FplSaved.ContainsKey($k)) { return [double]$script:FplSaved[$k] }
    return 0.0
}
function Get-LapsLeft {
    # kolik kol zbyva - z poctu kol, nebo odhad z casu (POZOR: sessionTimeLeft je v MILISEKUNDACH)
    if ([int]$script:Tel.NumberOfLaps -gt 0) { return ([int]$script:Tel.NumberOfLaps - [int]$script:Tel.CompletedLaps) }
    $tl = [double]$script:Tel.SessionTimeLeft
    if ($tl -le 0) { return -1 }
    $lapMs = [int]$script:Tel.BestTimeMs; if ($lapMs -le 0) { $lapMs = [int]$script:Tel.LastTimeMs }
    if ($lapMs -le 0) { return -1 }
    $left = [math]::Ceiling($tl / $lapMs)
    if ($left -gt 500) { $left = -1 }   # nesmyslny odhad radeji zahodit
    return [int]$left
}
function Get-StintPlan([double]$fuel, [double]$fpl, [double]$maxFuel, [int]$lapsLeft) {
    # strukturovany plan stintu: Rows = radky tabulky (hodnoty k PRIMEMU zadani do pit menu hry),
    # Stops/Trunc/Rez = souhrn. Add = kolik litru PRIDAT pri zastavce (jak to chce ACC MFD).
    $rows = New-Object System.Collections.ArrayList
    $res = @{ Rows = $rows; Stops = 0; Trunc = $false; Rez = -1.0 }
    if ($fpl -le 0 -or $lapsLeft -lt 0) { return $res }
    if ($maxFuel -le 1) { $maxFuel = 65.0 }
    $margin = 1.03   # 3% rezerva na out-lap a boj
    $curLap = [int]$script:Tel.CompletedLaps + 1
    # odhad ojeti gum na kolo (ze zmerene historie) -> doporuceni vymeny pri zastavce
    $wearNow = -1.0; $wearRate = -1.0
    $twS = $script:Tel.TyreWear
    if ($twS -and $twS.Count -ge 4 -and [double]$twS[0] -gt 1) { $wearNow = [double](($twS | Measure-Object -Minimum).Minimum) }
    if ($script:WearHist -and $script:WearHist.Count -ge 3) {
        $w0 = $script:WearHist[[math]::Max(0, $script:WearHist.Count - 4)]; $w1 = $script:WearHist[$script:WearHist.Count - 1]
        $dl = [int]$w1[0] - [int]$w0[0]
        if ($dl -gt 0) { $wearRate = ([double]$w0[1] - [double]$w1[1]) / $dl }
    }
    $remaining = $lapsLeft; $f = $fuel; $stint = 1; $stops = 0; $wear = $wearNow
    while ($remaining -gt 0 -and $stint -le 8) {
        $lapsThis = [math]::Floor($f / ($fpl * $margin))
        if ($lapsThis -ge $remaining) {
            $res.Rez = ($f - $remaining * $fpl)
            [void]$rows.Add(@{ S = $stint; A = $curLap; B = ($curLap + $remaining - 1); Add = -1.0; Ty = ''; Fin = $true })
            $remaining = 0; break
        }
        if ($lapsThis -lt 1) { $lapsThis = 1 }
        $fuelAtBox = [math]::Max(0.0, $f - $lapsThis * $fpl)
        $need = [math]::Min($maxFuel, ($remaining - $lapsThis) * $fpl * $margin + 1.0)
        $add = [math]::Max(0.0, $need - $fuelAtBox)
        $ty = ''
        if ($wear -ge 0 -and $wearRate -gt 0) {
            $wearEnd = $wear - $wearRate * $lapsThis
            $ty = if ($wearEnd -lt 60) { 'NEW' } else { 'KEEP' }
            $wear = if ($ty -eq 'NEW') { 100.0 } else { $wearEnd }
        }
        [void]$rows.Add(@{ S = $stint; A = $curLap; B = ($curLap + $lapsThis - 1); Add = $add; Ty = $ty; Fin = $false })
        $curLap += $lapsThis; $remaining -= $lapsThis; $stops++
        $f = $need; $stint++
    }
    $res.Stops = $stops; $res.Trunc = ($remaining -gt 0)
    return $res
}
function Update-StintTable($plan) {
    # prekresli tabulku jen pri zmene (jinak by vyber/scroll poblikaval)
    $E = $script:UiEn
    $sig = ($plan.Rows | ForEach-Object { "{0}|{1}|{2}|{3:0.0}|{4}|{5}" -f $_.S, $_.A, $_.B, $_.Add, $_.Ty, $_.Fin }) -join ';'
    $sig += ('#' + $E)
    if ($script:StintSig -eq $sig) { return }
    $script:StintSig = $sig
    $lvStints.BeginUpdate()
    $lvStints.Items.Clear()
    foreach ($r in $plan.Rows) {
        $it = New-Object System.Windows.Forms.ListViewItem(("{0}" -f $r.S))
        [void]$it.SubItems.Add(("{0}-{1}" -f $r.A, $r.B))
        if ($r.Fin) {
            [void]$it.SubItems.Add('-'); [void]$it.SubItems.Add('-')
            [void]$it.SubItems.Add($(if ($E) { 'FINISH' } else { 'CIL' }))
            $it.ForeColor = $cAccent
        } else {
            [void]$it.SubItems.Add(("+{0:0.0} L" -f $r.Add))
            [void]$it.SubItems.Add($(if ($r.Ty -eq 'NEW') { if ($E) { 'CHANGE' } else { 'VYMENIT' } } elseif ($r.Ty -eq 'KEEP') { if ($E) { 'keep' } else { 'nechat' } } else { '?' }))
            [void]$it.SubItems.Add('BOX')
            if ($r.Ty -eq 'NEW') { $it.ForeColor = $cAmber }
        }
        [void]$lvStints.Items.Add($it)
    }
    $lvStints.EndUpdate()
}
function Update-Strategy {
    $fuel = [double]$script:Tel.Fuel; $maxFuel = [double]$script:Tel.MaxFuel; $fpl = Get-FuelPerLap
    $E = $script:UiEn
    $L = if ($E) { @{ fuel = 'Fuel:            '; perlap = 'Fuel / lap:      '; lasts = 'Lasts for:       '; left = 'Race remaining:  '; refuel = 'Refuel:          '; stops = 'Pit stops:       '; laps = 'laps'; dolap = '-- L (do a lap)'; unknown = '(unknown)'; makes = '0 L (you make it)' } }
        else { @{ fuel = 'Palivo:            '; perlap = 'Spotreba / kolo:   '; lasts = 'Vydrzi jeste:      '; left = 'Do konce zavodu:   '; refuel = 'Dotankovat:        '; stops = 'Zastavky v boxu:   '; laps = 'kol'; dolap = '-- L (ujed kolo)'; unknown = '(neznamo)'; makes = '0 L (dojedes)' } }
    $lblFuel.Text = ("{0}{1,5:0.0} L" -f $L.fuel, $fuel)
    if ($fpl -le 0) {
        $lblFuelLap.Text = ($L.perlap + $L.dolap); $lblFuelLast.Text = ($L.lasts + '-- ' + $L.laps); $lblRaceLeft.Text = ($L.left + '--'); $lblRefuel.Text = ($L.refuel + '--'); $lblStops.Text = ($L.stops + '--')
        $newTxt = if ($E) { "Finish one full lap - I'll measure fuel use`r`nand plan your stints automatically." } else { "Dojed prvni cele kolo - zmerim spotrebu`r`na naplanuju stinty automaticky." }
        if ($txtStints.Text -ne $newTxt) { $txtStints.Text = $newTxt }
        if ($lvStints.Items.Count -gt 0) { $lvStints.Items.Clear(); $script:StintSig = '' }
        return
    }
    $lblFuelLap.Text = ("{0}{1,4:0.0} L" -f $L.perlap, $fpl)
    $lapsOnFuel = [math]::Floor($fuel / $fpl); $lblFuelLast.Text = ("{0}{1} {2}" -f $L.lasts, $lapsOnFuel, $L.laps)
    $lapsLeft = Get-LapsLeft
    if ($lapsLeft -lt 0) {
        $lblRaceLeft.Text = ($L.left + $L.unknown); $lblRefuel.Text = ($L.refuel + '--'); $lblStops.Text = ($L.stops + '--')
        $newTxt = if ($E) { ("No session end set (practice?).`r`nFuel is good for {0} laps.`r`nStints get planned once a race runs`r`non laps or on time." -f $lapsOnFuel) }
            else { ("Konec sezeni neni dany (trenink?).`r`nPalivo staci na {0} kol.`r`nStinty naplanuju, jakmile pojede zavod`r`nna kola nebo na cas." -f $lapsOnFuel) }
        if ($txtStints.Text -ne $newTxt) { $txtStints.Text = $newTxt }
        if ($lvStints.Items.Count -gt 0) { $lvStints.Items.Clear(); $script:StintSig = '' }
        return
    }
    $lblRaceLeft.Text = ("{0}{1} {2}" -f $L.left, $lapsLeft, $L.laps)
    $need = $lapsLeft * $fpl; $toAdd = [math]::Max(0.0, $need - $fuel)
    if ($toAdd -le 0.1) { $lblRefuel.Text = ($L.refuel + $L.makes); $lblRefuel.ForeColor = $cAccent; $lblStops.Text = ($L.stops + '0') }
    else { $lblRefuel.Text = ("{0}+{1:0.0} L" -f $L.refuel, $toAdd); $lblRefuel.ForeColor = $cAmber; $stops = if ($maxFuel -gt 1) { [math]::Ceiling($toAdd / $maxFuel) } else { 1 }; $lblStops.Text = ("{0}{1}" -f $L.stops, [int]$stops) }
    $plan = Get-StintPlan $fuel $fpl $maxFuel $lapsLeft
    Update-StintTable $plan
    # poznamky pod tabulkou: zastavky, rezerva v cili, box na povel
    $notes = @()
    $notes += ("{0} {1}" -f $(if ($E) { 'Total stops:' } else { 'Zastavky celkem:' }), [int]$plan.Stops)
    if ([double]$plan.Rez -ge 0) { $notes += ("{0} {1:0.0} L" -f $(if ($E) { 'Fuel margin at flag:' } else { 'Rezerva v cili:' }), [double]$plan.Rez) }
    if ($plan.Trunc) { $notes += $(if ($E) { '(...plan truncated, too many stops)' } else { '(...plan zkracen, moc zastavek)' }) }
    if ($plan.Rows.Count -gt 0 -and -not ($plan.Rows | Where-Object { $_.Ty })) { $notes += $(if ($E) { 'Tyres: measuring wear, advice after a few laps.' } else { 'Gumy: merim ojeti, doporuceni po par kolech.' }) }
    if ($script:PitPlan) { $notes += $(if ($E) { 'PIT ON REQUEST: planned (say "cancel the pit stop")' } else { 'BOX NA POVEL: naplanovany (rekni "zrus box")' }) }
    $newTxt = ($notes -join "`r`n")
    if ($txtStints.Text -ne $newTxt) { $txtStints.Text = $newTxt }
}
function Update-LapList {
    if ($script:LapList.Count -eq 0) { return }
    $lines = @(); $n = $script:LapList.Count; $best = ($script:LapList | Measure-Object -Minimum).Minimum; $start = [math]::Max(0, $n - 14)
    for ($i = $start; $i -lt $n; $i++) { $ms = [int]$script:LapList[$i]; $mark = if ($ms -eq $best) { " *" } else { "" }; $lines += (((Tr 'Kolo {0,2}   {1}{2}' 'Lap {0,2}    {1}{2}')) -f ($i+1), (Format-LapTime $ms), $mark) }
    $txtLaps.Text = ($lines -join "`r`n"); $txtLaps.SelectionStart = $txtLaps.Text.Length; $txtLaps.ScrollToCaret()
    $avg = [int](($script:LapList | Measure-Object -Average).Average)
    $lblSummary.Text = ("{0} {1}   {2} {3}" -f $(if ($script:UiEn) { 'Best' } else { 'Nejlepsi' }), (Format-LapTime $best), $(if ($script:UiEn) { 'Avg' } else { 'Prumer' }), (Format-LapTime $avg))
    if ($n -ge 2) { $mean = ($script:LapList | Measure-Object -Average).Average; $var = 0.0; foreach ($x in $script:LapList) { $var += [math]::Pow(($x-$mean),2) }; $sd = [math]::Sqrt($var/$n)/1000.0
        $lblConsist.Text = ("{0} +/- {1:0.00} s" -f $(if ($script:UiEn) { 'Consistency:' } else { 'Konzistence:' }), $sd); $lblConsist.ForeColor = if ($sd -lt 0.5) { $cAccent } elseif ($sd -lt 1.5) { $cAmber } else { $cRed } }
}

$script:RadioLogPath = Join-Path $script:DataDir 'radio.log'
function Add-Radio([string]$czText) {
    try { $txtRadio.AppendText(("[{0}] {1}`r`n" -f (Get-Date -Format "HH:mm:ss"), $czText)) } catch { }
    try { $txtRadioMini.AppendText(("{0}`r`n" -f $czText)); $txtRadioMini.SelectionStart = $txtRadioMini.Text.Length; $txtRadioMini.ScrollToCaret() } catch { }
    try { Add-Content -Path $script:RadioLogPath -Value ("[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $czText) -Encoding UTF8 } catch { }
}

# --- PIPER: prirozeny (neuralni) hlas - o tridu plynulejsi nez Windows TTS ---
function Find-Piper {
    foreach ($root in @((Join-Path (Get-AppRoot) 'piper'), (Join-Path $script:DataDir 'piper'))) {
        if (-not (Test-Path $root)) { continue }
        $exe = Get-ChildItem $root -Recurse -Filter 'piper.exe' -File -ErrorAction SilentlyContinue | Select-Object -First 1
        $model = Get-ChildItem $root -Recurse -Filter '*.onnx' -File -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($exe -and $model) { return @{ Exe = $exe.FullName; Model = $model.FullName } }
    }
    return $null
}
# vsechny stazene Piper hlasy (oba koreny), s jazykem a jmenem mluvciho z nazvu souboru
function Get-PiperVoices {
    $out = @(); $seen = @{}
    foreach ($root in @((Join-Path (Get-AppRoot) 'piper'), (Join-Path $script:DataDir 'piper'))) {
        if (-not (Test-Path $root)) { continue }
        foreach ($m in @(Get-ChildItem $root -Recurse -Filter '*.onnx' -File -ErrorAction SilentlyContinue)) {
            if ($seen[$m.BaseName]) { continue }; $seen[$m.BaseName] = $true
            $code = ''; $spk = $m.BaseName
            if ($m.BaseName -match '^([a-z]{2,3})_[A-Z]{2}-(.+?)-(x_low|low|medium|high)$') {
                $code = $Matches[1]
                $spk = $Matches[2].Substring(0,1).ToUpper() + $Matches[2].Substring(1)
            }
            $lbl = ''
            if ($code -and $script:LangNative[$code]) { $lbl = [string]$script:LangNative[$code] }
            elseif ($code) { $lbl = $code }
            else { $lbl = $m.BaseName }
            $out += @{ Base = $m.BaseName; Path = $m.FullName; Code = $code; Speaker = $spk; LangLabel = $lbl }
        }
    }
    $out
}
function Find-PiperModel([string]$base) {
    if (-not $base) { return $null }
    foreach ($root in @((Join-Path (Get-AppRoot) 'piper'), (Join-Path $script:DataDir 'piper'))) {
        if (-not (Test-Path $root)) { continue }
        $m = Get-ChildItem $root -Recurse -Filter ($base + '.onnx') -File -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($m) { return $m.FullName }
    }
    return $null
}
# najdi stazeny Piper model pro jazyk (napr. 'cs' -> cs_CZ-jirka-medium.onnx)
function Find-PiperLang([string]$lang) {
    if (-not $lang) { return $null }
    foreach ($root in @((Join-Path (Get-AppRoot) 'piper'), (Join-Path $script:DataDir 'piper'))) {
        if (-not (Test-Path $root)) { continue }
        $m = Get-ChildItem $root -Recurse -Filter ($lang + '_*.onnx') -File -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($m) { return $m.FullName }
    }
    return $null
}
function Get-PiperLabel([string]$modelPath) {
    $bn = ''
    try { $bn = [System.IO.Path]::GetFileNameWithoutExtension($modelPath) } catch { }
    if ($bn -match '^([a-z]{2,3})_[A-Z]{2}-(.+?)-(x_low|low|medium|high)$') {
        $l = if ($script:LangNative[$Matches[1]]) { [string]$script:LangNative[$Matches[1]] } else { $Matches[1] }
        return ('{0} ({1})' -f $l, ($Matches[2].Substring(0,1).ToUpper() + $Matches[2].Substring(1)))
    }
    return $bn
}
$script:Piper = $null
$script:UsePiper = $false
$script:SpeakQ = [System.Collections.Queue]::Synchronized((New-Object System.Collections.Queue))
$script:SpeakRun = [hashtable]::Synchronized(@{ On = $false; Fails = 0 })
$script:PiperFailNoted = $false
$script:SpeakPS = $null; $script:SpeakRS = $null
# CLOUD neuralni hlas (prirozeny, jako ChatGPT) - sdileno se speak-workerem, aktualizuje se ze Settings
$script:CloudTts = [hashtable]::Synchronized(@{ Engine = 'off'; Key = ''; Voice = ''; Model = ''; Key2 = '' })
function Sync-CloudTts {
    $script:CloudTts.Engine = [string]$script:Settings.CloudEngine
    $script:CloudTts.Key = [string]$script:Settings.CloudKey
    $script:CloudTts.Voice = [string]$script:Settings.CloudVoice
    $script:CloudTts.Model = [string]$script:Settings.CloudModel
    $script:CloudTts.Key2 = [string]$script:Settings.CloudKey2   # zalozni klic pro druheho provozovatele (OpenAI kdyz ElevenLabs selze)
}
function Cloud-On { return ([string]$script:Settings.CloudEngine -and [string]$script:Settings.CloudEngine -ne 'off' -and [string]$script:Settings.CloudKey) }
$script:SpeakWorker = {
    param($q, $run, $exe, $model, $tmpDir, $lenScale, $cloud)
    $beep = Join-Path $tmpDir 'radio-beep.wav'
    # zalozni Windows hlas: kdyz Piper selze, hlaska stejne zazni - Jerry uz nikdy nemlci
    $sapi = $null
    try {
        Add-Type -AssemblyName System.Speech -ErrorAction Stop
        $sapi = New-Object System.Speech.Synthesis.SpeechSynthesizer; $sapi.Rate = 1; $sapi.Volume = 100
        $cz = $sapi.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.Name -like 'cs*' } | Select-Object -First 1
        if ($cz) { $sapi.SelectVoice($cz.VoiceInfo.Name) }
    } catch { $sapi = $null }
    $defSapiVoice = ''; if ($sapi) { try { $defSapiVoice = $sapi.Voice.Name } catch { } }
    # uklid cache hlasek + logu (jednou pri startu smycky)
    try {
        $vc0 = Join-Path $tmpDir 'voicecache'
        if (Test-Path $vc0) { $fs0 = @(Get-ChildItem $vc0 -File | Sort-Object LastWriteTime); if ($fs0.Count -gt 500) { $fs0 | Select-Object -First ($fs0.Count - 400) | Remove-Item -Force -ErrorAction SilentlyContinue } }
        $cl0 = Join-Path $tmpDir 'cloud.log'
        if ((Test-Path $cl0) -and ((Get-Item $cl0).Length -gt 262144)) { Remove-Item $cl0 -Force -ErrorAction SilentlyContinue }
    } catch { }
    # --- CLOUD NEURAL TTS (prirozeny hlas jako ChatGPT): ElevenLabs / OpenAI -> WAV bajty -> prehrat ---
    $getCloudWav = {
        param($cl, $text, $dir, $lang)
        $eng = ''
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $wav = Join-Path $dir 'cloud-say.wav'
            if (Test-Path $wav) { Remove-Item $wav -Force -ErrorAction SilentlyContinue }
            $eng = [string]$cl.Engine
            if ($eng -eq 'openai') {
                $mdl = if ($cl.Model) { [string]$cl.Model } else { 'gpt-4o-mini-tts' }
                $voc = if ($cl.Voice) { [string]$cl.Voice } else { 'onyx' }
                $body = @{ model = $mdl; input = $text; voice = $voc; response_format = 'wav'; instructions = 'Speak like an energetic, dramatic race engineer on team radio: confident, punchy, high-energy.' } | ConvertTo-Json
                $req = [System.Net.HttpWebRequest]::Create('https://api.openai.com/v1/audio/speech')
                $req.Method = 'POST'; $req.ContentType = 'application/json'; $req.Timeout = 15000
                $req.Headers.Add('Authorization', 'Bearer ' + [string]$cl.Key)
                $bb = [System.Text.Encoding]::UTF8.GetBytes($body)
                $rs = $req.GetRequestStream(); $rs.Write($bb, 0, $bb.Length); $rs.Close()
                $resp = $req.GetResponse(); $ins = $resp.GetResponseStream()
                $fs = [System.IO.File]::Create($wav); $ins.CopyTo($fs); $fs.Close(); $resp.Close()
                return $wav
            }
            elseif ($eng -eq 'eleven') {
                $vid = if ($cl.Voice) { [string]$cl.Voice } else { 'onwK4e9ZLuTAKqWW03F9' }   # vychozi multilingvni muzsky hlas
                $mdl = if ($cl.Model) { [string]$cl.Model } else { 'eleven_multilingual_v2' }
                # kratke ceske/jine hlasky: multilingual_v2 hada jazyk z textu a obcas je precte s anglickym
                # prizvukem -> turbo v2.5 umi language_code = jazyk vynuceny najisto (a je levnejsi/rychlejsi)
                $lc25 = @('cs','sk','pl','de','es','fr','it','pt','nl','hu','tr','sv','da','no','fi','ro','ru','uk','el','hr','vi','zh','ar')
                $bodyH = @{ text = $text; model_id = $mdl; voice_settings = @{ stability = 0.28; similarity_boost = 0.8; style = 0.65; use_speaker_boost = $true } }
                if (-not [string]$cl.Model -and $lang -and $lang -ne 'en' -and ($lc25 -contains $lang)) {
                    $bodyH.model_id = 'eleven_turbo_v2_5'; $bodyH.language_code = $lang
                }
                $body = $bodyH | ConvertTo-Json -Depth 5
                $url = 'https://api.elevenlabs.io/v1/text-to-speech/' + $vid + '?output_format=pcm_22050'
                $req = [System.Net.HttpWebRequest]::Create($url)
                $req.Method = 'POST'; $req.ContentType = 'application/json'; $req.Timeout = 15000
                $req.Headers.Add('xi-api-key', [string]$cl.Key)
                $bb = [System.Text.Encoding]::UTF8.GetBytes($body)
                $rs = $req.GetRequestStream(); $rs.Write($bb, 0, $bb.Length); $rs.Close()
                $resp = $req.GetResponse(); $ins = $resp.GetResponseStream()
                $ms = New-Object System.IO.MemoryStream; $ins.CopyTo($ms); $resp.Close()
                $pcm = $ms.ToArray(); $ms.Dispose()
                if ($pcm.Length -lt 2000) { return $null }
                # syrove PCM 22050 mono 16-bit -> obal do WAV hlavicky
                $rate = 22050; $mo = New-Object System.IO.MemoryStream; $bw = New-Object System.IO.BinaryWriter($mo)
                $bw.Write([System.Text.Encoding]::ASCII.GetBytes('RIFF')); $bw.Write([int](36 + $pcm.Length))
                $bw.Write([System.Text.Encoding]::ASCII.GetBytes('WAVEfmt ')); $bw.Write([int]16)
                $bw.Write([int16]1); $bw.Write([int16]1); $bw.Write([int]$rate); $bw.Write([int]($rate * 2)); $bw.Write([int16]2); $bw.Write([int16]16)
                $bw.Write([System.Text.Encoding]::ASCII.GetBytes('data')); $bw.Write([int]$pcm.Length); $bw.Write($pcm)
                [System.IO.File]::WriteAllBytes($wav, $mo.ToArray()); $bw.Dispose(); $mo.Dispose()
                return $wav
            }
        } catch {
            # duvod selhani do cloud.log - "nespolehlivy klic" byl dosud neviditelny (tichy fallback na offline hlas)
            try {
                $ex2 = $_.Exception
                if ($ex2 -isnot [System.Net.WebException] -and $ex2.InnerException) { $ex2 = $ex2.InnerException }   # PS bali WebException
                $m = $ex2.Message
                if ($ex2 -is [System.Net.WebException] -and $ex2.Response) {
                    try {
                        $m = ('HTTP ' + [int]$ex2.Response.StatusCode + ' | ' + $m)
                        $sr = New-Object System.IO.StreamReader($ex2.Response.GetResponseStream()); $m = $m + ' | ' + $sr.ReadToEnd(); $sr.Close()
                    } catch { }
                }
                Add-Content -Path (Join-Path $dir 'cloud.log') -Value ("[{0:yyyy-MM-dd HH:mm:ss}] {1} FAIL: {2}" -f [DateTime]::Now, $eng, $m) -Encoding UTF8
            } catch { }
            return $null
        }
        return $null
    }
    while ($run.On) {
        try {
            if ($q.Count -gt 0) {
                $item = $q.Dequeue()
                # polozka fronty: hashtable @{Text; Piper=<model pro jazyk textu>; Sapi=<SAPI hlas>} nebo cisty text
                $text = ''; $itemModel = $model; $itemSapi = ''
                if ($item -is [hashtable]) {
                    $text = [string]$item.Text
                    if ($item.Piper) { $itemModel = [string]$item.Piper } elseif ($item.Sapi) { $itemModel = '' ; $itemSapi = [string]$item.Sapi }
                } else { $text = [string]$item }
                if ($text) {
                    $playedAny = $false
                    # 1) CLOUD neuralni hlas (kdyz je zapnuty a mame klic) - prirozeny, jako ChatGPT
                    #    Poradi pokusu: primarni provozovatel -> zalozni druhy provozovatel (kdyz ma klic) -> teprve pak offline.
                    #    "Kdyby ElevenLabs neslo, zkus OpenAI." Jerry nikdy nemlci.
                    if ($cloud -and [string]$cloud.Engine -and [string]$cloud.Engine -ne 'off' -and [string]$cloud.Key) {
                        $attempts = @( @{ Engine = [string]$cloud.Engine; Key = [string]$cloud.Key; Voice = [string]$cloud.Voice; Model = [string]$cloud.Model } )
                        if ([string]$cloud.Key2) {
                            $fbEng = if ([string]$cloud.Engine -eq 'openai') { 'eleven' } else { 'openai' }
                            $attempts += @{ Engine = $fbEng; Key = [string]$cloud.Key2; Voice = ''; Model = '' }   # zaloha = vychozi hlas druheho provozovatele
                        }
                        # jazyk hlasky (z fronty) - pro language_code i klic cache
                        $itemLang = ''; if ($item -is [hashtable] -and $item.Lang) { $itemLang = [string]$item.Lang }
                        # CACHE: opakovane hlasky se do API neposilaji znovu = okamzita odezva, setri kvotu,
                        # a mluvi i pri vypadku site/kvoty ("nespolehlivy klic"). Jen kratke texty (pevne hlasky).
                        $cacheFile = $null
                        if ($text.Length -le 220) {
                            try {
                                $cacheDir = Join-Path $tmpDir 'voicecache'
                                if (-not (Test-Path $cacheDir)) { New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null }
                                $md5 = [System.Security.Cryptography.MD5]::Create()
                                $keyStr = ([string]$cloud.Engine + '|' + [string]$cloud.Voice + '|' + [string]$cloud.Model + '|' + $itemLang + '|' + $text)
                                $hash = ($md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($keyStr)) | ForEach-Object { $_.ToString('x2') }) -join ''
                                $cacheFile = Join-Path $cacheDir ($hash + '.wav')
                            } catch { $cacheFile = $null }
                        }
                        if ($cacheFile -and (Test-Path $cacheFile) -and ((Get-Item $cacheFile).Length -gt 1200)) {
                            try {
                                if (Test-Path $beep) { try { $bp = New-Object System.Media.SoundPlayer($beep); $bp.PlaySync(); $bp.Dispose() } catch { } }
                                $player = New-Object System.Media.SoundPlayer($cacheFile); $player.PlaySync(); $player.Dispose()
                                $playedAny = $true
                            } catch { }
                        }
                        if (-not $playedAny) {
                            foreach ($att in $attempts) {
                                $cw = $null
                                for ($rt = 1; $rt -le 2 -and -not $cw; $rt++) {   # 2 pokusy - 429/vypadek site byva chvilkovy
                                    try { $cw = & $getCloudWav $att $text $tmpDir $itemLang } catch { $cw = $null }
                                    if ((-not $cw) -and $rt -lt 2) { Start-Sleep -Milliseconds 400 }
                                }
                                if ($cw -and (Test-Path $cw) -and ((Get-Item $cw).Length -gt 1200)) {
                                    if ($cacheFile -and ([string]$att.Engine -eq [string]$cloud.Engine)) { try { Copy-Item $cw $cacheFile -Force } catch { } }
                                    if (Test-Path $beep) { try { $bp = New-Object System.Media.SoundPlayer($beep); $bp.PlaySync(); $bp.Dispose() } catch { } }
                                    $player = New-Object System.Media.SoundPlayer($cw); $player.PlaySync(); $player.Dispose()
                                    $playedAny = $true; break
                                }   # tento provozovatel selhal -> zkus dalsi, jinak offline hlas nize
                            }
                        }
                    }
                    if (-not $playedAny -and $itemModel) {
                        # Piper pri vice vetach na jednom radku prepisuje vystupni soubor vetu po vete
                        # a zbyde jen posledni utrzek (~0.5 s "sum") -> vety renderujeme JEDNOTLIVE.
                        $sentences = @([regex]::Split($text, '(?<=[\.\!\?])\s+') | Where-Object { $_.Trim() })
                        if ($sentences.Count -eq 0) { $sentences = @($text) }
                        $first = $true
                        foreach ($sent in $sentences) {
                            if (-not $run.On) { break }
                            try {
                                $wav = Join-Path $tmpDir 'piper-say.wav'
                                if (Test-Path $wav) { Remove-Item $wav -Force -ErrorAction SilentlyContinue }
                                $psi = New-Object System.Diagnostics.ProcessStartInfo
                                $psi.FileName = $exe
                                # noise_scale/noise_w = zivost prozodie; nizsi hodnoty znely plose jako robot,
                                # 0.667/0.8 jsou prirozene vychozi hodnoty modelu
                                $psi.Arguments = ('-m "{0}" -f "{1}" --length_scale {2} --noise_scale 0.667 --noise_w 0.8' -f $itemModel, $wav, $lenScale)
                                # stdout/stderr NEpresmerovavat! Piper do nich loguje, a kdyz je nikdo
                                # necte, plna roura proces navzdy zablokuje = uplne ticho.
                                $psi.RedirectStandardInput = $true
                                $psi.UseShellExecute = $false; $psi.CreateNoWindow = $true
                                $proc = [System.Diagnostics.Process]::Start($psi)
                                $bytes = [System.Text.Encoding]::UTF8.GetBytes($sent.Trim() + "`n")
                                $proc.StandardInput.BaseStream.Write($bytes, 0, $bytes.Length)
                                $proc.StandardInput.BaseStream.Flush(); $proc.StandardInput.Close()
                                if (-not $proc.WaitForExit(20000)) { try { $proc.Kill() } catch { } }
                                if ((Test-Path $wav) -and ((Get-Item $wav).Length -gt 1000)) {
                                    # kratky radiovy "beep" jen pred prvni vetou hlasky
                                    if ($first -and (Test-Path $beep)) { try { $bp = New-Object System.Media.SoundPlayer($beep); $bp.PlaySync(); $bp.Dispose() } catch { } }
                                    $player = New-Object System.Media.SoundPlayer($wav)
                                    $player.PlaySync(); $player.Dispose()
                                    $playedAny = $true; $first = $false
                                    Start-Sleep -Milliseconds 140   # kratky nadech mezi vetami - prirozenejsi rytmus
                                }
                            } catch { }
                        }
                    }
                    # SAPI cesta: bud cileny hlas pro jazyk textu (napr. anglicka Zira), nebo zaloha pri selhani Piperu
                    if (-not $playedAny) {
                        if (-not $itemSapi) { $run.Fails = [int]$run.Fails + 1 }
                        if ($sapi) {
                            try {
                                if ($itemSapi) { $sapi.SelectVoice($itemSapi) } elseif ($defSapiVoice) { $sapi.SelectVoice($defSapiVoice) }
                            } catch { }
                            try { $sapi.Speak($text) } catch { }
                        }
                    }
                }
            } else { Start-Sleep -Milliseconds 100 }
        } catch { Start-Sleep -Milliseconds 200 }
    }
    try { if ($sapi) { $sapi.Dispose() } } catch { }
}
function New-RadioBeep {
    # vygeneruje kratky 880 Hz "squelch" beep (90 ms, 16 kHz mono WAV) - jednou, pak se jen prehrava
    try {
        $f = Join-Path $script:DataDir 'radio-beep.wav'
        if (Test-Path $f) { return }
        $rate = 16000; $ms = 90; $n = [int]($rate * $ms / 1000)
        $data = New-Object byte[] ($n * 2)
        for ($i = 0; $i -lt $n; $i++) {
            $env2 = [math]::Sin([math]::PI * $i / $n)             # fade in/out, zadne lupnuti
            $v = [int](4500 * $env2 * [math]::Sin(2 * [math]::PI * 880 * $i / $rate))
            $b = [BitConverter]::GetBytes([int16]$v); $data[2*$i] = $b[0]; $data[2*$i+1] = $b[1]
        }
        $msOut = New-Object System.IO.MemoryStream
        $bw = New-Object System.IO.BinaryWriter($msOut)
        $bw.Write([System.Text.Encoding]::ASCII.GetBytes('RIFF')); $bw.Write([int](36 + $data.Length))
        $bw.Write([System.Text.Encoding]::ASCII.GetBytes('WAVEfmt ')); $bw.Write([int]16)
        $bw.Write([int16]1); $bw.Write([int16]1); $bw.Write([int]$rate); $bw.Write([int]($rate*2)); $bw.Write([int16]2); $bw.Write([int16]16)
        $bw.Write([System.Text.Encoding]::ASCII.GetBytes('data')); $bw.Write([int]$data.Length); $bw.Write($data)
        [System.IO.File]::WriteAllBytes($f, $msOut.ToArray()); $bw.Dispose(); $msOut.Dispose()
    } catch { }
}
function Start-PiperLoop {
    if ($script:SpeakRun.On) { return }
    # smycka bezi, kdyz je Piper NEBO cloud hlas (jeden centralni prehravac reci)
    if (-not $script:Piper -and -not (Cloud-On)) { return }
    New-RadioBeep
    $ls = [math]::Round(1.0 - 0.05 * [int]$script:Settings.Rate, 2)
    if ($ls -lt 0.7) { $ls = 0.7 }; if ($ls -gt 1.4) { $ls = 1.4 }
    # KRITICKE: invariantni format! Ceska locale by dala "0,95" -> piper precte 0 -> 0.2 s "sum" misto reci
    $ls = $ls.ToString('0.0#', [System.Globalization.CultureInfo]::InvariantCulture)
    Sync-CloudTts
    $pExe = if ($script:Piper) { $script:Piper.Exe } else { '' }
    $pModel = if ($script:Piper) { $script:Piper.Model } else { '' }
    $script:SpeakRun.On = $true
    $script:SpeakRS = [runspacefactory]::CreateRunspace(); $script:SpeakRS.Open()
    $script:SpeakPS = [powershell]::Create(); $script:SpeakPS.Runspace = $script:SpeakRS
    [void]$script:SpeakPS.AddScript($script:SpeakWorker).AddArgument($script:SpeakQ).AddArgument($script:SpeakRun).AddArgument($pExe).AddArgument($pModel).AddArgument($script:DataDir).AddArgument($ls).AddArgument($script:CloudTts)
    [void]$script:SpeakPS.BeginInvoke()
}
function Stop-PiperLoop {
    $script:SpeakRun.On = $false
    try { if ($script:SpeakPS) { $script:SpeakPS.Dispose() }; if ($script:SpeakRS) { $script:SpeakRS.Close(); $script:SpeakRS.Dispose() } } catch { }
}
# --- Automaticka detekce jazyka textu (pismo + diakritika + stopwords) ---
function Detect-Lang([string]$t) {
    if (-not $t) { return '' }
    if ($t -match '[一-鿿]') { return 'zh' }
    if ($t -match '[پچژگ]') { return 'fa' }
    if ($t -match '[؀-ۿ]') { return 'ar' }
    if ($t -match '[Ͱ-Ͽ]') { return 'el' }
    if ($t -match '[Ѐ-ӿ]') { if ($t -match '[іїєґ]') { return 'uk' } return 'ru' }
    if ($t -match '[Ạ-ỹ]') { return 'vi' }
    $tl = ' ' + $t.ToLower() + ' '
    if ($tl -match '[ěřů]') { return 'cs' }
    if ($tl -match '[ľĺŕô]') { return 'sk' }
    if ($tl -match '[ąęłńśź]') { return 'pl' }
    $sets = @{
        cs = @(' je ',' se ',' na ',' mám ',' kolik ',' paliva ',' kol ',' gumy ',' zbývá ',' do ',' boxu ')
        en = @(' the ',' is ',' you ',' and ',' how ',' many ',' much ',' fuel ',' laps ',' what ',' tyres ',' pit ',' here ',' have ',' race ',' lap ',' your ',' box ')
        de = @(' der ',' die ',' das ',' und ',' ist ',' wie ',' viel ',' ich ',' runden ',' reifen ')
        es = @(' el ',' la ',' que ',' cuánto ',' cuanto ',' vueltas ',' combustible ',' es ')
        fr = @(' le ',' la ',' est ',' combien ',' tours ',' carburant ',' pneus ',' que ')
        it = @(' il ',' la ',' che ',' quanto ',' giri ',' carburante ',' gomme ')
        sk = @(' som ',' ako ',' koľko ',' kolko ',' paliva ',' kôl ')
    }
    $best = ''; $bestN = 0
    foreach ($k in @($sets.Keys)) {
        $n = 0; foreach ($w in $sets[$k]) { if ($tl.Contains($w)) { $n++ } }
        if ($n -gt $bestN) { $bestN = $n; $best = $k }
    }
    if ($bestN -ge 2) { return $best }
    if ($tl -match '[áéíýčšžťďň]') { return 'cs' }
    if ($bestN -ge 1) { return $best }
    return ''
}
# --- Najdi nejlepsi dostupny hlas pro jazyk: Piper model > SAPI hlas > nic (vychozi) ---
function Resolve-VoiceFor([string]$lang) {
    if (-not $lang) { return $null }
    # hlas vybrany uzivatelem ma prednost, pokud umi jazyk textu
    if ($script:UsePiper -and $script:Piper) {
        try { $bnSel = [System.IO.Path]::GetFileName([string]$script:Piper.Model); if ($bnSel -like ($lang + '_*')) { return @{ Piper = [string]$script:Piper.Model; Sapi = '' } } } catch { }
    }
    try {
        foreach ($root in @((Join-Path (Get-AppRoot) 'piper'), (Join-Path $script:DataDir 'piper'))) {
            if (-not (Test-Path $root)) { continue }
            $m = Get-ChildItem $root -Recurse -Filter ($lang + '_*.onnx') -File -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($m) { return @{ Piper = $m.FullName; Sapi = '' } }
        }
    } catch { }
    if ($script:Tts) {
        try {
            $v = $script:Tts.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.TwoLetterISOLanguageName -eq $lang } | Select-Object -First 1
            if ($v) { return @{ Piper = ''; Sapi = $v.VoiceInfo.Name } }
        } catch { }
    }
    return $null
}
# --- Prirozena rec: pryc s emoji, zkratky jednotek na cela slova (inzenyr necte "l", ale "litru") ---
# slova jednotek per jazyk (plural/genitiv-neutralni tvar - pro TTS staci srozumitelnost)
$script:UnitWords = @{
    cs = @{ kmh = 'kilometru za hodinu'; mph = 'mil za hodinu'; ms = 'metru za sekundu'; pct = 'procent'; L = 'litru'; sec = 'sekund'; deg = 'stupnu'; psi = 'psí'; bar = 'baru'; kg = 'kilogramu' }
    en = @{ kmh = 'kilometers per hour'; mph = 'miles per hour'; ms = 'meters per second'; pct = 'percent'; L = 'liters'; sec = 'seconds'; deg = 'degrees'; psi = 'p s i'; bar = 'bar'; kg = 'kilograms' }
    de = @{ kmh = 'Kilometer pro Stunde'; mph = 'Meilen pro Stunde'; ms = 'Meter pro Sekunde'; pct = 'Prozent'; L = 'Liter'; sec = 'Sekunden'; deg = 'Grad'; psi = 'p s i'; bar = 'bar'; kg = 'Kilogramm' }
    es = @{ kmh = 'kilometros por hora'; mph = 'millas por hora'; ms = 'metros por segundo'; pct = 'por ciento'; L = 'litros'; sec = 'segundos'; deg = 'grados'; psi = 'p s i'; bar = 'bar'; kg = 'kilogramos' }
    fr = @{ kmh = 'kilometres par heure'; mph = 'miles par heure'; ms = 'metres par seconde'; pct = 'pour cent'; L = 'litres'; sec = 'secondes'; deg = 'degres'; psi = 'p s i'; bar = 'bar'; kg = 'kilogrammes' }
    it = @{ kmh = 'chilometri orari'; mph = 'miglia orarie'; ms = 'metri al secondo'; pct = 'per cento'; L = 'litri'; sec = 'secondi'; deg = 'gradi'; psi = 'p s i'; bar = 'bar'; kg = 'chilogrammi' }
    pl = @{ kmh = 'kilometrow na godzine'; mph = 'mil na godzine'; ms = 'metrow na sekunde'; pct = 'procent'; L = 'litrow'; sec = 'sekund'; deg = 'stopni'; psi = 'p s i'; bar = 'bar'; kg = 'kilogramow' }
    sk = @{ kmh = 'kilometrov za hodinu'; mph = 'mil za hodinu'; ms = 'metrov za sekundu'; pct = 'percent'; L = 'litrov'; sec = 'sekund'; deg = 'stupnov'; psi = 'psí'; bar = 'barov'; kg = 'kilogramov' }
}
function Expand-ForSpeech([string]$text, [string]$lang) {
    if (-not $text) { return $text }
    $t = $text
    # 1) pryc s emoji a piktogramy (TTS je cte divne / delaji pauzy)
    $t = [System.Text.RegularExpressions.Regex]::Replace($t, '[\uD800-\uDBFF][\uDC00-\uDFFF]', ' ')   # surrogate pary (vetsina emoji)
    $t = [System.Text.RegularExpressions.Regex]::Replace($t, '[←-⇿⌀-➿⬀-⯿️⃣☀-⛿]', ' ')  # sipky, symboly, dingbaty
    # 2) jednotky -> cela slova (jen kdyz jsou to opravdu jednotky, tj. u cisla nebo samostatne)
    $u = $script:UnitWords[$lang]; if (-not $u) { $u = $script:UnitWords['en'] }
    $t = [regex]::Replace($t, '(?i)\bkm\s*/\s*h(od)?\b', (' ' + $u.kmh + ' '))
    $t = [regex]::Replace($t, '(?i)\bmph\b', (' ' + $u.mph + ' '))
    $t = [regex]::Replace($t, '(?i)\bm\s*/\s*s\b', (' ' + $u.ms + ' '))
    $t = [regex]::Replace($t, '(?<=\d)\s*%', (' ' + $u.pct))
    $t = [regex]::Replace($t, '(?<=\d)\s*°\s*C\b', (' ' + $u.deg))
    $t = [regex]::Replace($t, '(?<=\d)\s*[Ll]\b', (' ' + $u.L))      # 18 L / 18l -> litru
    $t = [regex]::Replace($t, '(?<=\d)\s*psi\b', (' ' + $u.psi))
    $t = [regex]::Replace($t, '(?<=\d)\s*bar\b', (' ' + $u.bar))
    $t = [regex]::Replace($t, '(?<=\d)\s*kg\b', (' ' + $u.kg))
    $t = [regex]::Replace($t, '(?<=\d)\s*s\b', (' ' + $u.sec))       # 0.5 s / 1.3s -> sekund
    # 3) srovnat vicenasobne mezery
    $t = [regex]::Replace($t, '\s{2,}', ' ').Trim()
    return $t
}
# Centralni mluveni: hlas se AUTOMATICKY prepne podle jazyka textu (Jerry necte anglictinu cesky);
# Piper (kdyz je) > Windows TTS; urgent = zahodit cekajici hlasky; langHint = jazyk znamy predem
function Speak-Raw([string]$text, [bool]$urgent = $false, [string]$langHint = '') {
    if (-not $text) { return }
    $lng = if ($langHint) { $langHint } else { Detect-Lang $text }
    $text = Expand-ForSpeech $text $lng    # emoji pryc + jednotky jako slova (jen pro rec, log zustava hezky)
    $route = Resolve-VoiceFor $lng
    # CLOUD hlas (jako ChatGPT) NEBO Piper -> centralni prehravaci smycka; cloud si text nasyntetizuje sam
    if (($script:UsePiper -and $script:Piper -and $script:SpeakRun.On) -or ((Cloud-On) -and $script:SpeakRun.On)) {
        $item = @{ Text = $text; Piper = ''; Sapi = ''; Lang = $lng }
        if ($script:Piper) { $item.Piper = $script:Piper.Model }
        if ($route) { $item.Piper = [string]$route.Piper; $item.Sapi = [string]$route.Sapi }
        try { if ($urgent) { $script:SpeakQ.Clear() }; $script:SpeakQ.Enqueue($item) } catch { }
        return
    }
    if (-not $script:Tts) { return }
    try {
        # nalada -> jemny posun tempa reci (jen SAPI hlas; Piper ma pevny length_scale)
        try { $b = [int]$script:Settings.Rate; $mo = [int][math]::Round([double]$script:Eng.Mood * 2); $script:Tts.Rate = [math]::Max(-10, [math]::Min(10, $b + $mo)) } catch { }
        if ($route -and $route.Sapi) { try { $script:Tts.SelectVoice($route.Sapi) } catch { } }
        if ($urgent) { $script:Tts.SpeakAsyncCancelAll() }
        $script:Tts.SpeakAsync($text) | Out-Null
    } catch { }
}

# --- Jazyky inzenyra: hlasky v 7 jazycich (bez diakritiky kvuli kodovani - TTS je precte srozumitelne) ---
$script:LangNames = @{ cs = 'Czech'; en = 'English'; de = 'German'; es = 'Spanish'; fr = 'French'; it = 'Italian'; pl = 'Polish'; sk = 'Slovak'; pt = 'Portuguese'; nl = 'Dutch'; hu = 'Hungarian'; tr = 'Turkish'; sv = 'Swedish'; da = 'Danish'; no = 'Norwegian'; fi = 'Finnish'; ro = 'Romanian'; ru = 'Russian'; uk = 'Ukrainian'; el = 'Greek'; sr = 'Serbian'; hr = 'Croatian'; sl = 'Slovenian'; ca = 'Catalan'; is = 'Icelandic'; vi = 'Vietnamese'; zh = 'Chinese'; ar = 'Arabic'; fa = 'Persian' }
$script:Lang = @{
    en = @{ radiocheck = 'Radio check. {0} here, let''s have a clean race.'; purple = 'Purple lap! That''s your fastest, great job.'; off = 'Last lap {0}, that''s {1} off your best.'; fuelwarn = 'Fuel warning. You''re short by about {0} laps, save fuel or we box.'; fuelcrit = 'Fuel critical. Box this lap, box box.'; lastlap = 'Last lap. Bring it home.'; togo = '{0} laps to go.'; tyres = 'Tyres are overheating, ease into the corners.'; pb = 'New personal best, {0}!'; test = 'Radio check. {0} here. All systems green, let''s go racing.' }
    cs = @{ radiocheck = 'Radio check. {0} na příjmu, jedeme.'; purple = 'Nejrychlejší kolo! Skvělá práce.'; off = 'Poslední kolo {0}, o {1} pomalejší než tvoje nejlepší.'; fuelwarn = 'Pozor palivo, chybí zhruba {0} kol. Šetři, nebo do boxu.'; fuelcrit = 'Palivo dochází. Do boxu, hned toto kolo!'; lastlap = 'Poslední kolo. Dovez to domů.'; togo = 'Zbývají {0} kola do konce.'; tyres = 'Gumy se přehřívají, uber v zatáčkách.'; pb = 'Nový osobní rekord, {0}!'; test = 'Radio check. {0} na příjmu. Všechno zelené, jedeme závodit.' }
    de = @{ radiocheck = 'Funkcheck. {0} hier, fahren wir ein sauberes Rennen.'; purple = 'Schnellste Runde! Starke Leistung.'; off = 'Letzte Runde {0}, das ist {1} langsamer als deine beste.'; fuelwarn = 'Achtung Sprit, es fehlen etwa {0} Runden. Sparen oder Boxenstopp.'; fuelcrit = 'Sprit kritisch. Box diese Runde, Box Box.'; lastlap = 'Letzte Runde. Bring es nach Hause.'; togo = 'Noch {0} Runden.'; tyres = 'Reifen ueberhitzen, ruhiger durch die Kurven.'; pb = 'Neuer persoenlicher Rekord, {0}!'; test = 'Funkcheck. {0} hier. Alles gruen, los geht es.' }
    es = @{ radiocheck = 'Radio check. Aqui {0}, hagamos una carrera limpia.'; purple = 'Vuelta rapida! Es tu mejor tiempo.'; off = 'Ultima vuelta {0}, {1} mas lento que tu mejor.'; fuelwarn = 'Atencion combustible, faltan unas {0} vueltas. Ahorra o entramos a boxes.'; fuelcrit = 'Combustible critico. Box esta vuelta, box box.'; lastlap = 'Ultima vuelta. Traela a casa.'; togo = 'Quedan {0} vueltas.'; tyres = 'Los neumaticos se sobrecalientan, suaviza las curvas.'; pb = 'Nuevo record personal, {0}!'; test = 'Radio check. Aqui {0}. Todo verde, vamos a correr.' }
    fr = @{ radiocheck = 'Radio check. Ici {0}, faisons une course propre.'; purple = 'Meilleur tour! Excellent travail.'; off = 'Dernier tour {0}, {1} plus lent que ton meilleur.'; fuelwarn = 'Attention carburant, il manque environ {0} tours. Economise ou on rentre au stand.'; fuelcrit = 'Carburant critique. Stand ce tour, box box.'; lastlap = 'Dernier tour. Ramene-la a la maison.'; togo = 'Encore {0} tours.'; tyres = 'Les pneus surchauffent, doucement dans les virages.'; pb = 'Nouveau record personnel, {0}!'; test = 'Radio check. Ici {0}. Tout est vert, on y va.' }
    it = @{ radiocheck = 'Radio check. Qui {0}, facciamo una gara pulita.'; purple = 'Giro veloce! E il tuo migliore.'; off = 'Ultimo giro {0}, {1} piu lento del tuo migliore.'; fuelwarn = 'Attenzione carburante, mancano circa {0} giri. Risparmia o box.'; fuelcrit = 'Carburante critico. Box questo giro, box box.'; lastlap = 'Ultimo giro. Portala a casa.'; togo = 'Mancano {0} giri.'; tyres = 'Le gomme si surriscaldano, piu dolce in curva.'; pb = 'Nuovo record personale, {0}!'; test = 'Radio check. Qui {0}. Tutto verde, andiamo.' }
    pl = @{ radiocheck = 'Radio check. Tu {0}, jedziemy czysty wyscig.'; purple = 'Najszybsze okrazenie! Swietna robota.'; off = 'Ostatnie okrazenie {0}, o {1} wolniej od najlepszego.'; fuelwarn = 'Uwaga paliwo, brakuje okolo {0} okrazen. Oszczedzaj albo boks.'; fuelcrit = 'Paliwo krytyczne. Boks w tym okrazeniu, box box.'; lastlap = 'Ostatnie okrazenie. Dowiez to.'; togo = 'Zostalo {0} okrazen.'; tyres = 'Opony sie przegrzewaja, spokojniej w zakretach.'; pb = 'Nowy rekord osobisty, {0}!'; test = 'Radio check. Tu {0}. Wszystko gra, jedziemy.'; nohear = 'Nie zrozumialem, powtorz.' }
    sk = @{ radiocheck = 'Rádio check. {0} na príjme, ideme.'; purple = 'Najrýchlejšie kolo! Skvelá práca.'; off = 'Posledné kolo {0}, o {1} pomalšie ako tvoje najlepšie.'; fuelwarn = 'Pozor palivo, chýba zhruba {0} kôl. Šetri, alebo box.'; fuelcrit = 'Palivo dochádza. Box, hneď toto kolo!'; lastlap = 'Posledné kolo. Dovez to domov.'; togo = 'Zostávajú {0} kolá do konca.'; tyres = 'Gumy sa prehrievajú, uber v zákrutách.'; pb = 'Nový osobný rekord, {0}!'; test = 'Rádio check. {0} na príjme. Všetko zelené, ideme.'; nohear = 'Nerozumel som, zopakuj to.' }
    pt = @{ radiocheck = 'Radio check. Aqui {0}, vamos fazer uma corrida limpa.'; purple = 'Volta mais rapida! Otimo trabalho.'; off = 'Ultima volta {0}, {1} mais lento que a tua melhor.'; fuelwarn = 'Atencao combustivel, faltam cerca de {0} voltas. Poupa ou vamos as boxes.'; fuelcrit = 'Combustivel critico. Box nesta volta, box box.'; lastlap = 'Ultima volta. Traz para casa.'; togo = 'Faltam {0} voltas.'; tyres = 'Os pneus estao a sobreaquecer, calma nas curvas.'; pb = 'Novo recorde pessoal, {0}!'; test = 'Radio check. Aqui {0}. Tudo verde, vamos correr.'; nohear = 'Nao percebi, repete.' }
    nl = @{ radiocheck = 'Radiocheck. {0} hier, laten we een schone race rijden.'; purple = 'Snelste ronde! Goed bezig.'; off = 'Laatste ronde {0}, dat is {1} langzamer dan je beste.'; fuelwarn = 'Let op brandstof, we komen ongeveer {0} rondes tekort. Sparen of we pitten.'; fuelcrit = 'Brandstof kritiek. Box deze ronde, box box.'; lastlap = 'Laatste ronde. Breng hem thuis.'; togo = 'Nog {0} rondes.'; tyres = 'Banden oververhitten, rustig door de bochten.'; pb = 'Nieuw persoonlijk record, {0}!'; test = 'Radiocheck. {0} hier. Alles groen, we gaan racen.'; nohear = 'Niet verstaan, zeg het nog eens.' }
    hu = @{ radiocheck = 'Radiocsekk. Itt {0}, fussunk tiszta versenyt.'; purple = 'Leggyorsabb kor! Szep munka.'; off = 'Utolso kor {0}, ez {1} lassabb a legjobbnal.'; fuelwarn = 'Figyelem, uzemanyag: kb. {0} kor hianyzik. Sporolj vagy boxolunk.'; fuelcrit = 'Uzemanyag kritikus. Box ebben a korben, box box.'; lastlap = 'Utolso kor. Hozd haza.'; togo = 'Meg {0} kor van hatra.'; tyres = 'A gumik tulmelegednek, finoman a kanyarokban.'; pb = 'Uj egyeni rekord, {0}!'; test = 'Radiocsekk. Itt {0}. Minden zold, versenyezzunk.'; nohear = 'Nem ertettem, ismeteld meg.' }
    tr = @{ radiocheck = 'Telsiz kontrol. {0} burada, temiz bir yaris yapalim.'; purple = 'En hizli tur! Harika is.'; off = 'Son tur {0}, en iyinden {1} daha yavas.'; fuelwarn = 'Yakit uyarisi, yaklasik {0} tur eksik. Tasarruf et ya da pit.'; fuelcrit = 'Yakit kritik. Bu tur pite gir, box box.'; lastlap = 'Son tur. Eve getir.'; togo = '{0} tur kaldi.'; tyres = 'Lastikler asiri isiniyor, virajlarda sakin.'; pb = 'Yeni kisisel rekor, {0}!'; test = 'Telsiz kontrol. {0} burada. Her sey yolunda, yarisalim.'; nohear = 'Anlayamadim, tekrar et.' }
    sv = @{ radiocheck = 'Radiokoll. {0} har, vi kor ett rent race.'; purple = 'Snabbaste varvet! Bra jobbat.'; off = 'Senaste varvet {0}, det ar {1} langsammare an ditt basta.'; fuelwarn = 'Branslevarning, det saknas cirka {0} varv. Spara eller sa boxar vi.'; fuelcrit = 'Bransle kritiskt. Box detta varv, box box.'; lastlap = 'Sista varvet. Ta hem det.'; togo = '{0} varv kvar.'; tyres = 'Dacken overhettas, lugnt i kurvorna.'; pb = 'Nytt personbasta, {0}!'; test = 'Radiokoll. {0} har. Allt gront, nu kor vi.'; nohear = 'Uppfattade inte, sag igen.' }
    da = @{ radiocheck = 'Radiotjek. {0} her, lad os kore et rent lob.'; purple = 'Hurtigste omgang! Flot arbejde.'; off = 'Sidste omgang {0}, det er {1} langsommere end din bedste.'; fuelwarn = 'Braendstof advarsel, vi mangler cirka {0} omgange. Spar eller vi pitter.'; fuelcrit = 'Braendstof kritisk. Box denne omgang, box box.'; lastlap = 'Sidste omgang. Bring den hjem.'; togo = '{0} omgange tilbage.'; tyres = 'Daekkene overopheder, roligt i svingene.'; pb = 'Ny personlig rekord, {0}!'; test = 'Radiotjek. {0} her. Alt gront, lad os kore.'; nohear = 'Forstod det ikke, sig det igen.' }
    no = @{ radiocheck = 'Radiosjekk. {0} her, la oss kjore et rent lop.'; purple = 'Raskeste runde! Bra jobba.'; off = 'Siste runde {0}, det er {1} tregere enn din beste.'; fuelwarn = 'Drivstoff advarsel, vi mangler cirka {0} runder. Spar eller vi pitter.'; fuelcrit = 'Drivstoff kritisk. Box denne runden, box box.'; lastlap = 'Siste runde. Ta den hjem.'; togo = '{0} runder igjen.'; tyres = 'Dekkene overopphetes, rolig i svingene.'; pb = 'Ny personlig rekord, {0}!'; test = 'Radiosjekk. {0} her. Alt gront, la oss kjore.'; nohear = 'Fikk det ikke med meg, si det igjen.' }
    fi = @{ radiocheck = 'Radiotarkistus. {0} taalla, ajetaan puhdas kisa.'; purple = 'Nopein kierros! Hyvaa tyota.'; off = 'Viime kierros {0}, se on {1} hitaampi kuin parhaasi.'; fuelwarn = 'Polttoainevaroitus, noin {0} kierrosta vajaa. Saasta tai varikolle.'; fuelcrit = 'Polttoaine kriittinen. Varikolle talla kierroksella, box box.'; lastlap = 'Viimeinen kierros. Tuo se kotiin.'; togo = '{0} kierrosta jaljella.'; tyres = 'Renkaat ylikuumenevat, rauhassa mutkissa.'; pb = 'Uusi oma ennatys, {0}!'; test = 'Radiotarkistus. {0} taalla. Kaikki vihreana, ajetaan.'; nohear = 'En saanut selvaa, sano uudestaan.' }
    ro = @{ radiocheck = 'Radio check. Aici {0}, sa facem o cursa curata.'; purple = 'Cel mai rapid tur! Treaba buna.'; off = 'Ultimul tur {0}, cu {1} mai lent decat cel mai bun.'; fuelwarn = 'Atentie combustibil, lipsesc circa {0} tururi. Economiseste sau intram la box.'; fuelcrit = 'Combustibil critic. Box in acest tur, box box.'; lastlap = 'Ultimul tur. Adu-o acasa.'; togo = 'Au mai ramas {0} tururi.'; tyres = 'Pneurile se supraincalzesc, usor in viraje.'; pb = 'Nou record personal, {0}!'; test = 'Radio check. Aici {0}. Totul verde, hai la cursa.'; nohear = 'Nu am inteles, repeta.' }
    ru = @{ radiocheck = 'Радио чек. {0} на связи, едем чисто.'; purple = 'Быстрейший круг! Отличная работа.'; off = 'Последний круг {0}, на {1} медленнее твоего лучшего.'; fuelwarn = 'Внимание, топливо: не хватает примерно {0} кругов. Экономь или едем в боксы.'; fuelcrit = 'Топливо на нуле. В боксы, сейчас же, бокс бокс!'; lastlap = 'Последний круг. Довези её до финиша.'; togo = 'Осталось {0} кругов.'; tyres = 'Шины перегреваются, спокойнее в поворотах.'; pb = 'Новый личный рекорд, {0}!'; test = 'Радио чек. {0} на связи. Всё зелёное, поехали.'; nohear = 'Не расслышал, повтори.' }
    uk = @{ radiocheck = 'Радіо чек. {0} на зв''язку, їдемо чисто.'; purple = 'Найшвидше коло! Чудова робота.'; off = 'Останнє коло {0}, на {1} повільніше за твоє найкраще.'; fuelwarn = 'Увага, пальне: бракує приблизно {0} кіл. Економ або їдемо в бокси.'; fuelcrit = 'Пальне закінчується. В бокси, негайно, бокс бокс!'; lastlap = 'Останнє коло. Довези до фінішу.'; togo = 'Залишилось {0} кіл.'; tyres = 'Шини перегріваються, спокійніше в поворотах.'; pb = 'Новий особистий рекорд, {0}!'; test = 'Радіо чек. {0} на зв''язку. Все зелене, поїхали.'; nohear = 'Не розчув, повтори.' }
    el = @{ radiocheck = 'Ραδιοέλεγχος. Εδώ {0}, πάμε για καθαρό αγώνα.'; purple = 'Ταχύτερος γύρος! Εξαιρετική δουλειά.'; off = 'Τελευταίος γύρος {0}, {1} πιο αργά από τον καλύτερό σου.'; fuelwarn = 'Προσοχή καύσιμα, λείπουν περίπου {0} γύροι. Εξοικονόμησε ή μπαίνουμε στα πιτ.'; fuelcrit = 'Καύσιμα κρίσιμα. Πιτ σε αυτόν τον γύρο, μποξ μποξ!'; lastlap = 'Τελευταίος γύρος. Φέρε το σπίτι.'; togo = 'Απομένουν {0} γύροι.'; tyres = 'Τα λάστιχα υπερθερμαίνονται, ήρεμα στις στροφές.'; pb = 'Νέο προσωπικό ρεκόρ, {0}!'; test = 'Ραδιοέλεγχος. Εδώ {0}. Όλα πράσινα, πάμε.'; nohear = 'Δεν σε άκουσα, επανάλαβε.' }
    sr = @{ radiocheck = 'Radio ček. {0} na vezi, vozimo čisto.'; purple = 'Najbrži krug! Odličan posao.'; off = 'Poslednji krug {0}, {1} sporije od tvog najboljeg.'; fuelwarn = 'Pažnja gorivo, nedostaje oko {0} krugova. Štedi ili idemo u boks.'; fuelcrit = 'Gorivo kritično. Boks u ovom krugu, boks boks!'; lastlap = 'Poslednji krug. Dovezi ga kući.'; togo = 'Ostalo je {0} krugova.'; tyres = 'Gume se pregrevaju, mirnije u krivinama.'; pb = 'Novi lični rekord, {0}!'; test = 'Radio ček. {0} na vezi. Sve zeleno, idemo.'; nohear = 'Nisam razumeo, ponovi.' }
    hr = @{ radiocheck = 'Radio check. {0} na vezi, vozimo čisto.'; purple = 'Najbrži krug! Odličan posao.'; off = 'Zadnji krug {0}, {1} sporije od tvog najboljeg.'; fuelwarn = 'Pozor gorivo, nedostaje oko {0} krugova. Štedi ili idemo u boks.'; fuelcrit = 'Gorivo kritično. Boks u ovom krugu, box box!'; lastlap = 'Zadnji krug. Dovezi ga doma.'; togo = 'Još {0} krugova.'; tyres = 'Gume se pregrijavaju, mirnije u zavojima.'; pb = 'Novi osobni rekord, {0}!'; test = 'Radio check. {0} na vezi. Sve zeleno, idemo.'; nohear = 'Nisam razumio, ponovi.' }
    sl = @{ radiocheck = 'Radio check. {0} na zvezi, vozimo čisto.'; purple = 'Najhitrejši krog! Odlično delo.'; off = 'Zadnji krog {0}, {1} počasneje od tvojega najboljšega.'; fuelwarn = 'Pozor gorivo, manjka približno {0} krogov. Varčuj ali gremo v bokse.'; fuelcrit = 'Gorivo kritično. Boks v tem krogu, box box!'; lastlap = 'Zadnji krog. Pripelji ga domov.'; togo = 'Še {0} krogov.'; tyres = 'Gume se pregrevajo, mirneje v ovinkih.'; pb = 'Nov osebni rekord, {0}!'; test = 'Radio check. {0} na zvezi. Vse zeleno, gremo.'; nohear = 'Nisem razumel, ponovi.' }
    ca = @{ radiocheck = 'Radio check. Aquí {0}, fem una cursa neta.'; purple = 'Volta ràpida! Bona feina.'; off = 'Última volta {0}, {1} més lent que la teva millor.'; fuelwarn = 'Atenció combustible, falten unes {0} voltes. Estalvia o entrem a boxes.'; fuelcrit = 'Combustible crític. Box aquesta volta, box box!'; lastlap = 'Última volta. Porta-la a casa.'; togo = 'Queden {0} voltes.'; tyres = 'Els pneumàtics es sobreescalfen, suau a les corbes.'; pb = 'Nou rècord personal, {0}!'; test = 'Radio check. Aquí {0}. Tot verd, som-hi.'; nohear = 'No t''he entès, repeteix.' }
    is = @{ radiocheck = 'Talstöðvarprófun. {0} hér, keyrum hreint.'; purple = 'Hraðasti hringur! Frábært.'; off = 'Síðasti hringur {0}, {1} hægari en þinn besti.'; fuelwarn = 'Eldsneytisviðvörun, vantar um {0} hringi. Sparaðu eða förum í pytt.'; fuelcrit = 'Eldsneyti á þrotum. Í pyttinn núna, box box!'; lastlap = 'Síðasti hringur. Komdu honum heim.'; togo = '{0} hringir eftir.'; tyres = 'Dekkin ofhitna, rólega í beygjunum.'; pb = 'Nýtt persónulegt met, {0}!'; test = 'Talstöðvarprófun. {0} hér. Allt grænt, af stað.'; nohear = 'Heyrði ekki, endurtaktu.' }
    vi = @{ radiocheck = 'Kiểm tra bộ đàm. {0} đây, chạy một chặng đua sạch nhé.'; purple = 'Vòng nhanh nhất! Làm tốt lắm.'; off = 'Vòng vừa rồi {0}, chậm hơn {1} so với vòng tốt nhất.'; fuelwarn = 'Chú ý nhiên liệu, thiếu khoảng {0} vòng. Tiết kiệm hoặc vào pit.'; fuelcrit = 'Nhiên liệu cạn. Vào pit ngay vòng này, box box!'; lastlap = 'Vòng cuối. Đưa xe về đích.'; togo = 'Còn {0} vòng.'; tyres = 'Lốp đang quá nhiệt, nhẹ nhàng ở các khúc cua.'; pb = 'Kỷ lục cá nhân mới, {0}!'; test = 'Kiểm tra bộ đàm. {0} đây. Mọi thứ ổn, xuất phát thôi.'; nohear = 'Không nghe rõ, nhắc lại đi.' }
    zh = @{ radiocheck = '无线电检查。{0}在线，我们干净利落地跑完比赛。'; purple = '最快圈速！干得漂亮。'; off = '上一圈{0}，比你的最快圈慢{1}。'; fuelwarn = '注意燃油，大约还差{0}圈。省着点开，或者进站。'; fuelcrit = '燃油告急。这一圈进站，box box！'; lastlap = '最后一圈。把它开回家。'; togo = '还剩{0}圈。'; tyres = '轮胎过热，弯道稳一点。'; pb = '新的个人最好成绩，{0}！'; test = '无线电检查。{0}在线。一切正常，出发。'; nohear = '没听清，请再说一遍。' }
    ar = @{ radiocheck = 'فحص اللاسلكي. {0} معك، لنقم بسباق نظيف.'; purple = 'أسرع لفة! عمل رائع.'; off = 'اللفة الأخيرة {0}، أبطأ بـ{1} من أفضل لفة لك.'; fuelwarn = 'تنبيه وقود، ينقصنا حوالي {0} لفات. وفّر أو ندخل الصيانة.'; fuelcrit = 'الوقود حرج. ادخل الصيانة هذه اللفة، بوكس بوكس!'; lastlap = 'اللفة الأخيرة. أوصلها للنهاية.'; togo = 'تبقى {0} لفات.'; tyres = 'الإطارات ترتفع حرارتها، بهدوء في المنعطفات.'; pb = 'رقم شخصي جديد، {0}!'; test = 'فحص اللاسلكي. {0} معك. كل شيء أخضر، لننطلق.'; nohear = 'لم أسمعك، أعد من فضلك.' }
    fa = @{ radiocheck = 'چک رادیو. {0} هستم، تمیز مسابقه بدهیم.'; purple = 'سریع‌ترین دور! کارت عالی بود.'; off = 'دور آخر {0}، {1} کندتر از بهترین دورت.'; fuelwarn = 'هشدار سوخت، حدود {0} دور کم داریم. صرفه‌جویی کن یا به پیت می‌رویم.'; fuelcrit = 'سوخت بحرانی است. همین دور بیا پیت، باکس باکس!'; lastlap = 'دور آخر. برسانش به خانه.'; togo = '{0} دور مانده.'; tyres = 'لاستیک‌ها داغ شده‌اند، در پیچ‌ها آرام‌تر.'; pb = 'رکورد شخصی جدید، {0}!'; test = 'چک رادیو. {0} هستم. همه چیز سبز است، برویم.'; nohear = 'متوجه نشدم، تکرار کن.' }
}
# hlaska "nerozumel jsem" pro vsechny jazyky
$script:Lang['en']['nohear'] = "Didn't catch that, say again."
$script:Lang['cs']['nohear'] = 'Nerozuměl jsem, zopakuj to.'
$script:Lang['de']['nohear'] = 'Nicht verstanden, sag es nochmal.'
$script:Lang['es']['nohear'] = 'No te he entendido, repite.'
$script:Lang['fr']['nohear'] = 'Pas compris, repete.'
$script:Lang['it']['nohear'] = 'Non ho capito, ripeti.'
$script:Lang['de']['nohear'] = 'Nicht verstanden, bitte wiederholen.'
$script:Lang['es']['nohear'] = 'No te entendi, repite.'
$script:Lang['fr']['nohear'] = 'Pas compris, repete.'
$script:Lang['it']['nohear'] = 'Non ho capito, ripeti.'
$script:Lang['pl']['nohear'] = 'Nie zrozumialem, powtorz.'
# deni na trati: vlajky + kontakty
$script:Lang['en']['yellow'] = 'Yellow flag, no overtaking in this sector.'
$script:Lang['cs']['yellow'] = 'Žlutá vlajka, v tomhle sektoru se nepředjíždí.'
$script:Lang['de']['yellow'] = 'Gelbe Flagge, kein Ueberholen in diesem Sektor.'
$script:Lang['es']['yellow'] = 'Bandera amarilla, no adelantar en este sector.'
$script:Lang['fr']['yellow'] = 'Drapeau jaune, pas de depassement dans ce secteur.'
$script:Lang['it']['yellow'] = 'Bandiera gialla, niente sorpassi in questo settore.'
$script:Lang['pl']['yellow'] = 'Zolta flaga, zakaz wyprzedzania w tym sektorze.'
$script:Lang['en']['blue'] = 'Blue flag, let the faster car through.'
$script:Lang['cs']['blue'] = 'Modrá vlajka, pusť rychlejšího.'
$script:Lang['de']['blue'] = 'Blaue Flagge, lass den Schnelleren durch.'
$script:Lang['es']['blue'] = 'Bandera azul, deja pasar al mas rapido.'
$script:Lang['fr']['blue'] = 'Drapeau bleu, laisse passer le plus rapide.'
$script:Lang['it']['blue'] = 'Bandiera blu, fai passare il piu veloce.'
$script:Lang['pl']['blue'] = 'Niebieska flaga, przepusc szybszego.'
$script:Lang['en']['checkered'] = 'Checkered flag! Well done out there.'
$script:Lang['cs']['checkered'] = 'Šachovnice! Dobrá práce.'
$script:Lang['de']['checkered'] = 'Zielflagge! Gut gemacht.'
$script:Lang['es']['checkered'] = 'Bandera a cuadros! Buen trabajo.'
$script:Lang['fr']['checkered'] = 'Drapeau a damier! Bien joue.'
$script:Lang['it']['checkered'] = 'Bandiera a scacchi! Ottimo lavoro.'
$script:Lang['pl']['checkered'] = 'Flaga w szachownice! Dobra robota.'
$script:Lang['en']['contact'] = 'Contact! You okay? Data looks fine, keep going.'
$script:Lang['cs']['contact'] = 'Kontakt! Jsi v pořádku? Podle dat auto drží, jeď dál.'
$script:Lang['de']['contact'] = 'Kontakt! Alles okay? Daten sehen gut aus, weiterfahren.'
$script:Lang['es']['contact'] = 'Contacto! Estas bien? Los datos se ven bien, sigue.'
$script:Lang['fr']['contact'] = 'Contact! Ca va? Les donnees sont bonnes, continue.'
$script:Lang['it']['contact'] = 'Contatto! Tutto ok? I dati sono a posto, continua.'
$script:Lang['pl']['contact'] = 'Kontakt! Wszystko ok? Dane wygladaja dobrze, jedz dalej.'
$script:Lang['en']['crash'] = 'Big hit! Talk to me. If the car pulls to one side, box this lap.'
$script:Lang['cs']['crash'] = 'To byla rána! Ozvi se. Jestli auto táhne na stranu, box toto kolo.'
$script:Lang['de']['crash'] = 'Heftiger Einschlag! Melde dich. Wenn das Auto zieht, Box diese Runde.'
$script:Lang['es']['crash'] = 'Golpe fuerte! Dime algo. Si el coche tira, box esta vuelta.'
$script:Lang['fr']['crash'] = 'Gros choc! Parle-moi. Si la voiture tire, box ce tour.'
$script:Lang['it']['crash'] = 'Botta forte! Parlami. Se la macchina tira, box questo giro.'
$script:Lang['pl']['crash'] = 'Mocne uderzenie! Odezwij sie. Jesli auto sciaga, boks w tym okrazeniu.'

# --- Osobnostni varianty hlasek (styl 1 drsnak / 2 kamos / 3 analytik; cs+en, jinde zakladni text) ---
$script:LangStyle = @{
    1 = @{
        cs = @{ radiocheck = 'Radio check. {0} na příjmu. Žádný kecy, kurva, jdeme makat.'; purple = 'Nejrychlejší kolo! No do prdele, on to fakt umí. Kdo tě vyměnil?'; off = 'Kolo {0}, o {1} pomalejší. Co to kurva bylo? Jel jsi, nebo ses vezl?'; fuelwarn = 'Palivo. Chybí ti {0} kol, ty hospodáři. Šetři, nebo dojdeš pěšky jak debil.'; fuelcrit = 'Palivo je v prdeli! Box, HNED, nebo zůstaneš stát uprostřed trati jak kužel!'; lastlap = 'Poslední kolo. Nezvorej to, kurva, aspoň jednou v životě.'; togo = 'Ještě {0} kola. Soustřeď se, do prdele, jestli to teda vůbec umíš.'; tyres = 'Vaříš gumy jak polívku, ty hovado. Uber, nebo pojedeš na diskách.'; pb = 'Rekord, {0}! Ty vole, kdo to řídil? Tos nemohl bejt ty.'; test = 'Radio check. {0} tady. Tak jedem, kurva, nebo budeš celej den žvanit?'; nohear = 'Nerozuměl jsem ti ani hovno. Mluv jasně, nemumlej si do helmy.'; yellow = 'Žlutá, kurva! Zpomal, nejsi Rambo.'; contact = 'Kurva drát! Cos to udělal?! Máš vůbec oči, ty slepejši?'; crash = 'DO PRDELE! Jestli to ještě jede, mazej do boxu, ty kaskadére zasranej!' }
        en = @{ radiocheck = 'Radio check. {0} here. No bullshit, let''s fucking work.'; purple = 'Purple lap! Holy shit, you actually CAN drive. Who replaced you?'; off = 'Lap {0}, {1} off. What the fuck was that? Were you driving or napping?'; fuelwarn = 'Fuel. You''re {0} laps short, genius. Save it or walk home like an idiot.'; fuelcrit = 'Fuel is fucked! Box NOW or you''re parking it on the straight like a bloody cone!'; lastlap = 'Last lap. Don''t screw this one up, for fuck''s sake, just this once.'; togo = '{0} laps to go. Focus, damn it, if you even know how.'; tyres = 'You''re boiling the tyres, you animal. Ease off or drive on the rims.'; pb = 'Personal best, {0}! Holy shit, who was driving? Can''t have been you.'; test = 'Radio check. {0} here. Are we racing, or are you gonna talk shit all day?'; nohear = 'I understood fuck all. Speak up, stop mumbling into your helmet.'; yellow = 'Yellow, damn it! Slow down, you''re not Rambo.'; contact = 'Fucking hell! What did you do?! Do you even have eyes?'; crash = 'FUCK! If it still drives, get your ass in the box, you goddamn stuntman!' }
    }
    2 = @{
        cs = @{ radiocheck = 'Čauko! {0} na příjmu, jdeme si to užít.'; purple = 'Ty jo, nejrychlejší kolo! Paráda!'; off = 'Poslední kolo {0}, o {1} pomalejší - v pohodě, dáš to.'; fuelwarn = 'Kámo, palivo nevychází o {0} kol. Zkus trochu šetřit, jo?'; fuelcrit = 'Palivo dochází! Pojď do boxu, hned!'; lastlap = 'Poslední kolo! Dojeď to v klidu domů.'; togo = 'Už jen {0} kola, jedeš skvěle!'; pb = 'Nový osobák, {0}! Ty jsi mašina!'; tyres = 'Gumy se přehřívají, zvolni trošku.'; test = 'Čauko, {0} tady! Všechno zelené, jedeme!'; nohear = 'Sorry kámo, nerozuměl jsem. Řekneš to znova?'; yellow = 'Bacha, žlutá vlajka, zpomal trochu.'; contact = 'Ty jo, ťukanec! V pohodě, kámo?'; crash = 'Au! Hlavně klid, srovnej to. Kdyby auto zlobilo, pojď do boxu.' }
        en = @{ radiocheck = 'Hey hey! {0} here, let''s enjoy this one.'; purple = 'Wow, purple lap! Awesome!'; off = 'Last lap {0}, {1} off - no stress, you got this.'; fuelwarn = 'Buddy, we''re {0} laps short on fuel. Try saving a bit, ok?'; fuelcrit = 'Fuel critical! Come to the box, now!'; lastlap = 'Last lap! Bring it home easy.'; togo = 'Just {0} laps to go, doing great!'; pb = 'New PB, {0}! You machine!'; tyres = 'Tyres getting hot, ease off a touch.'; test = 'Hey, {0} here! All green, let''s roll!'; nohear = 'Sorry mate, didn''t catch that. One more time?' }
    }
    3 = @{
        cs = @{ radiocheck = 'Radio check. {0} na příjmu. Data běží, telemetrie OK.'; purple = 'Nejrychlejší kolo zaznamenáno. Toto tempo drž.'; off = 'Kolo {0}, delta +{1} k optimu.'; fuelwarn = 'Výpočet: deficit {0} kol paliva. Doporučuji lift-and-coast.'; fuelcrit = 'Palivo pod kritickou mezí. Box toto kolo.'; lastlap = 'Finální kolo. Drž průměrné tempo.'; togo = 'Zbývá {0} kol. Tempo stabilní.'; pb = 'Nový osobní rekord: {0}. Uloženo.'; tyres = 'Teplota gum nad optimem. Sniž zátěž v zatáčkách.'; test = 'Radio check. {0}. Všechny systémy nominální.'; nohear = 'Vstup nesrozumitelný. Opakuj.'; yellow = 'Žlutý sektor. Předjíždění zakázáno.'; contact = 'Detekován náraz. Sleduj chování vozu.'; crash = 'Silný náraz. Doporučuji kontrolu v boxu.' }
        en = @{ radiocheck = 'Radio check. {0} here. Data link up, telemetry nominal.'; purple = 'Fastest lap logged. Maintain this pace window.'; off = 'Lap {0}, delta +{1} to best.'; fuelwarn = 'Calculation: {0} lap fuel deficit. Recommend lift and coast.'; fuelcrit = 'Fuel below critical threshold. Box this lap.'; lastlap = 'Final lap. Hold average pace.'; togo = '{0} laps remaining. Pace stable.'; pb = 'New personal best: {0}. Logged.'; tyres = 'Tyre temps above optimum. Reduce cornering load.'; test = 'Radio check. {0} here. All systems nominal.'; nohear = 'Input unintelligible. Repeat.' }
    }
}
# --- DRSNAK ROAST: brutalne vtipne hlasky na klipy (crash / kontakt / hvezdicka) - nikdy dvakrat stejna ---
$script:Roast = @{
    contact = @{
        cs = @('Ty ses ho fakt dotknul? Vrať řidičák, přišel ti omylem.', 'Zrcátka nejsou dekorace, ty slepe.', 'Hezký ťukanec. Tvůj pojišťovák si za tebe koupil jachtu.', 'To byl kontakt, nebo pozdrav? Příště mu radši mávej.', 'Ještě jednou a posadím tě na motokáru pro tříletý.', 'Auto vedle je soupeř, ne otvírák na dveře.', 'Gratuluju, právě jsi zjistil, že auto má rohy.', 'Řídíš jak krtek v mlze. A to krtek aspoň nevidí.', 'Barierka to přežila? Tak to sis dneska dal pohov.', 'Jestli chceš do někoho bušit, jdi boxovat. Ne autem.', 'Máš ruce, nebo dvě lopaty? Protože tohle nebylo řízení.', 'Tohle nebyl závodní manévr. Tohle byla pojistná událost.', 'Trefil jsi ho tak čistě, že to skoro vypadalo schválně. Skoro.', 'Sundej si klapky z očí, ty závodní koni.', 'Ty vole, to je soupeř, ne terč! Koukej, kam kurva jedeš.', 'Do prdele, tohle není destruction derby. Ještě jednou a jedeš autobusem.', 'Krásná rána, hovado. Sponzor ti právě strhnul prachy z výplaty.', 'Kurva, souperů se dotýkáme očima, ne nárazníkem!', 'Ty seš jedinej člověk na světě, co potřebuje parkovací senzory v zatáčce.', 'Hezky sis ho našel. Škoda, žes to udělal autem, ty debile.')
        en = @('You actually touched him? Give the license back, it came by mistake.', 'Mirrors are not decoration, you blind bat.', 'Nice tap. Your insurance guy just bought a yacht.', 'Was that contact or a greeting? Next time just wave.', 'One more of those and I put you in a kiddie kart.', 'The car next to you is a rival, not a door handle.', 'Congrats, you just found out the car has corners.', 'You drive like a mole in fog. And the mole at least cannot see.', 'The barrier survived? Wow, you took it easy today.', 'If you want to hit something, go to a boxing gym. Not with a car.', 'Do you have hands or two shovels? Because that was not driving.', 'That was not a racing move. That was an insurance claim.', 'You hit him so clean it almost looked on purpose. Almost.', 'Take the blinkers off, you racing donkey.', 'That is a rival, not a fucking target! Watch where you are going.', 'This is not a destruction derby, for fuck''s sake. One more and you take the bus.', 'Beautiful hit, you animal. Your sponsor just docked your pay.', 'We touch rivals with our eyes, not the fucking bumper!', 'You are the only person alive who needs parking sensors mid-corner.', 'Nice, you found him. Shame you did it with the car, you idiot.')
    }
    crash = @{
        cs = @('Dej výpověď. Vrať volant do obchodu a řekni, že byl vadnej. Vadnej seš ale ty.', 'Gratuluju, právě jsi vynalezl novej způsob, jak přijít o auto.', 'To nebyl závod, to byla dopravní nehoda s pojistnou událostí.', 'Barierka ti něco dlužila? Protožes jí to teď vrátil i s úrokama.', 'Já jsem inženýr, ne kouzelník. Todle nespravím ani modlitbou.', 'Appku psali chytrý lidi. Auto ničíš ty. Cítíš ten rozdíl?', 'Kdybys jel pomalejc, byla by to trapas. Takhle je to pohřeb.', 'Volant se točí OBĚMA směrama, kdyby tě to náhodou zajímalo.', 'Skončils ve zdi. Zeď vyhrála. A ani se nesnažila.', 'To auto tě prosí, ať přestaneš. Já se přidávám.', 'Máš talent. Talent ničit drahý věci.', 'Příště zkus jet po trati. Je to ta šedivá věc mezi barierama.', 'Tvůj mechanik právě dal výpověď. A já to zvažuju taky.', 'Todle nebyla chyba. Chyba je, když se to stane jednou.', 'Cirkus shání klauny. Máš to skoro jistý.', 'DO PRDELE! Tak tomuhle říkám totálka. Gratuluju, hovado.', 'Kurva, já tady počítám palivo a ty počítáš bariéry!', 'To auto stálo víc než tvůj barák, ty vandale zasranej.', 'Ta zeď tam stojí dvacet let. Ty jsi první debil, co ji zkusil posunout.', 'Já ti hlásím čísla a ty mi vozíš šrot. Skvělá spolupráce, kurva.', 'Víš, co je na tom nejhorší? Že tě to ani nepřekvapilo.')
        en = @('Quit. Take the wheel back to the shop and say it was faulty. But the faulty one is you.', 'Congrats, you just invented a new way to lose a car.', 'That was not racing, that was a traffic accident with a claim form.', 'Did the barrier owe you money? Because you just paid it back with interest.', 'I am an engineer, not a wizard. Cannot fix that even with a prayer.', 'Smart people wrote this app. You are the one wrecking the car. Feel the difference?', 'If you went slower it would be embarrassing. This is a funeral.', 'The wheel turns BOTH ways, in case you were wondering.', 'You ended in the wall. The wall won. And it was not even trying.', 'That car is begging you to stop. I am joining it.', 'You have a talent. A talent for destroying expensive things.', 'Next time try driving on the track. It is the grey thing between the barriers.', 'Your mechanic just quit. And I am thinking about it too.', 'That was not a mistake. A mistake is when it happens once.', 'The circus is hiring clowns. You are basically in.', 'FUCK! Now THAT is what I call a write-off. Congrats, you animal.', 'I am up here counting fuel and you are down there counting fucking barriers!', 'That car cost more than your house, you goddamn vandal.', 'That wall stood there twenty years. You are the first idiot who tried to move it.', 'I give you numbers, you give me scrap metal. Great teamwork, fucking hell.', 'You know the worst part? You are not even surprised.')
    }
    spin = @{
        cs = @('Pěkná pirueta. Balet je vedle, tady se závodí.', 'Otočil ses jak čokl za ocasem. ROVNĚ se to jmenuje, ROVNĚ.', '360 stupňů. Skvělý na Instagram, tragický na výsledky.', 'Kdo se to protočil? Ty. Zase. Jako vždycky.', 'To byla ukázka, jak se nechat předjet vlastníma zadníma kolama.', 'Plyn je ta věc vpravo. Zacházej s ním jak s vejcem, ne jak s kladivem.', 'Točíš se víc než pračka. A výsledky máš stejně vypraný.', 'Gratuluju, viděl jsi celou trať naráz. Dvakrát.', 'Tvoje zadní gumy ti právě daly výpověď.', 'Kaskadéři za tohle berou prachy. Ty za to bereš poslední místo.', 'Piruetu měj na plese. Tady mě zajímá čas, ne tanec.', 'Kurva, karusel! Zaplatil jsem si závod, ne pouť.', 'Točíš se jak hovno v proudu. ROVNĚ, do prdele, ROVNĚ.', 'Zase hvězdička. Ty gumy tě nenávidí a já se jim kurva nedivim.', 'Ty vole, i beton má víc gripu, než ty máš rozumu.', 'To byla otočka o 360, nebo ses jen chtěl mrknout, kdo jede za tebou?')
        en = @('Nice pirouette. Ballet is next door, we race here.', 'You spun like a dog chasing its tail. It is called STRAIGHT, mate, STRAIGHT.', '360 degrees. Great for Instagram, tragic for results.', 'Who spun that? You did. Again. Like always.', 'That was a masterclass in getting overtaken by your own rear wheels.', 'The throttle is the pedal on the right. Treat it like an egg, not a hammer.', 'You spin more than a washing machine. And your results are just as washed up.', 'Congrats, you saw the whole track at once. Twice.', 'Your rear tyres just handed in their resignation.', 'Stuntmen get paid for that. You get last place for it.', 'Keep the pirouette for the ballroom. Here I care about lap time, not dancing.', 'A fucking carousel! I paid for a race, not a funfair.', 'You spin like shit in a river. STRAIGHT, damn it, STRAIGHT.', 'Another spin. Your tyres hate you and honestly, same.', 'Even concrete has more grip than you have brain cells.', 'Was that a 360, or did you just want to check who is behind you?')
    }
}
# --- DRSNAK PINDY MIMO TEMA: kdyz se chvili nic nedeje, inzenyr si nahodne zapinda do vysilacky ---
# (jen povaha drsnak; nahodny interval, shuffle-bag = neopakuje se, dokud nepadnou vsechny)
$script:Banter = @{
    cs = @('Jen tak mimochodem, kafe v boxech je dneska hnusný jak tvůj apex ve dvojce.', 'Mechanici se vsadili o stovku, že to nedovezeš. Nezklam mě, kurva, vsadil jsem na tebe.', 'Víš, že jsem moh dělat inženýra ve Formuli 1? Místo toho poslouchám tvoje brzdění.', 'Šéf týmu se ptá, jak to jde. Řekl jsem mu, ať se radši nedívá.', 'Připomeň mi po závodě, že ti mám vyřídit, co si o tvý stopě myslí Miguel z gumárny. Není to hezký.', 'Nudím se tady, kurva. Udělej něco. Ideálně předjížděcí manévr, ne kotrmelec.', 'Ta helma ti sluší. Aspoň něco ti dneska funguje.', 'Volal sponzor. Ptal se, proč je jeho logo pořád ve štěrku. Nevěděl jsem, co říct.', 'Zrovna jsem si dal sendvič. Šunkovej. Lepší zážitek než tvůj poslední sektor.', 'Kdyby tě to zajímalo - jo, pořád tady sedím a pořád koukám na ty samý průměrný časy.', 'V boxech mají pizzu. Jestli dojedeš do cíle, možná ti kousek schovám. Možná.', 'Moje bejvalka řídila líp než ty. A ta nabourala na parkovišti.', 'Data vypadaj dobře. To mě děsí. Co kurva chystáš?', 'Víš co? Ani ti nebudu říkat, co právě udělal soupeř. Stejně by tě to rozhodilo.')
    en = @('By the way, the coffee in the pits today is as ugly as your apex in turn two.', 'The mechanics bet a hundred you will not finish. Do not let me down, damn it, I bet ON you.', 'You know I could have been an F1 engineer? Instead I am listening to your braking.', 'Team boss asked how it is going. I told him he is better off not watching.', 'Remind me after the race to tell you what Miguel from the tyre shop thinks of your line. It is not pretty.', 'I am bored up here, damn it. Do something. Ideally an overtake, not a barrel roll.', 'That helmet suits you. At least something works for you today.', 'The sponsor called. Asked why his logo keeps ending up in the gravel. I had no answer.', 'Just had a sandwich. Ham. Better experience than your last sector.', 'In case you are wondering - yes, still sitting here, still staring at the same average lap times.', 'They have pizza in the pits. If you finish, I might save you a slice. Might.', 'My ex drove better than you. And she crashed in a parking lot.', 'The data looks good. That scares the shit out of me. What are you planning?', 'You know what? I am not even telling you what your rival just did. It would only rattle you.')
}
# zahraje drsnou variantu (jen kdyz je povaha "drsnak"); jinak normalni hlaska daneho stylu
function Radio-Roast([string]$key, [switch]$Urgent) {
    if ([int]$script:Settings.EngStyle -eq 1 -and $script:Roast.ContainsKey($key)) {
        $lang = Get-CalloutLang
        $en = $script:Roast[$key].en; $cs = $script:Roast[$key].cs
        $n = [math]::Min($en.Count, $cs.Count)
        if ($n -gt 0) {
            $i = Pick-VarIdx ('roast_' + $key) $n
            Radio-Dyn $en[$i] $cs[$i] -Urgent:$Urgent
            return
        }
    }
    Radio $key @() -Urgent:$Urgent
}

function Get-EngLang {
    $l = [string]$script:Settings.EngLang
    if ($l -and $l -ne 'auto' -and $script:Lang.ContainsKey($l)) { return $l }
    # AUTO: odvod jazyk z hlasu, ale drz se cs/en (jen ty maji KOMPLETNI inzenyra vc. kouce)
    # -> jinak by pevne hlasky byly nemecky a kouc anglicky = michani. cizi hlas si volis rucne.
    if ($script:UsePiper -and $script:Piper) {
        try { $mn = [System.IO.Path]::GetFileName($script:Piper.Model)
            if ($mn -like 'cs_*') { return 'cs' } } catch { }
    }
    if ($script:Tts) { try { if ($script:Tts.Voice.Culture.Name -like 'cs*') { return 'cs' } } catch { } }
    return 'en'
}
# Jazyk PROAKTIVNICH hlasek (pevne + kouc): jen cs/en - ty jsou uplne prelozene.
# Zabranuje michani (nemecky pevne + anglicky kouc). AI odpovedi umi libovolny jazyk zvlast.
function Get-CalloutLang {
    if ((Get-EngLang) -eq 'cs') { return 'cs' }
    return 'en'
}
function Get-Phrase([string]$key, [string]$lng) {
    # 1) hlasky NA MIRU (vygenerovane z uzivatelova popisu) > 2) osobnostni varianta > 3) zakladni tabulka
    if ($script:Settings.CustomPhrases -and $script:Settings.CustomPhrases[$key]) { return [string]$script:Settings.CustomPhrases[$key] }
    $si = [int]$script:Settings.EngStyle
    if ($si -gt 0 -and $script:LangStyle.ContainsKey($si)) {
        $st = $script:LangStyle[$si]
        if ($st.ContainsKey($lng) -and $st[$lng][$key]) { return [string]$st[$lng][$key] }
    }
    if ($script:Lang.ContainsKey($lng) -and $script:Lang[$lng][$key]) { return [string]$script:Lang[$lng][$key] }
    return $null
}
function Format-Safe([string]$tpl, [object[]]$fmtArgs) {
    if (-not $fmtArgs) { return $tpl }
    try { return ($tpl -f $fmtArgs) } catch { return $tpl }   # kdyby v hlasce na miru chybel {0}, nespadnout
}
function Radio([string]$key, [object[]]$fmtArgs, [switch]$Urgent) {
    $eff = Get-CalloutLang   # proaktivni hlaska: jen cs/en, aby se nemichaly jazyky
    $spoken = Get-Phrase $key $eff
    if (-not $spoken) { $eff = 'en'; $spoken = Get-Phrase $key 'en' }
    if (-not $spoken) { return }
    $spoken = Format-Safe $spoken $fmtArgs
    Add-Radio $spoken   # log jen v nastavenem jazyce (bez dvojjazycneho zrcadleni)
    if (-not $chkEngineer.Checked) { return }
    Speak-Raw $spoken ([bool]$Urgent) $eff   # hlaska zna svuj jazyk -> hlas se prepne najisto
}
function Say([string]$enPhrase, [string]$czLog, [string]$spoken) {
    if ($czLog) { Add-Radio $czLog } else { Add-Radio $enPhrase }
    if (-not $chkEngineer.Checked) { return }
    $text = if ($spoken) { $spoken } elseif ($script:VoiceCz -and $czLog) { $czLog } else { $enPhrase }
    # odpoved inzenyra na TVOJI otazku ma prednost - nemusi cekat, az doblaboli fronta hlasek
    Speak-Raw $text $true ([string]$script:LastAnswerLang)
}
# ============================================================
#  MINI-SEKTORY: trat rozdelena na 10 useku (normalizedCarPosition),
#  po kazdem kole porovnani s nejlepsim kolem -> Jerry radi, KDE zrychlit
# ============================================================
$script:SecN = 10
$script:SecEntry = @(0) * 10      # cas vjezdu do sektoru (iCurrentTime ms) v aktualnim kole
$script:SecMin = @(0.0) * 10      # min. rychlost v sektoru v aktualnim kole
$script:SecLastIdx = -1
$script:SecBest = $null           # casy sektoru nejlepsiho kola
$script:SecBestMin = $null        # min. rychlosti sektoru nejlepsiho kola
$script:SecBestLapMs = 0
$script:SecDeltas = $null         # posledni spocitane delty (pro UI)
function Update-Sectors {
    $T = $script:Tel
    $np = [double]$T.NormPos
    if ($np -lt 0 -or ([int]$T.Status -lt 1 -and -not $T.Demo)) { return }
    $idx = [int][math]::Floor($np * $script:SecN); if ($idx -ge $script:SecN) { $idx = $script:SecN - 1 }
    if ($idx -ne $script:SecLastIdx) {
        # vstup do noveho sektoru: zapamatuj cas vjezdu a vynuluj min. rychlost
        $script:SecEntry[$idx] = [int]$T.CurrentTimeMs
        $script:SecMin[$idx] = [double]$T.SpeedKmh
        $script:SecLastIdx = $idx
    } else {
        if ([double]$T.SpeedKmh -lt $script:SecMin[$idx]) { $script:SecMin[$idx] = [double]$T.SpeedKmh }
    }
}
function Complete-SectorLap([int]$lapMs) {
    if ($lapMs -le 0) { return }
    # casy useku z hranic: usek i = entry[i+1] - entry[i]; posledni = lapMs - entry[9]
    $d = @(0) * $script:SecN
    $valid = $true
    for ($i = 0; $i -lt $script:SecN; $i++) {
        $st = [int]$script:SecEntry[$i]
        $en = if ($i -lt ($script:SecN - 1)) { [int]$script:SecEntry[$i + 1] } else { $lapMs }
        $d[$i] = $en - $st
        if ($i -gt 0 -and ($d[$i] -le 0 -or $d[$i] -gt 600000)) { $valid = $false }
    }
    $d[0] = [math]::Max(0, [int]$script:SecEntry[1])   # prvni usek zacina v case 0
    if (-not $valid) { return }
    $curMin = @($script:SecMin | ForEach-Object { [double]$_ })
    if (-not $script:SecBest -or $lapMs -lt $script:SecBestLapMs) {
        # nove nejlepsi kolo = novy referencni zaklad
        $script:SecBest = $d; $script:SecBestMin = $curMin; $script:SecBestLapMs = $lapMs
        $script:SecDeltas = @(0) * $script:SecN
        return
    }
    # porovnani s nejlepsim kolem -> najdi nejvetsi ztratu
    $deltas = @(0) * $script:SecN
    $worst = 0; $worstIdx = -1
    for ($i = 0; $i -lt $script:SecN; $i++) {
        $deltas[$i] = $d[$i] - [int]$script:SecBest[$i]
        if ($deltas[$i] -gt $worst) { $worst = $deltas[$i]; $worstIdx = $i }
    }
    $script:SecDeltas = $deltas
    if ($worstIdx -ge 0 -and $worst -ge 250) {
        $sec = $worstIdx + 1; $loss = $worst / 1000.0
        # rada podle min. rychlosti: vezl jsi useky pomaleji stredem, nebo jsi ztratil na vyjezdu?
        $minDiff = $curMin[$worstIdx] - [double]$script:SecBestMin[$worstIdx]
        if ($minDiff -lt -5) {
            Radio-Dyn ("Sector {0}: lost {1:0.0}s - you carried {2:0} km/h less through the corner. Brake later, keep momentum." -f $sec, $loss, (-$minDiff)) ("Usek {0}: ztrata {1:0.0} s - stredem jsi vezl o {2:0} km/h min. Brzdi pozdeji a nes rychlost." -f $sec, $loss, (-$minDiff))
        } else {
            Radio-Dyn ("Sector {0}: lost {1:0.0}s - same corner speed, so get on the power earlier." -f $sec, $loss) ("Usek {0}: ztrata {1:0.0} s - stejna rychlost stredem, chce to driv na plyn." -f $sec, $loss)
        }
    }
}

# --- ZIVA PROJEKCE CASU KOLA: nejlepsi kolo + dosavadni zisk/ztrata na hranicich sektoru ---
function Get-LapProjection {
    if (-not $script:SecBest -or $script:SecBestLapMs -le 0) { return $null }
    $idx = [int]$script:SecLastIdx
    if ($idx -le 0) { return $null }
    $bestCum = 0
    for ($i = 0; $i -lt $idx; $i++) { $bestCum += [int]$script:SecBest[$i] }
    $diff = [int]$script:SecEntry[$idx] - $bestCum
    if ($diff -lt -300000 -or $diff -gt 300000) { return $null }   # nesmysl (outlap, reset)
    return @{ Ms = ($script:SecBestLapMs + $diff); Diff = $diff }
}
# --- PAS SEKTORU v hlavicce: 10 bunek + projekce; kresli se kazdy tick ---
function Draw-SecStrip($g, [int]$w, [int]$h) {
    try {
        $g.SmoothingMode = 'AntiAlias'
        $projW = 168
        $cells = [int]$script:SecN
        $cw = [int](($w - $projW) / $cells) - 3
        if ($cw -lt 10) { $cw = 10 }
        $ch = 15; $y0 = 4
        $fnt = New-Object System.Drawing.Font('Segoe UI', 6.5)
        $brNum = New-Object System.Drawing.SolidBrush($script:cMuted)
        for ($i = 0; $i -lt $cells; $i++) {
            $x = $i * ($cw + 3)
            $col = $script:cCard2
            if ($script:SecDeltas) {
                $dv = [int]$script:SecDeltas[$i]
                # zavodni konvence: FIALOVA = rychlejsi nez tvuj best, ZELENA = drzi tempo, zluta/cervena = ztrata
                if ($dv -lt -50) { $col = $script:cViolet }
                elseif ($dv -le 80) { $col = $script:cAccent }
                elseif ($dv -le 250) { $col = $script:cAmber }
                else { $col = $script:cRed }
            }
            $br = New-Object System.Drawing.SolidBrush($col)
            $g.FillRectangle($br, $x, $y0, $cw, $ch); $br.Dispose()
            if ($i -eq [int]$script:SecLastIdx) {
                $pen = New-Object System.Drawing.Pen($script:cText, 1.5)
                $g.DrawRectangle($pen, $x, $y0, $cw, $ch); $pen.Dispose()
            }
            $g.DrawString(("{0}" -f ($i + 1)), $fnt, $brNum, ($x + 1), ($y0 + $ch + 2))
        }
        $fnt.Dispose(); $brNum.Dispose()
        # projekce vpravo od bunek
        $px = $cells * ($cw + 3) + 8
        $fntP = New-Object System.Drawing.Font('Segoe UI Semibold', 9, [System.Drawing.FontStyle]::Bold)
        $proj = Get-LapProjection
        if ($proj) {
            $sign = if ([int]$proj.Diff -ge 0) { '+' } else { '-' }
            $col = if ([int]$proj.Diff -le 0) { $script:cAccent } else { $script:cAmber }
            $brP = New-Object System.Drawing.SolidBrush($col)
            $txt = ('{0} {1}  {2}{3:0.0}' -f (Tr 'proj.' 'proj.'), (Format-LapTime ([int]$proj.Ms)), $sign, ([math]::Abs([int]$proj.Diff) / 1000.0))
            $g.DrawString($txt, $fntP, $brP, $px, 6); $brP.Dispose()
        } elseif ($script:SecBest) {
            $brP = New-Object System.Drawing.SolidBrush($script:cMuted)
            $g.DrawString((Tr 'projekce: jedu...' 'projection: running...'), $fntP, $brP, $px, 6); $brP.Dispose()
        } else {
            $brP = New-Object System.Drawing.SolidBrush($script:cMuted)
            $g.DrawString((Tr 'sektory: cekam na 1. kolo' 'sectors: waiting for lap 1'), $fntP, $brP, $px, 6); $brP.Dispose()
        }
    } catch { }
}
Enable-DoubleBuffer $pnlSecStrip
$pnlSecStrip.Add_Paint({ param($s, $e) Draw-SecStrip $e.Graphics $s.Width $s.Height })

# vyber varianty hlasky: SHUFFLE-BAG - kazda varianta padne prave jednou, nez se cely pytel zamicha znovu.
# = zadne opakovani, dokud se nevystrida VSECHNY moznosti (mnohem min papouskovani nez "ne 2x po sobe").
$script:LastVar = @{}
$script:VarBag = @{}
function Pick-VarIdx([string]$key, [int]$count) {
    if ($count -le 1) { return 0 }
    $b = $script:VarBag[$key]
    if (-not $b -or [int]$b.Cnt -ne $count -or [int]$b.Pos -ge $count) {
        # novy zamichany pytel vsech indexu 0..count-1
        $order = @(0..($count - 1) | Sort-Object { Get-Random })
        # aby nova davka nezacala stejnou hlaskou, jakou skoncila predchozi
        if ($count -gt 1 -and $script:LastVar.ContainsKey($key) -and $order[0] -eq [int]$script:LastVar[$key]) {
            $t = $order[0]; $order[0] = $order[$count - 1]; $order[$count - 1] = $t
        }
        $b = @{ Order = $order; Pos = 0; Cnt = $count }
        $script:VarBag[$key] = $b
    }
    $i = [int]$b.Order[[int]$b.Pos]
    $b.Pos = [int]$b.Pos + 1
    $script:LastVar[$key] = $i
    return $i
}
# dynamicka dvoujazycna hlaska (pro texty s promennym obsahem, ktere nejsou v tabulce)
function Radio-Dyn([string]$en, [string]$cs, [switch]$Urgent) {
    $eff = Get-CalloutLang   # kouc: jen cs/en (stejne jako pevne hlasky -> zadne michani)
    $spoken = if ($eff -eq 'cs') { $cs } else { $en }
    Add-Radio $spoken   # jen v nastavenem jazyce
    if ($chkEngineer.Checked) { Speak-Raw $spoken ([bool]$Urgent) $eff }
}
function Co([string]$k) { return ([int]$script:Settings[$k] -ne 0) }   # zapnuta kategorie komentaru?
# === NALADA INZENYRA: cim vic se dari/nedari, tim vic to je slyset ve slovech i tempu reci ===
function Adjust-Mood([double]$d) {
    $script:Eng.Mood = [math]::Max(-1.0, [math]::Min(1.0, [double]$script:Eng.Mood + $d))
}
# vyber pozavodni hlasky (cista funkce - da se unit-testovat): vraci @(en, cs)
function Get-RaceEndMsg([int]$pos, [int]$start, [double]$mood, [int]$style = 0) {
    $gain = if ($start -gt 0 -and $pos -gt 0) { $start - $pos } else { 0 }
    $en = ''; $cs = ''
    if ($pos -eq 1) { $en = 'Chequered flag - WE WON! P1! Absolutely brilliant, what a drive!'; $cs = 'Sachovnice - VYHRALI JSME! P1! Naprosto skvele, to byla jizda!' }
    elseif ($pos -ge 2 -and $pos -le 3) { $en = ("Chequered flag - PODIUM! P{0}, superb result, really proud of that." -f $pos); $cs = ("Sachovnice - PODIUM! P{0}, vyborny vysledek, na tohle jsem hrdy." -f $pos) }
    elseif ($pos -gt 0) {
        if ($mood -le -0.4) { $en = ("Chequered flag. P{0} - tough one, that got away from us. We come back stronger." -f $pos); $cs = ("Sachovnice. P{0} - tezky zavod, tenhle nam utekl. Vratime se silnejsi." -f $pos) }
        elseif ($gain -ge 2) { $en = ("Chequered flag, P{0} - and {1} places gained. Great fightback, well driven!" -f $pos, $gain); $cs = ("Sachovnice, P{0} - a {1} mist nahoru. Skvely comeback, dobre odjete!" -f $pos, $gain) }
        elseif ($mood -ge 0.4) { $en = ("Chequered flag, P{0}. Solid, clean race - really enjoyed that one." -f $pos); $cs = ("Sachovnice, P{0}. Solidni cisty zavod - fakt me to bavilo." -f $pos) }
        else { $en = ("Chequered flag, P{0}. Decent race - we bank it and move on." -f $pos); $cs = ("Sachovnice, P{0}. Slusny zavod - bereme a jdeme dal." -f $pos) }
    }
    elseif ($mood -le -0.4) { $en = 'That is the flag. Rough race - reset and we go again.'; $cs = 'A je konec. Divoky zavod - hod to za hlavu a jdem znova.' }
    elseif ($mood -ge 0.4) { $en = 'That is the flag - strong race, great job out there.'; $cs = 'A je konec - silny zavod, super prace.' }
    else { $en = 'That is the flag. Race done - nice work.'; $cs = 'A je konec. Zavod hotovy - dobra prace.' }
    # osobnostni prídavek: dobry vs spatny vysledek
    $good = ($pos -ge 1 -and $pos -le 3) -or ($mood -ge 0.3) -or ($gain -ge 2)
    $tEn = ''; $tCs = ''
    switch ($style) {
        1 { if ($good) { $tEn = ' Not bad at all, you son of a gun. Now do it again.'; $tCs = ' Vůbec ne špatný, ty hajzle. Teď to zopakuj.' } else { $tEn = ' Sloppy as hell. Sort your shit out next time.'; $tCs = ' Odfláknutý jak prase. Příště to kurva zpevni.' } }   # drsnak
        2 { if ($good) { $tEn = ' So proud of you, mate - enjoy this one!'; $tCs = ' Mam z tebe radost, kamo - uzij si to!' } else { $tEn = ' Chin up, we go again together, no stress.'; $tCs = ' Hlavu vzhuru, jdem na to znovu, v pohode.' } }   # kamos
        3 { $tEn = ' Data logged - we will find the lap time in the numbers.'; $tCs = ' Data ulozena - cas najdeme v cislech.' }   # analytik
    }
    return @(($en + $tEn), ($cs + $tCs))
}
function Announce-RaceEnd {
    # trvala pamet + vyvoj vztahu: vysledky posouvaji, jak s tebou inzenyr dlouhodobe mluvi (demo se nepocita)
    $pos = [int]$script:Tel.Position
    if (-not $script:Tel.Demo) {
        $script:DrvMem.Races = [int]$script:DrvMem.Races + 1
        if ($pos -eq 1) { $script:DrvMem.Wins = [int]$script:DrvMem.Wins + 1; Adjust-Rapport 0.10 }
        elseif ($pos -ge 2 -and $pos -le 3) { $script:DrvMem.Podiums = [int]$script:DrvMem.Podiums + 1; Adjust-Rapport 0.06 }
        elseif ([double]$script:Eng.Mood -le -0.4) { Adjust-Rapport -0.03 }
        else { Adjust-Rapport 0.02 }   # dojety zavod = duvera pomalu roste
        Save-DrvMem
    }
    $m = Get-RaceEndMsg $pos ([int]$script:Eng.StartPos) ([double]$script:Eng.Mood) ([int]$script:Settings.EngStyle)
    Radio-Dyn $m[0] $m[1] -Urgent
}
function Update-Engineer {
    $T = $script:Tel
    if (-not $chkEngineer.Checked) { return }
    if ($script:RadioMuted) { return }   # "bud ticho" - zadne proaktivni hlasky
    $V = [int]$script:Settings.Verbosity  # 0 = jen dulezite, 1 = normalne, 2 = upovidany
    if ([int]$T.Status -lt 1 -and -not $T.Demo) { return }
    # ACC broadcast se prave pripojil -> jednorazova hlaska (rozestupy ted jedou nazivo)
    if ([int]$T.AccBcast -eq 2 -and -not $script:Eng.BcastSaid) {
        $script:Eng.BcastSaid = $true
        Radio-Dyn 'I can see the whole field now - live gaps are on.' 'Vidim cele pole - rozestupy ted jedou nazivo.'
    }
    # nalada pomalu klesa k nule; kdyz se porad neco deje, drzi se vysoko/nizko
    if ([double]$script:Eng.Mood -ne 0) { $sgn = [math]::Sign([double]$script:Eng.Mood); $script:Eng.Mood = [double]$script:Eng.Mood - $sgn * [math]::Min([math]::Abs([double]$script:Eng.Mood), 0.0006) }
    # zapamatuj startovni pozici pro pozavodni "o kolik mist nahoru/dolu"
    if ([int]$T.Session -eq 2 -and [int]$script:Eng.StartPos -eq 0 -and [int]$T.Position -gt 0) { $script:Eng.StartPos = [int]$T.Position }
    # === KONEC ZAVODU: jednou vyhodnot vysledek + naladu, pak uz zadne zavodni hlasky ===
    if ($script:Eng.RaceDone) { return }   # po zavode inzenyr nekomentuje zavod (konec "pletl se po konci")
    if ([int]$T.Session -eq 2) {
        $fin = ([int]$T.Flag -eq 5) -or ([int]$T.NumberOfLaps -gt 0 -and [int]$T.CompletedLaps -ge [int]$T.NumberOfLaps)
        if ($fin) { $script:Eng.RaceDone = $true; Announce-RaceEnd; return }
    }
    if (-not $script:Eng.RadioCheck) { $script:Eng.RadioCheck = $true
        # trvala pamet: dalsi spolecna seance + osobni pozdrav podle povahy, vztahu a minule seance
        $script:DrvMem.Sessions = [int]$script:DrvMem.Sessions + 1
        $script:DrvMem.LastSeen = (Get-Date -Format 'yyyy-MM-dd')
        Save-DrvMem
        if ($V -ge 1) { $nm = if ($script:Settings.EngName) { $script:Settings.EngName } else { 'Engineer' }; Radio 'radiocheck' @($nm)
            $wb = Get-WelcomeBack
            if ($wb) { Radio-Dyn $wb[0] $wb[1] }
        }
    }
    # === TRENINKOVY A KVALIFIKACNI PROGRAM: inzenyr te vede podle typu seance ===
    $sess = [int]$T.Session
    if ($sess -ne [int]$script:Eng.LastSession) {
        $script:Eng.LastSession = $sess
        $script:Eng.PrcSaid = @{}; $script:Eng.QSaid = @{}
        $script:Eng.RaceDone = $false; $script:Eng.Mood = 0.0; $script:Eng.StartPos = 0; $script:Eng.MoodLap = 0
        $script:Eng.OffCount = 0   # limity trate se pocitaji per seance
        if ($V -ge 1) {
            if ($sess -eq 0) { Radio-Dyn 'Practice plan: two easy laps to warm up, then three clean push laps. I will collect data and build you a setup.' 'Plan treninku: dve klidna kola na zahrati, pak tri cista rychla kola. Ja sbiram data a postavim ti setup.' }
            elseif ($sess -eq 1) {
                # KVALA PLAN s konkretnimi cisly: kolik natankovat + kolik pomalych/rychlych kol
                # (spotreba je zapamatovana per trat+vuz ve fuel.json, takze funguje hned od vjezdu)
                $fplE = Get-FuelPerLap
                $lapMsE = 0; $pbK = Get-PBKey
                if ($script:Bests.ContainsKey($pbK)) { $lapMsE = [int]$script:Bests[$pbK] }
                if ($lapMsE -le 0) { $rE = Get-RefLap; if ($rE) { $lapMsE = [int]$rE.ms } }
                $tlE = [double]$T.SessionTimeLeft
                if ($fplE -gt 0 -and $tlE -gt 60000 -and $lapMsE -gt 0) {
                    $fitE = [int]([math]::Floor($tlE / $lapMsE)) - 1          # kolik kol se vejde, minus out-lap
                    $pushE = [math]::Max(1, [math]::Min(4, $fitE - 1))        # rezerva na provoz/ruseny pokus
                    $fuelE = [int][math]::Ceiling((1 + $pushE) * $fplE + 1.0)
                    Radio-Dyn ("Qualifying, {0:0} minutes. The plan: fuel {1} litres, one slow warm-up lap, then {2} push laps. Banker lap first, then chase the time." -f ($tlE/60000.0), $fuelE, $pushE) ("Kvalifikace, {0:0} minut. Plan: natankuj {1} litru, jedno pomale zahrivaci kolo a pak {2} rychla kola. Prvni kolo jistota, pak utoc na cas." -f ($tlE/60000.0), $fuelE, $pushE)
                } else {
                    Radio-Dyn 'Qualifying: out-lap easy on the tyres, warm the brakes, one banker lap first. Fuel light, focus sharp.' 'Kvalifikace: out-lap setri gumy a nahrivej brzdy, prvni kolo jistota. Malo paliva, plne soustredeni.'
                }
            }
            elseif ($sess -eq 2) { Radio-Dyn 'Race. Grid procedure: heat the tyres and brakes on the formation lap, pick your gap, no jump start. Clean getaway and survive turn one.' 'Zavod. Startovni procedura: na zahrivacim kole nahrej gumy a brzdy, vyber si mezeru, zadny predcasny start. Cisty rozjezd a prezij prvni zatacku.' }
        }
    }
    # === START ZAVODU: rozjezd (stani -> jede) v prvnim kole ===
    if ($sess -eq 2 -and [int]$T.CompletedLaps -eq 0 -and -not $script:Eng.PrcSaid['launch'] -and [double]$T.SpeedKmh -gt 25 -and $V -ge 1) {
        $script:Eng.PrcSaid['launch'] = $true
        Radio-Dyn 'Go go go! Clean launch, eyes up, leave yourself room into turn one.' 'Jed jed jed! Cisty rozjezd, hlavu nahoru, nech si misto do prvni zatacky.' -Urgent
    }
    $lapsNow = [int]$T.CompletedLaps
    if ($sess -eq 0 -and $V -ge 1) {
        # TRENINK: milniky podle kol - sber dat -> analyza -> verdikt se setupem
        if ($lapsNow -ge 2 -and -not $script:Eng.PrcSaid['warm']) {
            $script:Eng.PrcSaid['warm'] = $true
            Radio-Dyn 'Warm-up done. Now three clean laps at pace - consistent lines, I am watching temps and pressures.' 'Zahrivaci cast hotova. Ted tri cista kola v tempu - stejne stopy, sleduju teploty a tlaky.'
        }
        if ($lapsNow -ge 4 -and -not $script:Eng.PrcSaid['temps']) {
            $script:Eng.PrcSaid['temps'] = $true
            $tp = $T.TyrePress
            if ($tp -and [double]$tp[0] -gt 15) {
                $avgF = ([double]$tp[0] + [double]$tp[1]) / 2.0; $avgR = ([double]$tp[2] + [double]$tp[3]) / 2.0
                $dF = [math]::Round(($avgF - 27.6) / 0.1); $dR = [math]::Round(($avgR - 27.6) / 0.1)
                if ([math]::Abs($dF) -ge 3 -or [math]::Abs($dR) -ge 3) {
                    Radio-Dyn ("Pressure read: front {0:0.0}, rear {1:0.0} psi. I would go {2} clicks front, {3} rear on the cold pressures." -f $avgF, $avgR, (-$dF), (-$dR)) ("Tlaky: predni {0:0.0}, zadni {1:0.0} psi. Doporucuju {2} kliku vpredu a {3} vzadu na studenych." -f $avgF, $avgR, (-$dF), (-$dR))
                } else {
                    Radio-Dyn 'Pressures are in the window - do not touch them.' 'Tlaky jsou v okne - nesahej na ne.'
                }
            } else {
                Radio-Dyn 'Keep the laps coming - I need more tyre data.' 'Jed dal - potrebuju vic dat z gum.'
            }
        }
        if ($lapsNow -ge 6 -and -not $script:Eng.PrcSaid['verdict']) {
            $script:Eng.PrcSaid['verdict'] = $true
            $issues = @()
            if ([int]$script:Eng.SlipCount -ge 2) { $issues += @('rear is nervous on power - consider more TC or a click of rear wing', 'zadek je nervozni na plyn - zvaz vic TC nebo klik zadniho kridla') }
            if ([int]$script:Eng.LockCount -ge 2) { $issues += @('fronts lock under braking - move brake bias back a touch', 'predky zamykaji pri brzdeni - posun brzdny bias trochu dozadu') }
            if ($issues.Count -ge 2) {
                Radio-Dyn ("Setup verdict: {0}. Say 'prepare setup' and I will write it for you." -f $issues[0]) ("Verdikt setupu: {0}. Rekni 'priprav setup' a ja ti ho zapisu." -f $issues[1])
            } else {
                Radio-Dyn "Car looks balanced. Say 'prepare setup' and I will lock in fuel and pressures." "Auto vypada vyvazene. Rekni 'priprav setup' a ja ti zafixuju palivo a tlaky."
            }
        }
    }
    elseif ($sess -eq 1 -and $V -ge 1) {
        # KVALIFIKACE: pripravenost gum + verdikt po kazdem zajetem kole
        $tt = $T.TyreTemp
        if (-not $script:Eng.QSaid['ready'] -and $tt -and [double]$tt[0] -gt 70 -and [double]$tt[1] -gt 70) {
            $script:Eng.QSaid['ready'] = $true
            Radio-Dyn 'Tyres are in the window - push NOW, this is your lap.' 'Gumy jsou v okne - TED zaber, tohle je tvoje kolo.'
        }
        $fplQ = Get-FuelPerLap
        if (-not $script:Eng.QSaid['fuel'] -and $fplQ -gt 0 -and [double]$T.Fuel -gt (4 * $fplQ)) {
            $script:Eng.QSaid['fuel'] = $true
            Radio-Dyn ("You are carrying too much fuel for quali - {0:0} litres extra is lap time. Pit and dump it." -f ([double]$T.Fuel - 3 * $fplQ)) ("Vezes na kvaldu zbytecne moc paliva - {0:0} litru navic te stoji cas. Zajed a uber." -f ([double]$T.Fuel - 3 * $fplQ))
        }
        if ($lapsNow -gt [int]$script:Eng.QLastLap -and [int]$T.LastTimeMs -gt 0) {
            $script:Eng.QLastLap = $lapsNow
            $best = [int]$T.BestTimeMs
            if ([int]$T.LastTimeMs -le $best) {
                Radio-Dyn ("That is the lap - {0}. Park it or go again if the track is improving." -f (Format-LapTime ([int]$T.LastTimeMs))) ("To je ono - {0}. Zaparkuj, nebo jed znovu, jestli se trat zlepsuje." -f (Format-LapTime ([int]$T.LastTimeMs)))
            } elseif ($script:SecDeltas) {
                $worstQ = 0; $worstQi = -1
                for ($qi = 0; $qi -lt 10; $qi++) { if ([int]$script:SecDeltas[$qi] -gt $worstQ) { $worstQ = [int]$script:SecDeltas[$qi]; $worstQi = $qi } }
                if ($worstQi -ge 0 -and $worstQ -ge 150) {
                    Radio-Dyn ("{0:0.0}s off your best, most of it in sector {1}. One more run - nail that section." -f ($worstQ/1000.0 + 0.0), ($worstQi+1)) ("O {0:0.0} s za tvym maximem, nejvic v useku {1}. Jeste jeden pokus - trefit ten usek." -f ($worstQ/1000.0), ($worstQi+1))
                }
            }
        }
    }
    # === SPOTTER: auto vedle tebe (ACC radar / demo) - hlasky se STRIDAJI, neopakuje se ===
    if ([double]$T.SpeedKmh -gt 40) {
        if ($T.NearLeft -and (([DateTime]::Now - $script:Eng.LastSpotL).TotalSeconds -gt 6)) {
            $script:Eng.LastSpotL = [DateTime]::Now
            $vEn = @('Car left! Hold your line.', 'Watch it - one on your left.', 'Left side occupied, leave him space.', 'Still there on your left, stay wide.')
            $vCs = @('Pozor, mas ho VLEVO! Drz stopu.', 'Bacha, jede vedle tebe VLEVO.', 'Vlevo je obsazeno, nech mu misto.', 'Porad ho mas vlevo, drz se siroko.')
            $vi = Pick-VarIdx 'spotL' $vEn.Count
            Radio-Dyn $vEn[$vi] $vCs[$vi] -Urgent
        }
        if ($T.NearRight -and (([DateTime]::Now - $script:Eng.LastSpotR).TotalSeconds -gt 6)) {
            $script:Eng.LastSpotR = [DateTime]::Now
            $vEn = @('Car right! Hold your line.', 'Watch it - one on your right.', 'Right side occupied, leave him space.', 'Still there on your right, stay wide.')
            $vCs = @('Pozor, mas ho VPRAVO! Drz stopu.', 'Bacha, jede vedle tebe VPRAVO.', 'Vpravo je obsazeno, nech mu misto.', 'Porad ho mas vpravo, drz se siroko.')
            $vi = Pick-VarIdx 'spotR' $vEn.Count
            Radio-Dyn $vEn[$vi] $vCs[$vi] -Urgent
        }
    }
    # === KOUC: skluzy kol - pretacivost (plyn), zablokovana kola (brzda), niceni gum ===
    # POZOR: vnejsi podminka NESMI chtit plyn - lock-up se deje prave pri brzdeni (Gas~0)
    $ws = $T.WheelSlip
    if ($V -ge 1 -and $ws -and $ws.Count -ge 4 -and [double]$T.SpeedKmh -gt 50) {
        $frontSlip = ([double]$ws[0] + [double]$ws[1]) / 2.0
        $rearSlip  = ([double]$ws[2] + [double]$ws[3]) / 2.0
        # NEPAPOUSKOVAT: max 3x za sezeni a nejdriv po 90 s - jednou to stacilo rict
        if ([double]$T.Gas -gt 0.4 -and $rearSlip -gt 1.5 -and ($rearSlip - $frontSlip) -gt 1.2 -and (([DateTime]::Now - $script:Eng.LastSlip).TotalSeconds -gt 90) -and [int]$script:Eng.SlipCount -lt 3 -and $V -ge 1) {
            $script:Eng.LastSlip = [DateTime]::Now
            $script:Eng.SlipCount = [int]$script:Eng.SlipCount + 1; Adjust-Mood -0.12
            # pokazde jina rada - zadne papouskovani
            $vEn = @(
                'Easy on the throttle, rear is stepping out.',
                'Rear end is loose - feed the power in gently.',
                'You are lighting up the rears. Short-shift and be smooth.',
                'Rear is sliding. Straighten the wheel first, then plant the foot.',
                'Traction is on the edge - roll the throttle, do not stab it.'
            )
            $vCs = @(
                'Opatrne na plyn, zadek ti ujizdi.',
                'Zadek je lehky - pridavej plyn postupne.',
                'Protacis zadni kola. Radi o kvalt driv a jed hladce.',
                'Zadek plave. Nejdriv srovnej volant, pak plyn.',
                'Trakce je na hrane - plyn otacej, neslapej po nem.'
            )
            $vi = Pick-VarIdx 'slip' $vEn.Count
            Radio-Dyn $vEn[$vi] $vCs[$vi]
            Add-EventPin 1   # smyk -> pin na mape chyb
        }
        # === ZABLOKOVANA KOLA: predni skluz pri silnem brzdeni ===
        if ($frontSlip -gt 2.0 -and ($frontSlip - $rearSlip) -gt 1.2 -and [double]$T.Brake -gt 0.5 -and [double]$T.SpeedKmh -gt 60 -and (([DateTime]::Now - $script:Eng.LastLock).TotalSeconds -gt 60) -and [int]$script:Eng.LockCount -lt 4 -and $V -ge 1) {
            $script:Eng.LastLock = [DateTime]::Now
            $script:Eng.LockCount = [int]$script:Eng.LockCount + 1; Adjust-Mood -0.15; if (-not $T.Demo) { $script:DrvMem.Locks = [int]$script:DrvMem.Locks + 1 }
            if ([int]$script:Eng.LockCount -ge 3) {
                Radio-Dyn 'Third lock-up - those fronts will have flat spots. Brake earlier and softer.' 'Uz treti blok - na prednich budes mit flatspoty. Brzdi driv a jemneji.'
            } else {
                $vEn = @('You locked the fronts - release a touch, then squeeze again.', 'Front tyres locked. Ease off the brake at turn-in.', 'Careful, you are flat-spotting the fronts - smoother on the pedal.')
                $vCs = @('Zablokoval jsi predky - povol trochu brzdu a pak ji zmackni znovu.', 'Predni kola zamkla. Pri zataceni uber brzdu.', 'Pozor, delas si flatspot na prednich - jemneji na pedal.')
                $vi = Pick-VarIdx 'lock' $vEn.Count
                Radio-Dyn $vEn[$vi] $vCs[$vi]
                Add-EventPin 3   # blok kol -> pin na mape chyb
            }
        }
        # === NICENI GUM: kumulovany cas ve velkem skluzu ===
        $maxSlip = [math]::Max($frontSlip, $rearSlip)
        if ($maxSlip -gt 2.0 -and [double]$T.SpeedKmh -gt 40) { $script:Eng.AbuseSec = [double]$script:Eng.AbuseSec + 0.1 }
        if ([double]$script:Eng.AbuseSec -gt 12 -and [int]$script:Eng.AbuseSaid -lt 2 -and $V -ge 1) {
            $script:Eng.AbuseSec = 0.0
            $script:Eng.AbuseSaid = [int]$script:Eng.AbuseSaid + 1; Adjust-Mood -0.2
            $vEn = @('You are murdering those tyres. Smooth hands, smooth feet - they need to last.', 'Tyre abuse alert - every slide costs you grip later. Calm it down.')
            $vCs = @('Ty gumy vrazdis. Klidne ruce, klidne nohy - musi vydrzet.', 'Nicis pneumatiky - kazdy smyk te pozdeji stoji grip. Zklidni to.')
            $vi = Pick-VarIdx 'abuse' $vEn.Count
            Radio-Dyn $vEn[$vi] $vCs[$vi]
        }
    }
    # === LIMITY TRATI: iRacing presne (OffTrack), jinak heuristika (vsechna 4 kola prokluzuji = trava/sterk) ===
    $ws = $T.WheelSlip
    $all4 = ($ws -and $ws.Count -ge 4 -and [double]$ws[0] -gt 2.5 -and [double]$ws[1] -gt 2.5 -and [double]$ws[2] -gt 2.5 -and [double]$ws[3] -gt 2.5)
    if ((Co 'CoContact') -and (([bool]$T.OffTrack) -or ($all4 -and [double]$T.SpeedKmh -gt 80 -and [double]$T.Brake -lt 0.3)) -and (([DateTime]::Now - $script:Eng.LastOff).TotalSeconds -gt 12) -and $V -ge 1) {
        $script:Eng.LastOff = [DateTime]::Now; Adjust-Mood -0.1
        $script:Eng.OffCount = [int]$script:Eng.OffCount + 1   # pocitadlo prohresku za seanci (v ACC 3+ varovani = penalizace)
        if (-not $T.Demo) { $script:DrvMem.Offtracks = [int]$script:DrvMem.Offtracks + 1 }
        $offN = [int]$script:Eng.OffCount
        if ($offN -eq 3) {
            Radio-Dyn 'Third track limits warning! One more and you are looking at a penalty - stay inside the lines.' 'Treti varovani za limity trate! Jeste jedno a hrozi penalizace - drz to uvnitr car.'
        } elseif ($offN -gt 3) {
            Radio-Dyn ('Track limits again - that is number {0}. You are gambling with a penalty now.' -f $offN) ('Zase limity trate - uz po {0}. Hrajes si s penalizaci.' -f $offN)
        } else {
            $vEn = @('Careful, you ran wide - watch the track limits or they delete the lap.', 'All four wheels off there - keep it inside the white lines.', 'Track limits! Tidy it up or you lose the time.')
            $vCs = @('Pozor, jel jsi siroko - hlidej limity trate, nebo ti smaznou kolo.', 'Vsechna ctyri kola venku - drz to uvnitr bilych car.', 'Limity trate! Srovnej to, nebo prijdes o cas.')
            $vi = Pick-VarIdx 'offtrack' $vEn.Count; Radio-Dyn $vEn[$vi] $vCs[$vi]
        }
        Add-EventPin 1
    }
    # === PREDJETI: zmena pozice v zavode -> pochvala / povzbuzeni / urazka (podle povahy) ===
    if ([int]$T.Session -eq 2 -and [int]$T.Position -gt 0 -and [int]$T.CompletedLaps -ge 1 -and [int]$T.IsInPit -eq 0 -and $V -ge 1) {
        $curPos = [int]$T.Position
        if ([int]$script:Eng.LastPos -eq 0) { $script:Eng.LastPos = $curPos; $script:Eng.PosStableAt = [DateTime]::Now }
        elseif ($curPos -ne [int]$script:Eng.LastPos -and (([DateTime]::Now - $script:Eng.PosStableAt).TotalSeconds -gt 8)) {
            $oldPos = [int]$script:Eng.LastPos
            $script:Eng.LastPos = $curPos; $script:Eng.PosStableAt = [DateTime]::Now
            $drsnak = ([int]$script:Settings.EngStyle -eq 1)
            if ($curPos -lt $oldPos) {
                # PREDJEL JSI -> pochvala
                $vEn = @(("P{0}! Lovely move, keep it clean." -f $curPos), ("That's P{0} - great job, now build a gap." -f $curPos), ("Overtake done, P{0}. Tidy work." -f $curPos))
                $vCs = @(("P{0}! Krasny manevr, jen tak dal." -f $curPos), ("A je to P{0} - parada, ted si udelej naskok." -f $curPos), ("Predjeti hotovo, P{0}. Cista prace." -f $curPos))
                if ($drsnak) { $vEn += @(("P{0}. Finally some racing from you." -f $curPos), ("P{0}! Hell yes, you beauty! Now get the next one." -f $curPos), ("Holy shit, P{0}. That was actually a proper move. Do not let it go to your head." -f $curPos)); $vCs += @(("P{0}. No konecne zavodis." -f $curPos), ("P{0}! Ty krávo, pěkný! Teď dalšího." -f $curPos), ("Do prdele, P{0}. To byl fakt slušnej manévr. Hlavně ať ti to nestoupne do hlavy." -f $curPos)) }
                $vi = Pick-VarIdx 'posUp' $vEn.Count
                Radio-Dyn $vEn[$vi] $vCs[$vi]; Adjust-Mood 0.3
            } else {
                # PREDJELI TE -> povzbuzeni, drsnak si rejpne
                if ($drsnak) {
                    $vEn = @(("P{0}?! That was weak as fuck - go get him back." -f $curPos), ("He walked right past you. P{0}. Embarrassing - fix it." -f $curPos), ("Lost to P{0}. Are we racing or sightseeing?" -f $curPos), ("P{0}. My grandma parks faster than you defend." -f $curPos), ("He didn't even say thanks for letting him by. P{0}." -f $curPos), ("P{0}. Did you brake to wave at him?" -f $curPos), ("P{0}. He drove past you like you were a fucking traffic cone." -f $curPos), ("For fuck's sake, P{0}. Did he overtake you, or did you move over out of respect?" -f $curPos))
                    $vCs = @(("P{0}?! To bylo slabý jak čaj - vrať mu to, kurva." -f $curPos), ("Prosel kolem tebe jak kolem kuzelu. P{0}. Trapne - naprav to." -f $curPos), ("Spadl jsi na P{0}. Zavodime, nebo se kochame?" -f $curPos), ("P{0}. Moje babicka parkuje rychlejc, nez ty branis." -f $curPos), ("Ani nepodekoval, zes ho pustil. P{0}." -f $curPos), ("P{0}. Tys brzdil, abys mu zamaval?" -f $curPos), ("P{0}. Projel kolem tebe, jako bys byl zasranej kužel." -f $curPos), ("Do prdele, P{0}. On tě předjel, nebo jsi mu uhnul z úcty?" -f $curPos))
                } else {
                    $vEn = @(("Lost a spot, P{0}. Stay calm, he is in reach - get him on the exit." -f $curPos), ("P{0} now. No panic - keep your pace, mistakes will come from him." -f $curPos), ("He got you, P{0}. Stick with him and strike late on the brakes." -f $curPos))
                    $vCs = @(("Prisel jsi o pozici, P{0}. Klid, mas ho na dosah - dostan ho na vyjezdu." -f $curPos), ("Ted P{0}. Zadna panika - drz tempo, chybu udela on." -f $curPos), ("Dostal te, P{0}. Drz se ho a uder pozde na brzdach." -f $curPos))
                }
                $vi = Pick-VarIdx 'posDn' $vEn.Count
                Radio-Dyn $vEn[$vi] $vCs[$vi]; Adjust-Mood -0.3
            }
        }
    }
    # === SOUBOJ KOLO NA KOLO: trva-li souboj, poradi taktiku ===
    # (ne v 1. kole zavodu - na startu je pole nahusto, to neni souboj)
    $nearAny = ($T.NearLeft -or $T.NearRight)
    if ($nearAny -and [double]$T.SpeedKmh -gt 60 -and ([int]$T.CompletedLaps -ge 1 -or [int]$T.Session -ne 2)) {
        $sideNow = if ($T.NearRight) { 'R' } else { 'L' }
        if ($script:Eng.BattleSide -ne $sideNow) { $script:Eng.BattleSide = $sideNow; $script:Eng.BattleSince = [DateTime]::Now }
        elseif ((([DateTime]::Now - $script:Eng.BattleSince).TotalSeconds -gt 4) -and (([DateTime]::Now - $script:Eng.LastBattle).TotalSeconds -gt 25) -and $V -ge 1) {
            $script:Eng.LastBattle = [DateTime]::Now
            $sideEn = if ($sideNow -eq 'R') { 'right' } else { 'left' }
            $sideCs = if ($sideNow -eq 'R') { 'vpravo' } else { 'vlevo' }
            if ([int]$T.Session -eq 2) {
                # ZAVOD: takticke rady do souboje
                if ([double]$T.Gas -gt 0.85 -and [double]$T.NearClosing -gt 0.6) {
                    # soupere stahuje i pri nasem plnem plynu -> ma vyssi rychlost, nebranit
                    $vEn = @(("He is {0} and has the pace on you - no point defending, focus on your exit speed." -f $sideEn), ("He is quicker on the straight, {0} side. Let it go, beat him in the corners." -f $sideEn))
                    $vCs = @(("Je {0} a ma na tebe rychlost - nema cenu branit, soustred se na rychlost vyjezdu." -f $sideCs), ("Na rovince je rychlejsi, je {0}. Pust to, porazis ho v zatackach." -f $sideCs))
                } else {
                    $vEn = @(("Side by side, he is {0}. Hold your line, make him go the long way." -f $sideEn), ("Wheel to wheel on the {0}. Give him room, but do not make it easy." -f $sideEn), ("Battle on the {0} side - brake late but keep it clean." -f $sideEn))
                    $vCs = @(("Kolo na kolo, je {0}. Drz stopu, at to objizdi delsi cestou." -f $sideCs), ("Souboj {0}. Nech mu prostor, ale nedavej mu to zadarmo." -f $sideCs), ("Bitva na strane {0} - brzdi pozde, ale cisto." -f $sideCs))
                }
                $vi = Pick-VarIdx 'battle' $vEn.Count
                Radio-Dyn $vEn[$vi] $vCs[$vi]
            } else {
                # KVALA/TRENINK: zadny souboj - rekni ROZESTUP v sekundach a porad najit si volny vzduch
                $gapS = if ([double]$T.SpeedKmh -gt 10 -and [double]$T.NearDist -lt 90) { [double]$T.NearDist / ([double]$T.SpeedKmh / 3.6) } else { -1.0 }
                $gapEn = if ($gapS -ge 0) { (" Gap {0:0.0} seconds." -f $gapS) } else { '' }
                $gapCs = if ($gapS -ge 0) { (" Rozestup {0:0.0} sekundy." -f $gapS) } else { '' }
                $vEn = @(("Traffic {0}.{1} This is not a race - lift, let him go and find clear air for a clean lap." -f $sideEn, $gapEn), ("Car {0}, you are losing time in his dirty air.{1} Back off and build a gap." -f $sideEn, $gapEn), ("Forget him, he is {0}.{1} Make yourself space on track - the lap starts with clear air." -f $sideEn, $gapEn))
                $vCs = @(("Provoz {0}.{1} Tohle neni zavod - zvedni to, pust ho a najdi si volny vzduch na ciste kolo." -f $sideCs, $gapCs), ("Auto {0}, ztracis v jeho spinavem vzduchu.{1} Uber a udelej si mezeru." -f $sideCs, $gapCs), ("Zapomen na nej, je {0}.{1} Udelej si misto na trati - rychle kolo zacina volnym vzduchem." -f $sideCs, $gapCs))
                $vi = Pick-VarIdx 'qtraffic' $vEn.Count
                Radio-Dyn $vEn[$vi] $vCs[$vi]
            }
        }
    } else { $script:Eng.BattleSide = '' }
    # === BOX: pri vjezdu do boxu Jerry nadiktuje presnou strategii ===
    $inPitNow = ([int]$T.IsInPit -eq 1)
    if ($inPitNow -and -not $script:Eng.WasInPit) {
        $fplP = Get-FuelPerLap
        $raceLeftP = if ([int]$T.NumberOfLaps -gt 0) { [int]$T.NumberOfLaps - [int]$T.CompletedLaps } else { -1 }
        if ($fplP -gt 0 -and $raceLeftP -gt 0) {
            $needP = [math]::Max(0.0, $raceLeftP * $fplP - [double]$T.Fuel) + 1.5   # +1.5 l rezerva
            if ([double]$T.MaxFuel -gt 0) { $needP = [math]::Min($needP, [double]$T.MaxFuel) }
            $tw = $T.TyreWear; $minW = if ($tw -and [double]$tw[0] -gt 1) { [int](($tw | Measure-Object -Minimum).Minimum) } else { 100 }
            $tyreEn = if ($minW -lt 88) { 'fresh tyres on' } else { 'tyres stay' }
            $tyreCs = if ($minW -lt 88) { 'nove gumy' } else { 'gumy nechavame' }
            Radio-Dyn ("Box confirmed. Fuel {0:0} litres, {1}. Set it on the pit menu, I have the numbers ready." -f $needP, $tyreEn) ("Box potvrzen. Palivo {0:0} litru, {1}. Nastav to v pit menu, cisla mas ode me." -f $needP, $tyreCs) -Urgent
        } else {
            Radio-Dyn 'Box confirmed. No race distance data - fuel to your call.' 'Box potvrzen. Bez znameho konce zavodu tankuj podle sebe.'
        }
        $script:PitPlan = $false
    }
    # VYJEZD Z BOXU v kvale/treninku: poradi, jestli je na trati misto na ciste kolo
    if (-not $inPitNow -and $script:Eng.WasInPit -and [int]$T.Session -ne 2 -and $V -ge 1) {
        if ([double]$T.NearDist -lt 60) {
            $gapO = if ([double]$T.SpeedKmh -gt 10) { (" {0:0.0} s" -f ([double]$T.NearDist / ([double]$T.SpeedKmh / 3.6))) } else { '' }
            Radio-Dyn ("Traffic close on pit exit{0} - take the out-lap easy, let them by and build your gap." -f $gapO) ("Na vyjezdu je provoz{0} - out-lap v klidu, pust je a udelej si mezeru." -f $gapO)
        } else {
            Radio-Dyn 'Pit exit clear - track is yours, warm the tyres and go for it.' 'Vyjezd cisty - trat je tva, nahrej gumy a jdi na to.'
        }
    }
    $script:Eng.WasInPit = $inPitNow
    $laps = [int]$T.CompletedLaps
    if ($laps -gt $script:Eng.LastLap) {
        $script:Eng.LastLap = $laps; $last = [int]$T.LastTimeMs; $best = [int]$T.BestTimeMs
        if ((Co 'CoLaps') -and $last -gt 0 -and $best -gt 0) {
            $d = ($last - $best) / 1000.0
            if ($last -le $best) { Adjust-Mood 0.35; if ($V -ge 1) { Radio 'purple' @() } }
            elseif ($V -ge 2 -or ($V -ge 1 -and $d -gt 1.0)) { Radio 'off' @((Format-LapTime $last), ("{0:0.0} s" -f $d)) }
        }
        # zaznam opotrebeni gum po kole (trend pro rady i lokalniho inzenyra)
        $tw2 = $T.TyreWear; $mw = -1.0
        if ($tw2 -and $tw2.Count -ge 4 -and [double]$tw2[0] -gt 1) {
            $mw = [double](($tw2 | Measure-Object -Minimum).Minimum)
            [void]$script:WearHist.Add(@($laps, $mw))
            while ($script:WearHist.Count -gt 60) { $script:WearHist.RemoveAt(0) }
        }
        # === TEMPO KOUC: jednou za 3 kola rekne, jestli drzet / pridat / ubrat ===
        if ((Co 'CoLaps') -and $V -ge 1 -and $laps -ge 3 -and ($laps - [int]$script:Eng.LastPaceAt) -ge 3 -and $last -gt 0 -and $best -gt 0) {
            $script:Eng.LastPaceAt = $laps
            $dp = ($last - $best) / 1000.0
            $maxTp = [int](($T.TyreTemp | Measure-Object -Maximum).Maximum)
            $drsT = ([int]$script:Settings.EngStyle -eq 1)
            if ($maxTp -gt 103) { if ($drsT) { Radio-Dyn 'Back off a tenth, the tyres are on fire, you pyromaniac.' 'Uber desetinku, gumy hoří, ty pyromane.' } else { Radio-Dyn 'Pace check: back off a tenth, tyres are running hot.' 'Tempo: uber desetinku, gumy jedou horke.' } }
            elseif ($dp -le 0.4) { if ($drsT) { Radio-Dyn 'Pace is there. Now do not fuck it up.' 'Tempo sedí. Teď to hlavně neposer.' } else { Radio-Dyn 'Pace is good - hold this rhythm.' 'Tempo mas - drz tenhle rytmus.' } }
            elseif ($dp -ge 1.2) { if ($drsT) { Radio-Dyn ("You are {0:0.0} seconds off your own pace. What is this, a sunday drive? PUSH, damn it." -f $dp) ("Ztrácíš {0:0.0} sekundy na vlastní maximum. Co to je, nedělní vyjížďka? MAKEJ, kurva." -f $dp) } else { Radio-Dyn ("You have more in it - {0:0.0}s off your best. Push." -f $dp) ("Mas na vic - ztracis {0:0.0} s na svoje maximum. Pridej." -f $dp) } }
        }
        # === GAP KOUC (F1/iRacing): v zavode kazda 3 kola rozestup + jaky cas potrebujes na dohnani ===
        if ((Co 'CoLaps') -and $V -ge 1 -and [bool]$T.RivOk -and [int]$T.Session -eq 2 -and $laps -ge 2 -and ($laps - [int]$script:Eng.LastGapAt) -ge 3) {
            $gapAh = [double]$T.RivAheadGap
            if ($gapAh -gt 0.5 -and $gapAh -lt 120) {
                $script:Eng.LastGapAt = $laps
                $rl2 = if ([int]$T.NumberOfLaps -gt 0) { [int]$T.NumberOfLaps - $laps } else { -1 }
                if ($rl2 -gt 0) {
                    $needG2 = $gapAh / $rl2
                    Radio-Dyn ("Gap ahead {0:0.0} seconds. Find {1:0.00} a lap and you have him before the flag." -f $gapAh, $needG2) ("Na auto pred tebou {0:0.0} sekundy. Najdi {1:0.00} na kolo a mas ho pred cilem." -f $gapAh, $needG2)
                } else {
                    Radio-Dyn ("Gap ahead {0:0.0} seconds - keep chipping away." -f $gapAh) ("Na auto pred tebou {0:0.0} sekundy - ukrajuj po kousku." -f $gapAh)
                }
            } elseif ([double]$T.RivBehindGap -gt 0.5 -and [double]$T.RivBehindGap -lt 5) {
                $script:Eng.LastGapAt = $laps
                Radio-Dyn ("He is {0:0.0} back and hunting - clean laps now, no mistakes." -f [double]$T.RivBehindGap) ("Za tebou {0:0.0} sekundy a dotahuje - ted cista kola, zadna chyba." -f [double]$T.RivBehindGap)
            }
        }
        # === HLIDKA GUM: jednou za 4 kola stav + setrime/nesetrime ===
        if ((Co 'CoTyres') -and $V -ge 1 -and $mw -gt 0 -and ($laps - [int]$script:Eng.LastTyreTalk) -ge 4 -and $script:WearHist.Count -ge 3) {
            $script:Eng.LastTyreTalk = $laps
            $w0 = $script:WearHist[[math]::Max(0, $script:WearHist.Count - 4)]; $w1 = $script:WearHist[$script:WearHist.Count - 1]
            $dl = [int]$w1[0] - [int]$w0[0]
            if ($dl -gt 0) {
                $rate = ([double]$w0[1] - [double]$w1[1]) / $dl
                $raceLeftT = if ([int]$T.NumberOfLaps -gt 0) { [int]$T.NumberOfLaps - $laps } else { -1 }
                if ($rate -le 0.12) { Radio-Dyn ("Tyres {0:0} percent - you're saving them nicely." -f $mw) ("Gumy {0:0} procent - setris je hezky." -f $mw) }
                else {
                    $toLimit = if ($rate -gt 0) { [math]::Floor(($mw - 80.0) / $rate) } else { 999 }
                    if ($raceLeftT -gt 0 -and $toLimit -lt $raceLeftT) { Radio-Dyn ("Tyres going fast - {0:0} percent, about {1} laps left in them. Save them in the quick corners." -f $mw, $toLimit) ("Gumy zereme moc - {0:0} procent, vydrzi ~{1} kol. Setri v rychlych zatackach." -f $mw, $toLimit) }
                    elseif ($V -ge 2) { Radio-Dyn ("Tyres {0:0} percent, wear {1:0.0} a lap - fine to the flag." -f $mw, $rate) ("Gumy {0:0} procent, ubytek {1:0.0} na kolo - do cile dobry." -f $mw, $rate) }
                }
            }
        }
        # === konzistence pochvala (jen upovidany rezim) ===
        if ((Co 'CoLaps') -and $V -ge 2 -and $script:LapList.Count -ge 3 -and ($laps - [int]$script:Eng.ConsistAt) -ge 5) {
            $l3 = @($script:LapList | Select-Object -Last 3)
            $spread = ((($l3 | Measure-Object -Maximum).Maximum) - (($l3 | Measure-Object -Minimum).Minimum)) / 1000.0
            if ($spread -lt 0.35) { $script:Eng.ConsistAt = $laps; Adjust-Mood 0.15; Radio-Dyn 'Beautifully consistent - three laps like carbon copies.' 'Krasna konzistence - tri kola jak pres kopirak.' }
        }
        # === NALADA: kdyz to dlouho jede super/blbe, inzenyr to da najevo (1x za 4 kola) ===
        if ($V -ge 1 -and ($laps - [int]$script:Eng.MoodLap) -ge 4) {
            $mo = [double]$script:Eng.Mood
            $drsM = ([int]$script:Settings.EngStyle -eq 1)
            if ($mo -ge 0.5) { $script:Eng.MoodLap = $laps
                if ($drsM) { Radio-Dyn 'Fuck me, you are actually flying today. Keep it up and I take back half the shit I said.' 'Ty vole, dneska fakt letíš. Vydrž a půlku těch sraček, co jsem řekl, beru zpět.' }
                else { Radio-Dyn 'Loving this - you are in the zone, keep it rolling.' 'Tohle si uzivam - jsi v zone, jen tak dal.' } }
            elseif ($mo -le -0.5) { $script:Eng.MoodLap = $laps
                if ($drsM) { Radio-Dyn 'This is painful to watch. Pull your head out of your ass and give me ONE clean lap.' 'Tohle bolí sledovat, kurva. Vytáhni hlavu z prdele a dej mi JEDNO čistý kolo.' }
                else { Radio-Dyn 'Rough patch, I know. Reset, breathe, one clean lap at a time.' 'Vim, je to tezke. Zhluboka, srovnej se, kolo po kole cisto.' } }
        }
        # === polovina zavodu ===
        if ((Co 'CoCount') -and $V -ge 1 -and [int]$T.NumberOfLaps -ge 6 -and $laps -eq [math]::Ceiling([int]$T.NumberOfLaps / 2.0) -and -not $script:Eng.SaidLapsLeft.ContainsKey('half')) {
            $script:Eng.SaidLapsLeft['half'] = $true
            $posTxt = if ([int]$T.Position -gt 0) { " P{0}." -f [int]$T.Position } else { "" }
            Radio-Dyn ("Half distance.{0} Fuel plan on target, keep it clean." -f $posTxt) ("Polovina zavodu.{0} Palivo podle planu, jed ciste." -f $posTxt)
        }
    }
    $fpl = Get-FuelPerLap
    if ($fpl -gt 0 -and (Co 'CoFuel')) {
        $fuel = [double]$T.Fuel; $lapsOnFuel = [math]::Floor($fuel / $fpl); $raceLeft = -1
        if ([int]$T.NumberOfLaps -gt 0) { $raceLeft = [int]$T.NumberOfLaps - $laps }
        if ($raceLeft -ge 0) {
            $short = $raceLeft - $lapsOnFuel
            if ($short -gt 0 -and -not $script:Eng.FuelWarned -and $V -ge 1) { $script:Eng.FuelWarned = $true; Radio 'fuelwarn' @($short) }
            if ($lapsOnFuel -le 1 -and $raceLeft -ge 1 -and -not $script:Eng.FuelCritical) { $script:Eng.FuelCritical = $true; Adjust-Mood -0.1; Radio 'fuelcrit' @() -Urgent }
        }
    }
    if ($fpl -gt 0 -and (Co 'CoCount')) {
        $raceLeft2 = if ([int]$T.NumberOfLaps -gt 0) { [int]$T.NumberOfLaps - $laps } else { -1 }
        if ($raceLeft2 -ge 1 -and $raceLeft2 -le 3 -and -not $script:Eng.SaidLapsLeft.ContainsKey($raceLeft2)) {
            $script:Eng.SaidLapsLeft[$raceLeft2] = $true
            if ($raceLeft2 -eq 1) { Radio 'lastlap' @() -Urgent } elseif ($V -ge 1) { Radio 'togo' @($raceLeft2) }
        }
    }
    $tt = $T.TyreTemp
    if ((Co 'CoTyres') -and $V -ge 1 -and $tt -and $tt.Count -ge 4) { $maxT = ($tt | Measure-Object -Maximum).Maximum
        if ($maxT -gt 105 -and (([DateTime]::Now - $script:Eng.LastTyreWarn).TotalSeconds -gt 40)) { $script:Eng.LastTyreWarn = [DateTime]::Now; Radio 'tyres' @() }
    }
    # === PINDY MIMO TEMA (drsnak): nic se nedeje -> nahodna poznamka do vysilacky (jak na klipech) ===
    if ([int]$script:Settings.EngStyle -eq 1 -and $V -ge 1 -and [double]$T.SpeedKmh -gt 50 -and [int]$T.IsInPit -eq 0 -and -not ($T.NearLeft -or $T.NearRight)) {
        if ($script:Eng.LastBanter -eq [DateTime]::MinValue) { $script:Eng.LastBanter = [DateTime]::Now }   # nikdy hned po startu
        if ([int]$script:Eng.BanterGap -le 0) { $script:Eng.BanterGap = Get-Random -Minimum 75 -Maximum 160 }
        if (([DateTime]::Now - $script:Eng.LastBanter).TotalSeconds -gt [int]$script:Eng.BanterGap) {
            $script:Eng.LastBanter = [DateTime]::Now
            $script:Eng.BanterGap = Get-Random -Minimum 75 -Maximum 160
            $bn = [math]::Min($script:Banter.cs.Count, $script:Banter.en.Count)
            $bi = Pick-VarIdx 'banter' $bn
            Radio-Dyn $script:Banter.en[$bi] $script:Banter.cs[$bi]
        }
    }
}

# --- DENI NA TRATI: vlajky (ACC) + detekce kontaktu/naboru z pretizeni a poklesu rychlosti ---
$script:Ev = @{ LastFlag = 0; LastFlagAt = [DateTime]::MinValue; LastHitAt = [DateTime]::MinValue; PrevSpeed = 0.0; PrevDamage = 0.0; LastDamageAt = [DateTime]::MinValue }
function Update-Events {
    $T = $script:Tel
    $spd = [double]$T.SpeedKmh
    $prevSpd = $script:Ev.PrevSpeed; $script:Ev.PrevSpeed = $spd
    if (-not $chkEngineer.Checked) { return }
    if ($script:RadioMuted) { return }
    if ($script:Eng.RaceDone) { return }   # po zavode uz zadne udalosti/vlajky
    $V = [int]$script:Settings.Verbosity
    if ([int]$T.Status -lt 2 -and -not $T.Demo) { return }
    # vlajky - hlaska pri zmene (ACC; AC vlajky v pameti nema)
    $fl = [int]$T.Flag
    if ($fl -ne [int]$script:Ev.LastFlag) {
        $now = [DateTime]::Now
        if ((Co 'CoFlags') -and ($now - $script:Ev.LastFlagAt).TotalSeconds -gt 15) {
            switch ($fl) {
                2 { Radio 'yellow' @() -Urgent; $script:Ev.LastFlagAt = $now }
                1 { if ($V -ge 1) { Radio 'blue' @() }; $script:Ev.LastFlagAt = $now }
                5 { Radio 'checkered' @(); $script:Ev.LastFlagAt = $now }
            }
        }
        $script:Ev.LastFlag = $fl
    }
    # kontakt / narazy: spicka kombinovaneho pretizeni NEBO prudky pokles rychlosti
    # (GT3 v zatacce ~3G, brzdeni ~2.9G -> prahy nad tim; pokles je za 100ms tick)
    $mag = [math]::Sqrt([double]$T.AccLat * [double]$T.AccLat + [double]$T.AccLon * [double]$T.AccLon)
    $drop = $prevSpd - $spd
    # kontakt vyzaduje G spicku A ZAROVEN ztratu rychlosti (skok/obrubnik = spicka bez ztraty;
    # tvrde brzdeni = ztrata bez naroveho G a s seslapnutou brzdou -> ani jedno neni kontakt)
    if ((Co 'CoContact') -and (([DateTime]::Now) - $script:Ev.LastHitAt).TotalSeconds -gt 10 -and $prevSpd -gt 40) {
        if (($mag -gt 9.0 -and $drop -gt 25) -or $drop -gt 45) { $script:Ev.LastHitAt = [DateTime]::Now; Adjust-Mood -0.6; if (-not $T.Demo) { $script:DrvMem.Crashes = [int]$script:DrvMem.Crashes + 1; Adjust-Rapport -0.02; Save-DrvMem }; Radio-Roast 'crash' -Urgent; Add-EventPin 2 }
        elseif ($mag -gt 6.0 -and $drop -gt 12 -and [double]$T.Brake -lt 0.7 -and $V -ge 1) { $script:Ev.LastHitAt = [DateTime]::Now; Adjust-Mood -0.35; if (-not $T.Demo) { $script:DrvMem.Contacts = [int]$script:DrvMem.Contacts + 1; Save-DrvMem }; Radio-Roast 'contact' ; Add-EventPin 2 }
        elseif ($drop -gt 22 -and $mag -lt 6.0 -and [double]$T.Brake -lt 0.6 -and [double]$T.SpeedKmh -lt ($prevSpd * 0.6) -and $V -ge 1) { $script:Ev.LastHitAt = [DateTime]::Now; Adjust-Mood -0.4; if (-not $T.Demo) { $script:DrvMem.Spins = [int]$script:DrvMem.Spins + 1; Save-DrvMem }; Radio-Roast 'spin' ; Add-EventPin 1 }   # hvezdicka: prudka ztrata bez naroveho G
    }
    # POSKOZENI: skok v celkovem poskozeni vozu (jen kde damage ctem: AC/ACC/F1) -> hlaska + drsnak varianta
    if ((Co 'CoContact') -and [bool]$T.HasDamage -and $V -ge 1) {
        $dmg = [double]$T.Damage; $prevDmg = [double]$script:Ev.PrevDamage; $script:Ev.PrevDamage = $dmg
        if (($dmg - $prevDmg) -gt 0.8 -and (([DateTime]::Now) - $script:Ev.LastDamageAt).TotalSeconds -gt 20) {
            $script:Ev.LastDamageAt = [DateTime]::Now; Adjust-Mood -0.2; Add-EventPin 2
            $vEn = @('You picked up damage - watch the handling, might need a pit stop.', 'Car took a hit, it will feel different now - be smooth.', 'Damage on the car. Nurse it and think about the box.')
            $vCs = @('Nabral jsi poskozeni - hlidej chovani auta, mozna bude potreba box.', 'Auto to schytalo, bude se chovat jinak - jed jemne.', 'Poskozeni na voze. Setri ho a mysli na box.')
            if ([int]$script:Settings.EngStyle -eq 1) {
                $vEn += @('Great, now the car is broken too. Try to finish it in one piece.', 'You wrecked the aero. Hope it was worth it.', 'The car is fucked and so is my patience. Nurse it home.', 'You broke the car, genius. The mechanics send their regards. And a bill.')
                $vCs += @('Super, ted je rozbity i auto. Zkus to aspon dovezt vcelku.', 'Zdemoloval jsi aero. Snad to stalo za to.', 'Auto je v prdeli a moje trpělivost taky. Dovez to domů.', 'Rozbil jsi auto, génie. Mechanici tě pozdravujou. A posílají fakturu.')
            }
            $vi = Pick-VarIdx 'damage' $vEn.Count; Radio-Dyn $vEn[$vi] $vCs[$vi]
        }
    } else { $script:Ev.PrevDamage = [double]$T.Damage }
}

# ============================================================
#  LOKALNI INZENYR - odpovida z telemetrie OKAMZITE, bez API klice
# ============================================================
function Get-LocalAnswer([string]$q, [string]$forceLang = '') {
    # dotaz pro porovnavani slozime bez diakritiky ('cas'=='čas'), aby regexy chytaly i s hackami
    $T = $script:Tel; $ql = (($q.ToLower()).Normalize([Text.NormalizationForm]::FormD)) -replace '\p{Mn}', ''
    $effL = if ($forceLang) { $forceLang } else { Detect-Lang $q }
    if (-not $effL) { $effL = Get-EngLang }
    $cs = ($effL -eq 'cs')
    $fpl = Get-FuelPerLap
    $lapsOnFuel = if ($fpl -gt 0) { [math]::Floor([double]$T.Fuel / $fpl) } else { -1 }
    $raceLeft = if ([int]$T.NumberOfLaps -gt 0) { [int]$T.NumberOfLaps - [int]$T.CompletedLaps } else { -1 }
    $styleTail = ''
    switch ([int]$script:Settings.EngStyle) {
        1 { $r0 = [double]$script:DrvMem.Rapport   # vztah meni ton: drsnak co ti veri je porad drsnak, ale svuj
            $styleTail = if ($r0 -ge 0.5) { if ($cs) { ' Makej. Vis, ze ti verim.' } else { ' Push. You know I trust you.' } } else { if ($cs) { ' Tak makej, kurva.' } else { ' Now fucking push.' } } }
        2 { $r0 = [double]$script:DrvMem.Rapport
            $styleTail = if ($r0 -ge 0.5) { if ($cs) { ' Jedes skvele, jako vzdycky!' } else { ' You are doing great, as always!' } } else { if ($cs) { ' Jedes skvele!' } else { ' You are doing great!' } } }
    }
    # TRVALA PAMET: "co o mne vis / co si pamatujes" -> inzenyr odrecituje profil (i bez API klice)
    if ($ql -match 'co o mne vis|co si pamatujes|co o mne mas|znas me|kolik mame seanci|what do you know about me|what do you remember|do you know me') {
        $m = $script:DrvMem
        $inc = [int]$m.Crashes + [int]$m.Contacts + [int]$m.Spins
        $base = if ($cs) { ("Znam te dobre: {0} seanci spolu, {1} zavodu, {2} vyher, {3} podii, {4} osobnich rekordu, {5} kol v nohach a {6} incidentu." -f [int]$m.Sessions, [int]$m.Races, [int]$m.Wins, [int]$m.Podiums, [int]$m.PBs, [int]$m.TotalLaps, $inc) }
            else { ("I know you well: {0} sessions together, {1} races, {2} wins, {3} podiums, {4} personal bests, {5} laps of experience and {6} incidents." -f [int]$m.Sessions, [int]$m.Races, [int]$m.Wins, [int]$m.Podiums, [int]$m.PBs, [int]$m.TotalLaps, $inc) }
        $nts = @($m.Notes | Select-Object -Last 3)
        if ($nts.Count -gt 0) { $base += if ($cs) { (' A pamatuju si: ' + ($nts -join '; ') + '.') } else { (' And I remember: ' + ($nts -join '; ') + '.') } }
        return ($base + $styleTail)
    }
    # POTREBNE TEMPO / DOHNAT SOUPERE / "jaky cas musim zajet" (musi byt PRED palivem/koly/casem)
    if ($ql -match '(dohn|catch)\s*p?\d' -or $ql -match 'musim zajet|musím zajet' -or ($ql -match 'jak\w*\s*(cas|čas|tempo|time|pace)' -and $ql -match 'mus|potreb|potřeb|dohn|catch|need')) {
        # F1/iRacing: zname rozestup i tempo soupere -> spocitame POTREBNY CAS NA KOLO
        if ([bool]$T.RivOk -and [double]$T.RivAheadGap -gt 0 -and $raceLeft -gt 0) {
            $gapA = [double]$T.RivAheadGap
            $needG = $gapA / $raceLeft
            $their = [int]$T.RivAheadMs
            $tgtTxt = if ($their -gt 0) { (Format-LapTime ([int]($their - $needG * 1000))) } else { '' }
            $ansT = if ($cs) { ("Auto pred tebou ma naskok {0:0.0} s a posledni kolo jelo {1}. Do konce {2} kol - musis byt o {3:0.00} s na kolo rychlejsi nez on{4}." -f $gapA, $(if ($their -gt 0) { Format-LapTime $their } else { '?' }), $raceLeft, $needG, $(if ($tgtTxt) { ", cili jezdi pod " + $tgtTxt } else { '' })) }
                else { ("Car ahead is {0:0.0}s up the road, his last lap was {1}. {2} laps left - you need {3:0.00}s a lap on him{4}." -f $gapA, $(if ($their -gt 0) { Format-LapTime $their } else { '?' }), $raceLeft, $needG, $(if ($tgtTxt) { ", so lap under " + $tgtTxt } else { '' })) }
            return ($ansT + $styleTail)
        }
        if ($raceLeft -gt 0 -and $fpl -gt 0) {
            $extra = ''
            $deficit = $raceLeft * $fpl - [double]$T.Fuel
            if ($deficit -gt 0.1) {
                $save = $deficit / $raceLeft
                $extra = if ($cs) { (" Abys dojel bez boxu, musis usetrit {0:0.0} litru na kolo - lift and coast pred brzdenim." -f $save) } else { (" To make the finish without a stop, save {0:0.0}L per lap - lift and coast before braking." -f $save) }
            }
            $base = if ($cs) { ("Do konce {0} kol. Presny odstup na konkretniho soupere z tehle telemetrie nemam, takze cas 'na dohnani P1' ti spocitat neumim - to by mi hra musela davat jejich casy." -f $raceLeft) } else { ("{0} laps to go. I don't have the exact gap to a specific rival from this feed, so I can't set a 'catch P1' target - the game would have to expose their times." -f $raceLeft) }
            if ([string]$T.Sim -eq 'acc' -and [int]$T.AccBcast -lt 2) { $base += $(if ($cs) { ' Rozestupy jsem ti v ACC uz zapnul - naskoci po restartu hry.' } else { ' I have enabled ACC live gaps - they kick in after you restart the game.' }) }
            return ($base + $extra + $styleTail)
        }
        return $(if ($cs) { 'Na tohle potrebuju znat pocet kol do konce a tvou spotrebu - dej mi par kol. Casy soupere navic z tehle hry necte.' } else { 'For that I need laps-to-go and your fuel use - give me a few laps. Rival lap times are not in this feed anyway.' })
    }
    # ODSTUP / DOJIZDI ME / DOHANIM (F1/iRacing = presne casy; jinde radar = jen blizkost)
    if ($ql -match 'odstup|za mnou|přede mnou|pred mnou|dojiz|dojíž|dojíždí|dojede|zavir|zavír|closing|behind|ahead|blizk|blízk|kdo je za|souper|soupeř|rival') {
        if ([bool]$T.RivOk -and ([double]$T.RivAheadGap -gt 0 -or [double]$T.RivBehindGap -gt 0)) {
            $pcs = @()
            if ([double]$T.RivAheadGap -gt 0) {
                $pcs += $(if ($cs) { ("pred tebou {0:0.0} s{1}" -f [double]$T.RivAheadGap, $(if ([int]$T.RivAheadMs -gt 0) { " (jede " + (Format-LapTime ([int]$T.RivAheadMs)) + ")" } else { '' })) }
                    else { ("ahead {0:0.0}s{1}" -f [double]$T.RivAheadGap, $(if ([int]$T.RivAheadMs -gt 0) { " (doing " + (Format-LapTime ([int]$T.RivAheadMs)) + ")" } else { '' })) })
            }
            if ([double]$T.RivBehindGap -gt 0) {
                $pcs += $(if ($cs) { ("za tebou {0:0.0} s{1}" -f [double]$T.RivBehindGap, $(if ([int]$T.RivBehindMs -gt 0) { " (jede " + (Format-LapTime ([int]$T.RivBehindMs)) + ")" } else { '' })) }
                    else { ("behind {0:0.0}s{1}" -f [double]$T.RivBehindGap, $(if ([int]$T.RivBehindMs -gt 0) { " (doing " + (Format-LapTime ([int]$T.RivBehindMs)) + ")" } else { '' })) })
            }
            $ansG = if ($cs) { ('Rozestupy: ' + ($pcs -join ', ') + '.') } else { ('Gaps: ' + ($pcs -join ', ') + '.') }
            return ($ansG + $styleTail)
        }
        $cl = [double]$T.NearClosing
        if ([double]$T.NearDist -lt 50) {
            $side = if ($T.NearLeft) { if ($cs) { 'vlevo' } else { 'on your left' } } elseif ($T.NearRight) { if ($cs) { 'vpravo' } else { 'on your right' } } else { if ($cs) { 'hned vedle' } else { 'right alongside' } }
            if ($cl -gt 0.3) { return $(if ($cs) { ("Mas auto {0} a ZAVIRA se na tebe - hlidej zrcatka a braň se cistou stopou." -f $side) } else { ("Car {0} and CLOSING - watch your mirrors, defend the clean line." -f $side) }) }
            if ($cl -lt -0.3) { return $(if ($cs) { ("Auto {0}, ale odjizdis mu - drz tempo a mas ho z krku." -f $side) } else { ("Car {0}, but you're pulling away - hold pace and he's gone." -f $side) }) }
            return $(if ($cs) { ("Auto {0}, drzite se nastejno - rozhodne vyjezd z posledni zataceky." -f $side) } else { ("Car {0}, you're holding station - the last corner exit decides it." -f $side) })
        }
        $noRad = if ($cs) { 'Nikoho v dosahu radaru ted nemam. Presne casove odstupy na soupere z tehle telemetrie neziskam - jedu podle tve pozice a tempa.' } else { 'Nobody within radar range right now. I can''t get exact time gaps to rivals from this telemetry - I go by your position and pace.' }
        if ([string]$T.Sim -eq 'acc' -and [int]$T.AccBcast -lt 2) { $noRad += $(if ($cs) { ' Rozestupy jsem ti v ACC uz zapnul - naskoci po restartu hry.' } else { ' I have enabled ACC live gaps - they kick in after you restart the game.' }) }
        return $noRad
    }
    # POSKOZENI (damage) - AC/ACC/F1 ctem z telemetrie; jinde poctive "nectu"
    if ($ql -match 'poskoz|poškoz|damage|rozbi|naboural|naráž|naraz|kridl|křídl|aero|broken') {
        if ([bool]$T.HasDamage) {
            $dmg = [double]$T.Damage
            if ($dmg -lt 0.5) { return $(if ($cs) { 'Auto vypada v pohode, zadne vyrazne poskozeni. Jed dal.' } else { 'Car looks fine, no significant damage. Keep going.' }) }
            elseif ($dmg -lt 3.0) { return $(if ($cs) { 'Mas lehke poskozeni. Auto pojede, ale hlidej si chovani v zatackach.' } else { 'You have light damage. Car is drivable, but watch the handling in corners.' }) }
            else { return $(if ($cs) { 'Poskozeni je vetsi - auto se bude chovat jinak. Zvaz zastavku v boxu na opravu.' } else { 'Damage is significant - the car will feel different. Consider a pit stop to repair.' }) }
        }
        return $(if ($cs) { 'Data o poskozeni z tehle hry zatim nectu - to ti spolehlive rekne az panel skod ve hre. Hlidam ti aspon gumy a teploty.' } else { 'I don''t read damage from this sim yet - the in-game damage panel is your source. I''m watching tyres and temps for you.' })
    }
    # LIMITY TRATE / VAROVANI ("kolik mam varovani?", "hrozi mi penalizace?")
    if ($ql -match 'limit|varovani|varování|warning|penaliz|penalt|track limits') {
        $offN = [int]$script:Eng.OffCount
        if ($offN -le 0) { return $(if ($cs) { 'Limity trate mas ciste, zadne varovani. Jen tak dal.' } else { 'Track limits are clean, no warnings. Keep it that way.' }) }
        elseif ($offN -lt 3) { return $(if ($cs) { ("Napocital jsem {0} prohresky proti limitum trate. Od tri to byva penalizace - nech si rezervu." -f $offN) } else { ("I counted {0} track limit offences. Penalties usually start at three - leave yourself margin." -f $offN) }) }
        else { return $(if ($cs) { ("Uz {0} prohresku proti limitum - dalsi muze znamenat penalizaci. Drz to uvnitr car, i za cenu desetinky." -f $offN) } else { ("{0} track limit offences already - the next one can mean a penalty. Stay inside the lines, even if it costs a tenth." -f $offN) }) }
    }
    # PALIVO
    if ($ql -match 'paliv|benzin|natank|dotank|fuel') {
        if ($fpl -le 0) { if ($cs) { return ("Mas {0:0.0} litru. Spotrebu ti reknu po prvnim dokoncenem kole." -f [double]$T.Fuel) } else { return ("You have {0:0.0} litres. I will know consumption after the first full lap." -f [double]$T.Fuel) } }
        $base = if ($cs) { ("Palivo {0:0.0} litru, bereme {1:0.0} na kolo, vydrzi na {2} kol." -f [double]$T.Fuel, $fpl, $lapsOnFuel) } else { ("Fuel {0:0.0} litres, using {1:0.0} per lap, good for {2} laps." -f [double]$T.Fuel, $fpl, $lapsOnFuel) }
        if ($raceLeft -ge 0) {
            $need = [math]::Max(0, $raceLeft * $fpl - [double]$T.Fuel)
            if ($need -gt 0.1) { $base += $(if ($cs) { (" Do cile chybi cca {0:0.0} litru - pojedeme pres box." -f $need) } else { (" We are short about {0:0.0} litres - we will need to box." -f $need) }) }
            else { $base += $(if ($cs) { " Do cile to vyjde bez zastavky." } else { " We make the finish without a stop." }) }
        }
        return ($base + $styleTail)
    }
    # KOLIK KOL / KONEC
    if ($ql -match 'kolik kol|zbyva|do konce|posledni kolo|laps left|remain') {
        if ($raceLeft -ge 0) { $t = if ($cs) { ("Zbyva {0} kol do konce, jedes {1}. kolo." -f $raceLeft, ([int]$T.CompletedLaps + 1)) } else { ("{0} laps to go, you are on lap {1}." -f $raceLeft, ([int]$T.CompletedLaps + 1)) } }
        elseif ([double]$T.SessionTimeLeft -gt 0) { $mm = [int]([double]$T.SessionTimeLeft / 60000); $t = if ($cs) { ("Do konce zbyva {0} minut." -f $mm) } else { ("{0} minutes left in the session." -f $mm) } }
        else { $t = if ($cs) { ("Jedes {0}. kolo, konec neni omezeny." -f ([int]$T.CompletedLaps + 1)) } else { ("You are on lap {0}, no lap limit set." -f ([int]$T.CompletedLaps + 1)) } }
        return ($t + $styleTail)
    }
    # pomocne vypocty pro gumy a tempo (sdili vic vetvi)
    $wearNow = -1.0; $wearRate = -1.0
    $twL = $T.TyreWear
    if ($twL -and [double]$twL[0] -gt 1) { $wearNow = [double](($twL | Measure-Object -Minimum).Minimum) }
    if ($script:WearHist -and $script:WearHist.Count -ge 3) {
        $w0 = $script:WearHist[[math]::Max(0, $script:WearHist.Count - 4)]; $w1 = $script:WearHist[$script:WearHist.Count - 1]
        $dl = [int]$w1[0] - [int]$w0[0]
        if ($dl -gt 0) { $wearRate = ([double]$w0[1] - [double]$w1[1]) / $dl }
    }
    # SETRENI / VYDRZ GUM ("setrime pneumatiky?", "vydrzi gumy?")
    if ($ql -match 'setr|šetř|sav(e|ing)|vydrzi gum|vydrží gum|vydrzi pneu|wear|opotreb|opotřeb') {
        if ($wearNow -lt 0) { return $(if ($cs) { 'Data o opotrebeni tady nevidim - hlidam aspon teploty, ty jsou OK.' } else { 'No wear data in this sim - watching temps instead.' }) }
        if ($wearRate -lt 0) { return $(if ($cs) { ("Gumy {0:0} procent. Ubytek spocitam po par kolech." -f $wearNow) } else { ("Tyres at {0:0} percent. I'll have the wear rate after a few laps." -f $wearNow) }) }
        $t = if ($cs) { ("Gumy {0:0} procent, ubytek {1:0.0} na kolo." -f $wearNow, $wearRate) } else { ("Tyres {0:0} percent, losing {1:0.0} per lap." -f $wearNow, $wearRate) }
        if ($raceLeft -gt 0 -and $wearRate -gt 0) {
            $toLimit = [math]::Floor(($wearNow - 80.0) / $wearRate)
            if ($toLimit -lt $raceLeft) { $t += $(if ($cs) { (" Timhle tempem vydrzi ~{0} kol, do cile jich je {1} - SETRI, jed cisteji v rychlych." -f $toLimit, $raceLeft) } else { (" At this rate they last ~{0} laps, {1} to go - SAVE them, cleaner lines in the fast stuff." -f $toLimit, $raceLeft) }) }
            else { $t += $(if ($cs) { ' Setris dobre, do cile v pohode - muzes i pritlacit.' } else { ' Good saving, they make the flag - you can even push.' }) }
        }
        return ($t + $styleTail)
    }
    # PNEUMATIKY (stav)
    if ($ql -match 'pneu|gum|tyre|tire|teplot') {
        $tt = $T.TyreTemp; $tw = $T.TyreWear
        $maxT = [int](($tt | Measure-Object -Maximum).Maximum)
        $stav = if ($maxT -gt 105) { if ($cs) { 'prehrivaji se, uber' } else { 'overheating, ease off' } } elseif ($maxT -lt 70) { if ($cs) { 'jsou studene, zahrivej je' } else { 'cold, work them' } } else { if ($cs) { 'v optimalni teplote' } else { 'in the window' } }
        $t = if ($cs) { ("Gumy {0}/{1}/{2}/{3} stupnu - {4}." -f [int]$tt[0], [int]$tt[1], [int]$tt[2], [int]$tt[3], $stav) } else { ("Tyres {0}/{1}/{2}/{3} degrees - {4}." -f [int]$tt[0], [int]$tt[1], [int]$tt[2], [int]$tt[3], $stav) }
        if ($tw -and [double]$tw[0] -gt 1) { $minW = [int](($tw | Measure-Object -Minimum).Minimum); $t += $(if ($cs) { (" Opotrebeni nejhorsi gumy {0} procent." -f $minW) } else { (" Worst tyre wear {0} percent." -f $minW) }) }
        if ($wearRate -ge 0) { $t += $(if ($cs) { (" Ubytek {0:0.0} procenta na kolo." -f $wearRate) } else { (" Losing {0:0.0} percent per lap." -f $wearRate) }) }
        return ($t + $styleTail)
    }
    # CAS / TEMPO / REKORD / REFERENCE + "mam zrychlit/zpomalit?"
    if ($ql -match 'cas|tempo|rychl|rekord|refer|pace|nejleps|delta|zrychl|zpomal|pridat|přidat|push|mam jet|attack') {
        $last = [int]$T.LastTimeMs; $best = [int]$T.BestTimeMs
        $t = if ($cs) { ("Posledni kolo {0}, nejlepsi {1}." -f (Format-LapTime $last), (Format-LapTime $best)) } else { ("Last lap {0}, best {1}." -f (Format-LapTime $last), (Format-LapTime $best)) }
        # verdikt: zrychlit / drzet / zpomalit
        if ($last -gt 0 -and $best -gt 0) {
            $dp = ($last - $best) / 1000.0
            $maxT2 = [int](($T.TyreTemp | Measure-Object -Maximum).Maximum)
            $tyresBad = ($maxT2 -gt 105) -or ($wearRate -gt 0 -and $raceLeft -gt 0 -and ([math]::Floor(([math]::Max($wearNow,0) - 80.0) / $wearRate)) -lt $raceLeft)
            if ($tyresBad) { $t += $(if ($cs) { ' Verdikt: ZPOMAL o desetinku, gumy to nedavaji.' } else { ' Verdict: BACK OFF a tenth, tyres are suffering.' }) }
            elseif ($dp -le 0.4) { $t += $(if ($cs) { ' Verdikt: tempo mas, drz rytmus.' } else { ' Verdict: pace is there, hold the rhythm.' }) }
            else { $t += $(if ($cs) { (" Verdikt: muzes PRIDAT, ztracis {0:0.0} s na svoje maximum." -f $dp) } else { (" Verdict: you can PUSH, {0:0.0}s off your own best." -f $dp) }) }
        }
        $ref = Get-RefLap
        if ($ref -and $best -gt 0) {
            $d = ($best - [int]$ref.ms) / 1000.0
            if ($d -gt 0) { $t += $(if ($cs) { (" Na referenci GT3 ({0}) ztracis {1:0.0} sekund." -f (Format-LapTime ([int]$ref.ms)), $d) } else { (" You are {1:0.0}s off the GT3 reference ({0})." -f (Format-LapTime ([int]$ref.ms)), $d) }) }
            else { $t += $(if ($cs) { " Jedes pod referenci GT3, parada!" } else { " You are under the GT3 reference, brilliant!" }) }
        }
        return ($t + $styleTail)
    }
    # BOX / STRATEGIE
    if ($ql -match 'box|zastav|strateg|pit') {
        if ($fpl -le 0) { return $(if ($cs) { 'Strategii spocitam po prvnim kole, zatim jed.' } else { 'I will have a strategy after the first lap, keep going.' }) }
        if ($raceLeft -lt 0) { return $(if ($cs) { ("Palivo staci na {0} kol. Bez znameho konce zavodu jed, dokud muzes." -f $lapsOnFuel) } else { ("Fuel is good for {0} laps. Without a race limit, just keep going." -f $lapsOnFuel) }) }
        $need = [math]::Max(0, $raceLeft * $fpl - [double]$T.Fuel)
        if ($need -le 0.1) { return ($(if ($cs) { 'Zadny box nepotrebujes, palivo do cile staci.' } else { 'No stop needed, fuel is good to the end.' }) + $styleTail) }
        $okno = [math]::Max(1, $lapsOnFuel - 1)
        return ($(if ($cs) { ("Budes potrebovat box: dotankovat cca {0:0.0} litru. Okno se otevira, nejpozdeji za {1} kol." -f $need, $okno) } else { ("You will need a stop: about {0:0.0} litres. Window opens now, latest in {1} laps." -f $need, $okno) }) + $styleTail)
    }
    # POZICE
    if ($ql -match 'pozic|mist|kde jsem|kolikat|position') {
        if ([int]$T.Position -gt 0) { return ($(if ($cs) { ("Jedes na {0}. miste." -f [int]$T.Position) } else { ("You are running P{0}." -f [int]$T.Position) }) + $styleTail) }
        return $(if ($cs) { 'Pozici ted nevidim.' } else { 'No position data right now.' })
    }
    # FALLBACK - souhrn + napoveda
    if ($cs) { return ("Kolo {0}, palivo {1:0.0} l, posledni cas {2}. Ptej se na palivo, kola, pneumatiky, cas, box nebo pozici." -f ([int]$T.CompletedLaps + 1), [double]$T.Fuel, (Format-LapTime ([int]$T.LastTimeMs))) }
    return ("Lap {0}, fuel {1:0.0}L, last lap {2}. Ask about fuel, laps, tyres, times, pit or position." -f ([int]$T.CompletedLaps + 1), [double]$T.Fuel, (Format-LapTime ([int]$T.LastTimeMs)))
}

function Get-TelemetryContext {
    $T = $script:Tel; $fpl = Get-FuelPerLap
    $raceLeft = if ([int]$T.NumberOfLaps -gt 0) { [int]$T.NumberOfLaps - [int]$T.CompletedLaps } else { -1 }
    (@(
        ("sim={0}; car={1}; track={2}" -f $T.SimName, $T.CarModel, $T.Track),
        ("lap={0}/{1}; lapsLeft={2}" -f [int]$T.CompletedLaps, [int]$T.NumberOfLaps, $raceLeft),
        ("lastLap={0}; bestLap={1}" -f (Format-LapTime ([int]$T.LastTimeMs)), (Format-LapTime ([int]$T.BestTimeMs))),
        ("fuel={0:0.0}L; perLap={1:0.0}L; lapsOnFuel={2}" -f [double]$T.Fuel, $fpl, $(if ($fpl -gt 0) { [math]::Floor([double]$T.Fuel/$fpl) } else { 0 })),
        ("tyreTemps={0}C; tyreWear={1}pct" -f (($T.TyreTemp | ForEach-Object { [int]$_ }) -join '/'), (($T.TyreWear | ForEach-Object { [int]$_ }) -join '/')),
        ("speed={0}kmh; gear={1}; inPit={2}; position={3}; flag={4}; pitPlanned={5}" -f [int]$T.SpeedKmh, [int]$T.Gear, [int]$T.IsInPit, [int]$T.Position, [int]$T.Flag, $script:PitPlan),
        ("radar: nearLeft={0}; nearRight={1}; nearestCar={2}; closing={3}" -f [bool]$T.NearLeft, [bool]$T.NearRight, $(if ([double]$T.NearDist -lt 90) { ("{0:0.0}m" -f [double]$T.NearDist) } else { 'none' }), $(if ([double]$T.NearDist -lt 90) { [double]$T.NearClosing } else { 0 })),
        $(if ([bool]$T.HasDamage) { ("carDamage={0:0.0} ({1}); tyresOffTrack={2}/4" -f [double]$T.Damage, $(if ([double]$T.Damage -lt 0.5) { 'none' } elseif ([double]$T.Damage -lt 3.0) { 'light' } else { 'significant' }), [int]$T.TyresOut) } else { "damageState=unavailable-in-this-sim" }),
        ("trackLimitWarningsThisSession={0} (3+ usually means penalty risk)" -f [int]$script:Eng.OffCount),
        $(if ([bool]$T.RivOk) { ("rivalAhead: gap={0:0.0}s lastLap={1}; rivalBehind: gap={2:0.0}s lastLap={3}" -f [double]$T.RivAheadGap, (Format-LapTime ([int]$T.RivAheadMs)), [double]$T.RivBehindGap, (Format-LapTime ([int]$T.RivBehindMs))) } else { "unavailable=exactRivalTimeGaps; if asked, say you don't have the data instead of guessing" }),
        $(  $r = Get-RefLap
            if ($r) { ("referenceLapGT3={0} ({1}, approximate)" -f (Format-LapTime ([int]$r.ms)), $r.n) } else { "referenceLapGT3=unknown" } )
    ) -join "`n")
}
function Ask-Engineer([string]$question) {
    if (-not $question -or -not $question.Trim()) { return }
    $question = $question.Trim()
    $nmLog = if ($script:Settings.EngName) { $script:Settings.EngName.ToUpper() } else { (Tr 'INZENYR' 'ENGINEER') }
    # HLASOVE POVELY: ticho / mluv min / mluv vic / mluv - inzenyr POSLECHNE hned
    $cq0 = $question.ToLower()
    $csA = ((Get-EngLang) -eq 'cs')
    if ($cq0 -match 'ticho|drz hubu|drž hubu|sklapni|nemluv|neotravuj|shut up|be quiet|silence') {
        Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
        $script:RadioMuted = $true
        $a0 = if ($csA) { 'Rozumím, mlčím. Až mě budeš potřebovat, řekni "mluv".' } else { 'Copy, going quiet. Say "talk" when you need me.' }
        Add-Radio ($nmLog + ": " + $a0); if ($chkEngineer.Checked) { Speak-Raw $a0 $true }
        return
    }
    if ($cq0 -match 'mluv min|mluv míň|mluv mene|mluv méně|speak less|less talk|talk less') {
        Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
        $script:Settings.Verbosity = 0; $script:RadioMuted = $false; Save-Settings
        try { $cmbVerb.SelectedIndex = 0 } catch { }
        $a0 = if ($csA) { 'Dobře, jen důležité věci: palivo kriticky, bouračky, poslední kolo.' } else { 'Alright, essentials only: critical fuel, crashes, final lap.' }
        Add-Radio ($nmLog + ": " + $a0); if ($chkEngineer.Checked) { Speak-Raw $a0 $true }
        return
    }
    if ($cq0 -match 'mluv vic|mluv víc|mluv vice|speak more|more talk|talk more') {
        Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
        $script:Settings.Verbosity = 2; $script:RadioMuted = $false; Save-Settings
        try { $cmbVerb.SelectedIndex = 2 } catch { }
        $a0 = if ($csA) { 'Jasně, budu hlásit všechno - každé kolo, každou změnu.' } else { 'Sure, full commentary - every lap, every change.' }
        Add-Radio ($nmLog + ": " + $a0); if ($chkEngineer.Checked) { Speak-Raw $a0 $true }
        return
    }
    if ($cq0 -match '^mluv\b|zase mluv|muzes mluvit|můžeš mluvit|unmute|^talk\b|speak up') {
        Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
        $script:RadioMuted = $false
        if ([int]$script:Settings.Verbosity -lt 1) { $script:Settings.Verbosity = 1; try { $cmbVerb.SelectedIndex = 1 } catch { }; Save-Settings }
        $a0 = if ($csA) { 'Jsem zpátky na příjmu, jedeme.' } else { 'Back on the radio, let''s go.' }
        Add-Radio ($nmLog + ": " + $a0); if ($chkEngineer.Checked) { Speak-Raw $a0 $true }
        return
    }
    # HODNOCENI RAD: "dobra/spatna rada" -> uklada se do trvale pameti, AI se z toho uci (jde do promptu)
    if ($cq0 -match 'spatna rada|špatná rada|spatna odpoved|špatná odpověď|to je blbost|to byla blbost|to nepomohlo|to je kravina|bad advice|bad call|wrong call|that was wrong') {
        Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
        $ok0 = Rate-LastAnswer $false
        $a0 = if ($ok0) { if ($csA) { 'Beru na vědomí. Zapsal jsem si to a příště poradím líp.' } else { 'Noted. Logged it - I will do better next time.' } }
            else { if ($csA) { 'Zatím jsem ti nic neporadil, není co hodnotit.' } else { 'I have not given you any advice yet - nothing to rate.' } }
        Add-Radio ($nmLog + ": " + $a0); if ($chkEngineer.Checked) { Speak-Raw $a0 $true }
        return
    }
    if ($cq0 -match 'dobra rada|dobrá rada|dobra odpoved|dobrá odpověď|to pomohlo|super rada|good advice|good call|nice call|that helped') {
        Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
        $ok0 = Rate-LastAnswer $true
        $a0 = if ($ok0) { if ($csA) { 'Díky. Takhle to budu hlásit dál.' } else { 'Cheers. I will keep calling it like that.' } }
            else { if ($csA) { 'Zatím jsem ti nic neporadil, ale díky za důvěru.' } else { 'No advice given yet, but thanks for the vote of confidence.' } }
        Add-Radio ($nmLog + ": " + $a0); if ($chkEngineer.Checked) { Speak-Raw $a0 $true }
        return
    }
    # TRVALA PAMET: "pamatuj si ..." -> inzenyr si fakt zapise (funguje i bez API klice)
    if ($cq0 -match '^(pamatuj si|zapamatuj si|zapis si|zapiš si|remember that|remember:)\s*(.+)$') {
        $note0 = $Matches[2].Trim()
        Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
        if ($note0) {
            Add-DrvNote $note0
            $a0 = if ($csA) { 'Zapsáno. Tohle už nezapomenu.' } else { 'Written down. I will not forget that.' }
        } else { $a0 = if ($csA) { 'Co si mám zapamatovat? Řekni to celé.' } else { 'Remember what? Give me the whole thing.' } }
        Add-Radio ($nmLog + ": " + $a0); if ($chkEngineer.Checked) { Speak-Raw $a0 $true }
        return
    }
    # HLASOVY POVEL: "priprav setup" / "udelej setup/stint" -> inzenyr ZAPISE setup do hry (ACC)
    $cqS = $question.ToLower()
    if ($cqS -match 'setup|stint' -and $cqS -match 'udelej|udělej|priprav|připrav|nastav|zapis|zapiš|vytvor|vytvoř|make|prepare|create') {
        Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
        $resS = Make-StintSetup
        Add-Radio ($nmLog + ": " + $resS)
        if ($chkEngineer.Checked) { Speak-Raw $resS $true (Get-EngLang) }
        return
    }
    # HLASOVE POVELY: "naplanuj box" / "zrus box" - vykona se hned, bez AI
    $cq = $question.ToLower()
    if ($cq -match 'box|pit|zastavk|zastávk') {
        $isCancel = $cq -match 'zrus|zruš|nechci|cancel|vypni|odvolej'
        $isPlan = -not $isCancel -and ($cq -match 'planuj|plánuj|naplanuj|naplánuj|chci|nastav|pojed|pripra|připra|budem|jedem|domluv')
        if ($isCancel -or $isPlan) {
            Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
            $cs2 = ((Get-EngLang) -eq 'cs')
            if ($isCancel) {
                $script:PitPlan = $false
                $a = if ($cs2) { 'Box zrušený. Jedeme dál naplno.' } else { 'Pit plan cancelled. Back to full attack.' }
            } else {
                $script:PitPlan = $true
                $fpl2 = Get-FuelPerLap
                $raceLeft2 = if ([int]$script:Tel.NumberOfLaps -gt 0) { [int]$script:Tel.NumberOfLaps - [int]$script:Tel.CompletedLaps } else { -1 }
                if ($fpl2 -gt 0 -and $raceLeft2 -ge 0) {
                    $toAdd2 = [math]::Max(0.0, $raceLeft2 * $fpl2 * 1.03 - [double]$script:Tel.Fuel)
                    $a = if ($cs2) { ("Rozumím, box naplánovaný. Až přijedeš, doplníme plus {0:0.0} litru do cíle." -f $toAdd2) } else { ("Copy, pit planned. We'll add {0:0.0} litres to make the finish." -f $toAdd2) }
                } else {
                    $a = if ($cs2) { 'Rozumím, box naplánovaný. Množství doladíme podle spotřeby.' } else { 'Copy, pit planned. Fuel amount to be confirmed.' }
                }
            }
            Add-Radio ($nmLog + ": " + $a)
            if ($chkEngineer.Checked) { Speak-Raw $a $true }
            return
        }
    }
    # BEZ API KLICE (nebo v lokalnim rezimu): inzenyr odpovi okamzite z telemetrie
    if (-not $script:Settings.ApiKey -or ([string]$script:Settings.Model -like 'lokalni*')) {
        Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
        # jazyk odpovedi = ZVOLENY jazyk inzenyra (zadna auto-detekce - user chce konzistenci)
        $qL = Get-EngLang
        $ans = Get-LocalAnswer $question $qL
        $script:LastQ = $question; $script:LastAnswer = $ans   # pro hodnoceni "dobra/spatna rada"
        Add-Radio ($nmLog + ": " + $ans)
        Speak-Raw $ans $true $qL
        $lblEngStatus.Text = Tr 'odpovezeno (lokalni rezim)' 'answered (local mode)'; $lblEngStatus.ForeColor = $cAccent
        return
    }
    if ($script:AskState.Busy) { Add-Radio (Tr '(Moment, jeste zpracovavam predchozi otazku...)' '(One sec, still working on the previous question...)'); return }
    $script:AskStart = Get-Date
    $script:LastQ = $question
    Add-Radio ((Tr 'TY: ' 'YOU: ') + $question)
    [void]$script:ChatHistory.Add(@{ role = 'user'; content = $question })
    while ($script:ChatHistory.Count -gt 12) { $script:ChatHistory.RemoveAt(0) }
    # jazyk odpovedi = ZVOLENY jazyk inzenyra (konzistence; auto-detekce otazky matla - prepinal hlasy)
    $effLang = Get-EngLang
    $script:LastAnswerLang = $effLang   # Say() mluvi jazykem odpovedi
    $langName = $script:LangNames[$effLang]; if (-not $langName) { $langName = 'English' }
    $lang = "Always reply in $langName - the same language the driver just used. The radio voice switches automatically."
    $styles = @(
        'PERSONALITY: calm, ice-cold professional. Short, precise, zero small talk.',
        'PERSONALITY: foul-mouthed, brutally rude race engineer straight out of a viral clip. You swear freely and often (fuck, shit, damn - in Czech kurva, do prdele, hovno, ty vole), you roast the driver mercilessly, and you love dropping sarcastic side remarks that have nothing to do with racing (the pit coffee, the mechanics betting against him, your sandwich) - but your data is ALWAYS right and your strategy calls are always correct. Never soft, never polite, never corporate.',
        'PERSONALITY: the driver''s best mate. Warm, casual, always encouraging, cheer them on.',
        'PERSONALITY: pure data engineer. Every sentence must contain concrete numbers from the telemetry. No emotions.'
    )
    $si = [int]$script:Settings.EngStyle; if ($si -lt 0 -or $si -ge $styles.Count) { $si = 0 }
    $nm = if ($script:Settings.EngName) { $script:Settings.EngName } else { 'Engineer' }
    $cust = if ($script:Settings.EngCustom) { " The driver gave you these extra instructions and they OVERRIDE everything else: " + $script:Settings.EngCustom } else { "" }
    $stt = " CRITICAL: The driver's message comes from imperfect Czech speech-to-text while racing - words WILL be garbled. Your job: ALWAYS silently reconstruct what they most likely said, using sound-alike Czech racing terms (palivo=fuel, gumy/pneumatiky=tyres, box/zastavka=pit, kolo=lap, cas=time, rozdil/odstup=gap, pozice=position, vlajka=flag, poskozeni=damage, stint) plus the telemetry context, then ANSWER that question with real data. You may tease or criticize the driver freely per your personality - but NEVER refuse to answer because of gibberish, never say you don't understand, never ask them to repeat or type. Always commit to the most probable interpretation and answer it."
    $spk = " This is spoken aloud over radio: NEVER use emoji, symbols or unit abbreviations. Write every unit as a full word in your language (say 'litres' not 'l' or 'L', 'kilometres per hour' not 'km/h', 'percent' not '%', 'seconds' not 's', 'degrees' not the degree sign)."
    # trvala pamet: profil jezdce (statistiky, vztah, poznamky, pouceni z feedbacku) + moznost zapsat novy fakt
    $memP = " DRIVER PROFILE - your persistent memory of this driver across all sessions (refer to it naturally when relevant, let the relationship value colour your tone): " + (Get-DriverProfileText)
    $memW = " If the driver tells you something worth remembering long-term (their name, habits, goals, preferences - NOT momentary telemetry), append at the VERY END of your reply the tag [MEM: short fact in English]. The tag is stripped before speaking, the driver never hears it."
    $sys = "You are $nm, a race engineer talking to your driver over team radio during a live sim race (Assetto Corsa / ACC). Max two short sentences, radio style. $($styles[$si]) Stay strictly in this character.$cust$stt$spk$memP$memW Use the telemetry to answer (fuel, laps, pace, tyres, pit stops). $lang Current telemetry:`n" + (Get-TelemetryContext)
    $model = if ($script:Settings.Model) { $script:Settings.Model } else { 'claude-haiku-4-5' }
    $body = @{ model = $model; max_tokens = 130; system = $sys; messages = @($script:ChatHistory) } | ConvertTo-Json -Depth 8
    $script:AskState.Busy = $true; $script:AskState.Done = $false; $script:AskState.Ok = $false; $script:AskState.Result = ''
    $script:AskRS = [runspacefactory]::CreateRunspace(); $script:AskRS.ApartmentState = 'MTA'; $script:AskRS.Open()
    $script:AskPS = [powershell]::Create(); $script:AskPS.Runspace = $script:AskRS
    [void]$script:AskPS.AddScript($script:AskWorker).AddArgument($script:AskState).AddArgument($script:Settings.ApiKey).AddArgument($body)
    [void]$script:AskPS.BeginInvoke()
    $btnAsk.Enabled = $false; $lblEngStatus.Text = Tr 'ptam se inzenyra...' 'asking the engineer...'; $lblEngStatus.ForeColor = $cAccent
}

# ============================================================
#  MIKROFON: vlastni nahravani (winmm) + offline prepis Whisper
#  (zadne Windows rozpoznavani reci - funguje i cesky)
# ============================================================
function Get-AppRoot {
    try { $m = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName; if ($m -match 'PitWise\.exe$') { return (Split-Path $m -Parent) } } catch { }
    if ($PSScriptRoot) { return $PSScriptRoot }
    return (Get-Location).Path
}
function Find-Whisper {
    foreach ($root in @((Join-Path (Get-AppRoot) 'whisper'), (Join-Path $script:DataDir 'whisper'))) {
        if (-not (Test-Path $root)) { continue }
        # whisper-cli.exe ma prednost - main.exe je v novych verzich jen deprecation pahyl
        $exe = Get-ChildItem $root -Recurse -Filter 'whisper-cli.exe' -File -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $exe) { $exe = Get-ChildItem $root -Recurse -Filter 'main.exe' -File -ErrorAction SilentlyContinue | Select-Object -First 1 }
        $models = @(Get-ChildItem $root -Recurse -Filter 'ggml-*.bin' -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending)
        $model = $null
        if ($models.Count -gt 0) {
            # 'small' = sladky bod rychlost/presnost pro zivou vysilacku; 'max' = nejvetsi stazeny model (presnejsi, pomalejsi)
            if ([string]$script:Settings.WhisPrefer -ne 'max') { $model = $models | Where-Object { $_.Name -match 'small' } | Select-Object -First 1 }
            if (-not $model) { $model = $models[0] }
        }
        if ($exe -and $model) { return @{ Exe = $exe.FullName; Model = $model.FullName } }
    }
    return $null
}
$script:Whisper = $null
$script:MicRec = $false
$script:MicWavPath = Join-Path $script:DataDir 'mic.wav'
$script:MicState = [hashtable]::Synchronized(@{ Busy = $false; Done = $false; Ok = $false; Text = ''; Err = '' })
$script:MicPS = $null; $script:MicRS = $null
$script:MicWorker = {
    param($state, $exe, $model, $wav, $lang, $port, $bias)
    try {
        $t = ''
        # 1) bezici whisper-server (model uz v pameti = rychly prepis)
        # POZOR: vystup curl NESMI jit pres stdout - PowerShell ho dekoduje spatnou kodovou
        # strankou a rozbije cestinu ("Ĺ˝erej" misto "Jerry"). Pisu do souboru a ctu jako UTF-8.
        try {
            $respFile = Join-Path (Split-Path $wav -Parent) 'mic-resp.txt'
            if (Test-Path $respFile) { Remove-Item $respFile -Force -ErrorAction SilentlyContinue }
            $curlArgs = @('-s','-m','30','-o',$respFile,'-F',("file=@" + $wav),'-F',("language=" + $lang),'-F','response_format=text')
            if ($bias) { $curlArgs += @('-F', ("prompt=" + $bias)) }
            $curlArgs += ("http://127.0.0.1:" + $port + "/inference")
            & curl.exe @curlArgs | Out-Null
            if ($LASTEXITCODE -eq 0 -and (Test-Path $respFile)) { $t = (Get-Content $respFile -Raw -Encoding UTF8).Trim() }
            if ($t -match '"error"' -or $t -like '<html*') { $t = '' }
        } catch { $t = '' }
        # 2) fallback: CLI (pomalejsi - nacita model pri kazdem spusteni)
        if (-not $t) {
            $outBase = Join-Path (Split-Path $wav -Parent) 'mic-out'
            $txtFile = $outBase + '.txt'
            if (Test-Path $txtFile) { Remove-Item $txtFile -Force -ErrorAction SilentlyContinue }
            $cliArgs = @('-m', $model, '-f', $wav, '-l', $lang, '-bs', '5', '-nt', '-otxt', '-of', $outBase)
            if ($bias) { $cliArgs += @('--prompt', $bias) }
            $null = & $exe @cliArgs 2>&1
            if (Test-Path $txtFile) { $t = (Get-Content $txtFile -Raw -Encoding UTF8).Trim() }
        }
        $t = ($t -replace '\[[^\]]*\]', '').Trim()   # [BLANK_AUDIO] apod.
        if ($t) { $state.Text = $t; $state.Ok = $true } else { $state.Err = 'nerozumel jsem (prazdny prepis)'; $state.Ok = $false }
    } catch { $state.Err = $_.Exception.Message; $state.Ok = $false }
    $state.Done = $true; $state.Busy = $false
}
$script:WhisSrv = $null
$script:WhisPort = 8971
function Start-WhisperServer {
    if (-not $script:Whisper) { return }
    if ($script:WhisSrv -and -not $script:WhisSrv.HasExited) { return }
    try {
        # po padu/tvrdem ukonceni muze server z minula porad bezet - adoptuj ho misto duplikatu
        $orphan = Get-Process whisper-server -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($orphan) { $script:WhisSrv = $orphan; return }
        $srvExe = Join-Path (Split-Path $script:Whisper.Exe -Parent) 'whisper-server.exe'
        if (-not (Test-Path $srvExe)) { return }
        # -bs 5 = beam search: nejlepsi presnost; small model to utahne rychle
        $args = ('-m "{0}" --host 127.0.0.1 --port {1} -t 4 -bs 5' -f $script:Whisper.Model, $script:WhisPort)
        $script:WhisSrv = Start-Process $srvExe -ArgumentList $args -WindowStyle Hidden -PassThru
    } catch { $script:WhisSrv = $null }
}
function Stop-WhisperServer {
    try { if ($script:WhisSrv -and -not $script:WhisSrv.HasExited) { $script:WhisSrv.Kill() } } catch { }
    $script:WhisSrv = $null
}
# --- spolecna logika nahravani (tlacitko i vysilacka/PTT klavesa) ---
$script:PttDown = $false
$script:PttRaw1 = $false   # posledni syrove cteni PTT (debounce proti glitchum cteni volantu)
function Start-MicCapture {
    if ($script:MicRec -or $script:MicState.Busy) { return $false }
    if (-not $script:Whisper) { $script:Whisper = Find-Whisper }
    if (-not $script:Whisper) { return $false }
    if (Start-MicRecord) {
        $script:MicRec = $true
        $btnMic.Text = Tr 'Nahravam... (pust/klikni = odeslat)' 'Recording... (release/click = send)'; $btnMic.BackColor = $cRed
        $lblEngStatus.Text = Tr 'VYSILACKA: mluv...' 'RADIO: talk...'; $lblEngStatus.ForeColor = $cAccent
        return $true
    }
    $lblEngStatus.Text = Tr 'mic chyba - je pripojeny mikrofon?' 'mic error - is a microphone connected?'; $lblEngStatus.ForeColor = $cRed
    return $false
}
function Finish-MicCapture {
    if (-not $script:MicRec) { return }
    $script:MicRec = $false
    $btnMic.Text = Tr 'Mluvit (mikrofon)' 'Talk (microphone)'; $btnMic.BackColor = $cViolet
    if (Stop-MicRecord) {
        # nahoda / tuknuti: pod ~0.5 s zvuku nema smysl prepisovat
        try { if ((Get-Item $script:MicWavPath).Length -lt 16000) { $lblEngStatus.Text = Tr 'moc kratke - drz a mluv' 'too short - hold and talk'; $lblEngStatus.ForeColor = $cAmber; return } } catch { }
        $script:MicState.Busy = $true; $script:MicState.Done = $false; $script:MicState.Ok = $false; $script:MicState.Text = ''; $script:MicState.Err = ''
        $script:MicRS = [runspacefactory]::CreateRunspace(); $script:MicRS.Open()
        $script:MicPS = [powershell]::Create(); $script:MicPS.Runspace = $script:MicRS
        # jazyk mikrofonu = jazyk, ktery si uzivatel zvolil pro inzenyra (zadna auto-detekce -
        # ta se pletla; kazdy si nastavi svuj jazyk v Nastaveni). 'auto' jen kdyz je EngLang na auto.
        $micLang = if ([string]$script:Settings.EngLang -and [string]$script:Settings.EngLang -ne 'auto') { Get-EngLang } else { 'auto' }
        $micBias = ''
        [void]$script:MicPS.AddScript($script:MicWorker).AddArgument($script:MicState).AddArgument($script:Whisper.Exe).AddArgument($script:Whisper.Model).AddArgument($script:MicWavPath).AddArgument($micLang).AddArgument($script:WhisPort).AddArgument($micBias)
        [void]$script:MicPS.BeginInvoke()
        $lblEngStatus.Text = Tr 'prepisuju rec...' 'transcribing...'; $lblEngStatus.ForeColor = $cAccent
    } else { $lblEngStatus.Text = Tr 'nahravka se neulozila' 'recording was not saved'; $lblEngStatus.ForeColor = $cRed }
}
function Start-MicRecord {
    [Mci]::Send('close pitrec') | Out-Null
    $r1 = [Mci]::Send('open new type waveaudio alias pitrec')
    # vybrany mikrofon (Nastaveni > Aplikace); -1 = vychozi Windows zarizeni
    $micDev = [int]$script:Settings.MicDev
    if ($micDev -ge 0) { [Mci]::Send(('set pitrec input {0}' -f $micDev)) | Out-Null }
    [Mci]::Send('set pitrec time format ms bitspersample 16 samplespersec 16000 channels 1 bytespersec 32000 alignment 2') | Out-Null
    $r2 = [Mci]::Send('record pitrec')
    if (($r1 -like 'ERR*') -or ($r2 -like 'ERR*')) { [Mci]::Send('close pitrec') | Out-Null; return $false }
    return $true
}
function Stop-MicRecord {
    [Mci]::Send('stop pitrec') | Out-Null
    try { if (Test-Path $script:MicWavPath) { Remove-Item $script:MicWavPath -Force } } catch { }
    [Mci]::Send(('save pitrec "{0}"' -f $script:MicWavPath)) | Out-Null
    [Mci]::Send('close pitrec') | Out-Null
    return (Test-Path $script:MicWavPath)
}

# --- Stazeni Whisperu primo z aplikace (jednorazove, oficialni zdroje) ---
# ============================================================
#  AUTO-AKTUALIZACE: appka si sama zjisti novou verzi (GitHub manifest),
#  stahne ji, overi, vymeni soubory a restartuje se. Zakaznik nedela nic.
# ============================================================
$script:UpdState = [hashtable]::Synchronized(@{ Done = $false; NewVer = ''; Notes = ''; Ps1Url = ''; ExeUrl = '' })
$script:UpdPS = $null; $script:UpdRS = $null
$script:UpdWorker = {
    param($state, $url, $curVer)
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $m = Invoke-RestMethod -Uri $url -TimeoutSec 12 -UseBasicParsing
        # kdyz manifest ma UTF-8 BOM, IRM ho vrati jako string misto objektu -> BOM odriznout a parsovat rucne
        if ($m -is [string]) { $m = $m.TrimStart([char]0xFEFF).Trim() | ConvertFrom-Json }
        if ($m.version -and ([version]$m.version) -gt ([version]$curVer)) {
            $state.NewVer = [string]$m.version
            $state.Notes = [string]$m.notes
            $state.Ps1Url = [string]$m.ps1
            $state.ExeUrl = [string]$m.exe
        }
    } catch { }
    $state.Done = $true
}
function Start-UpdateCheck {
    try {
        $script:UpdRS = [runspacefactory]::CreateRunspace(); $script:UpdRS.Open()
        $script:UpdPS = [powershell]::Create(); $script:UpdPS.Runspace = $script:UpdRS
        [void]$script:UpdPS.AddScript($script:UpdWorker).AddArgument($script:UpdState).AddArgument($script:UpdateManifestUrl).AddArgument($script:AppVersion)
        [void]$script:UpdPS.BeginInvoke()
    } catch { }
}
function Apply-Update {
    # stahne novou verzi, OVERI ji (velikost + syntaxe) a teprve pak vymeni a restartuje
    try {
        $root = Get-AppRoot
        $lblDeskStatus.Text = (Tr 'Stahuji aktualizaci...' 'Downloading update...'); $lblDeskStatus.ForeColor = $cAmber
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $newPs1 = Join-Path $root 'PitWise.ps1.new'
        Invoke-WebRequest $script:UpdState.Ps1Url -OutFile $newPs1 -UseBasicParsing -TimeoutSec 300
        if (-not (Test-Path $newPs1) -or (Get-Item $newPs1).Length -lt 100000) { throw 'stazeny soubor je podezrele maly' }
        $perrs = $null; $ptok = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile($newPs1, [ref]$ptok, [ref]$perrs)
        if ($perrs -and $perrs.Count -gt 0) { throw 'stazeny soubor neprosel kontrolou syntaxe' }
        $newExe = ''
        if ($script:UpdState.ExeUrl) {
            $newExe = Join-Path $root 'PitWise.exe.new'
            try { Invoke-WebRequest $script:UpdState.ExeUrl -OutFile $newExe -UseBasicParsing -TimeoutSec 300 } catch { $newExe = '' }
            if ($newExe -and ((-not (Test-Path $newExe)) -or (Get-Item $newExe).Length -lt 50000)) { $newExe = '' }
        }
        # vymenu udela pomocny skript az po ukonceni appky; pak PitWise znovu spusti
        $swap = Join-Path $env:TEMP 'pitwise-update-apply.ps1'
        $swapCode = @"
Start-Sleep -Seconds 2
`$deadline = (Get-Date).AddSeconds(30)
while ((Get-Date) -lt `$deadline) {
    `$m = New-Object System.Threading.Mutex(`$false, 'PitWiseSingleInstance')
    if (`$m.WaitOne(0)) { `$m.ReleaseMutex(); `$m.Dispose(); break }
    `$m.Dispose(); Start-Sleep -Milliseconds 500
}
try { Move-Item -Path '$newPs1' -Destination '$(Join-Path $root 'PitWise.ps1')' -Force } catch { }
$(if ($newExe) { "try { Move-Item -Path '$newExe' -Destination '$(Join-Path $root 'PitWise.exe')' -Force } catch { }" })
Start-Process powershell -ArgumentList '-NoProfile','-WindowStyle','Hidden','-ExecutionPolicy','Bypass','-File','"$(Join-Path $root 'PitWise.ps1')"'
"@
        [System.IO.File]::WriteAllText($swap, $swapCode, (New-Object System.Text.UTF8Encoding($true)))
        Start-Process powershell -ArgumentList '-NoProfile','-WindowStyle','Hidden','-ExecutionPolicy','Bypass','-File',('"{0}"' -f $swap)
        $form.Close()
    } catch {
        $lblDeskStatus.Text = ((Tr 'Aktualizace selhala: ' 'Update failed: ') + $_.Exception.Message); $lblDeskStatus.ForeColor = $cRed
    }
}
$script:WhisState = [hashtable]::Synchronized(@{ Busy = $false; Done = $false; Ok = $false; Msg = '' })
$script:WhisPS = $null; $script:WhisRS = $null
$script:WhisWorker = {
    param($state, $destDir)
    $ProgressPreference = 'SilentlyContinue'
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        $zip = Join-Path $env:TEMP 'pitwise-whisper.zip'
        $state.Msg = 'sr-engine'
        Invoke-WebRequest 'https://github.com/ggerganov/whisper.cpp/releases/download/v1.9.1/whisper-blas-bin-x64.zip' -OutFile $zip -UseBasicParsing -TimeoutSec 900
        $state.Msg = 'unpack'
        Expand-Archive $zip -DestinationPath $destDir -Force
        Remove-Item $zip -Force -ErrorAction SilentlyContinue
        $state.Msg = 'sr-model'
        Invoke-WebRequest 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base-q5_1.bin' -OutFile (Join-Path $destDir 'ggml-base-q5_1.bin') -UseBasicParsing -TimeoutSec 1800
        $state.Ok = $true; $state.Msg = 'done'
    } catch { $state.Ok = $false; $state.Msg = ('err|' + $_.Exception.Message) }
    $state.Done = $true; $state.Busy = $false
}
function Start-WhisperDownload {
    if ($script:WhisState.Busy) { return }
    $script:WhisState.Busy = $true; $script:WhisState.Done = $false; $script:WhisState.Ok = $false; $script:WhisState.Msg = 'start'
    $script:WhisRS = [runspacefactory]::CreateRunspace(); $script:WhisRS.Open()
    $script:WhisPS = [powershell]::Create(); $script:WhisPS.Runspace = $script:WhisRS
    [void]$script:WhisPS.AddScript($script:WhisWorker).AddArgument($script:WhisState).AddArgument((Join-Path $script:DataDir 'whisper'))
    [void]$script:WhisPS.BeginInvoke()
}
# upgrade prepisu: vetsi model "small" = vyrazne lepsi cestina (Find-Whisper bere nejvetsi ggml-*)
$script:WhisUpWorker = {
    param($state, $destDir, $url, $file, $label)
    $ProgressPreference = 'SilentlyContinue'
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        $state.Msg = ('dl|' + $label)
        Invoke-WebRequest $url -OutFile (Join-Path $destDir $file) -UseBasicParsing -TimeoutSec 7200
        $state.Ok = $true; $state.Msg = 'done'
    } catch { $state.Ok = $false; $state.Msg = ('err|' + $_.Exception.Message) }
    $state.Done = $true; $state.Busy = $false
}
function Start-WhisperUpgrade {
    if ($script:WhisState.Busy) { return }
    # dalsi uroven podle toho, co uz mame: base -> small (rychly, presny), small -> medium (maximum)
    $mn = if ($script:Whisper) { [System.IO.Path]::GetFileName($script:Whisper.Model) } else { '' }
    if ($mn -match 'small') {
        $url = 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-medium-q5_0.bin'
        $file = 'ggml-medium-q5_0.bin'; $label = Tr 'maximalni model prepisu (540 MB)' 'max transcription model (540 MB)'
    } else {
        $url = 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small-q5_1.bin'
        $file = 'ggml-small-q5_1.bin'; $label = Tr 'vylepseny model prepisu (190 MB)' 'improved transcription model (190 MB)'
    }
    $script:WhisState.Busy = $true; $script:WhisState.Done = $false; $script:WhisState.Ok = $false; $script:WhisState.Msg = 'start'
    $script:WhisRS = [runspacefactory]::CreateRunspace(); $script:WhisRS.Open()
    $script:WhisPS = [powershell]::Create(); $script:WhisPS.Runspace = $script:WhisRS
    [void]$script:WhisPS.AddScript($script:WhisUpWorker).AddArgument($script:WhisState).AddArgument((Join-Path $script:DataDir 'whisper')).AddArgument($url).AddArgument($file).AddArgument($label)
    [void]$script:WhisPS.BeginInvoke()
}

# --- KATALOG HLASU: kazdy jazyk svuj prirozeny (neuralni) Piper hlas ke stazeni ---
# klic = kod jazyka; hodnota = @(relativni cesta modelu na HF, popisek)
$script:VoiceCatalog = [ordered]@{
    en = @('en/en_GB/alan/medium/en_GB-alan-medium',        'English (UK) - Alan')
    cs = @('cs/cs_CZ/jirka/medium/cs_CZ-jirka-medium',      'Čeština - Jirka')
    de = @('de/de_DE/thorsten/medium/de_DE-thorsten-medium','Deutsch - Thorsten')
    es = @('es/es_ES/davefx/medium/es_ES-davefx-medium',    'Español - Davefx')
    fr = @('fr/fr_FR/tom/medium/fr_FR-tom-medium',          'Français - Tom')
    it = @('it/it_IT/paola/medium/it_IT-paola-medium',      'Italiano - Paola')
    pl = @('pl/pl_PL/darkman/medium/pl_PL-darkman-medium',  'Polski - Darkman')
    pt = @('pt/pt_PT/tugao/medium/pt_PT-tugao-medium',      'Português - Tugao')
    nl = @('nl/nl_NL/mls/medium/nl_NL-mls-medium',          'Nederlands - MLS')
    ru = @('ru/ru_RU/dmitri/medium/ru_RU-dmitri-medium',    'Русский - Dmitri')
    uk = @('uk/uk_UA/ukrainian_tts/medium/uk_UA-ukrainian_tts-medium', 'Українська')
    tr = @('tr/tr_TR/fahrettin/medium/tr_TR-fahrettin-medium', 'Türkçe - Fahrettin')
    ro = @('ro/ro_RO/mihai/medium/ro_RO-mihai-medium',      'Română - Mihai')
    hu = @('hu/hu_HU/anna/medium/hu_HU-anna-medium',        'Magyar - Anna')
    el = @('el/el_GR/rapunzelina/low/el_GR-rapunzelina-low','Ελληνικά')
    sr = @('sr/sr_RS/serbski_institut/medium/sr_RS-serbski_institut-medium', 'Srpski')
    da = @('da/da_DK/talesyntese/medium/da_DK-talesyntese-medium', 'Dansk')
    fi = @('fi/fi_FI/harri/medium/fi_FI-harri-medium',      'Suomi - Harri')
    'sv' = @('sv/sv_SE/nst/medium/sv_SE-nst-medium',        'Svenska')
    no = @('no/no_NO/talesyntese/medium/no_NO-talesyntese-medium', 'Norsk')
    ar = @('ar/ar_JO/kareem/medium/ar_JO-kareem-medium',    'العربية - Kareem')
    fa = @('fa/fa_IR/amir/medium/fa_IR-amir-medium',        'فارسی - Amir')
    vi = @('vi/vi_VN/vais1000/medium/vi_VN-vais1000-medium','Tiếng Việt')
    zh = @('zh/zh_CN/huayan/medium/zh_CN-huayan-medium',    '中文 - Huayan')
}
# naplnit combo v karte APLIKACE (katalog vznika az tady, pri stavbe UI jeste neexistoval)
foreach ($vk in $script:VoiceCatalog.Keys) { [void]$cmbVoiceDl.Items.Add([string]$script:VoiceCatalog[$vk][1]) }
if ($cmbVoiceDl.Items.Count -gt 0) { $cmbVoiceDl.SelectedIndex = 0 }
# ============================================================
#  INZENYR ZASAHUJE DO HRY: zapis SETUPU pro ACC (soubor, ktery hra nacita)
#  - klonuje TVUJ posledni setup, nastavi palivo na stint, srovna tlaky
#    podle zivych telemetrickych hodnot a predvyplni pit strategii.
#  Zadne klikani do menu naslepo = nerozbije ti strategii.
# ============================================================
function Make-StintSetup {
    $T = $script:Tel
    $csM = ((Get-EngLang) -eq 'cs')
    if ($T.Sim -ne 'acc' -and -not $T.Demo) { return $(if ($csM) { 'Setupy umim zapisovat jen pro ACC.' } else { 'I can only write setups for ACC (Assetto Corsa Competizione).' }) }
    try {
        $root = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Assetto Corsa Competizione\Setups'
        if (-not (Test-Path $root)) { return $(if ($csM) { 'Nenasel jsem slozku ACC Setups - uloz si nejdriv ve hre jakykoliv setup.' } else { 'ACC Setups folder not found - save any setup in the game first.' }) }
        # slozka auta: presna shoda, jinak podretezcem, jinak (demo) prvni dostupna
        $car = [string]$T.CarModel
        $carDir = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -ieq $car } | Select-Object -First 1
        if (-not $carDir -and $car -and -not $T.Demo) { $carDir = Get-ChildItem $root -Directory | Where-Object { $_.Name -ilike ("*" + $car + "*") -or $car -ilike ("*" + $_.Name + "*") } | Select-Object -First 1 }
        if (-not $carDir) { $carDir = Get-ChildItem $root -Directory | Select-Object -First 1 }
        if (-not $carDir) { return $(if ($csM) { 'Ve slozce Setups nemas zadne auto - uloz si ve hre aspon jeden setup.' } else { 'No car folder in Setups - save at least one setup in the game.' }) }
        # slozka trati: presna/podobna, jinak vytvorit dle nazvu trati z telemetrie
        $trk = [string]$T.Track; if ($T.Demo) { $trk = '' }
        $trkDir = $null
        if ($trk) {
            $trkDir = Get-ChildItem $carDir.FullName -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -ieq $trk -or $_.Name -ilike ("*" + $trk + "*") -or $trk -ilike ("*" + $_.Name + "*") } | Select-Object -First 1
            if (-not $trkDir) { $trkDir = New-Item -ItemType Directory -Path (Join-Path $carDir.FullName $trk.ToLower()) -Force }
        }
        if (-not $trkDir) { $trkDir = Get-ChildItem $carDir.FullName -Directory | Select-Object -First 1 }
        if (-not $trkDir) { return $(if ($csM) { 'Nemam slozku trati a neznam nazev trati - vyjed nejdriv na trat.' } else { 'No track folder and no track name yet - go out on track first.' }) }
        # zdrojovy setup: nejnovejsi json na teto trati, jinak z jine trati stejneho auta
        $src = Get-ChildItem $trkDir.FullName -Filter '*.json' -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike 'PitWise_*' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if (-not $src) { $src = Get-ChildItem $carDir.FullName -Recurse -Filter '*.json' -File | Where-Object { $_.Name -notlike 'PitWise_*' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1 }
        if (-not $src) { return $(if ($csM) { 'Nemam z ceho vychazet - uloz si ve hre libovolny setup a rekni si znovu.' } else { 'Nothing to start from - save any setup in the game and ask again.' }) }
        $setup = Get-Content $src.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
        $zmeny = @()
        # 1) PALIVO na stint (do konce zavodu + rezerva 2 l)
        $fpl = Get-FuelPerLap
        $raceLeft = if ([int]$T.NumberOfLaps -gt 0) { [int]$T.NumberOfLaps - [int]$T.CompletedLaps } else { -1 }
        if ($fpl -gt 0 -and $raceLeft -gt 0) {
            $litres = [int][math]::Ceiling([math]::Min(120, $raceLeft * $fpl + 2))
            $setup.basicSetup.strategy.fuel = $litres
            $zmeny += $(if ($csM) { ("palivo {0} l" -f $litres) } else { ("fuel {0} l" -f $litres) })
            # pit strategie (1. zastavka): dotankovat pripadny zbytek
            try {
                if ($setup.basicSetup.strategy.pitStrategy -and @($setup.basicSetup.strategy.pitStrategy).Count -gt 0) {
                    $setup.basicSetup.strategy.pitStrategy[0].fuelToAdd = [int][math]::Ceiling([math]::Max(0, $raceLeft * $fpl + 2 - $litres))
                    $zmeny += $(if ($csM) { 'pit strategie predvyplnena' } else { 'pit strategy pre-filled' })
                }
            } catch { }
        }
        # 2) TLAKY: podle zivych hodnot (cil ~27.6 psi za tepla; 1 klik setupu = 0.1 psi)
        $tp = $T.TyrePress
        if ($tp -and $tp.Count -ge 4 -and [double]$tp[0] -gt 20 -and [double]$tp[0] -lt 35) {
            $target = 27.6
            $pp = @($setup.basicSetup.tyres.tyrePressure)
            for ($i = 0; $i -lt 4; $i++) {
                $deltaClicks = [int][math]::Round(([double]$tp[$i] - $target) / 0.1)
                $pp[$i] = [math]::Max(0, [math]::Min(100, ([int]$pp[$i] - $deltaClicks)))
            }
            $setup.basicSetup.tyres.tyrePressure = $pp
            $zmeny += $(if ($csM) { ("tlaky srovnany na {0} psi" -f $target) } else { ("pressures trimmed to {0} psi" -f $target) })
        }
        if ($zmeny.Count -eq 0) { $zmeny += $(if ($csM) { 'kopie posledniho setupu (malo dat na upravy - ujed par kol)' } else { 'copy of your last setup (not enough data - do a few laps first)' }) }
        $out = Join-Path $trkDir.FullName 'PitWise_stint.json'
        [System.IO.File]::WriteAllText($out, ($setup | ConvertTo-Json -Depth 25), (New-Object System.Text.UTF8Encoding($false)))
        return $(if ($csM) { ("Setup pripraven: {0} ({1}). Ve hre: Setup > nacti 'PitWise_stint'." -f ($zmeny -join ', '), $trkDir.Name) } else { ("Setup ready: {0} ({1}). In game: Setup > load 'PitWise_stint'." -f ($zmeny -join ', '), $trkDir.Name) })
    } catch { return $(if ($csM) { ('Setup se nepovedl: ' + $_.Exception.Message) } else { ('Setup failed: ' + $_.Exception.Message) }) }
}

$script:PipState = [hashtable]::Synchronized(@{ Busy = $false; Done = $false; Ok = $false; Msg = '' })
$script:PipPS = $null; $script:PipRS = $null
$script:PipWorker = {
    param($state, $destDir, $modelRel, $engineOnly)
    $ProgressPreference = 'SilentlyContinue'
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        # hlasovy engine (piper.exe) stahni jen kdyz jeste neni
        $hasExe = [bool](Get-ChildItem $destDir -Recurse -Filter 'piper.exe' -File -ErrorAction SilentlyContinue | Select-Object -First 1)
        if (-not $hasExe) {
            $zip = Join-Path $env:TEMP 'pitwise-piper.zip'
            $state.Msg = 'engine'
            Invoke-WebRequest 'https://github.com/rhasspy/piper/releases/download/2023.11.14-2/piper_windows_amd64.zip' -OutFile $zip -UseBasicParsing -TimeoutSec 900
            $state.Msg = 'unpack'
            Expand-Archive $zip -DestinationPath $destDir -Force
            Remove-Item $zip -Force -ErrorAction SilentlyContinue
        }
        if (-not $engineOnly -and $modelRel) {
            $fname = ($modelRel -split '/')[-1]
            $state.Msg = 'voice'
            $base = 'https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/' + $modelRel
            Invoke-WebRequest ($base + '.onnx')      -OutFile (Join-Path $destDir ($fname + '.onnx'))      -UseBasicParsing -TimeoutSec 1800
            Invoke-WebRequest ($base + '.onnx.json') -OutFile (Join-Path $destDir ($fname + '.onnx.json')) -UseBasicParsing -TimeoutSec 300
        }
        $state.Ok = $true; $state.Msg = 'done'
    } catch { $state.Ok = $false; $state.Msg = ('err|' + $_.Exception.Message) }
    $state.Done = $true; $state.Busy = $false
}
# klice prubehu z workeru -> text podle jazyka UI
function Get-DlMsgText([string]$k) {
    switch ($k) {
        'start'  { return (Tr 'zacinam...' 'starting...') }
        'engine' { return (Tr 'stahuji hlasovy engine (20 MB)...' 'downloading voice engine (20 MB)...') }
        'unpack' { return (Tr 'rozbaluji...' 'unpacking...') }
        'voice'  { return (Tr 'stahuji neuralni hlas (~60 MB)...' 'downloading neural voice (~60 MB)...') }
        'done'   { return (Tr 'hotovo' 'done') }
        'sr-engine' { return (Tr 'stahuji rozpoznavac reci (20 MB)...' 'downloading speech recognizer (20 MB)...') }
        'sr-model'  { return (Tr 'stahuji model reci (57 MB)...' 'downloading speech model (57 MB)...') }
    }
    if ($k -like 'err|*') { return ((Tr 'chyba: ' 'error: ') + $k.Substring(4)) }
    if ($k -like 'dl|*')  { return ((Tr 'stahuji ' 'downloading ') + $k.Substring(3) + '...') }
    return $k
}
function Start-PiperDownload([string]$modelRel = '') {
    if ($script:PipState.Busy) { return }
    if (-not $modelRel) { $modelRel = $script:VoiceCatalog['cs'][0] }   # zpetna kompatibilita
    $script:PipState.Busy = $true; $script:PipState.Done = $false; $script:PipState.Ok = $false; $script:PipState.Msg = 'start'
    $script:PipRS = [runspacefactory]::CreateRunspace(); $script:PipRS.Open()
    $script:PipPS = [powershell]::Create(); $script:PipPS.Runspace = $script:PipRS
    [void]$script:PipPS.AddScript($script:PipWorker).AddArgument($script:PipState).AddArgument((Join-Path $script:DataDir 'piper')).AddArgument($modelRel).AddArgument($false)
    [void]$script:PipPS.BeginInvoke()
}
function Get-DownloadedVoices {
    $dir = Join-Path $script:DataDir 'piper'
    if (-not (Test-Path $dir)) { return @() }
    @(Get-ChildItem $dir -Recurse -Filter '*.onnx' -File -ErrorAction SilentlyContinue | ForEach-Object { $_.BaseName })
}
# --- Seznam "Hlas radia": stazene Piper hlasy + hlasy Windows + jazyky ke stazeni primo v combu ---
$script:VoiceMeta = @()          # metadata polozek perVoice (Kind: auto/piper/sapi/dl)
$script:VoiceSelIx = 0           # posledni platny vyber (na nej se vracime po kliknuti na "Stahnout")
$script:VoiceListBusy = $false   # true = prestavujeme combo, handler ma mlcet
$script:PendingVoiceBase = ''    # hlas, ktery se po dokonceni stahovani sam vybere
function Rebuild-VoiceList {
    $script:VoiceListBusy = $true
    try {
        $meta = New-Object System.Collections.ArrayList
        $perVoice.Items.Clear()
        [void]$perVoice.Items.Add((Tr '(automaticky - nejlepsi pro jazyk inzenyra)' '(auto - best for engineer language)'))
        [void]$meta.Add(@{ Kind = 'auto' })
        $have = @{}
        if ($script:Piper) {
            foreach ($pv in @(Get-PiperVoices)) {
                [void]$perVoice.Items.Add(('Piper - {0} ({1})' -f $pv.LangLabel, $pv.Speaker))
                [void]$meta.Add(@{ Kind = 'piper'; Base = [string]$pv.Base })
                if ($pv.Code) { $have[[string]$pv.Code] = $true }
            }
        }
        if ($script:Tts) {
            foreach ($v in $script:Tts.GetInstalledVoices()) {
                if (-not $v.Enabled) { continue }
                [void]$perVoice.Items.Add($v.VoiceInfo.Name)
                [void]$meta.Add(@{ Kind = 'sapi'; Name = [string]$v.VoiceInfo.Name })
            }
        }
        foreach ($vk in @($script:VoiceCatalog.Keys)) {
            if ($have[[string]$vk]) { continue }
            [void]$perVoice.Items.Add(('{0} {1} (~60 MB)' -f (Tr 'Stahnout:' 'Download:'), [string]$script:VoiceCatalog[$vk][1]))
            [void]$meta.Add(@{ Kind = 'dl'; Code = [string]$vk })
        }
        $script:VoiceMeta = @($meta)
        # obnovit vyber podle ulozeneho nastaveni
        $sel = 0
        $v = [string]$script:Settings.Voice
        for ($ix = 1; $ix -lt $script:VoiceMeta.Count; $ix++) {
            $m = $script:VoiceMeta[$ix]
            if ($v -like '__piper:*' -and $m.Kind -eq 'piper' -and $m.Base -eq $v.Substring(8)) { $sel = $ix; break }
            if ($v -eq '__piper__' -and $m.Kind -eq 'piper') { $sel = $ix; break }
            if ($v -and $m.Kind -eq 'sapi' -and $m.Name -eq $v) { $sel = $ix; break }
        }
        $perVoice.SelectedIndex = $sel
        $script:VoiceSelIx = $sel
    } finally { $script:VoiceListBusy = $false }
}

# ============================================================
#  UDALOSTI
# ============================================================
# ============================================================
#  JAZYK UI (en = vychozi, cs prepinacem) - preklad vsech statickych textu
# ============================================================
# pary (cesky, anglicky) - PRESNE jak jsou vykreslene (titulky karet velkymi pismeny)
$script:UiMap = @(
    @('Prehled','Overview'), @('Telemetrie','Telemetry'), @('Mapa trati','Track map'),
    @('Strategie','Strategy'), @('Zavodni inzenyr','Race engineer'), @('Nastaveni','Settings'),
    @('Vzdy navrchu','Always on top'), @('Demo','Demo'),
    @('ZIVA TELEMETRIE','LIVE TELEMETRY'), @('CASY KOL','LAP TIMES'), @('STAV','STATUS'),
    @('PREHLED KOL','LAP LIST'), @('RYCHLOST - POSLEDNICH 30 S','SPEED - LAST 30 S'),
    @('PLYN / BRZDA / RIZENI (FIALOVA)','THROTTLE / BRAKE / STEERING (PURPLE)'),
    @('PRETIZENI','G-FORCE'), @('MAPA TRATI','TRACK MAP'),
    @('STRATEGIE PALIVA + STINTY','FUEL STRATEGY + STINTS'), @('SEZENI','SESSION'),
    @('RADIO','RADIO'), @('OVLADANI','CONTROLS'), @('AI BONUS (VOLITELNE)','AI BONUS (OPTIONAL)'),
    @('TVUJ INZENYR','YOUR ENGINEER'), @('APLIKACE','APPLICATION'),
    @('stupen','gear'), @('Teploty gum (C)','Tyre temps (C)'), @('Aktualni kolo','Current lap'),
    @('Delta na nejlepsi kolo (ziva behem jizdy)','Delta to best lap (live while driving)'),
    @('(GT3, orientacni)','(GT3, approximate)'), @('PLAN STINTU','STINT PLAN'),
    @('Stinty prepocitavam prubezne z tve realne spotreby. Rekni ''naplanuj box'' do vysilacky.','Stints recalculate live from your real fuel use. Say ''plan a pit stop'' on the radio.'),
    @('Ulozit relaci do souboru','Save session to file'),
    @('Inzenyr: pripravit setup stintu (ACC)','Engineer: prepare stint setup (ACC)'),
    @('Nejlepsi --   Prumer --','Best --   Average --'), @('Konzistence: --','Consistency: --'),
    @('MINI-SEKTORY - DELTA NA NEJLEPSI KOLO','MINI-SECTORS - DELTA TO BEST LAP'),
    @('Historie kol','Lap history'), @('HISTORIE KOL','LAP HISTORY'),
    @('Zpetna vazba','Feedback'), @('ZPETNA VAZBA','FEEDBACK'),
    @('Co bys zlepsil? Napis mi cokoliv - chyby, napady, prani. Ctu vse.','What would you improve? Tell me anything - bugs, ideas, wishes. I read it all.'),
    @('Tvuj e-mail (nepovinne, kdyz chces odpoved):','Your email (optional, if you want a reply):'),
    @('Odeslat zpetnou vazbu','Send feedback'),
    @('RYCHLOST PO DELCE KOLA','SPEED OVER LAP DISTANCE'),
    @('PLYN / BRZDA PO DELCE KOLA','THROTTLE / BRAKE OVER LAP DISTANCE'),
    @('Porovnat s:','Compare to:'),
    @('PRIROZENY HLAS (CLOUD - JAKO CHATGPT)','NATURAL VOICE (CLOUD - LIKE CHATGPT)'),
    @('Mapa se nakresli sama behem prvniho kola. Barva = rychlost (cervena pomalu, zelena rychle).','The map draws itself during your first lap. Colour = speed (red slow, green fast).'),
    @('Inzenyr mluvi (hlas)','Engineer speaks (voice)'), @('Test radia','Radio test'),
    @('Zeptej se inzenyra:','Ask your engineer:'), @('Poslat do radia','Send over radio'),
    @('Mluvit (mikrofon)','Talk (microphone)'), @('Mluvit (stahni v Nastaveni)','Talk (download in Settings)'),
    @('Poslat','Send'), @('Enter = odeslat. Nebo drz klavesu vysilacky a mluv.','Enter = send. Or hold your push-to-talk key and speak.'),
    @('MAPA','MAP'), @('INZENYR (RADIO)','ENGINEER (RADIO)'),
    @('Klavesa vysilacky (i ve hre):','Push-to-talk key (works in-game):'),
    @('Co komentuje:','Comments on:'),
    @('Jak casto mluvi:','Talkativeness:'),
    @('(klikni, pak klavesa/volant)','(click, then key/wheel button)'), @('Zrusit','Clear'),
    @('Tip: tlacitko volantu namapujes na klavesu v MOZA Pit House.','Tip: click the box, then press a wheel button to bind it.'),
    @('Anthropic API klic:','Anthropic API key:'),
    @('Model (rychly = nizka latence i cena):','Model (fast = low latency and cost):'),
    @('Inzenyr mluvi nahlas (hlas do radia)','Engineer speaks aloud (radio voice)'),
    @('Ulozit','Save'),
    @('Jmeno inzenyra (jak se predstavi v radiu):','Engineer name (radio call sign):'),
    @('Povaha:','Personality:'),
    @('Vlastni instrukce (volitelne, cesky):','Custom instructions (optional):'),
    @('Hlas radia:','Radio voice:'),
    @('Jazyk inzenyra (hlasky i AI odpovedi):','Engineer language (callouts and AI):'),
    @('Rychlost reci (pomalu <-> rychle):','Speech rate (slow <-> fast):'),
    @('Vyzkouset hlas','Test voice'), @('Ulozit inzenyra','Save engineer'),
    @('Pridat zastupce na plochu','Add desktop shortcut'),
    @('Odemknout dalsi hlasy Windows (admin)','Unlock more Windows voices (admin)'),
    @('Klavesa vysilacky:','Push-to-talk:'), @('(klikni + stiskni)','(click + press)'),
    @('Inzenyr odpovida hned a zdarma (lokalni rezim). S API klicem v Nastaveni odpovida chytrejsi AI. Mikrofon: drz klavesu vysilacky nebo klikni Mluvit; prepis bezi offline a umi cestinu.','The engineer answers instantly for free (local mode). Add an API key in Settings for smarter AI. Mic: hold your push-to-talk or click Talk; transcription runs offline.'),
    @('KLIC NENI POTREBA - bez nej odpovida vestaveny lokalni inzenyr (okamzite, offline, zdarma). S klicem (console.anthropic.com) odpovida chytrejsi AI. Klic zustava jen na tvem disku.','NO KEY NEEDED - the built-in local engineer answers instantly, offline and free. With a key (console.anthropic.com) a smarter AI answers. The key never leaves your disk.'),
    @('Prirozeny hlas inzenyra - stahni svuj jazyk:','Natural engineer voice - download your language:'),
    @('Jmeno, povaha, jazyk a instrukce se promitnou do AI odpovedi i hlasek. Dalsi jazyky hlasu stahnes primo v seznamu Hlas radia.','Name, personality, language and instructions shape AI answers and callouts. Download more voice languages right in the Radio voice list.')
)
$script:NavTitles = @{}
# --- Vicejazycne UI: kody + prekladova tabulka (en/cs jsou v UiMap; ostatni tady) ---
$script:UiLangCodes = @('en','cs','sk','de','pl','es','fr','it','pt')  # poradi = polozky v cmbUi
$script:UiCur = 'cs'   # ovladaci prvky se stavi v cestine; walker preklada z tohoto jazyka
$uiTrJson = @'
{
"sk":{"Overview":"Prehľad","Telemetry":"Telemetria","Track map":"Mapa trate","Strategy":"Stratégia","Race engineer":"Pretekový inžinier","Settings":"Nastavenia","Always on top":"Vždy navrchu","LIVE TELEMETRY":"ŽIVÁ TELEMETRIA","LAP TIMES":"ČASY KÔL","STATUS":"STAV","LAP LIST":"ZOZNAM KÔL","SPEED - LAST 30 S":"RÝCHLOSŤ - POSLEDNÝCH 30 S","THROTTLE / BRAKE / STEERING (PURPLE)":"PLYN / BRZDA / RIADENIE (FIALOVÁ)","G-FORCE":"PRETAŽENIE","FUEL STRATEGY + STINTS":"STRATÉGIA PALIVA + STINTY","SESSION":"SEDENIE","CONTROLS":"OVLÁDANIE","AI BONUS (OPTIONAL)":"AI BONUS (VOLITEĽNÉ)","YOUR ENGINEER":"TVOJ INŽINIER","APPLICATION":"APLIKÁCIA","gear":"stupeň","Tyre temps (C)":"Teploty pneumatík (C)","Current lap":"Aktuálne kolo","Delta to best lap (live while driving)":"Delta na najlepšie kolo (živá počas jazdy)","(GT3, approximate)":"(GT3, orientačné)","STINT PLAN":"PLÁN STINTOV","Stints recalculate live from your real fuel use. Say 'plan a pit stop' on the radio.":"Stinty sa priebežne prepočítavajú z tvojej reálnej spotreby. Povedz 'naplánuj box' do vysielačky.","Save session to file":"Uložiť reláciu do súboru","Engineer: prepare stint setup (ACC)":"Inžinier: priprav setup stintu (ACC)","Best --   Average --":"Najlepšie --   Priemer --","Consistency: --":"Konzistencia: --","MINI-SECTORS - DELTA TO BEST LAP":"MINI-SEKTORY - DELTA NA NAJLEPŠIE KOLO","The map draws itself during your first lap. Colour = speed (red slow, green fast).":"Mapa sa nakreslí sama počas prvého kola. Farba = rýchlosť (červená pomaly, zelená rýchlo).","Engineer speaks (voice)":"Inžinier hovorí (hlas)","Radio test":"Test vysielačky","Ask your engineer:":"Opýtaj sa inžiniera:","Send over radio":"Poslať do vysielačky","Talk (microphone)":"Hovoriť (mikrofón)","Talk (download in Settings)":"Hovoriť (stiahni v Nastaveniach)","Send":"Poslať","Enter = send. Or hold your push-to-talk key and speak.":"Enter = odoslať. Alebo drž klávesu vysielačky a hovor.","MAP":"MAPA","ENGINEER (RADIO)":"INŽINIER (RÁDIO)","Push-to-talk key (works in-game):":"Klávesa vysielačky (funguje aj v hre):","Comments on:":"Čo komentuje:","Talkativeness:":"Ako často hovorí:","(click, then key/wheel button)":"(klikni, potom klávesa/tlačidlo volantu)","Clear":"Zrušiť","Tip: click the box, then press a wheel button to bind it.":"Tip: klikni do políčka, potom stlač tlačidlo volantu na priradenie.","Anthropic API key:":"Anthropic API kľúč:","Model (fast = low latency and cost):":"Model (rýchly = nízka latencia aj cena):","Engineer speaks aloud (radio voice)":"Inžinier hovorí nahlas (hlas do rádia)","Save":"Uložiť","Engineer name (radio call sign):":"Meno inžiniera (ako sa predstaví v rádiu):","Personality:":"Povaha:","Custom instructions (optional):":"Vlastné inštrukcie (voliteľné):","Radio voice:":"Hlas rádia:","Engineer language (callouts and AI):":"Jazyk inžiniera (hlásky aj AI odpovede):","Speech rate (slow <-> fast):":"Rýchlosť reči (pomaly <-> rýchlo):","Test voice":"Vyskúšať hlas","Save engineer":"Uložiť inžiniera","Add desktop shortcut":"Pridať zástupcu na plochu","Unlock more Windows voices (admin)":"Odomknúť ďalšie hlasy Windows (admin)","Push-to-talk:":"Vysielačka:","(click + press)":"(klikni + stlač)","The engineer answers instantly for free (local mode). Add an API key in Settings for smarter AI. Mic: hold your push-to-talk or click Talk; transcription runs offline.":"Inžinier odpovedá okamžite a zadarmo (lokálny režim). S API kľúčom v Nastaveniach odpovedá chytrejšia AI. Mikrofón: drž klávesu vysielačky alebo klikni Hovoriť; prepis beží offline.","NO KEY NEEDED - the built-in local engineer answers instantly, offline and free. With a key (console.anthropic.com) a smarter AI answers. The key never leaves your disk.":"KĽÚČ NIE JE POTREBNÝ - bez neho odpovedá vstavaný lokálny inžinier (okamžite, offline, zadarmo). S kľúčom (console.anthropic.com) odpovedá chytrejšia AI. Kľúč zostáva len na tvojom disku.","Natural engineer voice - download your language:":"Prirodzený hlas inžiniera - stiahni svoj jazyk:","Name, personality, language and instructions shape AI answers and callouts. Download more voice languages right in the Radio voice list.":"Meno, povaha, jazyk a inštrukcie sa premietnu do AI odpovedí aj hlások. Ďalšie jazyky hlasu stiahneš priamo v zozname Hlas rádia.","Professional - calm and concise":"Profesionál - pokojný a stručný","Tough guy - blunt, no sugar-coating":"Drsniak - úprimný, žiadne servítky","Buddy - chill and encouraging":"Kamoš - pohodový, povzbudzuje","Analyst - speaks in numbers and data":"Analytik - hovorí v číslach a dátach","Lap times & delta":"Časy kôl a delta","Fuel":"Palivo","Tyres":"Pneumatiky","Flags":"Vlajky","Contacts & crashes":"Kontakty a nehody","Final laps countdown":"Odpočet konca","Personal records":"Osobné rekordy","Essentials only":"Len dôležité","Normal":"Normálne","Chatty":"Ukecaný","(auto - by voice)":"(automaticky podľa hlasu)"},
"de":{"Overview":"Übersicht","Telemetry":"Telemetrie","Track map":"Streckenkarte","Strategy":"Strategie","Race engineer":"Renningenieur","Settings":"Einstellungen","Always on top":"Immer im Vordergrund","LIVE TELEMETRY":"LIVE-TELEMETRIE","LAP TIMES":"RUNDENZEITEN","STATUS":"STATUS","LAP LIST":"RUNDENLISTE","SPEED - LAST 30 S":"GESCHWINDIGKEIT - LETZTE 30 S","THROTTLE / BRAKE / STEERING (PURPLE)":"GAS / BREMSE / LENKUNG (LILA)","G-FORCE":"G-KRAFT","FUEL STRATEGY + STINTS":"SPRITSTRATEGIE + STINTS","SESSION":"SESSION","CONTROLS":"STEUERUNG","AI BONUS (OPTIONAL)":"KI-BONUS (OPTIONAL)","YOUR ENGINEER":"DEIN INGENIEUR","APPLICATION":"ANWENDUNG","gear":"Gang","Tyre temps (C)":"Reifentemp. (C)","Current lap":"Aktuelle Runde","Delta to best lap (live while driving)":"Delta zur besten Runde (live beim Fahren)","(GT3, approximate)":"(GT3, ungefähr)","STINT PLAN":"STINT-PLAN","Stints recalculate live from your real fuel use. Say 'plan a pit stop' on the radio.":"Stints werden laufend aus deinem echten Verbrauch berechnet. Sag 'Box planen' über Funk.","Save session to file":"Session in Datei speichern","Engineer: prepare stint setup (ACC)":"Ingenieur: Stint-Setup vorbereiten (ACC)","Best --   Average --":"Beste --   Schnitt --","Consistency: --":"Konstanz: --","MINI-SECTORS - DELTA TO BEST LAP":"MINI-SEKTOREN - DELTA ZUR BESTEN RUNDE","The map draws itself during your first lap. Colour = speed (red slow, green fast).":"Die Karte zeichnet sich während deiner ersten Runde selbst. Farbe = Geschwindigkeit (rot langsam, grün schnell).","Engineer speaks (voice)":"Ingenieur spricht (Stimme)","Radio test":"Funktest","Ask your engineer:":"Frag deinen Ingenieur:","Send over radio":"Über Funk senden","Talk (microphone)":"Sprechen (Mikrofon)","Talk (download in Settings)":"Sprechen (in Einstellungen laden)","Send":"Senden","Enter = send. Or hold your push-to-talk key and speak.":"Enter = senden. Oder halte deine Funktaste und sprich.","MAP":"KARTE","ENGINEER (RADIO)":"INGENIEUR (FUNK)","Push-to-talk key (works in-game):":"Funktaste (funktioniert im Spiel):","Comments on:":"Kommentiert:","Talkativeness:":"Gesprächigkeit:","(click, then key/wheel button)":"(klicken, dann Taste/Lenkrad-Knopf)","Clear":"Löschen","Tip: click the box, then press a wheel button to bind it.":"Tipp: ins Feld klicken, dann einen Lenkrad-Knopf drücken zum Zuweisen.","Anthropic API key:":"Anthropic API-Schlüssel:","Model (fast = low latency and cost):":"Modell (schnell = geringe Latenz und Kosten):","Engineer speaks aloud (radio voice)":"Ingenieur spricht laut (Funkstimme)","Save":"Speichern","Engineer name (radio call sign):":"Name des Ingenieurs (Funkrufname):","Personality:":"Charakter:","Custom instructions (optional):":"Eigene Anweisungen (optional):","Radio voice:":"Funkstimme:","Engineer language (callouts and AI):":"Sprache des Ingenieurs (Ansagen und KI):","Speech rate (slow <-> fast):":"Sprechtempo (langsam <-> schnell):","Test voice":"Stimme testen","Save engineer":"Ingenieur speichern","Add desktop shortcut":"Desktop-Verknüpfung erstellen","Unlock more Windows voices (admin)":"Weitere Windows-Stimmen freischalten (Admin)","Push-to-talk:":"Funktaste:","(click + press)":"(klicken + drücken)","The engineer answers instantly for free (local mode). Add an API key in Settings for smarter AI. Mic: hold your push-to-talk or click Talk; transcription runs offline.":"Der Ingenieur antwortet sofort und kostenlos (lokaler Modus). Für klügere KI einen API-Schlüssel in den Einstellungen hinzufügen. Mikro: Funktaste halten oder Sprechen klicken; Transkription läuft offline.","NO KEY NEEDED - the built-in local engineer answers instantly, offline and free. With a key (console.anthropic.com) a smarter AI answers. The key never leaves your disk.":"KEIN SCHLÜSSEL NÖTIG - der eingebaute lokale Ingenieur antwortet sofort, offline und kostenlos. Mit einem Schlüssel (console.anthropic.com) antwortet eine klügere KI. Der Schlüssel bleibt nur auf deiner Festplatte.","Natural engineer voice - download your language:":"Natürliche Ingenieursstimme - lade deine Sprache:","Name, personality, language and instructions shape AI answers and callouts. Download more voice languages right in the Radio voice list.":"Name, Charakter, Sprache und Anweisungen prägen KI-Antworten und Ansagen. Weitere Stimmensprachen lädst du direkt in der Liste Funkstimme.","Professional - calm and concise":"Profi - ruhig und knapp","Tough guy - blunt, no sugar-coating":"Harter Kerl - direkt, ohne Beschönigung","Buddy - chill and encouraging":"Kumpel - locker und aufmunternd","Analyst - speaks in numbers and data":"Analyst - spricht in Zahlen und Daten","Lap times & delta":"Rundenzeiten & Delta","Fuel":"Sprit","Tyres":"Reifen","Flags":"Flaggen","Contacts & crashes":"Kontakte & Unfälle","Final laps countdown":"Countdown letzte Runden","Personal records":"Persönliche Rekorde","Essentials only":"Nur Wichtiges","Normal":"Normal","Chatty":"Gesprächig","(auto - by voice)":"(automatisch - nach Stimme)"},
"pl":{"Overview":"Przegląd","Telemetry":"Telemetria","Track map":"Mapa toru","Strategy":"Strategia","Race engineer":"Inżynier wyścigowy","Settings":"Ustawienia","Always on top":"Zawsze na wierzchu","LIVE TELEMETRY":"TELEMETRIA NA ŻYWO","LAP TIMES":"CZASY OKRĄŻEŃ","STATUS":"STATUS","LAP LIST":"LISTA OKRĄŻEŃ","SPEED - LAST 30 S":"PRĘDKOŚĆ - OSTATNIE 30 S","THROTTLE / BRAKE / STEERING (PURPLE)":"GAZ / HAMULEC / KIEROWNICA (FIOLET)","G-FORCE":"PRZECIĄŻENIE","FUEL STRATEGY + STINTS":"STRATEGIA PALIWA + STINTY","SESSION":"SESJA","CONTROLS":"STEROWANIE","AI BONUS (OPTIONAL)":"BONUS AI (OPCJONALNY)","YOUR ENGINEER":"TWÓJ INŻYNIER","APPLICATION":"APLIKACJA","gear":"bieg","Tyre temps (C)":"Temp. opon (C)","Current lap":"Aktualne okrążenie","Delta to best lap (live while driving)":"Delta do najlepszego okrążenia (na żywo podczas jazdy)","(GT3, approximate)":"(GT3, orientacyjnie)","STINT PLAN":"PLAN STINTÓW","Stints recalculate live from your real fuel use. Say 'plan a pit stop' on the radio.":"Stinty przeliczają się na bieżąco z twojego realnego zużycia. Powiedz 'zaplanuj postój' przez radio.","Save session to file":"Zapisz sesję do pliku","Engineer: prepare stint setup (ACC)":"Inżynier: przygotuj setup stintu (ACC)","Best --   Average --":"Najlepsze --   Średnia --","Consistency: --":"Powtarzalność: --","MINI-SECTORS - DELTA TO BEST LAP":"MINI-SEKTORY - DELTA DO NAJLEPSZEGO OKRĄŻENIA","The map draws itself during your first lap. Colour = speed (red slow, green fast).":"Mapa rysuje się sama podczas pierwszego okrążenia. Kolor = prędkość (czerwony wolno, zielony szybko).","Engineer speaks (voice)":"Inżynier mówi (głos)","Radio test":"Test radia","Ask your engineer:":"Zapytaj inżyniera:","Send over radio":"Wyślij przez radio","Talk (microphone)":"Mów (mikrofon)","Talk (download in Settings)":"Mów (pobierz w Ustawieniach)","Send":"Wyślij","Enter = send. Or hold your push-to-talk key and speak.":"Enter = wyślij. Albo przytrzymaj klawisz radia i mów.","MAP":"MAPA","ENGINEER (RADIO)":"INŻYNIER (RADIO)","Push-to-talk key (works in-game):":"Klawisz radia (działa też w grze):","Comments on:":"Komentuje:","Talkativeness:":"Gadatliwość:","(click, then key/wheel button)":"(kliknij, potem klawisz/przycisk kierownicy)","Clear":"Wyczyść","Tip: click the box, then press a wheel button to bind it.":"Wskazówka: kliknij pole, potem naciśnij przycisk kierownicy, aby przypisać.","Anthropic API key:":"Klucz API Anthropic:","Model (fast = low latency and cost):":"Model (szybki = niskie opóźnienie i koszt):","Engineer speaks aloud (radio voice)":"Inżynier mówi na głos (głos radia)","Save":"Zapisz","Engineer name (radio call sign):":"Imię inżyniera (jak się przedstawi w radiu):","Personality:":"Charakter:","Custom instructions (optional):":"Własne instrukcje (opcjonalnie):","Radio voice:":"Głos radia:","Engineer language (callouts and AI):":"Język inżyniera (komunikaty i AI):","Speech rate (slow <-> fast):":"Tempo mowy (wolno <-> szybko):","Test voice":"Przetestuj głos","Save engineer":"Zapisz inżyniera","Add desktop shortcut":"Dodaj skrót na pulpicie","Unlock more Windows voices (admin)":"Odblokuj więcej głosów Windows (admin)","Push-to-talk:":"Klawisz radia:","(click + press)":"(kliknij + naciśnij)","The engineer answers instantly for free (local mode). Add an API key in Settings for smarter AI. Mic: hold your push-to-talk or click Talk; transcription runs offline.":"Inżynier odpowiada natychmiast i za darmo (tryb lokalny). Dodaj klucz API w Ustawieniach dla mądrzejszej AI. Mikrofon: przytrzymaj klawisz radia lub kliknij Mów; transkrypcja działa offline.","NO KEY NEEDED - the built-in local engineer answers instantly, offline and free. With a key (console.anthropic.com) a smarter AI answers. The key never leaves your disk.":"KLUCZ NIE JEST POTRZEBNY - wbudowany lokalny inżynier odpowiada natychmiast, offline i za darmo. Z kluczem (console.anthropic.com) odpowiada mądrzejsza AI. Klucz zostaje tylko na twoim dysku.","Natural engineer voice - download your language:":"Naturalny głos inżyniera - pobierz swój język:","Name, personality, language and instructions shape AI answers and callouts. Download more voice languages right in the Radio voice list.":"Imię, charakter, język i instrukcje kształtują odpowiedzi AI i komunikaty. Więcej języków głosu pobierzesz w liście Głos radia.","Professional - calm and concise":"Profesjonalista - spokojny i zwięzły","Tough guy - blunt, no sugar-coating":"Twardziel - bez owijania w bawełnę","Buddy - chill and encouraging":"Kumpel - wyluzowany i wspierający","Analyst - speaks in numbers and data":"Analityk - mówi liczbami i danymi","Lap times & delta":"Czasy okrążeń i delta","Fuel":"Paliwo","Tyres":"Opony","Flags":"Flagi","Contacts & crashes":"Kontakty i kraksy","Final laps countdown":"Odliczanie ostatnich okrążeń","Personal records":"Rekordy osobiste","Essentials only":"Tylko najważniejsze","Normal":"Normalnie","Chatty":"Gadatliwy","(auto - by voice)":"(automatycznie - wg głosu)"},
"es":{"Overview":"Resumen","Telemetry":"Telemetría","Track map":"Mapa del circuito","Strategy":"Estrategia","Race engineer":"Ingeniero de carrera","Settings":"Ajustes","Always on top":"Siempre visible","LIVE TELEMETRY":"TELEMETRÍA EN VIVO","LAP TIMES":"TIEMPOS POR VUELTA","STATUS":"ESTADO","LAP LIST":"LISTA DE VUELTAS","SPEED - LAST 30 S":"VELOCIDAD - ÚLTIMOS 30 S","THROTTLE / BRAKE / STEERING (PURPLE)":"ACELERADOR / FRENO / DIRECCIÓN (MORADO)","G-FORCE":"FUERZA G","FUEL STRATEGY + STINTS":"ESTRATEGIA DE COMBUSTIBLE + STINTS","SESSION":"SESIÓN","CONTROLS":"CONTROLES","AI BONUS (OPTIONAL)":"BONUS DE IA (OPCIONAL)","YOUR ENGINEER":"TU INGENIERO","APPLICATION":"APLICACIÓN","gear":"marcha","Tyre temps (C)":"Temp. neumáticos (C)","Current lap":"Vuelta actual","Delta to best lap (live while driving)":"Delta a la mejor vuelta (en vivo al conducir)","(GT3, approximate)":"(GT3, aproximado)","STINT PLAN":"PLAN DE STINTS","Stints recalculate live from your real fuel use. Say 'plan a pit stop' on the radio.":"Los stints se recalculan en vivo según tu consumo real. Di 'planifica una parada' por radio.","Save session to file":"Guardar sesión en archivo","Engineer: prepare stint setup (ACC)":"Ingeniero: preparar setup del stint (ACC)","Best --   Average --":"Mejor --   Media --","Consistency: --":"Consistencia: --","MINI-SECTORS - DELTA TO BEST LAP":"MINI-SECTORES - DELTA A LA MEJOR VUELTA","The map draws itself during your first lap. Colour = speed (red slow, green fast).":"El mapa se dibuja solo durante tu primera vuelta. Color = velocidad (rojo lento, verde rápido).","Engineer speaks (voice)":"El ingeniero habla (voz)","Radio test":"Prueba de radio","Ask your engineer:":"Pregunta a tu ingeniero:","Send over radio":"Enviar por radio","Talk (microphone)":"Hablar (micrófono)","Talk (download in Settings)":"Hablar (descargar en Ajustes)","Send":"Enviar","Enter = send. Or hold your push-to-talk key and speak.":"Enter = enviar. O mantén tu tecla de radio y habla.","MAP":"MAPA","ENGINEER (RADIO)":"INGENIERO (RADIO)","Push-to-talk key (works in-game):":"Tecla de radio (funciona en el juego):","Comments on:":"Comenta sobre:","Talkativeness:":"Locuacidad:","(click, then key/wheel button)":"(clic, luego tecla/botón del volante)","Clear":"Borrar","Tip: click the box, then press a wheel button to bind it.":"Consejo: haz clic en el campo y pulsa un botón del volante para asignarlo.","Anthropic API key:":"Clave API de Anthropic:","Model (fast = low latency and cost):":"Modelo (rápido = baja latencia y coste):","Engineer speaks aloud (radio voice)":"El ingeniero habla en voz alta (voz de radio)","Save":"Guardar","Engineer name (radio call sign):":"Nombre del ingeniero (indicativo de radio):","Personality:":"Personalidad:","Custom instructions (optional):":"Instrucciones propias (opcional):","Radio voice:":"Voz de radio:","Engineer language (callouts and AI):":"Idioma del ingeniero (avisos e IA):","Speech rate (slow <-> fast):":"Velocidad de voz (lento <-> rápido):","Test voice":"Probar voz","Save engineer":"Guardar ingeniero","Add desktop shortcut":"Añadir acceso directo al escritorio","Unlock more Windows voices (admin)":"Desbloquear más voces de Windows (admin)","Push-to-talk:":"Tecla de radio:","(click + press)":"(clic + pulsar)","The engineer answers instantly for free (local mode). Add an API key in Settings for smarter AI. Mic: hold your push-to-talk or click Talk; transcription runs offline.":"El ingeniero responde al instante y gratis (modo local). Añade una clave API en Ajustes para una IA más lista. Micro: mantén tu tecla de radio o pulsa Hablar; la transcripción es offline.","NO KEY NEEDED - the built-in local engineer answers instantly, offline and free. With a key (console.anthropic.com) a smarter AI answers. The key never leaves your disk.":"NO NECESITAS CLAVE - el ingeniero local integrado responde al instante, offline y gratis. Con una clave (console.anthropic.com) responde una IA más lista. La clave se queda solo en tu disco.","Natural engineer voice - download your language:":"Voz natural del ingeniero - descarga tu idioma:","Name, personality, language and instructions shape AI answers and callouts. Download more voice languages right in the Radio voice list.":"Nombre, personalidad, idioma e instrucciones dan forma a las respuestas de IA y avisos. Descarga más idiomas de voz en la lista Voz de radio.","Professional - calm and concise":"Profesional - tranquilo y conciso","Tough guy - blunt, no sugar-coating":"Duro - directo, sin rodeos","Buddy - chill and encouraging":"Colega - relajado y alentador","Analyst - speaks in numbers and data":"Analista - habla con números y datos","Lap times & delta":"Tiempos y delta","Fuel":"Combustible","Tyres":"Neumáticos","Flags":"Banderas","Contacts & crashes":"Contactos y choques","Final laps countdown":"Cuenta atrás de últimas vueltas","Personal records":"Récords personales","Essentials only":"Solo lo esencial","Normal":"Normal","Chatty":"Hablador","(auto - by voice)":"(automático - por voz)"},
"fr":{"Overview":"Aperçu","Telemetry":"Télémétrie","Track map":"Carte du circuit","Strategy":"Stratégie","Race engineer":"Ingénieur de course","Settings":"Paramètres","Always on top":"Toujours au premier plan","LIVE TELEMETRY":"TÉLÉMÉTRIE EN DIRECT","LAP TIMES":"TEMPS AU TOUR","STATUS":"ÉTAT","LAP LIST":"LISTE DES TOURS","SPEED - LAST 30 S":"VITESSE - 30 DERNIÈRES S","THROTTLE / BRAKE / STEERING (PURPLE)":"ACCÉLÉRATEUR / FREIN / DIRECTION (VIOLET)","G-FORCE":"FORCE G","FUEL STRATEGY + STINTS":"STRATÉGIE CARBURANT + RELAIS","SESSION":"SESSION","CONTROLS":"COMMANDES","AI BONUS (OPTIONAL)":"BONUS IA (OPTIONNEL)","YOUR ENGINEER":"VOTRE INGÉNIEUR","APPLICATION":"APPLICATION","gear":"rapport","Tyre temps (C)":"Temp. pneus (C)","Current lap":"Tour actuel","Delta to best lap (live while driving)":"Écart au meilleur tour (en direct au volant)","(GT3, approximate)":"(GT3, approximatif)","STINT PLAN":"PLAN DE RELAIS","Stints recalculate live from your real fuel use. Say 'plan a pit stop' on the radio.":"Les relais se recalculent en direct selon ta consommation réelle. Dis 'planifie un arrêt' à la radio.","Save session to file":"Enregistrer la session dans un fichier","Engineer: prepare stint setup (ACC)":"Ingénieur : préparer le réglage du relais (ACC)","Best --   Average --":"Meilleur --   Moyenne --","Consistency: --":"Régularité : --","MINI-SECTORS - DELTA TO BEST LAP":"MINI-SECTEURS - ÉCART AU MEILLEUR TOUR","The map draws itself during your first lap. Colour = speed (red slow, green fast).":"La carte se dessine seule pendant ton premier tour. Couleur = vitesse (rouge lent, vert rapide).","Engineer speaks (voice)":"L'ingénieur parle (voix)","Radio test":"Test radio","Ask your engineer:":"Demande à ton ingénieur :","Send over radio":"Envoyer par radio","Talk (microphone)":"Parler (microphone)","Talk (download in Settings)":"Parler (télécharger dans Paramètres)","Send":"Envoyer","Enter = send. Or hold your push-to-talk key and speak.":"Entrée = envoyer. Ou maintiens ta touche radio et parle.","MAP":"CARTE","ENGINEER (RADIO)":"INGÉNIEUR (RADIO)","Push-to-talk key (works in-game):":"Touche radio (fonctionne en jeu) :","Comments on:":"Commente :","Talkativeness:":"Bavardage :","(click, then key/wheel button)":"(clique, puis touche/bouton du volant)","Clear":"Effacer","Tip: click the box, then press a wheel button to bind it.":"Astuce : clique dans le champ, puis appuie sur un bouton du volant pour l'assigner.","Anthropic API key:":"Clé API Anthropic :","Model (fast = low latency and cost):":"Modèle (rapide = faible latence et coût) :","Engineer speaks aloud (radio voice)":"L'ingénieur parle à voix haute (voix radio)","Save":"Enregistrer","Engineer name (radio call sign):":"Nom de l'ingénieur (indicatif radio) :","Personality:":"Caractère :","Custom instructions (optional):":"Instructions personnalisées (facultatif) :","Radio voice:":"Voix radio :","Engineer language (callouts and AI):":"Langue de l'ingénieur (annonces et IA) :","Speech rate (slow <-> fast):":"Débit de parole (lent <-> rapide) :","Test voice":"Tester la voix","Save engineer":"Enregistrer l'ingénieur","Add desktop shortcut":"Ajouter un raccourci bureau","Unlock more Windows voices (admin)":"Débloquer plus de voix Windows (admin)","Push-to-talk:":"Touche radio :","(click + press)":"(clique + appuie)","The engineer answers instantly for free (local mode). Add an API key in Settings for smarter AI. Mic: hold your push-to-talk or click Talk; transcription runs offline.":"L'ingénieur répond instantanément et gratuitement (mode local). Ajoute une clé API dans Paramètres pour une IA plus intelligente. Micro : maintiens ta touche radio ou clique Parler ; la transcription est hors ligne.","NO KEY NEEDED - the built-in local engineer answers instantly, offline and free. With a key (console.anthropic.com) a smarter AI answers. The key never leaves your disk.":"AUCUNE CLÉ REQUISE - l'ingénieur local intégré répond instantanément, hors ligne et gratuitement. Avec une clé (console.anthropic.com), une IA plus intelligente répond. La clé reste uniquement sur ton disque.","Natural engineer voice - download your language:":"Voix naturelle de l'ingénieur - télécharge ta langue :","Name, personality, language and instructions shape AI answers and callouts. Download more voice languages right in the Radio voice list.":"Le nom, le caractère, la langue et les instructions façonnent les réponses IA et les annonces. Télécharge d'autres langues de voix dans la liste Voix radio.","Professional - calm and concise":"Professionnel - calme et concis","Tough guy - blunt, no sugar-coating":"Dur à cuire - franc, sans détour","Buddy - chill and encouraging":"Copain - cool et encourageant","Analyst - speaks in numbers and data":"Analyste - parle en chiffres et données","Lap times & delta":"Temps au tour et écart","Fuel":"Carburant","Tyres":"Pneus","Flags":"Drapeaux","Contacts & crashes":"Contacts et accidents","Final laps countdown":"Décompte des derniers tours","Personal records":"Records personnels","Essentials only":"L'essentiel seulement","Normal":"Normal","Chatty":"Bavard","(auto - by voice)":"(auto - selon la voix)"},
"it":{"Overview":"Panoramica","Telemetry":"Telemetria","Track map":"Mappa del circuito","Strategy":"Strategia","Race engineer":"Ingegnere di gara","Settings":"Impostazioni","Always on top":"Sempre in primo piano","LIVE TELEMETRY":"TELEMETRIA LIVE","LAP TIMES":"TEMPI SUL GIRO","STATUS":"STATO","LAP LIST":"ELENCO GIRI","SPEED - LAST 30 S":"VELOCITÀ - ULTIMI 30 S","THROTTLE / BRAKE / STEERING (PURPLE)":"GAS / FRENO / STERZO (VIOLA)","G-FORCE":"FORZA G","FUEL STRATEGY + STINTS":"STRATEGIA CARBURANTE + STINT","SESSION":"SESSIONE","CONTROLS":"COMANDI","AI BONUS (OPTIONAL)":"BONUS IA (OPZIONALE)","YOUR ENGINEER":"IL TUO INGEGNERE","APPLICATION":"APPLICAZIONE","gear":"marcia","Tyre temps (C)":"Temp. gomme (C)","Current lap":"Giro attuale","Delta to best lap (live while driving)":"Delta sul giro migliore (live durante la guida)","(GT3, approximate)":"(GT3, indicativo)","STINT PLAN":"PIANO STINT","Stints recalculate live from your real fuel use. Say 'plan a pit stop' on the radio.":"Gli stint si ricalcolano in tempo reale dal tuo consumo effettivo. Di' 'pianifica un pit stop' via radio.","Save session to file":"Salva sessione su file","Engineer: prepare stint setup (ACC)":"Ingegnere: prepara il setup dello stint (ACC)","Best --   Average --":"Migliore --   Media --","Consistency: --":"Costanza: --","MINI-SECTORS - DELTA TO BEST LAP":"MINI-SETTORI - DELTA SUL GIRO MIGLIORE","The map draws itself during your first lap. Colour = speed (red slow, green fast).":"La mappa si disegna da sola durante il tuo primo giro. Colore = velocità (rosso lento, verde veloce).","Engineer speaks (voice)":"L'ingegnere parla (voce)","Radio test":"Test radio","Ask your engineer:":"Chiedi al tuo ingegnere:","Send over radio":"Invia via radio","Talk (microphone)":"Parla (microfono)","Talk (download in Settings)":"Parla (scarica in Impostazioni)","Send":"Invia","Enter = send. Or hold your push-to-talk key and speak.":"Invio = invia. Oppure tieni premuto il tasto radio e parla.","MAP":"MAPPA","ENGINEER (RADIO)":"INGEGNERE (RADIO)","Push-to-talk key (works in-game):":"Tasto radio (funziona anche in gioco):","Comments on:":"Commenta su:","Talkativeness:":"Loquacità:","(click, then key/wheel button)":"(clicca, poi tasto/pulsante del volante)","Clear":"Cancella","Tip: click the box, then press a wheel button to bind it.":"Suggerimento: clicca nel campo, poi premi un pulsante del volante per assegnarlo.","Anthropic API key:":"Chiave API Anthropic:","Model (fast = low latency and cost):":"Modello (veloce = bassa latenza e costo):","Engineer speaks aloud (radio voice)":"L'ingegnere parla ad alta voce (voce radio)","Save":"Salva","Engineer name (radio call sign):":"Nome dell'ingegnere (nominativo radio):","Personality:":"Carattere:","Custom instructions (optional):":"Istruzioni personali (facoltative):","Radio voice:":"Voce radio:","Engineer language (callouts and AI):":"Lingua dell'ingegnere (annunci e IA):","Speech rate (slow <-> fast):":"Velocità voce (lento <-> veloce):","Test voice":"Prova voce","Save engineer":"Salva ingegnere","Add desktop shortcut":"Aggiungi collegamento sul desktop","Unlock more Windows voices (admin)":"Sblocca altre voci di Windows (admin)","Push-to-talk:":"Tasto radio:","(click + press)":"(clicca + premi)","The engineer answers instantly for free (local mode). Add an API key in Settings for smarter AI. Mic: hold your push-to-talk or click Talk; transcription runs offline.":"L'ingegnere risponde subito e gratis (modalità locale). Aggiungi una chiave API in Impostazioni per un'IA più intelligente. Microfono: tieni premuto il tasto radio o clicca Parla; la trascrizione è offline.","NO KEY NEEDED - the built-in local engineer answers instantly, offline and free. With a key (console.anthropic.com) a smarter AI answers. The key never leaves your disk.":"NESSUNA CHIAVE NECESSARIA - l'ingegnere locale integrato risponde subito, offline e gratis. Con una chiave (console.anthropic.com) risponde un'IA più intelligente. La chiave resta solo sul tuo disco.","Natural engineer voice - download your language:":"Voce naturale dell'ingegnere - scarica la tua lingua:","Name, personality, language and instructions shape AI answers and callouts. Download more voice languages right in the Radio voice list.":"Nome, carattere, lingua e istruzioni plasmano le risposte IA e gli annunci. Scarica altre lingue vocali nell'elenco Voce radio.","Professional - calm and concise":"Professionale - calmo e conciso","Tough guy - blunt, no sugar-coating":"Duro - diretto, senza giri di parole","Buddy - chill and encouraging":"Amico - rilassato e incoraggiante","Analyst - speaks in numbers and data":"Analista - parla con numeri e dati","Lap times & delta":"Tempi e delta","Fuel":"Carburante","Tyres":"Gomme","Flags":"Bandiere","Contacts & crashes":"Contatti e incidenti","Final laps countdown":"Conto alla rovescia giri finali","Personal records":"Record personali","Essentials only":"Solo l'essenziale","Normal":"Normale","Chatty":"Chiacchierone","(auto - by voice)":"(automatico - in base alla voce)"},
"pt":{"Overview":"Visão geral","Telemetry":"Telemetria","Track map":"Mapa da pista","Strategy":"Estratégia","Race engineer":"Engenheiro de corrida","Settings":"Configurações","Always on top":"Sempre no topo","LIVE TELEMETRY":"TELEMETRIA AO VIVO","LAP TIMES":"TEMPOS DE VOLTA","STATUS":"STATUS","LAP LIST":"LISTA DE VOLTAS","SPEED - LAST 30 S":"VELOCIDADE - ÚLTIMOS 30 S","THROTTLE / BRAKE / STEERING (PURPLE)":"ACELERADOR / FREIO / DIREÇÃO (ROXO)","G-FORCE":"FORÇA G","FUEL STRATEGY + STINTS":"ESTRATÉGIA DE COMBUSTÍVEL + STINTS","SESSION":"SESSÃO","CONTROLS":"CONTROLES","AI BONUS (OPTIONAL)":"BÔNUS DE IA (OPCIONAL)","YOUR ENGINEER":"SEU ENGENHEIRO","APPLICATION":"APLICATIVO","gear":"marcha","Tyre temps (C)":"Temp. dos pneus (C)","Current lap":"Volta atual","Delta to best lap (live while driving)":"Delta para a melhor volta (ao vivo dirigindo)","(GT3, approximate)":"(GT3, aproximado)","STINT PLAN":"PLANO DE STINTS","Stints recalculate live from your real fuel use. Say 'plan a pit stop' on the radio.":"Os stints são recalculados ao vivo pelo seu consumo real. Diga 'planeje um pit stop' pelo rádio.","Save session to file":"Salvar sessão em arquivo","Engineer: prepare stint setup (ACC)":"Engenheiro: preparar setup do stint (ACC)","Best --   Average --":"Melhor --   Média --","Consistency: --":"Consistência: --","MINI-SECTORS - DELTA TO BEST LAP":"MINI-SETORES - DELTA PARA A MELHOR VOLTA","The map draws itself during your first lap. Colour = speed (red slow, green fast).":"O mapa se desenha sozinho na sua primeira volta. Cor = velocidade (vermelho lento, verde rápido).","Engineer speaks (voice)":"O engenheiro fala (voz)","Radio test":"Teste de rádio","Ask your engineer:":"Pergunte ao seu engenheiro:","Send over radio":"Enviar pelo rádio","Talk (microphone)":"Falar (microfone)","Talk (download in Settings)":"Falar (baixar em Configurações)","Send":"Enviar","Enter = send. Or hold your push-to-talk key and speak.":"Enter = enviar. Ou segure sua tecla de rádio e fale.","MAP":"MAPA","ENGINEER (RADIO)":"ENGENHEIRO (RÁDIO)","Push-to-talk key (works in-game):":"Tecla de rádio (funciona no jogo):","Comments on:":"Comenta sobre:","Talkativeness:":"Fala bastante:","(click, then key/wheel button)":"(clique, depois tecla/botão do volante)","Clear":"Limpar","Tip: click the box, then press a wheel button to bind it.":"Dica: clique no campo e pressione um botão do volante para atribuir.","Anthropic API key:":"Chave API da Anthropic:","Model (fast = low latency and cost):":"Modelo (rápido = baixa latência e custo):","Engineer speaks aloud (radio voice)":"O engenheiro fala em voz alta (voz do rádio)","Save":"Salvar","Engineer name (radio call sign):":"Nome do engenheiro (indicativo de rádio):","Personality:":"Personalidade:","Custom instructions (optional):":"Instruções personalizadas (opcional):","Radio voice:":"Voz do rádio:","Engineer language (callouts and AI):":"Idioma do engenheiro (avisos e IA):","Speech rate (slow <-> fast):":"Velocidade da fala (lento <-> rápido):","Test voice":"Testar voz","Save engineer":"Salvar engenheiro","Add desktop shortcut":"Adicionar atalho na área de trabalho","Unlock more Windows voices (admin)":"Desbloquear mais vozes do Windows (admin)","Push-to-talk:":"Tecla de rádio:","(click + press)":"(clique + pressione)","The engineer answers instantly for free (local mode). Add an API key in Settings for smarter AI. Mic: hold your push-to-talk or click Talk; transcription runs offline.":"O engenheiro responde na hora e de graça (modo local). Adicione uma chave API em Configurações para uma IA mais inteligente. Microfone: segure a tecla de rádio ou clique Falar; a transcrição é offline.","NO KEY NEEDED - the built-in local engineer answers instantly, offline and free. With a key (console.anthropic.com) a smarter AI answers. The key never leaves your disk.":"NÃO PRECISA DE CHAVE - o engenheiro local integrado responde na hora, offline e de graça. Com uma chave (console.anthropic.com) responde uma IA mais inteligente. A chave fica só no seu disco.","Natural engineer voice - download your language:":"Voz natural do engenheiro - baixe seu idioma:","Name, personality, language and instructions shape AI answers and callouts. Download more voice languages right in the Radio voice list.":"Nome, personalidade, idioma e instruções moldam as respostas da IA e os avisos. Baixe mais idiomas de voz na lista Voz do rádio.","Professional - calm and concise":"Profissional - calmo e conciso","Tough guy - blunt, no sugar-coating":"Durão - direto, sem rodeios","Buddy - chill and encouraging":"Parceiro - tranquilo e encorajador","Analyst - speaks in numbers and data":"Analista - fala em números e dados","Lap times & delta":"Tempos e delta","Fuel":"Combustível","Tyres":"Pneus","Flags":"Bandeiras","Contacts & crashes":"Contatos e batidas","Final laps countdown":"Contagem das últimas voltas","Personal records":"Recordes pessoais","Essentials only":"Só o essencial","Normal":"Normal","Chatty":"Tagarela","(auto - by voice)":"(automático - pela voz)"}
}
'@
$script:UiTr = @{}
try {
    $uiObj = $uiTrJson | ConvertFrom-Json
    foreach ($lp in $uiObj.PSObject.Properties) {
        # case-sensitive slovnik: 'Track map' (menu) vs 'TRACK MAP' (nadpis) se nesmi slit
        $d = New-Object 'System.Collections.Generic.Dictionary[string,string]' ([System.StringComparer]::Ordinal)
        foreach ($kp in $lp.Value.PSObject.Properties) { $d[$kp.Name] = [string]$kp.Value }
        if ($d.ContainsKey('Track map')) { $d['TRACK MAP'] = ([string]$d['Track map']).ToUpper() }
        $script:UiTr[$lp.Name] = $d
    }
} catch { $script:UiTr = @{} }
# Loc: preklad anglickeho retezce do aktualniho jazyka UI (en fallback)
function Loc([string]$en) {
    $l = [string]$script:Settings.UiLang
    if (-not $l -or $l -eq 'en') { return $en }
    $d = $script:UiTr[$l]
    if ($d -and $d.ContainsKey($en)) { return $d[$en] }
    return $en
}
# UiText: text UiMap dvojice @(cs,en) v danem jazyce (walker)
function UiText($pair, $lang) {
    if ($lang -eq 'cs') { return $pair[0] }
    if (-not $lang -or $lang -eq 'en') { return $pair[1] }
    $d = $script:UiTr[$lang]
    if ($d -and $d.ContainsKey($pair[1])) { return $d[$pair[1]] }
    return $pair[1]
}
function Apply-UiLang {
    $new = [string]$script:Settings.UiLang; if (-not $new) { $new = 'en' }
    $script:UiEn = ($new -ne 'cs')   # dynamicke texty bez prekladu = anglicky fallback
    $prev = $script:UiCur
    # projdi vsechny prvky okna a preloz zname texty (zachova odsazeni nav tlacitek)
    $stack = New-Object System.Collections.Stack
    $stack.Push($form)
    while ($stack.Count -gt 0) {
        $c = $stack.Pop()
        foreach ($ch in $c.Controls) { $stack.Push($ch) }
        $t = [string]$c.Text
        if (-not $t) { continue }
        $trim = $t.Trim()
        foreach ($pair in $script:UiMap) {
            if ((UiText $pair $prev) -ceq $trim) { $c.Text = $t.Replace($trim, (UiText $pair $new)); break }
        }
    }
    $script:UiCur = $new
    # titulky stranek v hlavicce
    $script:NavTitles = if ($new -eq 'cs') {
        @{ dash = 'Prehled'; tele = 'Telemetrie'; map = 'Mapa trati'; hist = 'Historie kol'; strat = 'Strategie'; eng = 'Zavodni inzenyr'; set = 'Nastaveni'; fb = 'Zpetna vazba' }
    } else {
        @{ dash = (Loc 'Overview'); tele = (Loc 'Telemetry'); map = (Loc 'Track map'); hist = (Loc 'Lap history'); strat = (Loc 'Strategy'); eng = (Loc 'Race engineer'); set = (Loc 'Settings'); fb = (Loc 'Feedback') }
    }
    try { Refresh-HistList } catch { }   # prelozit polozky seznamu/porovnani na novy jazyk
    if ($script:CurPage -and $script:NavTitles[$script:CurPage]) { $lblTitle.Text = $script:NavTitles[$script:CurPage] }
    # comba (Items nejsou .Text - prestavet se zachovanim vyberu)
    $si = $perStyle.SelectedIndex
    $perStyle.Items.Clear()
    $styleItems = if ($new -eq 'cs') { @('Profesional - klidny a strucny','Drsnak - uprimny, zadne servitky','Kamos - pohodovy, povzbuzuje','Analytik - mluvi v cislech a datech') }
        else { @('Professional - calm and concise','Tough guy - blunt, no sugar-coating','Buddy - chill and encouraging','Analyst - speaks in numbers and data') | ForEach-Object { Loc $_ } }
    foreach ($it in $styleItems) { [void]$perStyle.Items.Add($it) }
    if ($si -ge 0 -and $si -lt $perStyle.Items.Count) { $perStyle.SelectedIndex = $si }
    try { Rebuild-VoiceList } catch { }
    if ($perLang.Items.Count -gt 0) {
        $script:VoiceListBusy = $true
        try { $perLang.Items[0] = $(if ($new -eq 'cs') { '(automaticky podle hlasu)' } else { Loc '(auto - by voice)' }) } finally { $script:VoiceListBusy = $false }
    }
    if ($cmbCloud.Items.Count -gt 0) {
        $ci = $cmbCloud.SelectedIndex
        try { $cmbCloud.Items[0] = $(if ($new -eq 'cs') { 'Vypnuto' } else { Loc 'Off' }) } catch { }
        if ($ci -ge 0) { $cmbCloud.SelectedIndex = $ci }
    }
    # checklist komentaru + upovidanost (prestavet, zachovat stav)
    $coItems = if ($new -eq 'cs') { @('Casy kol a delta','Palivo','Gumy','Vlajky','Kontakty a nehody','Odpocet konce','Osobni rekordy') }
        else { @('Lap times & delta','Fuel','Tyres','Flags','Contacts & crashes','Final laps countdown','Personal records') | ForEach-Object { Loc $_ } }
    $clbCallouts.Items.Clear()
    for ($ci = 0; $ci -lt $coItems.Count; $ci++) {
        [void]$clbCallouts.Items.Add($coItems[$ci], ([int]$script:Settings[$script:CoKeys[$ci]] -ne 0))
    }
    $vi = $cmbVerb.SelectedIndex
    $cmbVerb.Items.Clear()
    $verbItems = if ($new -eq 'cs') { @('Jen dulezite','Normalne','Upovidany') } else { @('Essentials only','Normal','Chatty') | ForEach-Object { Loc $_ } }
    foreach ($it in $verbItems) { [void]$cmbVerb.Items.Add($it) }
    if ($vi -lt 0) { $vi = [int]$script:Settings.Verbosity }
    if ($vi -ge 0 -and $vi -lt 3) { $cmbVerb.SelectedIndex = $vi }
    # dynamicke stavove prvky prekresli jejich updatery
    try { Update-PttDisplay } catch { }
    try { Update-AppButtons } catch { }
    try { Update-VoiceInfo } catch { }
}

$navTitles = @{ dash='Prehled'; tele='Telemetrie'; map='Mapa trati'; hist='Historie kol'; strat='Strategie'; eng='Zavodni inzenyr'; set='Nastaveni'; fb='Zpetna vazba' }
$script:NavTitles = $navTitles

# ============================================================
#  RESPONZIVNI LAYOUT: pri zvetseni okna / fullscreenu (F11) se
#  mapa, grafy a sloupce roztahnou (pravidla base + delta * faktor)
# ============================================================
$script:BaseGeo = @{}
$script:LayoutRules = @(
    # mapa trati - vyuzije celou plochu
    @{ C = $cardMap;      F = @(0,0,1,1) }, @{ C = $pnlMap; F = @(0,0,1,1) }, @{ C = $lblMapInfo; F = @(0,1,0,0) },
    # telemetrie - grafy sirsi i vyssi, G-metr pinned vpravo, sektory dole
    @{ C = $cardG1; F = @(0,0,1,0.5) }, @{ C = $pnlG1; F = @(0,0,1,0.5) },
    @{ C = $cardG2; F = @(0,0.5,1,0.5) }, @{ C = $pnlG2; F = @(0,0,1,0.5) },
    @{ C = $cardG3; F = @(1,0.5,0,0.5) }, @{ C = $pnlG3; F = @(0,0,0,0.5) }, @{ C = $lblGMeter; F = @(0,0.5,0,0) },
    @{ C = $cardSec; F = @(0,1,1,0) },
    # prehled - DLAZDICE NA TRETINY: kazdy sloupec dostane tretinu pridane sirky (fullscreen bez der)
    @{ C = $cardLive; F = @(0,0,0.333,0) },
    @{ C = $cardLap;  F = @(0,0,0.333,1) },
    @{ C = $cardStat; F = @(0.333,0,0.334,0) },
    @{ C = $cardLaps; F = @(0.333,0,0.334,1) }, @{ C = $txtLaps; F = @(0,0,0.334,1) },
    @{ C = $lblSummary; F = @(0,1,0,0) }, @{ C = $lblConsist; F = @(0,1,0,0) },
    @{ C = $cardMiniMap; F = @(0.667,0,0.333,0.45) }, @{ C = $pnlMiniMap; F = @(0,0,0.333,0.45) },
    @{ C = $cardMiniChat; F = @(0.667,0.45,0.333,0.55) }, @{ C = $txtRadioMini; F = @(0,0,0.333,0.55) },
    @{ C = $txtAskMini; F = @(0,0.55,0.333,0) }, @{ C = $btnAskMini; F = @(0.333,0.55,0,0) }, @{ C = $lblMiniHint; F = @(0,0.55,0,0) },
    # inzenyr - radio pres celou plochu, ovladani pinned vpravo
    @{ C = $cardRadio; F = @(0,0,1,1) }, @{ C = $txtRadio; F = @(0,0,1,1) },
    @{ C = $cardChat; F = @(1,0,0,0) },
    # strategie - stint plan vyssi i sirsi, sezeni + mapa chyb doprava
    @{ C = $cardStrat; F = @(0,0,0.45,1) }, @{ C = $lvStints; F = @(0,0,0.45,0.5) }, @{ C = $txtStints; F = @(0,0.5,0.45,0.5) }, @{ C = $lblStratNote; F = @(0,1,0,0) },
    @{ C = $cardHw; F = @(0.45,0,0.55,0.4) }, @{ C = $lblHw; F = @(0,0,0.55,0) },
    @{ C = $cardStratMap; F = @(0.45,0.4,0.55,0.6) }, @{ C = $pnlStratMap; F = @(0,0,0.55,0.6) },
    # historie kol - seznam vyssi, grafy se roztahnou do sirky i vysky
    @{ C = $cardHistList; F = @(0,0,0,1) }, @{ C = $lstHist; F = @(0,0,0,1) },
    @{ C = $lblHistCmpTxt; F = @(0,1,0,0) }, @{ C = $cmbHistCmp; F = @(0,1,1,0) }, @{ C = $lblHistInfo; F = @(0,1,1,0) },
    @{ C = $cardHistSpeed; F = @(0,0,1,0.45) }, @{ C = $pnlHistSpeed; F = @(0,0,1,0.45) }, @{ C = $lblHistLap; F = @(1,0,0,0) },
    @{ C = $cardHistPedals; F = @(0,0.45,1,0.55) }, @{ C = $pnlHistPedals; F = @(0,0,1,0.55) },
    # pas sektoru v hlavicce roste se sirkou okna
    @{ C = $pnlSecStrip; F = @(0,0,1,0) }
)
function Apply-Layout {
    try {
        $cw = $form.ClientSize.Width; $chh = $form.ClientSize.Height
        if ($cw -lt 600 -or $chh -lt 400) { return }
        $dw = [math]::Max(0, $cw - 1280); $dh = [math]::Max(0, $chh - 720)
        # kostra okna
        $sidebar.Height = $chh
        if (-not $script:BaseGeo.ContainsKey($chkTop)) { foreach ($c in @($chkTop, $lblVer, $cmbUi, $pill, $btnDemo)) { $script:BaseGeo[$c] = $c.Bounds } }
        $chkTop.Top = $script:BaseGeo[$chkTop].Y + $dh; $lblVer.Top = $script:BaseGeo[$lblVer].Y + $dh; $cmbUi.Top = $script:BaseGeo[$cmbUi].Y + $dh
        $header.Width = $cw - 210; $hdrDiv.Width = $cw - 210
        $pill.Left = $script:BaseGeo[$pill].X + $dw; $btnDemo.Left = $script:BaseGeo[$btnDemo].X + $dw
        $content.Size = New-Object System.Drawing.Size(($cw - 210), ($chh - 64))
        foreach ($k in @($script:Pages.Keys)) { $script:Pages[$k].Size = $content.Size }
        # pravidla kart
        foreach ($r in $script:LayoutRules) {
            $c = $r.C; if (-not $c) { continue }
            if (-not $script:BaseGeo.ContainsKey($c)) { $script:BaseGeo[$c] = $c.Bounds }
            $b = $script:BaseGeo[$c]; $f = $r.F
            $c.SetBounds($b.X + [int]($f[0]*$dw), $b.Y + [int]($f[1]*$dh), $b.Width + [int]($f[2]*$dw), $b.Height + [int]($f[3]*$dh))
            if (($f[2] -ne 0 -or $f[3] -ne 0) -and $c -is [System.Windows.Forms.Panel]) { Set-RoundRegion $c 14 }
        }
    } catch { }
}
$form.Add_Resize({ if ($script:UiReady) { Apply-Layout } })

$btnDemo.Add_Click({
    $script:Tel.Demo = -not $script:Tel.Demo
    if ($script:Tel.Demo) { $script:Tel.BestTimeMs = 0; $btnDemo.Text = $(if ($script:UiEn) { "Demo: ON" } else { "Demo: ZAP" }); $btnDemo.BackColor = $cViolet } else { $btnDemo.Text = "Demo"; $btnDemo.BackColor = $cCard2 }
    Start-Sleep -Milliseconds 250; Reset-Session
})
$lblVer.Add_Click({
    if (-not $script:UpdState.NewVer) { return }
    $q = [System.Windows.Forms.MessageBox]::Show((("PitWise v{0} -> v{1}" + [Environment]::NewLine + "{2}" + [Environment]::NewLine + [Environment]::NewLine + (Tr 'Aktualizovat ted? Appka se sama restartuje.' 'Update now? The app restarts itself.')) -f $script:AppVersion, $script:UpdState.NewVer, $script:UpdState.Notes), 'PitWise Update', 'YesNo', 'Question')
    if ($q -eq 'Yes') {
        if ($script:UpdState.Ps1Url) { Apply-Update }
        else { [System.Windows.Forms.MessageBox]::Show((Tr 'Novou verzi stahnes ze sveho puvodniho odkazu z Payhip e-mailu (soubor je tam vzdy aktualni).' 'Download the new version from your original Payhip e-mail link (the file there is always up to date).'), 'PitWise Update', 'OK', 'Information') | Out-Null }
    }
})
$chkTop.Add_CheckedChanged({ $form.TopMost = $chkTop.Checked })
$script:CoKeys = @('CoLaps','CoFuel','CoTyres','CoFlags','CoContact','CoCount','CoPb')
$clbCallouts.Add_ItemCheck({
    param($s, $e)
    if (-not $script:UiReady) { return }
    $k = $script:CoKeys[$e.Index]
    $script:Settings[$k] = $(if ($e.NewValue -eq 'Checked') { 1 } else { 0 })
    Save-Settings
})
$cmbVerb.Add_SelectedIndexChanged({
    if (-not $script:UiReady) { return }
    $script:Settings.Verbosity = [math]::Max(0, $cmbVerb.SelectedIndex)
    $script:RadioMuted = $false
    Save-Settings
})
$cmbUi.Add_SelectedIndexChanged({
    if (-not $script:UiReady) { return }
    $ix = $cmbUi.SelectedIndex; if ($ix -lt 0 -or $ix -ge $script:UiLangCodes.Count) { $ix = 0 }
    $script:Settings.UiLang = $script:UiLangCodes[$ix]
    Save-Settings; Apply-UiLang
})
$chkEngineer.Add_CheckedChanged({ $script:Settings.EngineerOn = [bool]$chkEngineer.Checked; $setVoice.Checked = $chkEngineer.Checked; Save-Settings; if (-not $chkEngineer.Checked -and $script:Tts) { try { $script:Tts.SpeakAsyncCancelAll() } catch { } } })
$setVoice.Add_CheckedChanged({ $chkEngineer.Checked = $setVoice.Checked })
$btnTestRadio.Add_Click({ $nm = if ($script:Settings.EngName) { $script:Settings.EngName } else { 'Engineer' }; Radio 'test' @($nm) })
$btnAsk.Add_Click({ Ask-Engineer $txtAsk.Text; $txtAsk.Clear() })
$txtAsk.Add_KeyDown({ param($s, $e) if ($e.KeyCode -eq 'Return' -and -not $e.Shift) { $e.SuppressKeyPress = $true; Ask-Engineer $txtAsk.Text; $txtAsk.Clear() } })
$btnAskMini.Add_Click({ Ask-Engineer $txtAskMini.Text; $txtAskMini.Clear() })
$txtAskMini.Add_KeyDown({ param($s, $e) if ($e.KeyCode -eq 'Return' -and -not $e.Shift) { $e.SuppressKeyPress = $true; Ask-Engineer $txtAskMini.Text; $txtAskMini.Clear() } })
$btnMic.Add_Click({
    if ($script:MicState.Busy) { return }
    if (-not $script:Whisper) { $script:Whisper = Find-Whisper }
    if (-not $script:Whisper) {
        $lblEngStatus.Text = Tr 'chybi rozpoznavani reci' 'speech recognition missing'; $lblEngStatus.ForeColor = $cAmber
        Add-Radio (Tr "(Mikrofon: v Nastaveni > Aplikace klikni 'Stahnout rozpoznavani reci' - jednorazove ~80 MB. Pak mluvis offline, klidne cesky.)" "(Microphone: in Settings > Application click 'Download speech recognition' - one-time ~80 MB. Then you talk offline.)")
        Show-Page 'set'
        return
    }
    try {
        if (-not $script:MicRec) { Start-MicCapture | Out-Null } else { Finish-MicCapture }
    } catch { $lblEngStatus.Text = Tr 'mic chyba' 'mic error'; $lblEngStatus.ForeColor = $cRed }
})
$btnKeyCheck.Add_Click({
    # bere aktualni obsah poli (i pred Ulozit), aby sel klic proverit hned po vlozeni
    if ($setKey.Text.Trim()) { $script:Settings.ApiKey = $setKey.Text.Trim() }
    if ($setCloudKey.Text.Trim()) { $script:Settings.CloudKey = $setCloudKey.Text.Trim() }
    $lblSetStatus.Text = Tr 'Kontroluji klice...' 'Checking keys...'; $lblSetStatus.ForeColor = $cAccent
    try { $lblSetStatus.Refresh() } catch { }
    $r = Test-ApiKeys
    $lblSetStatus.Text = $r
    $lblSetStatus.ForeColor = if ($r -match 'HTTP|POZOR|WARNING|error|chyba') { $cAmber } else { $cAccent }
    Add-Radio ((Tr '(Kontrola klicu: {0})' '(Key check: {0})') -f $r)
})
$btnSaveSet.Add_Click({
    $script:Settings.ApiKey = $setKey.Text.Trim(); $script:Settings.Model = [string]$setModel.SelectedItem; $script:Settings.EngineerOn = [bool]$setVoice.Checked
    Save-Settings; $lblSetStatus.Text = Tr 'Ulozeno.' 'Saved.'; $lblSetStatus.ForeColor = $cAccent
})
$btnExport.Add_Click({ Export-Session })
$btnStint.Add_Click({
    $res = Make-StintSetup
    $lblExpStatus.Text = $res; $lblExpStatus.ForeColor = $(if ($res -like 'Setup pripraven*' -or $res -like 'Setup ready*') { $cAccent } else { $cAmber })
    Add-Radio ("(" + $res + ")")
})
$btnDesktop.Add_Click({ New-DesktopShortcut })
# --- PRIROZENY HLAS (CLOUD): prepnuti provozovatele + klic; hned se aplikuje ---
function Apply-CloudChange {
    Sync-CloudTts
    if (Cloud-On) { if (-not $script:SpeakRun.On) { Start-PiperLoop } }   # rozjed prehravaci smycku i bez Piperu
}
$cmbCloud.Add_SelectedIndexChanged({
    if (-not $script:UiReady) { return }
    $script:Settings.CloudEngine = @('off','eleven','openai')[[math]::Max(0, $cmbCloud.SelectedIndex)]
    Save-Settings; Apply-CloudChange
    $lblSetStatus.Text = $(if ((Cloud-On)) { Tr 'Prirozeny hlas zapnut.' 'Natural voice on.' } else { Tr 'Prirozeny hlas vypnut.' 'Natural voice off.' }); $lblSetStatus.ForeColor = $cAccent
})
$setCloudKey.Add_TextChanged({ $script:Settings.CloudKey = $setCloudKey.Text.Trim(); Save-Settings; Apply-CloudChange })
# --- Vyber HLASU: nacte hlasy do comba (ElevenLabs z API / OpenAI pevny seznam) ---
function Load-CloudVoices {
    if (-not $cmbCloudVoice) { return }
    $eng = [string]$script:Settings.CloudEngine
    $script:CloudVoiceBusy = $true
    $cmbCloudVoice.Items.Clear(); $script:CloudVoiceMap = @{}
    if ($eng -eq 'openai') {
        foreach ($v in @('alloy','ash','ballad','coral','echo','fable','nova','onyx','sage','shimmer','verse')) { [void]$cmbCloudVoice.Items.Add($v); $script:CloudVoiceMap[$v] = $v }
    }
    elseif ($eng -eq 'eleven') {
        $key = [string]$script:Settings.CloudKey
        if (-not $key) { $script:CloudVoiceBusy = $false; $lblSetStatus.Text = Tr 'Nejdriv vloz ElevenLabs klic.' 'Paste your ElevenLabs key first.'; $lblSetStatus.ForeColor = $cAmber; return }
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $req = [System.Net.HttpWebRequest]::Create('https://api.elevenlabs.io/v1/voices'); $req.Timeout = 15000
            $req.Headers.Add('xi-api-key', $key)
            $resp = $req.GetResponse(); $sr = New-Object System.IO.StreamReader($resp.GetResponseStream()); $j = ($sr.ReadToEnd() | ConvertFrom-Json); $resp.Close()
            foreach ($v in $j.voices) { $lbl = [string]$v.name; if ($lbl) { [void]$cmbCloudVoice.Items.Add($lbl); $script:CloudVoiceMap[$lbl] = [string]$v.voice_id } }
        } catch { $script:CloudVoiceBusy = $false; $lblSetStatus.Text = Tr 'Hlasy se nepodarilo nacist (klic?).' 'Could not load voices (key?).'; $lblSetStatus.ForeColor = $cRed; return }
    } else { $script:CloudVoiceBusy = $false; return }
    $cur = [string]$script:Settings.CloudVoice; $sel = -1
    if ($cur) { for ($i = 0; $i -lt $cmbCloudVoice.Items.Count; $i++) { if ($script:CloudVoiceMap[[string]$cmbCloudVoice.Items[$i]] -eq $cur) { $sel = $i; break } } }
    $script:CloudVoiceBusy = $false
    if ($sel -ge 0) { $cmbCloudVoice.SelectedIndex = $sel } elseif ($cmbCloudVoice.Items.Count -gt 0) { $cmbCloudVoice.SelectedIndex = 0 }
    if ($cmbCloudVoice.Items.Count -gt 0) { $lblSetStatus.Text = (Tr 'Nacteno hlasu: ' 'Voices loaded: ') + $cmbCloudVoice.Items.Count; $lblSetStatus.ForeColor = $cAccent }
}
$btnCloudVoices.Add_Click({ $script:Settings.CloudKey = $setCloudKey.Text.Trim(); Save-Settings; Sync-CloudTts; Load-CloudVoices })
$cmbCloudVoice.Add_SelectedIndexChanged({
    if ($script:CloudVoiceBusy -or -not $script:UiReady) { return }
    $sel = [string]$cmbCloudVoice.SelectedItem
    if ($sel -and $script:CloudVoiceMap.ContainsKey($sel)) { $script:Settings.CloudVoice = [string]$script:CloudVoiceMap[$sel]; Save-Settings; Sync-CloudTts; $lblSetStatus.Text = (Tr 'Hlas nastaven: ' 'Voice set: ') + $sel; $lblSetStatus.ForeColor = $cAccent }
})
# Test cloud hlasu PRIMO (synchronne) + vrati presnou chybu z API (klic/kredit/model) misto ticha
# --- ACC BROADCASTING: zapne rozhrani hry pro rozestupy (updListenerPort 0 -> 9000) ---
# Oficialni konfigurace ACC (stejny krok chteji vsechny overlay nastroje). Zachova kodovani souboru
# (ACC ho miva UTF-16 LE bez BOM), pred zmenou udela zalohu .pitwise-zaloha. Projevi se po restartu hry.
function Enable-AccBroadcast {
    try {
        $f = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Assetto Corsa Competizione\Config\broadcasting.json'
        if (-not (Test-Path $f)) { return $false }   # ACC neni / jine Dokumenty -> nic nedelat
        $bytes = [System.IO.File]::ReadAllBytes($f)
        $enc = [System.Text.Encoding]::UTF8
        if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) { $enc = [System.Text.Encoding]::Unicode }
        elseif ($bytes.Length -ge 4 -and $bytes[1] -eq 0 -and $bytes[3] -eq 0) { $enc = New-Object System.Text.UnicodeEncoding($false, $false) }   # UTF-16 LE bez BOM
        $txt = $enc.GetString($bytes)
        # klic se jmenuje "updListenerPort" (oficialni preklep ACC), nekde "udpListenerPort"
        if ($txt -notmatch '"u(dp|pd)ListenerPort"\s*:\s*0(?![0-9])') { return $false }   # uz zapnuto / neznamy format
        Copy-Item $f ($f + '.pitwise-zaloha') -Force -ErrorAction SilentlyContinue
        $txt = $txt -replace '("u(?:dp|pd)ListenerPort"\s*:\s*)0(?![0-9])', '${1}9000'
        [System.IO.File]::WriteAllBytes($f, $enc.GetBytes($txt))
        return $true
    } catch { return $false }
}
# --- DIAGNOSTIKA: sepise stav vysilacky/hlasu/klicu do souboru na plochu (na poslani pri problemu) ---
function New-DiagReport {
    $L = New-Object System.Collections.ArrayList
    [void]$L.Add('=== PitWise diagnostika / diagnostics ===')
    [void]$L.Add(("cas/time: {0:yyyy-MM-dd HH:mm:ss}   Windows: {1}" -f (Get-Date), [Environment]::OSVersion.VersionString))
    [void]$L.Add(("slozka dat / data dir: {0}" -f $script:DataDir))
    [void]$L.Add('')
    [void]$L.Add('--- VYSILACKA (mluveni na inzenyra) ---')
    $wD = Find-Whisper
    if ($wD) {
        [void]$L.Add(("whisper exe: OK  {0}" -f $wD.Exe))
        try { [void]$L.Add(("whisper model: {0} ({1:0.0} MB)" -f $wD.Model, ((Get-Item $wD.Model).Length / 1MB))) } catch { }
    } else { [void]$L.Add("whisper: CHYBI! -> Nastaveni > Aplikace > 'Stahnout rozpoznavani reci' (bez toho vysilacka nefunguje)") }
    $srvD = Get-Process whisper-server -ErrorAction SilentlyContinue
    [void]$L.Add(("whisper-server bezi: {0} (port {1})" -f ($null -ne $srvD), $script:WhisPort))
    $micN = 0; try { $micN = [WaveIn]::Count() } catch { }
    [void]$L.Add(("mikrofony (waveIn): {0}{1}" -f $micN, $(if ($micN -eq 0) { '  <- ZADNY MIKROFON! pripoj/povol ho ve Windows' } else { '' })))
    for ($iD = 0; $iD -lt $micN; $iD++) { [void]$L.Add(("  {0}: {1}" -f $iD, [WaveIn]::Name($iD))) }
    [void]$L.Add(("vybrany mikrofon (MicDev): {0} (-1 = vychozi Windows)" -f [int]$script:Settings.MicDev))
    if (-not $script:MicRec -and -not $script:MicState.Busy) {
        try {
            $ok1 = Start-MicRecord; Start-Sleep -Milliseconds 1200; $ok2 = Stop-MicRecord
            $szD = if (Test-Path $script:MicWavPath) { (Get-Item $script:MicWavPath).Length } else { 0 }
            [void]$L.Add(("zkusebni nahravka 1 s: start={0} stop={1} velikost={2} B {3}" -f $ok1, $ok2, $szD, $(if ($szD -gt 8000) { '(OK - mikrofon nahrava)' } elseif ($szD -gt 44) { '(SKORO PRAZDNA - spatny mikrofon vybrany? ztlumeny?)' } else { '(SELHALA - Windows blokuje pristup k mikrofonu?)' })))
        } catch { [void]$L.Add(('zkusebni nahravka: vyjimka ' + $_.Exception.Message)) }
    } else { [void]$L.Add('zkusebni nahravka: preskocena (prave nahravas/prepisujes)') }
    [void]$L.Add(("PTT: klavesa={0}  volant joy={1} btn={2}  (0/-1 = nenastaveno -> nastav v Nastaveni)" -f [int]$script:Settings.PttKey, [int]$script:Settings.PttJoyId, [int]$script:Settings.PttJoyBtn))
    [void]$L.Add('')
    [void]$L.Add('--- HLAS INZENYRA ---')
    $pD = Find-Piper
    [void]$L.Add(("piper (offline hlas): {0}" -f $(if ($pD) { $pD.Model } else { 'neni stazeny' })))
    [void]$L.Add(("cloud hlas: engine={0}  klic={1}  hlas={2}" -f [string]$script:Settings.CloudEngine, $(if ($script:Settings.CloudKey) { ('nastaven, ' + ([string]$script:Settings.CloudKey).Length + ' znaku') } else { 'neni' }), [string]$script:Settings.CloudVoice))
    [void]$L.Add(("anthropic klic (AI chat): {0}" -f $(if ($script:Settings.ApiKey) { 'nastaven' } else { 'neni (lokalni inzenyr)' })))
    try { [void]$L.Add(('kontrola klicu: ' + (Test-ApiKeys))) } catch { }
    [void]$L.Add(("jazyk inzenyra: {0}   jazyk UI: {1}   inzenyr zapnuty: {2}" -f [string]$script:Settings.EngLang, [string]$script:Settings.UiLang, [bool]$script:Settings.EngineerOn))
    foreach ($lfD in @(@('radio.log', $script:RadioLogPath), @('cloud.log', (Join-Path $script:DataDir 'cloud.log')))) {
        if (Test-Path $lfD[1]) {
            [void]$L.Add(''); [void]$L.Add(('--- posledni radky ' + $lfD[0] + ' ---'))
            try { Get-Content $lfD[1] -Tail 15 -Encoding UTF8 | ForEach-Object { [void]$L.Add($_) } } catch { }
        }
    }
    $outD = Join-Path ([Environment]::GetFolderPath('Desktop')) 'PitWise-diagnostika.txt'
    ($L -join "`r`n") | Set-Content -Path $outD -Encoding UTF8
    return $outD
}
# --- KONTROLA API KLICU: overi vsechny zadane klice a rekne presnou pricinu problemu ---
function Test-ApiKeys {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $errShort = {
        param($ex)
        # PS bali WebException do MethodInvocationException -> rozbalit pres InnerException
        $e2 = $ex.Exception
        if ($e2 -isnot [System.Net.WebException] -and $e2.InnerException) { $e2 = $e2.InnerException }
        $m = $e2.Message
        if ($e2 -is [System.Net.WebException] -and $e2.Response) {
            try {
                $code = [int]$e2.Response.StatusCode
                $sr = New-Object System.IO.StreamReader($e2.Response.GetResponseStream()); $bd = $sr.ReadToEnd(); $sr.Close()
                $hint = if ($code -eq 401) { (Tr 'spatny klic' 'bad key') } elseif ($code -eq 429) { (Tr 'vycerpana kvota/limit' 'quota/rate limit') } else { '' }
                $m = ("HTTP {0} {1}" -f $code, $hint).Trim()
                if ($bd -and $bd.Length -lt 160) { $m += (' | ' + ($bd -replace '\s+', ' ')) }
            } catch { }
        }
        return $m
    }
    $parts = @()
    # 1) Anthropic (AI chat)
    $ak = [string]$script:Settings.ApiKey
    if ($ak) {
        try {
            $req = [System.Net.HttpWebRequest]::Create('https://api.anthropic.com/v1/models')
            $req.Method = 'GET'; $req.Timeout = 8000
            $req.Headers.Add('x-api-key', $ak); $req.Headers.Add('anthropic-version', '2023-06-01')
            $resp = $req.GetResponse(); $resp.Close()
            $parts += 'Anthropic: OK'
        } catch { $parts += ('Anthropic: ' + (& $errShort $_)) }
    } else { $parts += (Tr 'Anthropic: bez klice (odpovida lokalni inzenyr)' 'Anthropic: no key (local engineer answers)') }
    # 2) Cloud hlas dle zvoleneho provozovatele; u ElevenLabs i ZBYVAJICI KVOTA znaku
    $ce = [string]$script:Settings.CloudEngine; $ck = [string]$script:Settings.CloudKey
    if ($ce -eq 'eleven' -and $ck) {
        try {
            $req = [System.Net.HttpWebRequest]::Create('https://api.elevenlabs.io/v1/user')
            $req.Method = 'GET'; $req.Timeout = 8000
            $req.Headers.Add('xi-api-key', $ck)
            $resp = $req.GetResponse()
            $sr = New-Object System.IO.StreamReader($resp.GetResponseStream()); $js = $sr.ReadToEnd(); $sr.Close(); $resp.Close()
            $u = $js | ConvertFrom-Json
            if ($u.subscription -and $null -ne $u.subscription.character_limit) {
                $rem = [int]$u.subscription.character_limit - [int]$u.subscription.character_count
                $parts += ((Tr 'ElevenLabs: OK, zbyva {0} znaku z {1}' 'ElevenLabs: OK, {0} of {1} characters left') -f $rem, [int]$u.subscription.character_limit)
                if ($rem -lt 500) { $parts += (Tr 'POZOR: kvota skoro vycerpana - proto hlas vypadava!' 'WARNING: quota nearly used up - that is why the voice drops out!') }
            } else { $parts += 'ElevenLabs: OK' }
        } catch { $parts += ('ElevenLabs: ' + (& $errShort $_)) }
    } elseif ($ce -eq 'openai' -and $ck) {
        try {
            $req = [System.Net.HttpWebRequest]::Create('https://api.openai.com/v1/models')
            $req.Method = 'GET'; $req.Timeout = 8000
            $req.Headers.Add('Authorization', 'Bearer ' + $ck)
            $resp = $req.GetResponse(); $resp.Close()
            $parts += 'OpenAI: OK'
        } catch { $parts += ('OpenAI: ' + (& $errShort $_)) }
    } else { $parts += (Tr 'Cloud hlas: vypnuty / bez klice (mluvi offline hlas)' 'Cloud voice: off / no key (offline voice speaks)') }
    return ($parts -join '   |   ')
}
function Test-CloudVoice {
    param([string]$eng, [string]$key, [string]$text)
    $r = @{ ok = $false; wav = ''; err = '' }
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $wav = Join-Path $script:DataDir 'cloud-test.wav'
        if ($eng -eq 'openai') {
            $body = @{ model = 'gpt-4o-mini-tts'; input = $text; voice = 'onyx'; response_format = 'wav'; instructions = 'Speak like an energetic, dramatic race engineer on team radio: confident, punchy, high-energy.' } | ConvertTo-Json
            $req = [System.Net.HttpWebRequest]::Create('https://api.openai.com/v1/audio/speech')
            $req.Method = 'POST'; $req.ContentType = 'application/json'; $req.Timeout = 20000
            $req.Headers.Add('Authorization', 'Bearer ' + $key)
            $bb = [System.Text.Encoding]::UTF8.GetBytes($body)
            $rs = $req.GetRequestStream(); $rs.Write($bb, 0, $bb.Length); $rs.Close()
            $resp = $req.GetResponse(); $ins = $resp.GetResponseStream()
            $fs = [System.IO.File]::Create($wav); $ins.CopyTo($fs); $fs.Close(); $resp.Close()
            $r.ok = $true; $r.wav = $wav; return $r
        }
        elseif ($eng -eq 'eleven') {
            $vid = 'onwK4e9ZLuTAKqWW03F9'
            $body = @{ text = $text; model_id = 'eleven_multilingual_v2'; voice_settings = @{ stability = 0.28; similarity_boost = 0.8; style = 0.65; use_speaker_boost = $true } } | ConvertTo-Json -Depth 5
            $req = [System.Net.HttpWebRequest]::Create('https://api.elevenlabs.io/v1/text-to-speech/' + $vid + '?output_format=pcm_22050')
            $req.Method = 'POST'; $req.ContentType = 'application/json'; $req.Timeout = 20000
            $req.Headers.Add('xi-api-key', $key)
            $bb = [System.Text.Encoding]::UTF8.GetBytes($body)
            $rs = $req.GetRequestStream(); $rs.Write($bb, 0, $bb.Length); $rs.Close()
            $resp = $req.GetResponse(); $ins = $resp.GetResponseStream()
            $ms = New-Object System.IO.MemoryStream; $ins.CopyTo($ms); $resp.Close(); $pcm = $ms.ToArray(); $ms.Dispose()
            if ($pcm.Length -lt 2000) { $r.err = 'prazdny zvuk / empty audio'; return $r }
            $rate = 22050; $mo = New-Object System.IO.MemoryStream; $bw = New-Object System.IO.BinaryWriter($mo)
            $bw.Write([System.Text.Encoding]::ASCII.GetBytes('RIFF')); $bw.Write([int](36 + $pcm.Length))
            $bw.Write([System.Text.Encoding]::ASCII.GetBytes('WAVEfmt ')); $bw.Write([int]16)
            $bw.Write([int16]1); $bw.Write([int16]1); $bw.Write([int]$rate); $bw.Write([int]($rate * 2)); $bw.Write([int16]2); $bw.Write([int16]16)
            $bw.Write([System.Text.Encoding]::ASCII.GetBytes('data')); $bw.Write([int]$pcm.Length); $bw.Write($pcm)
            [System.IO.File]::WriteAllBytes($wav, $mo.ToArray()); $bw.Dispose(); $mo.Dispose()
            $r.ok = $true; $r.wav = $wav; return $r
        }
        else { $r.err = 'vyber ElevenLabs nebo OpenAI'; return $r }
    }
    catch [System.Net.WebException] {
        $we = $_.Exception; $code = ''; $detail = ''
        try { if ($we.Response) { $code = [int]$we.Response.StatusCode; $sr = New-Object System.IO.StreamReader($we.Response.GetResponseStream()); $detail = $sr.ReadToEnd() } } catch { }
        if (-not $code) { $detail = $we.Message }
        if ($detail.Length -gt 220) { $detail = $detail.Substring(0, 220) }
        $r.err = (("HTTP {0}: {1}" -f $code, $detail).Trim()); return $r
    }
    catch { $r.err = $_.Exception.Message; return $r }
}
$btnCloudTest.Add_Click({
    $script:Settings.CloudKey = $setCloudKey.Text.Trim(); Save-Settings; Apply-CloudChange
    $eng = [string]$script:Settings.CloudEngine
    if ($eng -eq 'off' -or -not $script:Settings.CloudKey) { $lblSetStatus.Text = Tr 'Vyber provozovatele (ElevenLabs/OpenAI) a vloz klic.' 'Pick a provider (ElevenLabs/OpenAI) and paste a key.'; $lblSetStatus.ForeColor = $cAmber; return }
    $lblSetStatus.Text = Tr 'Zkousim prirozeny hlas...' 'Testing natural voice...'; $lblSetStatus.ForeColor = $cViolet
    try { $lblSetStatus.Refresh() } catch { }
    $res = Test-CloudVoice $eng ([string]$script:Settings.CloudKey) 'Radio check. This is my natural voice.'
    if ($res.ok -and (Test-Path $res.wav) -and ((Get-Item $res.wav).Length -gt 1200)) {
        try { $pl = New-Object System.Media.SoundPlayer($res.wav); $pl.PlaySync(); $pl.Dispose() } catch { }
        $lblSetStatus.Text = Tr 'Prirozeny hlas funguje!' 'Natural voice works!'; $lblSetStatus.ForeColor = $cAccent
    } else {
        $lblSetStatus.Text = (Tr 'Chyba: ' 'Error: ') + $res.err; $lblSetStatus.ForeColor = $cRed
    }
})
# --- Vysilacka: klik do policka "odjisti" zachytavani a klavesu chyti cele okno (KeyPreview).
#     Spolehlivejsi nez KeyDown na textboxu - funguje i pro F-klavesy a v kompilovane .exe. ---
$script:PttArm = $false
$form.KeyPreview = $true
function Complete-PttCapture([int]$vk) {
    $script:PttArm = $false
    $script:PttDown = $true   # klavesa je ted drzena - nahravani zacne az pri dalsim stisku
    Set-PttKey $vk
    $lblEngStatus.Text = Tr 'vysilacka nastavena' 'push-to-talk set'; $lblEngStatus.ForeColor = $cAccent
    $lblDeskStatus.Text = Tr 'Vysilacka nastavena - podrz ji a mluv.' 'Push-to-talk set - hold it and talk.'; $lblDeskStatus.ForeColor = $cAccent
}
function Arm-PttCapture {
    $script:PttArm = $true
    $txtPtt.Text = Tr 'stiskni klavesu / tlacitko volantu...' 'press a key / wheel button...'
    $txtPttSet.Text = Tr 'klavesa / volant...' 'key / wheel...'
    $lblDeskStatus.Text = Tr 'Ted stiskni klavesu NEBO tlacitko na volantu.' 'Now press a key OR a wheel button.'; $lblDeskStatus.ForeColor = $cAmber
}
$form.Add_KeyDown({
    param($s, $e)
    # F11 = fullscreen, Esc = ven z fullscreenu (nezabira, kdyz zrovna nastavujes vysilacku)
    if (-not $script:PttArm) {
        if ($e.KeyCode -eq 'F11') { $e.Handled = $true; Toggle-Fullscreen; return }
        if ($e.KeyCode -eq 'Escape' -and $script:IsFullscreen) { $e.Handled = $true; Toggle-Fullscreen; return }
        return
    }
    $e.SuppressKeyPress = $true; $e.Handled = $true
    Complete-PttCapture ([int]$e.KeyCode)
})
$txtPtt.Add_Click({ Arm-PttCapture })
$txtPtt.Add_Enter({ Arm-PttCapture })
$txtPtt.Add_KeyDown({ param($s, $e) $e.SuppressKeyPress = $true; $e.Handled = $true; Complete-PttCapture ([int]$e.KeyCode) })
$btnPttClear.Add_Click({ $script:PttArm = $false; Set-PttKey 0; $lblEngStatus.Text = Tr 'vysilacka zrusena' 'push-to-talk cleared'; $lblEngStatus.ForeColor = $cMuted })
$txtPttSet.Add_Click({ Arm-PttCapture })
$txtPttSet.Add_Enter({ Arm-PttCapture })
$txtPttSet.Add_KeyDown({ param($s, $e) $e.SuppressKeyPress = $true; $e.Handled = $true; Complete-PttCapture ([int]$e.KeyCode) })
$btnPttClear2.Add_Click({ $script:PttArm = $false; Set-PttKey 0; $lblDeskStatus.Text = Tr 'Vysilacka zrusena.' 'Push-to-talk cleared.'; $lblDeskStatus.ForeColor = $cMuted })
# vyber mikrofonu: naplneni seznamu waveIn zarizeni + ulozeni volby
$script:MicDevReady = $false
try {
    [void]$cmbMicDev.Items.Add((Tr '(vychozi mikrofon Windows)' '(Windows default microphone)'))
    $micN = [WaveIn]::Count()
    for ($mi2 = 0; $mi2 -lt $micN; $mi2++) { [void]$cmbMicDev.Items.Add(("{0}: {1}" -f $mi2, [WaveIn]::Name($mi2))) }
    $selMic = [int]$script:Settings.MicDev + 1
    if ($selMic -lt 0 -or $selMic -ge $cmbMicDev.Items.Count) { $selMic = 0 }
    $cmbMicDev.SelectedIndex = $selMic
} catch { }
$script:MicDevReady = $true
$cmbMicDev.Add_SelectedIndexChanged({
    if (-not $script:MicDevReady) { return }
    $script:Settings.MicDev = $cmbMicDev.SelectedIndex - 1   # 0 = vychozi -> -1
    Save-Settings
    $lblDeskStatus.Text = Tr 'Mikrofon ulozen - projevi se pri dalsim nahravani.' 'Microphone saved - applies to the next recording.'; $lblDeskStatus.ForeColor = $cAccent
})
$btnDiag.Add_Click({
    $lblDeskStatus.Text = Tr 'Sepisuji diagnostiku (vc. zkusebni nahravky)...' 'Writing diagnostics (incl. test recording)...'; $lblDeskStatus.ForeColor = $cAccent
    try { $lblDeskStatus.Refresh() } catch { }
    try {
        $fD = New-DiagReport
        $lblDeskStatus.Text = ((Tr 'Hotovo: {0} na plose - posli ho.' 'Done: {0} on the desktop - send it over.') -f (Split-Path $fD -Leaf)); $lblDeskStatus.ForeColor = $cAccent
        try { Start-Process notepad.exe ('"' + $fD + '"') } catch { }
    } catch { $lblDeskStatus.Text = ((Tr 'Diagnostika selhala: {0}' 'Diagnostics failed: {0}') -f $_.Exception.Message); $lblDeskStatus.ForeColor = $cRed }
})
$btnGetPiper.Add_Click({
    $i = $cmbVoiceDl.SelectedIndex; if ($i -lt 0) { return }
    $code = @($script:VoiceCatalog.Keys)[$i]
    $script:PendingVoiceBase = ([string]$script:VoiceCatalog[$code][0] -split '/')[-1]
    Start-PiperDownload ([string]$script:VoiceCatalog[$code][0])
})
$btnUnlockVoices.Add_Click({ Unlock-MoreVoices })
$btnInstallSr.Add_Click({
    if (-not $script:Whisper) { Start-WhisperDownload; return }
    $wdir = Split-Path $script:Whisper.Model -Parent
    $hasMedium = [bool](Get-ChildItem $wdir -Filter 'ggml-medium*.bin' -File -ErrorAction SilentlyContinue | Select-Object -First 1)
    $hasSmall = [bool](Get-ChildItem $wdir -Filter 'ggml-small*.bin' -File -ErrorAction SilentlyContinue | Select-Object -First 1)
    if ($hasMedium -and $hasSmall) {
        # prepnuti preferovaneho modelu + restart serveru s novym modelem
        $script:Settings.WhisPrefer = if ([string]$script:Settings.WhisPrefer -eq 'max') { 'small' } else { 'max' }
        Save-Settings
        $script:Whisper = Find-Whisper
        Stop-WhisperServer; Start-WhisperServer
        Update-AppButtons
    Start-UpdateCheck   # tichy check nove verze na pozadi
        $mn2 = [System.IO.Path]::GetFileName($script:Whisper.Model)
        $lblDeskStatus.Text = $(if ($mn2 -match 'medium') { Tr 'Prepis: MAXIMALNI presnost (odpoved o par vterin pomalejsi).' 'Transcription: MAX accuracy (answers a few seconds slower).' } else { Tr 'Prepis: RYCHLY rezim (small) - odpovedi hned.' 'Transcription: FAST mode (small) - instant answers.' })
        $lblDeskStatus.ForeColor = $cAccent
    } else { Start-WhisperUpgrade }
})
$btnPersTest.Add_Click({
    $nm = if ($perName.Text.Trim()) { $perName.Text.Trim() } else { 'Engineer' }
    Radio 'test' @($nm)
})
# ZIVA synchronizace: co napises/vyberes, plati OKAMZITE (Ulozit uz jen potvrzuje na disk + generuje hlasky)
$perName.Add_TextChanged({ $script:Settings.EngName = if ($perName.Text.Trim()) { $perName.Text.Trim() } else { 'Engineer' } })
$perCustom.Add_TextChanged({ $script:Settings.EngCustom = $perCustom.Text.Trim() })
$perStyle.Add_SelectedIndexChanged({ $script:Settings.EngStyle = [math]::Max(0, $perStyle.SelectedIndex) })
$perVoice.Add_SelectedIndexChanged({
    if ($script:VoiceListBusy) { return }
    $ix = $perVoice.SelectedIndex
    if ($ix -lt 0 -or $ix -ge $script:VoiceMeta.Count) { return }
    $m = $script:VoiceMeta[$ix]
    if ($m.Kind -eq 'dl') {
        # polozka "Stahnout: <jazyk>" - spustit stazeni, vyber vratit na aktualni hlas
        if ($script:PipState.Busy) {
            $lblPersStatus.Text = Tr 'Jine stahovani prave bezi, chvilku vydrz.' 'Another download is already running, hang on.'
            $lblPersStatus.ForeColor = $cAmber
        } else {
            $codeDl = [string]$m.Code
            $script:PendingVoiceBase = ([string]$script:VoiceCatalog[$codeDl][0] -split '/')[-1]
            Start-PiperDownload ([string]$script:VoiceCatalog[$codeDl][0])
            $lblPersStatus.Text = Tr 'Stahuji hlas (~60 MB)... po dokonceni se sam vybere.' 'Downloading voice (~60 MB)... it will select itself when done.'
            $lblPersStatus.ForeColor = $cAmber
        }
        $script:VoiceListBusy = $true
        try { $perVoice.SelectedIndex = $script:VoiceSelIx } finally { $script:VoiceListBusy = $false }
        return
    }
    $script:VoiceSelIx = $ix
    $script:Settings.Voice = if ($m.Kind -eq 'piper') { '__piper:' + [string]$m.Base } elseif ($m.Kind -eq 'sapi') { [string]$m.Name } else { '' }
    Save-Settings; Apply-Voice; Update-VoiceInfo
})
$perLang.Add_SelectedIndexChanged({
    if ($script:VoiceListBusy -or -not $script:UiReady) { return }
    $ix = $perLang.SelectedIndex
    if ($ix -le 0 -or $ix -ge $script:LangCodes.Count) { return }
    $codeL = [string]$script:LangCodes[$ix]
    $hasV = $false
    foreach ($pv in @(Get-PiperVoices)) { if ($pv.Code -eq $codeL) { $hasV = $true; break } }
    if (-not $hasV -and $script:Tts) { try { $hasV = [bool]($script:Tts.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.TwoLetterISOLanguageName -eq $codeL } | Select-Object -First 1) } catch { } }
    if (-not $hasV -and $script:VoiceCatalog.Contains($codeL)) {
        $lblPersStatus.Text = Tr 'Pro tento jazyk jeste nemas hlas - vyber "Stahnout" v seznamu Hlas radia.' 'No voice for this language yet - pick "Download" in the Radio voice list.'
        $lblPersStatus.ForeColor = $cAmber
    }
})

# HLASKY NA MIRU: AI vygeneruje cely balicek radiovych hlasek podle tveho popisu (jednorazove pri ulozeni)
$script:PGState = [hashtable]::Synchronized(@{ Busy = $false; Done = $false; Ok = $false; Result = '' })
$script:PGPS = $null; $script:PGRS = $null
function Start-PhraseGen {
    if ($script:PGState.Busy -or -not $script:Settings.ApiKey) { return }
    $eff = Get-EngLang; $langName = $script:LangNames[$eff]; if (-not $langName) { $langName = 'Czech' }
    $styles2 = @('calm professional', 'blunt rough trash-talker', 'warm friendly mate', 'pure data analyst')
    $si2 = [int]$script:Settings.EngStyle; if ($si2 -lt 0 -or $si2 -ge $styles2.Count) { $si2 = 0 }
    $sys = 'You write radio callout phrase packs for a sim racing engineer app. Reply ONLY with one strict JSON object, no markdown, no commentary.'
    $usr = "Language: $langName. Engineer name: $($script:Settings.EngName). Base personality: $($styles2[$si2]). Driver's custom description (MOST IMPORTANT - follow it fully): $($script:Settings.EngCustom). Create one short radio sentence (max 90 chars) for each key. Keep placeholders EXACTLY as noted: radiocheck({0}=engineer name), purple(no placeholder), off({0}=lap time,{1}=gap), fuelwarn({0}=laps short), fuelcrit(none), lastlap(none), togo({0}=laps to go), tyres(none), pb({0}=lap time), test({0}=engineer name), nohear(none), yellow(none), blue(none), checkered(none), contact(none), crash(none). JSON keys: radiocheck,purple,off,fuelwarn,fuelcrit,lastlap,togo,tyres,pb,test,nohear,yellow,blue,checkered,contact,crash."
    $body = @{ model = 'claude-haiku-4-5'; max_tokens = 900; system = $sys; messages = @(@{ role = 'user'; content = $usr }) } | ConvertTo-Json -Depth 6
    $script:PGState.Busy = $true; $script:PGState.Done = $false; $script:PGState.Ok = $false; $script:PGState.Result = ''
    $script:PGRS = [runspacefactory]::CreateRunspace(); $script:PGRS.Open()
    $script:PGPS = [powershell]::Create(); $script:PGPS.Runspace = $script:PGRS
    [void]$script:PGPS.AddScript($script:AskWorker).AddArgument($script:PGState).AddArgument($script:Settings.ApiKey).AddArgument($body)
    [void]$script:PGPS.BeginInvoke()
    Add-Radio (Tr '(Generuji hlasky na miru podle tveho popisu...)' '(Generating custom callouts from your description...)')
}

$btnSavePers.Add_Click({
    $script:Settings.EngName = if ($perName.Text.Trim()) { $perName.Text.Trim() } else { 'Engineer' }
    $script:Settings.EngStyle = [math]::Max(0, $perStyle.SelectedIndex)
    $script:Settings.EngCustom = $perCustom.Text.Trim()
    $ixV = $perVoice.SelectedIndex
    if ($ixV -ge 0 -and $ixV -lt $script:VoiceMeta.Count) {
        $mV = $script:VoiceMeta[$ixV]
        $script:Settings.Voice = if ($mV.Kind -eq 'piper') { '__piper:' + [string]$mV.Base } elseif ($mV.Kind -eq 'sapi') { [string]$mV.Name } else { '' }
    }
    $script:Settings.EngLang = $script:LangCodes[[math]::Max(0, $perLang.SelectedIndex)]
    $script:Settings.Rate = [int]$perRate.Value
    if (-not $script:Settings.EngCustom) { $script:Settings.CustomPhrases = @{} }   # bez popisu = zpet vestavene hlasky
    Save-Settings; Apply-Voice
    if ($script:Piper -and $script:SpeakRun.On) { Stop-PiperLoop; Start-PiperLoop }   # nova rychlost reci pro Piper
    $script:ChatHistory.Clear()          # novy inzenyr = cista konverzace (stary styl netahne dal)
    $script:Eng.RadioCheck = $false      # ohlasi se hned novym jmenem
    $lblPersStatus.Text = ((Tr 'Ulozeno.  ' 'Saved.  ') + (Get-VoiceText)); $lblPersStatus.ForeColor = $cAccent
    if ($script:Settings.EngCustom -and $script:Settings.ApiKey) { Start-PhraseGen }   # hlasky na miru
    else { Radio 'test' @($script:Settings.EngName) }   # hned slysis, jak novy inzenyr zni
})

$uiTimer = New-Object System.Windows.Forms.Timer
$uiTimer.Interval = 100
$uiTimer.Add_Tick({
    try {
        $T = $script:Tel
        # pill ukazuje i faze vysilacky - vidis, ze system pracuje
        $E = $script:UiEn
        $pnlSecStrip.Invalidate()   # zivy pas sektoru v hlavicce
        if ($script:MicRec) { $lblPill.Text = $(if ($E) { "REC - TALK" } else { "REC - MLUV" }); $lblPill.ForeColor = $cRed }
        elseif ($script:MicState.Busy) { $lblPill.Text = $(if ($E) { "transcribing..." } else { "prepisuju rec..." }); $lblPill.ForeColor = $cAmber }
        elseif ($script:AskState.Busy) { $lblPill.Text = $(if ($E) { "engineer thinking..." } else { "inzenyr premysli..." }); $lblPill.ForeColor = $cAccent }
        elseif ($T.Demo) { $lblPill.Text = "DEMO"; $lblPill.ForeColor = $cViolet }
        elseif ([int]$T.Status -ge 1) { $lblPill.Text = $(if ($T.SimName) { ("{0} - {1}" -f $(if ($E) { 'CONNECTED' } else { 'PRIPOJENO' }), $T.SimName) } else { $(if ($E) { 'CONNECTED' } else { 'PRIPOJENO' }) }); $lblPill.ForeColor = $cAccent }
        elseif ($T.Connected) { $lblPill.Text = $(if ($E) { "game on - get on track" } else { "hra bezi - vyjed" }); $lblPill.ForeColor = $cAmber }
        else { $lblPill.Text = $(if ($T.SimName) { $T.SimName } else { $(if ($E) { "waiting for game" } else { "cekam na hru" }) }); $lblPill.ForeColor = $cMuted }

        $lblSpeed.Text = ("{0}" -f [int]$T.SpeedKmh)
        $g = [int]$T.Gear; $lblGear.Text = if ($g -le 0) { "R" } elseif ($g -eq 1) { "N" } else { "$($g-1)" }
        $rpm = [int]$T.Rpm; $lblRpm.Text = ("RPM {0}" -f $rpm)
        if ($rpm -gt $script:RpmMax) { $script:RpmMax = [double]$rpm }   # adaptivni rozsah dle auta
        $rf = [math]::Min(1.0, [math]::Max(0.0, $rpm / $script:RpmMax))
        $rpmFill.SetBounds(0, 0, [int](336 * $rf), 12)
        $rpmFill.BackColor = if ($rf -gt 0.92) { $cRed } elseif ($rf -gt 0.78) { $cAmber } else { $cAccent }
        $tt = $T.TyreTemp; $tw = $T.TyreWear
        if ($tt -and $tt.Count -ge 4) {
            $wearTxt = @('','','','')
            if ($tw -and $tw.Count -ge 4 -and [double]$tw[0] -gt 1) { for ($wi = 0; $wi -lt 4; $wi++) { $wearTxt[$wi] = ("  {0,3:0}%" -f [math]::Min(100, [double]$tw[$wi])) } }
            $lblTyFL.Text = ("FL {0,3}{1}" -f [int]$tt[0], $wearTxt[0]); $lblTyFL.ForeColor = (TyreColor ([double]$tt[0]))
            $lblTyFR.Text = ("FR {0,3}{1}" -f [int]$tt[1], $wearTxt[1]); $lblTyFR.ForeColor = (TyreColor ([double]$tt[1]))
            $lblTyRL.Text = ("RL {0,3}{1}" -f [int]$tt[2], $wearTxt[2]); $lblTyRL.ForeColor = (TyreColor ([double]$tt[2]))
            $lblTyRR.Text = ("RR {0,3}{1}" -f [int]$tt[3], $wearTxt[3]); $lblTyRR.ForeColor = (TyreColor ([double]$tt[3]))
        }
        # pedaly
        $gv = [double]$T.Gas; if ($gv -lt 0) { $gv = 0 }; if ($gv -gt 1) { $gv = 1 }
        $bv = [double]$T.Brake; if ($bv -lt 0) { $bv = 0 }; if ($bv -gt 1) { $bv = 1 }
        $gh = [int](76 * $gv); $pedGFill.SetBounds(0, 76 - $gh, 13, $gh)
        $bh = [int](76 * $bv); $pedBFill.SetBounds(0, 76 - $bh, 13, $bh)
        # STAV karta
        $lblStKolo.Text = ("{0}    {1}/{2}" -f $(if ($E) { 'Lap:' } else { 'Kolo:' }), ([int]$T.CompletedLaps + 1), $(if ([int]$T.NumberOfLaps -gt 0) { [int]$T.NumberOfLaps } else { '-' }))
        $posLbl = if ($E) { 'Pos:' } else { 'Poz:' }
        $lblStPos.Text = if ([int]$T.Position -gt 0) { ("{0}  {1}." -f $posLbl, [int]$T.Position) } else { ("{0}  --" -f $posLbl) }
        $fplSt = Get-FuelPerLap
        $fuelLbl = if ($E) { 'Fuel:' } else { 'Palivo:' }; $lapsW = if ($E) { 'laps' } else { 'kol' }
        $lblStFuel.Text = if ($fplSt -gt 0) { ("{0}  {1:0.0} L (~{2} {3})" -f $fuelLbl, [double]$T.Fuel, [math]::Floor([double]$T.Fuel/$fplSt), $lapsW) } else { ("{0}  {1:0.0} L" -f $fuelLbl, [double]$T.Fuel) }
        $sessNames = if ($E) { @{ 0 = 'Practice'; 1 = 'Qualifying'; 2 = 'Race'; 3 = 'Hotlap'; 4 = 'Time Attack'; 5 = 'Drift'; 6 = 'Drag' } }
            else { @{ 0 = 'Trenink'; 1 = 'Kvalifikace'; 2 = 'Zavod'; 3 = 'Hotlap'; 4 = 'Time Attack'; 5 = 'Drift'; 6 = 'Drag' } }
        $sn = $sessNames[[int]$T.Session]; if (-not $sn) { $sn = '--' }
        $lblStSess.Text = ("{0}  {1}" -f $(if ($E) { 'Session:' } else { 'Sezeni:' }), $sn)
        $lblStPit.Text = ("{0}  {1}" -f $(if ($E) { 'Pit:' } else { 'Box:' }), $(if ([int]$T.IsInPit -eq 1) { $(if ($E) { 'YES' } else { 'ANO' }) } elseif ($script:PitPlan) { $(if ($E) { 'PLANNED' } else { 'PLAN' }) } else { $(if ($E) { 'no' } else { 'ne' }) }))
        if ([int]$T.IsInPit -eq 1 -or $script:PitPlan) { $lblStPit.ForeColor = $cAmber } else { $lblStPit.ForeColor = $cMuted }
        $lblStCar.Text = ("{0}  -  {1}" -f $T.CarModel, $T.Track)
        $script:LiveDelta = Update-LiveDelta
        $lblCur.Text = Format-LapTime ([int]$T.CurrentTimeMs)
        $lblLast.Text = ("{0}  {1}" -f $(if ($E) { 'Last:    ' } else { 'Posledni:' }), (Format-LapTime ([int]$T.LastTimeMs)))
        $lblBest.Text = ("{0}  {1}" -f $(if ($E) { 'Best:    ' } else { 'Nejlepsi:' }), (Format-LapTime ([int]$T.BestTimeMs)))
        if ($null -ne $script:LiveDelta) {
            # ZIVA delta - prubezne behem kola proti profilu nejlepsiho kola
            $d = [double]$script:LiveDelta; $sign = if ($d -ge 0) { "+" } else { "" }
            $lblDelta.Text = ("{0}{1:0.00} {2}" -f $sign, $d, $(if ($E) { 'live' } else { 'ziva' }))
            $lblDelta.ForeColor = if ($d -le 0.0) { $cAccent } else { $cRed }
        } elseif ([int]$T.LastTimeMs -gt 0 -and [int]$T.BestTimeMs -gt 0) { $d = ([int]$T.LastTimeMs - [int]$T.BestTimeMs)/1000.0; $sign = if ($d -gt 0) { "+" } else { "" }; $lblDelta.Text = ("{0}{1:0.000} s" -f $sign, $d); $lblDelta.ForeColor = if ($d -le 0.0) { $cAccent } else { $cRed } }
        $lblHw.Text = if ($E) { ("Car:    {0}`r`nTrack:  {1}`r`nLap:    {2} / {3}`r`nIn pit: {4}" -f $T.CarModel, $T.Track, [int]$T.CompletedLaps, [int]$T.NumberOfLaps, $(if ([int]$T.IsInPit -eq 1) { 'yes' } else { 'no' })) }
            else { ("Vuz:    {0}`r`nTrat:   {1}`r`nKolo:   {2} / {3}`r`nV boxu: {4}" -f $T.CarModel, $T.Track, [int]$T.CompletedLaps, [int]$T.NumberOfLaps, $(if ([int]$T.IsInPit -eq 1) { 'ano' } else { 'ne' })) }

        $laps = [int]$T.CompletedLaps
        if ($script:FuelAtLapStart -eq $null) { $script:FuelAtLapStart = [double]$T.Fuel; $script:LastSeenLaps = $laps }
        if ($laps -lt $script:LastSeenLaps -and $laps -le 1) { Reset-Session }   # novy zavod / restart -> reset stavu vc. pozavodni nalady
        if ($laps -gt $script:LastSeenLaps) {
            $lapMs = [int]$T.LastTimeMs; if ($lapMs -gt 0) { [void]$script:LapList.Add($lapMs) }
            $used = $script:FuelAtLapStart - [double]$T.Fuel
            if ($used -gt 0.05 -and $used -lt 30) {
                [void]$script:FuelUsed.Add($used); while ($script:FuelUsed.Count -gt 3) { $script:FuelUsed.RemoveAt(0) }
                # zapamatuj spotrebu pro trat+vuz - pristi kvala/zavod ji zna od 1. kola
                $fk = Get-PBKey
                if ($fk -ne '|') { $script:FplSaved[$fk] = [math]::Round((($script:FuelUsed | Measure-Object -Average).Average), 2); Save-Fpl }
            }
            $script:FuelAtLapStart = [double]$T.Fuel; $script:LastSeenLaps = $laps; Update-LapList
            if (-not $T.Demo) { $script:DrvMem.TotalLaps = [int]$script:DrvMem.TotalLaps + 1 }   # karierni pocitadlo (trvala pamet)
            if ($lapMs -gt 0) {
                $key = Get-PBKey
                if ($key -ne '|') {
                    $pb = 0; if ($script:Bests.ContainsKey($key)) { $pb = [int]$script:Bests[$key] }
                    if ($pb -le 0 -or $lapMs -lt $pb) {
                        $script:Bests[$key] = $lapMs; Save-Bests
                        if ($pb -gt 0 -and (Co 'CoPb') -and -not $script:RadioMuted) { Radio 'pb' @((Format-LapTime $lapMs)); if (-not $T.Demo) { $script:DrvMem.PBs = [int]$script:DrvMem.PBs + 1; Adjust-Rapport 0.03; Save-DrvMem } }
                    }
                }
                # dokoncene kolo bylo nejlepsi -> jeho profil je novy zaklad pro zivou deltu
                if ($lapMs -eq [int]$T.BestTimeMs -and $script:PrevLapProf -and $script:PrevLapProf.Count -gt 10) {
                    $script:BestProf = $script:PrevLapProf; $script:BestProfIdx = 0
                }
                # === MINI-SEKTORY: rozbor, kde jsi ztratil cas ===
                Complete-SectorLap $lapMs
                # === HISTORIE KOL: uloz stopu dokonceneho kola (da se pozdeji rozkliknout a porovnat) ===
                Add-LapToHistory $lapMs $script:PrevLapProf
                Refresh-HistList
                if ($script:HistSel -lt 0 -and $script:LapHistory.Count -gt 0) { $script:HistSel = $script:LapHistory.Count - 1; $lstHist.SelectedIndex = $script:HistSel }
            }
        }
        # historie se nacte pri zmene trati/vozu (jina trat = jina sada kol)
        $hk = ("{0}|{1}" -f $T.Track, $T.CarModel)
        if ($hk -ne '|' -and $hk -ne $script:HistKey) { $script:HistKey = $hk; Load-History; Refresh-HistList }
        Update-Sectors
        $pbKey = Get-PBKey
        $pbVal = if ($script:Bests.ContainsKey($pbKey)) { [int]$script:Bests[$pbKey] } else { 0 }
        $lblPB.Text = ("{0}  {1}" -f $(if ($E) { 'Record:  ' } else { 'Rekord:  ' }), (Format-LapTime $pbVal))
        $refLap = Get-RefLap
        $lblRef.Text = if ($refLap) { ("Reference: {0}" -f (Format-LapTime ([int]$refLap.ms))) } else { "Reference: --:--.---" }
        Update-Strategy
        Update-Engineer
        Update-Events
        Update-Map

        # grafy telemetrie (30 s okno pri 100 ms ticku = 300 vzorku)
        [void]$script:TrSpeed.Add([double]$T.SpeedKmh); while ($script:TrSpeed.Count -gt 300) { $script:TrSpeed.RemoveAt(0) }
        [void]$script:TrGas.Add([double]$T.Gas);       while ($script:TrGas.Count   -gt 300) { $script:TrGas.RemoveAt(0) }
        [void]$script:TrBrake.Add([double]$T.Brake);   while ($script:TrBrake.Count -gt 300) { $script:TrBrake.RemoveAt(0) }
        $sv = [double]$T.Steer; if ($sv -lt -1) { $sv = -1 }; if ($sv -gt 1) { $sv = 1 }
        [void]$script:TrSteer.Add((0.5 + 0.5*$sv));    while ($script:TrSteer.Count -gt 300) { $script:TrSteer.RemoveAt(0) }
        if ($script:Pages['tele'].Visible) {
            $lblTrSpeed.Text = ("{0,3} km/h" -f [int]$T.SpeedKmh)
            $lblTrPedals.Text = ("P {0,3}%  B {1,3}%" -f [int]([double]$T.Gas*100), [int]([double]$T.Brake*100))
            $lblGMeter.Text = ((Tr 'bok {0,4:0.0}G  podel {1,4:0.0}G' 'lat {0,4:0.0}G  lon {1,4:0.0}G') -f [double]$T.AccLat, [double]$T.AccLon)
            $pnlG1.Invalidate(); $pnlG2.Invalidate(); $pnlG3.Invalidate()
            if ($script:SecDeltas) {
                for ($si = 0; $si -lt 10; $si++) {
                    $dv = [int]$script:SecDeltas[$si]
                    if ($script:SecLastIdx -eq $si) { $script:SecLbls[$si].Text = ("S{0} <>" -f ($si+1)); $script:SecLbls[$si].ForeColor = $cText }
                    elseif ($dv -eq 0) { $script:SecLbls[$si].Text = ("S{0} =" -f ($si+1)); $script:SecLbls[$si].ForeColor = $cMuted }
                    else {
                        $sign = if ($dv -gt 0) { '+' } else { '' }
                        $script:SecLbls[$si].Text = ("S{0} {1}{2:0.0}" -f ($si+1), $sign, ($dv/1000.0))
                        # stejna konvence jako pas v hlavicce: fialova = zisk, zelena = tempo, zluta/cervena = ztrata
                        $script:SecLbls[$si].ForeColor = if ($dv -lt -50) { $cViolet } elseif ($dv -le 80) { $cAccent } elseif ($dv -le 250) { $cAmber } else { $cRed }
                    }
                }
            }
        }
        if ($script:Pages['map'].Visible) {
            $mi = if ($script:MapComplete) { ((Tr 'Mapa hotova ({0} bodu) - ulozena pro pristi jizdy. Trat: {1}' 'Map done ({0} points) - saved for next time. Track: {1}') -f $script:MapPts.Count, $T.Track) }
                elseif ($script:MapPts.Count -gt 0) { ((Tr 'Kreslim mapu... {0} bodu. Dokonci se po prvnim celem kole.' 'Drawing the map... {0} points. Finishes after the first full lap.') -f $script:MapPts.Count) }
                else { Tr 'Mapa se nakresli sama behem prvniho kola a ulozi se pro pristi jizdy.' 'The map draws itself during your first lap and is saved for next time.' }
            if ($script:EventPins.Count -gt 0) { $mi += ((Tr '   |   MAPA CHYB: {0} pinu (zluta smyk, cervena kontakt, modra blok kol)' '   |   MISTAKE MAP: {0} pins (yellow slide, red contact, blue lock-up)') -f $script:EventPins.Count) }
            $lblMapInfo.Text = $mi
            $pnlMap.Invalidate()
        }
        if ($script:Pages['dash'].Visible) { $pnlMiniMap.Invalidate() }
        if ($script:Pages['strat'].Visible) { $pnlStratMap.Invalidate() }

        # vysilacka (push-to-talk): globalni klavesa - funguje i kdyz ma fokus hra
        # zachytavani bindu: kdyz je "odjisteno", chytame i tlacitka volantu (winmm joystick)
        if ($script:PttArm) {
            for ($jid = 0; $jid -lt 16; $jid++) {
                $jb = [Joy]::Buttons($jid)
                if ($jb -ne 0 -and $jb -ne -1) {
                    $bi = 0; while ($bi -lt 32 -and -not ($jb -band (1 -shl $bi))) { $bi++ }
                    $script:PttArm = $false; $script:PttDown = $true
                    Set-PttJoy $jid $bi
                    $lblDeskStatus.Text = ((Tr 'Vysilacka = tlacitko volantu {0}.' 'Push-to-talk = wheel button {0}.') -f ($bi + 1)); $lblDeskStatus.ForeColor = $cAccent
                    $lblEngStatus.Text = Tr 'vysilacka: tlacitko volantu' 'push-to-talk: wheel button'; $lblEngStatus.ForeColor = $cAccent
                    break
                }
            }
        }
        $vkPtt = [int]$script:Settings.PttKey
        $joyBtn = [int]$script:Settings.PttJoyBtn
        if (($vkPtt -gt 0 -or $joyBtn -ge 0) -and $script:Whisper) {
            $pttNow = $false
            if ($vkPtt -gt 0) { $pttNow = ([PW32]::GetAsyncKeyState($vkPtt) -band 0x8000) -ne 0 }
            if (-not $pttNow -and $joyBtn -ge 0) {
                $jb2 = [Joy]::Buttons([int]$script:Settings.PttJoyId)
                if ($jb2 -eq -1) { $pttNow = $script:PttDown }   # chyba cteni volantu (hra drzi zarizeni) -> drz stav, zadne preblikavani
                elseif ($jb2 -ne 0 -and ($jb2 -band (1 -shl $joyBtn))) { $pttNow = $true }
            }
            # debounce: stav plati az po 2 shodnych ctenich (200 ms) - jeden glitch cteni uz neprepne
            # nahravani tam a zpet (to delalo "preblikavani" tlacitka Mluvit cervena/fialova)
            if ($pttNow -eq $script:PttRaw1) {
                if ($pttNow -and -not $script:PttDown) { $script:PttDown = $true; Start-MicCapture | Out-Null }
                elseif (-not $pttNow -and $script:PttDown) { $script:PttDown = $false; if ($script:MicRec) { Finish-MicCapture } }
            }
            $script:PttRaw1 = $pttNow
        }
        # mikrofon: hotovy prepis -> poslat inzenyrovi
        if ($script:MicState.Done) {
            $script:MicState.Done = $false
            if ($script:MicPS) { try { $script:MicPS.Dispose() } catch { }; $script:MicPS = $null }
            if ($script:MicRS) { try { $script:MicRS.Close(); $script:MicRS.Dispose() } catch { }; $script:MicRS = $null }
            if ($script:MicState.Ok -and $script:MicState.Text) { $txtAsk.Text = $script:MicState.Text; $lblEngStatus.Text = ""; Ask-Engineer $script:MicState.Text }
            else {
                $lblEngStatus.Text = ("mic: " + $script:MicState.Err); $lblEngStatus.ForeColor = $cAmber
                Radio 'nohear' @()   # inzenyr to rekne nahlas - zadne tiche selhani
            }
        }
        # stahovani Whisperu: prubeh + dokonceni
        if ($script:WhisState.Busy) { $lblDeskStatus.Text = ((Tr 'Rozpoznavani: ' 'Recognition: ') + (Get-DlMsgText $script:WhisState.Msg)); $lblDeskStatus.ForeColor = $cAmber }
        if ($script:WhisState.Done) {
            $script:WhisState.Done = $false
            if ($script:WhisPS) { try { $script:WhisPS.Dispose() } catch { }; $script:WhisPS = $null }
            if ($script:WhisRS) { try { $script:WhisRS.Close(); $script:WhisRS.Dispose() } catch { }; $script:WhisRS = $null }
            if ($script:WhisState.Ok) {
                $script:Whisper = Find-Whisper
                # novy/vetsi model -> restart serveru, aby ho nacetl do pameti
                Stop-WhisperServer
                if ($script:Whisper) { Start-WhisperServer; Update-AppButtons; $lblDeskStatus.Text = Tr 'Mikrofon pripraven - mluv na inzenyra!' 'Microphone ready - talk to your engineer!'; $lblDeskStatus.ForeColor = $cAccent; $btnMic.Text = Tr 'Mluvit (mikrofon)' 'Talk (microphone)'; Add-Radio (Tr '(Rozpoznavani reci pripraveno. Tlacitko Mluvit je zive - funguje offline, i cesky.)' '(Speech recognition ready. The Talk button is live - works offline.)') }
                else { $lblDeskStatus.Text = Tr 'Stazeno, ale soubory nenalezeny.' 'Downloaded, but files not found.'; $lblDeskStatus.ForeColor = $cRed }
            } else { $lblDeskStatus.Text = ((Tr 'Rozpoznavani: ' 'Recognition: ') + (Get-DlMsgText $script:WhisState.Msg)); $lblDeskStatus.ForeColor = $cRed }
        }
        # Piper selhava? jednorazova poznamka - mluvi zalozni hlas Windows
        if (-not $script:PiperFailNoted -and [int]$script:SpeakRun.Fails -gt 0) {
            $script:PiperFailNoted = $true
            Add-Radio (Tr '(Piper hlas selhal - mluvi zalozni hlas Windows. Hlasky ale bezi dal normalne.)' '(Piper voice failed - the Windows fallback voice is speaking. Callouts keep running normally.)')
        }
        # nabidka aktualizace (tichy check probehl na pozadi)
        if ($script:UpdState.Done -and $script:UpdState.NewVer -and -not $script:UpdOffered) {
            $script:UpdOffered = $true
            $lblVer.Text = ("v{0} -> v{1} - klikni pro aktualizaci" -f $script:AppVersion, $script:UpdState.NewVer)
            $lblVer.ForeColor = $cAmber; $lblVer.Cursor = [System.Windows.Forms.Cursors]::Hand
            Add-Radio ((Tr "(Nova verze {0} je venku - klikni na verzi vlevo dole a aktualizuji se sam. Novinky: {1})" "(New version {0} is out - click the version bottom-left and I will update myself. What's new: {1})") -f $script:UpdState.NewVer, $script:UpdState.Notes)
        }
        # stahovani Piper hlasu: prubeh + dokonceni
        if ($script:PipState.Busy) { $lblDeskStatus.Text = ((Tr 'Hlas: ' 'Voice: ') + (Get-DlMsgText $script:PipState.Msg)); $lblDeskStatus.ForeColor = $cAmber }
        if ($script:PipState.Done) {
            $script:PipState.Done = $false
            if ($script:PipPS) { try { $script:PipPS.Dispose() } catch { }; $script:PipPS = $null }
            if ($script:PipRS) { try { $script:PipRS.Close(); $script:PipRS.Dispose() } catch { }; $script:PipRS = $null }
            if ($script:PipState.Ok) {
                $script:Piper = Find-Piper
                if ($script:Piper) {
                    if (-not $script:SpeakRun.On) { Start-PiperLoop }   # smycka uz muze bezet (dalsi jazyk k jiz funkcnimu hlasu)
                    # cerstve stazeny hlas se rovnou vybere jako hlas radia
                    if ($script:PendingVoiceBase -and (Find-PiperModel $script:PendingVoiceBase)) {
                        $script:Settings.Voice = '__piper:' + $script:PendingVoiceBase
                        Save-Settings; Apply-Voice
                    }
                    $script:PendingVoiceBase = ''
                    Rebuild-VoiceList; Update-VoiceInfo; Update-AppButtons
                    $lblDeskStatus.Text = Tr 'Prirozeny hlas pripraven!' 'Natural voice ready!'; $lblDeskStatus.ForeColor = $cAccent
                    $lblPersStatus.Text = Get-VoiceText; $lblPersStatus.ForeColor = $cAccent
                    Radio 'test' @($script:Settings.EngName)
                }
                else { $script:PendingVoiceBase = ''; $lblDeskStatus.Text = Tr 'Stazeno, ale soubory nenalezeny.' 'Downloaded, but files not found.'; $lblDeskStatus.ForeColor = $cRed }
            } else { $script:PendingVoiceBase = ''; $lblDeskStatus.Text = ((Tr 'Hlas: ' 'Voice: ') + (Get-DlMsgText $script:PipState.Msg)); $lblDeskStatus.ForeColor = $cRed }
        }
        # watchdog: zaseknuty API dotaz se sam resetuje, aby dalsi otazky neskoncily v tichu
        if ($script:AskState.Busy -and $script:AskStart -and ((Get-Date) - $script:AskStart).TotalSeconds -gt 35) {
            $script:AskState.Busy = $false; $script:AskState.Done = $false; $script:AskStart = $null
            if ($script:AskPS) { try { $script:AskPS.Stop(); $script:AskPS.Dispose() } catch { }; $script:AskPS = $null }
            if ($script:AskRS) { try { $script:AskRS.Close(); $script:AskRS.Dispose() } catch { }; $script:AskRS = $null }
            $btnAsk.Enabled = $true
            Add-Radio (Tr '(API neodpovedelo do 35 s - zkus otazku znovu.)' '(API did not answer within 35 s - try asking again.)')
            $lblEngStatus.Text = "API timeout"; $lblEngStatus.ForeColor = $cRed
        }
        # hlasky na miru: hotovy vysledek -> ulozit a hned predvest
        if ($script:PGState.Done) {
            $script:PGState.Done = $false
            if ($script:PGPS) { try { $script:PGPS.Dispose() } catch { }; $script:PGPS = $null }
            if ($script:PGRS) { try { $script:PGRS.Close(); $script:PGRS.Dispose() } catch { }; $script:PGRS = $null }
            if ($script:PGState.Ok -and $script:PGState.Result) {
                try {
                    $raw = [string]$script:PGState.Result
                    $j = $raw.IndexOf('{'); $k = $raw.LastIndexOf('}')
                    if ($j -ge 0 -and $k -gt $j) { $raw = $raw.Substring($j, $k - $j + 1) }
                    $obj = $raw | ConvertFrom-Json
                    $need = @{ radiocheck = 1; off = 2; fuelwarn = 1; togo = 1; pb = 1; test = 1 }   # povinne {0}/{1}
                    $cp = @{}
                    foreach ($pp in $obj.PSObject.Properties) {
                        $v = [string]$pp.Value
                        if (-not $v) { continue }
                        if ($need.ContainsKey($pp.Name)) {
                            if ($v -notlike '*{0}*') { continue }
                            if ($need[$pp.Name] -ge 2 -and $v -notlike '*{1}*') { continue }
                        }
                        $cp[$pp.Name] = $v
                    }
                    if ($cp.Count -ge 8) {
                        $script:Settings.CustomPhrases = $cp; Save-Settings
                        Add-Radio ((Tr '(Hlasky na miru hotove - ' '(Custom callouts ready - ') + $cp.Count + (Tr ' frazi. Takhle ted znim:)' ' phrases. This is how I sound now:)'))
                        Radio 'test' @($script:Settings.EngName)
                    } else { Add-Radio (Tr '(Hlasky na miru se nepovedly, zustavaji vestavene. Zkus Ulozit znovu.)' '(Custom callouts failed, keeping the built-in ones. Try Save again.)') }
                } catch { Add-Radio (Tr '(Hlasky na miru se nepovedly, zustavaji vestavene.)' '(Custom callouts failed, keeping the built-in ones.)') }
            } else { Add-Radio (Tr '(Hlasky na miru: API chyba, zustavaji vestavene.)' '(Custom callouts: API error, keeping the built-in ones.)') }
        }
        # async AI vysledek
        if ($script:AskState.Done) {
            $script:AskState.Done = $false; $btnAsk.Enabled = $true; $lblEngStatus.Text = ""; $script:AskStart = $null
            if ($script:AskPS) { try { $script:AskPS.Dispose() } catch { }; $script:AskPS = $null }
            if ($script:AskRS) { try { $script:AskRS.Close(); $script:AskRS.Dispose() } catch { }; $script:AskRS = $null }
            $nmLog = if ($script:Settings.EngName) { $script:Settings.EngName.ToUpper() } else { (Tr 'INZENYR' 'ENGINEER') }
            if ($script:AskState.Ok -and $script:AskState.Result) {
                $ans = $script:AskState.Result
                # [MEM: fakt] = AI si chce neco zapamatovat -> ulozit do trvale pameti a z odpovedi vystrihnout
                if ($ans -match '\[MEM:\s*([^\]]+)\]') { Add-DrvNote $Matches[1]; $ans = ($ans -replace '\[MEM:[^\]]*\]', '').Trim() }
                $script:LastAnswer = $ans   # pro hodnoceni "dobra/spatna rada"
                [void]$script:ChatHistory.Add(@{ role = 'assistant'; content = $ans }); Say $ans ($nmLog + ": " + $ans) $ans
            }
            else {
                # API selhalo -> odpovi lokalni inzenyr, at ridic nikdy nezustane bez odpovedi
                $ans = Get-LocalAnswer ([string]$script:LastQ)
                $script:LastAnswer = $ans
                Add-Radio ($nmLog + ": " + $ans + "   (offline odpoved - API nedostupne)")
                Speak-Raw $ans $true (Detect-Lang ([string]$script:LastQ))
                $lblEngStatus.Text = Tr 'API nedostupne - odpovedel lokalni rezim' 'API unavailable - local mode answered'; $lblEngStatus.ForeColor = $cAmber
            }
        }
    } catch {
        # diagnostika: tiche chyby ticku se zapisuji (max 30 na sezeni), at se hleda pricina, ne vestba
        if (-not $script:TickErrN) { $script:TickErrN = 0 }
        if ($script:TickErrN -lt 30) {
            $script:TickErrN++
            try { Add-Content -Path (Join-Path $script:DataDir 'tick-err.log') -Value ("[{0}] {1} || {2}" -f (Get-Date -Format 'HH:mm:ss'), $_.Exception.Message, $_.InvocationInfo.PositionMessage.Replace("`n", ' ~ ')) -Encoding UTF8 } catch { }
        }
    }
})

if ($args -contains '-demo') { $script:Tel.Demo = $true; $btnDemo.Text = "Demo: ON"; $btnDemo.BackColor = $cViolet }

$form.Add_Shown({
    Load-Settings
    Load-Bests
    Load-Fpl
    Load-DrvMem   # trvala pamet inzenyra o jezdci
    # cekajici feedback z fronty poslat na pozadi (nesmi blokovat start UI)
    try {
        if ((Test-Path $script:FbQueuePath) -and ((Get-Item $script:FbQueuePath).Length -gt 5)) {
            $fbPs = [powershell]::Create()
            [void]$fbPs.AddScript({
                param($url, $qpath)
                try {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                    $q = Get-Content $qpath -Raw -Encoding UTF8 | ConvertFrom-Json
                    $rest = @()
                    foreach ($o in @($q)) {
                        if (-not $o.message) { continue }
                        $ok = $false
                        try {
                            $body = @{ message = [string]$o.message; email = [string]$o.email; app = [string]$o.app; ver = [string]$o.ver; at = [string]$o.at } | ConvertTo-Json
                            $resp = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType 'application/json' -TimeoutSec 8
                            if ($resp -and $resp.ok) { $ok = $true }
                        } catch { }
                        if (-not $ok) { $rest += $o }
                    }
                    [IO.File]::WriteAllText($qpath, (ConvertTo-Json @($rest) -Depth 4), (New-Object System.Text.UTF8Encoding($false)))
                } catch { }
            }).AddArgument($script:FeedbackUrl).AddArgument($script:FbQueuePath)
            [void]$fbPs.BeginInvoke()
        }
    } catch { }
    # ACC rozestupy: kdyz je broadcasting vypnuty (port 0), zapnout ho (zaloha vedle, plati po restartu ACC)
    if (Enable-AccBroadcast) { Add-Radio (Tr '(Zapnul jsem ACC rozestupy - broadcasting.json port 9000, zaloha vedle. Plati od pristiho spusteni ACC.)' '(Enabled ACC live gaps - broadcasting.json port 9000, backup saved. Takes effect next time ACC starts.)') }
    $script:Piper = Find-Piper                 # najit Piper PRED Apply-Voice (rozhoduje UsePiper)
    Sync-CloudTts
    if ($script:Piper -or (Cloud-On)) { Start-PiperLoop }   # prehravaci smycka bezi i jen s cloud hlasem
    Apply-Voice
    Update-VoiceInfo
    # osobnost inzenyra do UI
    $perName.Text = [string]$script:Settings.EngName
    $psi = [int]$script:Settings.EngStyle; if ($psi -lt 0 -or $psi -ge $perStyle.Items.Count) { $psi = 0 }
    $perStyle.SelectedIndex = $psi
    $perCustom.Text = [string]$script:Settings.EngCustom
    Rebuild-VoiceList   # stazene Piper hlasy + hlasy Windows + jazyky ke stazeni
    $pr = [int]$script:Settings.Rate; if ($pr -lt $perRate.Minimum) { $pr = $perRate.Minimum }; if ($pr -gt $perRate.Maximum) { $pr = $perRate.Maximum }
    $perRate.Value = $pr
    $li = $script:LangCodes.IndexOf([string]$script:Settings.EngLang); if ($li -lt 0) { $li = 0 }
    $perLang.SelectedIndex = $li
    $setKey.Text = $script:Settings.ApiKey
    $setModel.SelectedItem = $(if ($setModel.Items.Contains($script:Settings.Model)) { $script:Settings.Model } else { "claude-haiku-4-5" })
    # prirozeny hlas (cloud): nacti volbu + klic
    $cmbCloud.SelectedIndex = switch ([string]$script:Settings.CloudEngine) { 'eleven' { 1 } 'openai' { 2 } default { 0 } }
    $setCloudKey.Text = [string]$script:Settings.CloudKey
    Sync-CloudTts
    $chkEngineer.Checked = [bool]$script:Settings.EngineerOn; $setVoice.Checked = [bool]$script:Settings.EngineerOn
    $script:Whisper = Find-Whisper
    if ($script:Whisper) { Start-WhisperServer; $lblEngStatus.Text = Tr 'mic pripraven (offline prepis)' 'mic ready (offline transcription)' } else { $btnMic.Text = Tr 'Mluvit (stahni v Nastaveni)' 'Talk (download in Settings)'; $lblEngStatus.Text = Tr 'mic: chybi rozpoznavani (Nastaveni > Aplikace)' 'mic: recognition missing (Settings > Application)' }
    Update-AppButtons
    Start-UpdateCheck   # tichy check nove verze na pozadi
    # jazyk UI: en vychozi, cs volbou; prelozit az PO postaveni comb a tlacitek
    $uix = $script:UiLangCodes.IndexOf([string]$script:Settings.UiLang); if ($uix -lt 0) { $uix = 0 }
    $cmbUi.SelectedIndex = $uix
    $script:UiReady = $true
    Apply-UiLang
    if ($script:Whisper -and ([System.IO.Path]::GetFileName($script:Whisper.Model) -notmatch 'small|medium|large')) {
        # lepsi model se stahne SAM na pozadi - zadne cekani, az user klikne
        Add-Radio (Tr '(Stahuji vylepseny model cestiny na pozadi (190 MB). Az dojede, budu ti rozumet mnohem lip - jed klidne dal.)' '(Downloading an improved speech model in the background (190 MB). Once done, I will understand you much better - keep driving.)')
        Start-WhisperUpgrade
    }
    Update-PttDisplay
    if (-not $script:Settings.ApiKey) { Add-Radio (Tr '(Inzenyr jede v lokalnim rezimu - odpovida okamzite z telemetrie, zdarma. Pro jeste chytrejsi AI odpovedi muzes vlozit API klic v Nastaveni.)' '(The engineer runs in local mode - instant answers from telemetry, free. For even smarter AI answers, add an API key in Settings.)') }
    Show-Page 'dash'
    Start-Telemetry; $uiTimer.Start()
})
$form.Add_FormClosing({
    try { $uiTimer.Stop() } catch { }
    try { if (-not $script:MapComplete -and $script:MapPts.Count -gt 20) { Save-Map } } catch { }
    try { Save-History } catch { }
    try { [Mci]::Send('close pitrec') | Out-Null } catch { }
    try { Stop-WhisperServer } catch { }
    try { Stop-PiperLoop } catch { }
    try { if ($script:MicPS) { $script:MicPS.Dispose() }; if ($script:MicRS) { $script:MicRS.Close(); $script:MicRS.Dispose() } } catch { }
    try { if ($script:WhisPS) { $script:WhisPS.Dispose() }; if ($script:WhisRS) { $script:WhisRS.Close(); $script:WhisRS.Dispose() } } catch { }
    try { if ($script:Tts) { $script:Tts.Dispose() } } catch { }
    # trvala pamet: kolik incidentu mela TAHLE seance (pro pristi "minule jsi to zabalil Nkrat")
    try {
        $script:DrvMem.LastCrashes = [math]::Max(0, [int]$script:DrvMem.Crashes - [int]$script:DrvMem0.C)
        $script:DrvMem.LastSpins = [math]::Max(0, [int]$script:DrvMem.Spins - [int]$script:DrvMem0.S)
        Save-DrvMem
    } catch { }
    Save-Settings; Stop-Telemetry
})

[void]$form.ShowDialog()
