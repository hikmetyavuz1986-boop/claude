# Zeus Matematik — proje notları (yeni sohbet için)

Kullanıcı: GitHub/terminal konusunda yeni başlayan; **Türkçe ve sade** anlatım ister, teknik terim sevmez.

## İşletme
- **Zeus Matematik**: İstanbul Avrupa Yakası, **lise öğrencilerine yüz yüze birebir** matematik dersi.
- Hedef: Meta (Instagram/Facebook) **mesaj** kampanyası. 1 kampanya, 5 reklam seti, 5 reklam (A–E).
- Meta ADS bağlantısı var ama Zeus Matematik hesabına Meta henüz erişim açmadı ("kademeli açılıyor").

## 5 konu (her biri sorun → çözüm → teklif)
| | Konu | Kime | Video fikri |
|---|---|---|---|
| A | Konu eksikleri | Öğrenci | Yapboz |
| B | Yazılılar | Veli | Geri sayım takvimi |
| C | Zor sorular | Öğrenci | Tahtada soru çözümü |
| D | 11. sınıf eksikleri | Veli | Yol haritası |
| E | TYT–AYT netleri | 12. sınıf / mezun | Net grafiği |

## Dosyalar (Masaüstü\claude)
- `reklamlar\*.png` — 5 statik reklam görseli (Canva, logolu)
- `reklamlar\reels-video\*.mp4` — 5 sessiz 15 sn Reels (1080×1920). **Bunlar iyi.**
- `reklamlar\reels-video-sesli\*.mp4` — Yunus sesli sürüm. **Kullanıcı beğenmedi: ses sahnelerle senkron değil.**
- `reklamlar\seslendirme\` — eski ses dosyaları
- `reels-tasarim\video\` — videoları üreten kaynak: `*.html` + `ortak.css` + `render.ps1` (Chrome ile kare kare çekip ffmpeg ile MP4 yapar)
  - Çalıştırma: `Set-ExecutionPolicy -Scope Process Bypass -Force; & .\render.ps1 -Html A-konu-eksikleri.html`
- `zeus-logo.jpg` — logo

## Videoların sahne zamanları (her videoda aynı)
- **0–5 sn** sorun · **5–10 sn** çözüm · **10–15 sn** logo + teklif + düğme

## Yarım kalan iş: senkron seslendirme
- Ses: ElevenLabs **"Mustafa Silici - Energetic Commercial"** (voice_id `uxXY4QvpsdWFe6Yigtlq`), model `eleven_v4`, 1 sürüm.
- Yöntem: her video için **sahne başına ayrı ses parçası** (≤4,6 sn), parçaları **0,2 / 5,2 / 10,3. saniyeye** yerleştir (ffmpeg adelay + amix), gerekirse atempo ile sığdır.
- ElevenLabs istek sınırı sıkı: istekler arasında ~45 sn bekle, aynı anda tek üretim.
- Üretilenler (ElevenLabs flow'larında, henüz indirilmedi):
  - A: flow `zFuJDv7QeZNlmGCQUxwI` — 3 parça hazır
  - B: flow `74uUrRSyYuptOfAO5kc3` — 3 parça hazır
- Kalan: C, D, E (her biri 3 parça), sonra indirme + birleştirme.

### Sahne metinleri (ekrandakiyle aynı)
- **A** 1: "Konu eksikleri mi birikiyor? Bir parça eksikse, bütün resim tamamlanmaz." · 2: "Eksik parçayı bul, temelden tamamla. Birebir derslerle, senin hızında." · 3: "Zeus Matematik! Yüz yüze birebir matematik dersi. Hemen mesaj gönder!"
- **B** 1: "Matematik yazılısı yaklaşıyor mu? Konular birikti, çalışma son geceye kaldı." · 2: "Konu tekrarı, yazılı tipi sorular, genel tekrar. Telaş değil, planlı hazırlık." · 3: "Zeus Matematik! Çocuğunuzun sınıfına uygun birebir ders. Ders programını sorun!"
- **C** 1: "Zor sorularda takılıyor musun? Nereden başlayacağını bilmiyor musun?" · 2: "Üç adım: verilenleri işaretle, doğru yöntemi seç, adım adım sonuca ulaş." · 3: "Zeus Matematik! Seviyene uygun birebir soru çözümü. Hemen mesaj gönder!"
- **D** 1: "Eksikler on ikinci sınıfa taşınmasın. Birikmiş konular, sınav yılını zorlaştırır." · 2: "Önceliğe göre kişisel çalışma planı. Eksik analizi, düzenli takip ve tekrar." · 3: "Zeus Matematik! On birinci sınıfa özel birebir ders. Programı öğrenin!"
- **E** 1: "TYT ve AYT netlerin yerinde mi sayıyor? Çok çalışıyorsun ama grafik değişmiyor." · 2: "Eksik analizi, hedefli soru çözümü, zaman yönetimi. Daha doğru çalış!" · 3: "Zeus Matematik! TYT ve AYT'ye birebir hazırlık. Hemen mesaj gönder!"

## Diğer
- GitHub: kullanıcı `hikmetyavuz1986-boop`, bu klasör `clude` adlı herkese açık depoya bağlı. `/yedekle` modu ile yedeklenir.
- Claude modları (bu oturumda yapıldı): yedekle, maliyet-uyarisi, dosya-agaci, ilerleme, ozet, bilmeniz-gereken, hatirla.
