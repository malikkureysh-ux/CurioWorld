--!strict
--[[
	locales.lua — Übersetzungs-Tabelle (DE + EN Starter)
	====================================================

	Format: { key = "Wert mit {platzhaltern}" }

	Für die anderen 7 Sprachen (ES, FR, HI, TR, ZH, JA, AR)
	in Phase 2-3 mit professionellen Übersetzern ergänzen.
	Studio-Workflow: Game Settings → Localization → Translator.
]]

local Locales = {}

Locales.de = {
	-- UI
	["ui.shop.buy_button"]      = "Kaufen",
	["ui.shop.buy_for_gold"]    = "{price} Gold",
	["ui.shop.buy_for_gems"]    = "{price} Gems",
	["ui.shop.not_enough_gold"] = "Nicht genug Gold",
	["ui.shop.not_enough_gems"] = "Nicht genug Gems",
	["ui.shop.vip_required"]    = "VIP-Pass erforderlich",
	["ui.shop.compliance_notice"] = "Rein kosmetisch — kein Spielvorteil.",

	["ui.hud.welcome"]          = "Willkommen, {name}!",
	["ui.hud.gold"]             = "Gold",
	["ui.hud.gems"]             = "Gems",
	["ui.hud.daily_bonus"]      = "Tages-Bonus",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	-- Districts
	["district.hamburg_harbor.name"] = "Hamburg Harbor",
	["district.hamburg_harbor.tagline"] = "Wo Kräne tanzen und Wasser Geschichten erzählt.",
	["district.skybridge_bay.name"]   = "SkyBridge Bay",
	["district.skybridge_bay.tagline"] = "Brücken spannen, Seile spannen.",
	["district.liberty_blocks.name"]  = "Liberty Blocks",
	["district.liberty_blocks.tagline"] = "Die Stadt, die niemals schläft.",
	["district.neo_sakura.name"]      = "Neo Sakura",
	["district.neo_sakura.tagline"]   = "Neon-Lichter, endlose Codes.",
	["district.moon_bazaar.name"]     = "Moon Bazaar",
	["district.moon_bazaar.tagline"]  = "Gewürze, Sterne, Geschichten.",

	-- NPCs
	["npc.mira.greeting"]    = "Hallo! Ich bin Mira. Brauchst du Hilfe bei einer Quest?",
	["npc.tomo.greeting"]    = "Reisende Händler kommen und gehen. Schau dir meine Waren an!",

	-- Compliance
	["compliance.under_13_notice"] = "Du bist unter 13 — Käufe benötigen die Zustimmung deiner Eltern.",
}

Locales.en = {
	["ui.shop.buy_button"]      = "Buy",
	["ui.shop.buy_for_gold"]    = "{price} Gold",
	["ui.shop.buy_for_gems"]    = "{price} Gems",
	["ui.shop.not_enough_gold"] = "Not enough Gold",
	["ui.shop.not_enough_gems"] = "Not enough Gems",
	["ui.shop.vip_required"]    = "VIP Pass required",
	["ui.shop.compliance_notice"] = "Cosmetic only — no gameplay advantage.",

	["ui.hud.welcome"]          = "Welcome, {name}!",
	["ui.hud.gold"]             = "Gold",
	["ui.hud.gems"]             = "Gems",
	["ui.hud.daily_bonus"]      = "Daily Bonus",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	["district.hamburg_harbor.name"] = "Hamburg Harbor",
	["district.hamburg_harbor.tagline"] = "Where cranes dance and water tells stories.",
	["district.skybridge_bay.name"]   = "SkyBridge Bay",
	["district.skybridge_bay.tagline"] = "Spanning bridges, tightening ropes.",
	["district.liberty_blocks.name"]  = "Liberty Blocks",
	["district.liberty_blocks.tagline"] = "The city that never sleeps.",
	["district.neo_sakura.name"]      = "Neo Sakura",
	["district.neo_sakura.tagline"]   = "Neon lights, endless code.",
	["district.moon_bazaar.name"]     = "Moon Bazaar",
	["district.moon_bazaar.tagline"]  = "Spices, stars, stories.",

	["npc.mira.greeting"]    = "Hi! I'm Mira. Need help with a quest?",
	["npc.tomo.greeting"]    = "Traveling merchants come and go. Browse my wares!",
	["npc.werftmeister.greeting"] = "Boats need wood, sails, and patience. Want to help?",
	["npc.kapitaen.greeting"] = "From up here, you can see the whole harbor. Beautiful, isn't it?",

	["quest.hh_01.title"]       = "The First Crane",
	["quest.hh_01.description"] = "Mira wants to show you how the harbor cranes work.",
	["quest.hh_02.title"]       = "Lift the Cargo",
	["quest.hh_02.description"] = "Use a crane to move a container from one dock to another.",
	["quest.hh_03.title"]       = "Build a Boat Together",
	["quest.hh_03.description"] = "The shipyard needs hands. Gather materials and help build a small boat.",

	["compliance.under_13_notice"] = "You're under 13 — purchases need a parent's okay.",
}

-- ============================================================
-- Spanish (ES) — 9th most-spoken language
-- ============================================================

Locales.es = {
	["ui.shop.buy_button"]      = "Comprar",
	["ui.shop.buy_for_gold"]    = "{price} de Oro",
	["ui.shop.buy_for_gems"]    = "{price} de Gemas",
	["ui.shop.not_enough_gold"] = "No tienes suficiente Oro",
	["ui.shop.not_enough_gems"] = "No tienes suficientes Gemas",
	["ui.shop.vip_required"]    = "Necesitas Pase VIP",
	["ui.shop.compliance_notice"] = "Solo cosmético — sin ventaja en el juego.",

	["ui.hud.welcome"]          = "¡Bienvenido, {name}!",
	["ui.hud.gold"]             = "Oro",
	["ui.hud.gems"]             = "Gemas",
	["ui.hud.daily_bonus"]      = "Bonus diario",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	["district.hamburg_harbor.name"] = "Puerto de Hamburgo",
	["district.hamburg_harbor.tagline"] = "Donde las grúas bailan y el agua cuenta historias.",
	["district.skybridge_bay.name"]   = "Bahía SkyBridge",
	["district.skybridge_bay.tagline"] = "Tender puentes, tensar cuerdas.",
	["district.liberty_blocks.name"]  = "Bloques Liberty",
	["district.liberty_blocks.tagline"] = "La ciudad que nunca duerme.",
	["district.neo_sakura.name"]      = "Neo Sakura",
	["district.neo_sakura.tagline"]   = "Luces de neón, código sin fin.",
	["district.moon_bazaar.name"]     = "Bazar Luna",
	["district.moon_bazaar.tagline"]  = "Especias, estrellas, historias.",

	["npc.mira.greeting"]    = "¡Hola! Soy Mira. ¿Necesitas ayuda con una misión?",
	["npc.tomo.greeting"]    = "Los mercaderes viajeros van y vienen. ¡Mira mis productos!",
	["npc.werftmeister.greeting"] = "Los barcos necesitan madera, velas y paciencia. ¿Quieres ayudar?",
	["npc.kapitaen.greeting"] = "Desde aquí arriba se ve todo el puerto. ¿Hermoso, verdad?",

	["quest.hh_01.title"]       = "La Primera Grúa",
	["quest.hh_01.description"] = "Mira quiere enseñarte cómo funcionan las grúas del puerto.",
	["quest.hh_02.title"]       = "Eleva la Carga",
	["quest.hh_02.description"] = "Usa una grúa para mover un contenedor de un muelle a otro.",
	["quest.hh_03.title"]       = "Construye un Barco Juntos",
	["quest.hh_03.description"] = "El astillero necesita manos. Reúne materiales y ayuda a construir un pequeño barco.",

	["compliance.under_13_notice"] = "Eres menor de 13 años — las compras necesitan el permiso de tus padres.",
}

-- ============================================================
-- French (FR) — 5th most-spoken in EU
-- ============================================================

Locales.fr = {
	["ui.shop.buy_button"]      = "Acheter",
	["ui.shop.buy_for_gold"]    = "{price} Or",
	["ui.shop.buy_for_gems"]    = "{price} Gemmes",
	["ui.shop.not_enough_gold"] = "Pas assez d'Or",
	["ui.shop.not_enough_gems"] = "Pas assez de Gemmes",
	["ui.shop.vip_required"]    = "Pass VIP requis",
	["ui.shop.compliance_notice"] = "Cosmétique uniquement — aucun avantage de jeu.",

	["ui.hud.welcome"]          = "Bienvenue, {name} !",
	["ui.hud.gold"]             = "Or",
	["ui.hud.gems"]             = "Gemmes",
	["ui.hud.daily_bonus"]      = "Bonus quotidien",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	["district.hamburg_harbor.name"] = "Port de Hambourg",
	["district.hamburg_harbor.tagline"] = "Là où les grues dansent et l'eau raconte des histoires.",
	["district.skybridge_bay.name"]   = "Baie SkyBridge",
	["district.skybridge_bay.tagline"] = "Construire des ponts, tendre des cordes.",
	["district.liberty_blocks.name"]  = "Blocs Liberty",
	["district.liberty_blocks.tagline"] = "La ville qui ne dort jamais.",
	["district.neo_sakura.name"]      = "Néo Sakura",
	["district.neo_sakura.tagline"]   = "Lumières néon, code sans fin.",
	["district.moon_bazaar.name"]     = "Bazar Lune",
	["district.moon_bazaar.tagline"]  = "Épices, étoiles, histoires.",

	["npc.mira.greeting"]    = "Salut ! Je suis Mira. Tu as besoin d'aide pour une quête ?",
	["npc.tomo.greeting"]    = "Les marchands voyageurs vont et viennent. Regarde mes marchandises !",
	["npc.werftmeister.greeting"] = "Les bateaux ont besoin de bois, de voiles et de patience. Tu veux aider ?",
	["npc.kapitaen.greeting"] = "D'ici, on voit tout le port. Magnifique, n'est-ce pas ?",

	["quest.hh_01.title"]       = "La Première Grue",
	["quest.hh_01.description"] = "Mira veut te montrer comment fonctionnent les grues du port.",
	["quest.hh_02.title"]       = "Soulève la Cargaison",
	["quest.hh_02.description"] = "Utilise une grue pour déplacer un conteneur d'un quai à l'autre.",
	["quest.hh_03.title"]       = "Construisez un Bateau Ensemble",
	["quest.hh_03.description"] = "Le chantier naval a besoin de bras. Rassemble des matériaux et aide à construire un petit bateau.",

	["compliance.under_13_notice"] = "Tu as moins de 13 ans — les achats nécessitent l'accord de tes parents.",
}

-- ============================================================
-- Turkish (TR) — close to user, high priority
-- ============================================================

Locales.tr = {
	["ui.shop.buy_button"]      = "Satın Al",
	["ui.shop.buy_for_gold"]    = "{price} Altın",
	["ui.shop.buy_for_gems"]    = "{price} Mücevher",
	["ui.shop.not_enough_gold"] = "Yeterli Altın yok",
	["ui.shop.not_enough_gems"] = "Yeterli Mücevher yok",
	["ui.shop.vip_required"]    = "VIP Pass gerekli",
	["ui.shop.compliance_notice"] = "Sadece kozmetik — oyun avantajı yok.",

	["ui.hud.welcome"]          = "Hoş geldin, {name}!",
	["ui.hud.gold"]             = "Altın",
	["ui.hud.gems"]             = "Mücevher",
	["ui.hud.daily_bonus"]      = "Günlük Bonus",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	["district.hamburg_harbor.name"] = "Hamburg Limanı",
	["district.hamburg_harbor.tagline"] = "Vinçlerin dans ettiği, suyun hikâyeler anlattığı yer.",
	["district.skybridge_bay.name"]   = "SkyBridge Koyu",
	["district.skybridge_bay.tagline"] = "Köprüler kurmak, ipleri germek.",
	["district.liberty_blocks.name"]  = "Liberty Blokları",
	["district.liberty_blocks.tagline"] = "Hiç uyumayan şehir.",
	["district.neo_sakura.name"]      = "Neo Sakura",
	["district.neo_sakura.tagline"]   = "Neon ışıkları, sonsuz kod.",
	["district.moon_bazaar.name"]     = "Ay Pazarı",
	["district.moon_bazaar.tagline"]  = "Baharatlar, yıldızlar, hikâyeler.",

	["npc.mira.greeting"]    = "Merhaba! Ben Mira. Bir görev için yardıma ihtiyacın var mı?",
	["npc.tomo.greeting"]    = "Gezgin tüccarlar gelir ve gider. Mallarıma bir bak!",
	["npc.werftmeister.greeting"] = "Gemiler tahtaya, yelkenlere ve sabıra ihtiyaç duyar. Yardım eder misin?",
	["npc.kapitaen.greeting"] = "Buradan tüm limanı görebilirsin. Güzel, değil mi?",

	["quest.hh_01.title"]       = "İlk Vinç",
	["quest.hh_01.description"] = "Mira sana liman vinçlerinin nasıl çalıştığını göstermek istiyor.",
	["quest.hh_02.title"]       = "Yükü Kaldır",
	["quest.hh_02.description"] = "Bir konteyneri bir iskeleden diğerine taşımak için vinç kullan.",
	["quest.hh_03.title"]       = "Birlikte Bir Tekne Yapın",
	["quest.hh_03.description"] = "Tersaneye eleman lazım. Malzeme topla ve küçük bir tekne yapımına yardım et.",

	["compliance.under_13_notice"] = "13 yaşından küçüksün — satın alımlar için ebeveyn onayı gerekir.",
}

-- ============================================================
-- Hindi (HI) — 3rd most-spoken globally
-- ============================================================

Locales.hi = {
	["ui.shop.buy_button"]      = "खरीदें",
	["ui.shop.buy_for_gold"]    = "{price} सोना",
	["ui.shop.buy_for_gems"]    = "{price} रत्न",
	["ui.shop.not_enough_gold"] = "पर्याप्त सोना नहीं",
	["ui.shop.not_enough_gems"] = "पर्याप्त रत्न नहीं",
	["ui.shop.vip_required"]    = "VIP पास आवश्यक",
	["ui.shop.compliance_notice"] = "केवल सजावटी — कोई गेमप्ले लाभ नहीं।",

	["ui.hud.welcome"]          = "स्वागत है, {name}!",
	["ui.hud.gold"]             = "सोना",
	["ui.hud.gems"]             = "रत्न",
	["ui.hud.daily_bonus"]      = "दैनिक बोनस",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	["district.hamburg_harbor.name"] = "हैम्बर्ग हार्बर",
	["district.hamburg_harbor.tagline"] = "जहाँ क्रेन नाचती हैं और पानी कहानियाँ सुनाता है।",
	["district.skybridge_bay.name"]   = "स्काईब्रिज खाड़ी",
	["district.skybridge_bay.tagline"] = "पुल बनाना, रस्सियाँ कसना।",
	["district.liberty_blocks.name"]  = "लिबर्टी ब्लॉक्स",
	["district.liberty_blocks.tagline"] = "वो शहर जो कभी नहीं सोता।",
	["district.neo_sakura.name"]      = "नियो साकुरा",
	["district.neo_sakura.tagline"]   = "नियॉन लाइट्स, अनंत कोड।",
	["district.moon_bazaar.name"]     = "चाँद बाज़ार",
	["district.moon_bazaar.tagline"]  = "मसाले, सितारे, कहानियाँ।",

	["npc.mira.greeting"]    = "नमस्ते! मैं मीरा हूँ। क्या आपको किसी खोज में मदद चाहिए?",
	["npc.tomo.greeting"]    = "यात्रा करने वाले व्यापारी आते-जाते रहते हैं। मेरा सामान देखें!",
	["npc.werftmeister.greeting"] = "नावों को लकड़ी, पाल और धैर्य चाहिए। क्या आप मदद करेंगे?",
	["npc.kapitaen.greeting"] = "यहाँ से पूरा बंदरगाह दिखता है। सुंदर है, है ना?",

	["quest.hh_01.title"]       = "पहली क्रेन",
	["quest.hh_01.description"] = "मीरा आपको बंदरगाह की क्रेनों का काम दिखाना चाहती है।",
	["quest.hh_02.title"]       = "माल उठाओ",
	["quest.hh_02.description"] = "एक कंटेनर को एक घाट से दूसरे घाट तक ले जाने के लिए क्रेन का उपयोग करें।",
	["quest.hh_03.title"]       = "मिलकर एक नाव बनाएँ",
	["quest.hh_03.description"] = "जहाज़घर को हाथों की ज़रूरत है। सामग्री इकट्ठा करें और एक छोटी नाव बनाने में मदद करें।",

	["compliance.under_13_notice"] = "आप 13 साल से कम हैं — खरीदारी के लिए माता-पिता की अनुमति चाहिए।",
}

-- ============================================================
-- Chinese Simplified (ZH) — largest single-language market
-- ============================================================

Locales.zh = {
	["ui.shop.buy_button"]      = "购买",
	["ui.shop.buy_for_gold"]    = "{price} 金币",
	["ui.shop.buy_for_gems"]    = "{price} 宝石",
	["ui.shop.not_enough_gold"] = "金币不足",
	["ui.shop.not_enough_gems"] = "宝石不足",
	["ui.shop.vip_required"]    = "需要 VIP 通行证",
	["ui.shop.compliance_notice"] = "仅外观——无游戏优势。",

	["ui.hud.welcome"]          = "欢迎，{name}！",
	["ui.hud.gold"]             = "金币",
	["ui.hud.gems"]             = "宝石",
	["ui.hud.daily_bonus"]      = "每日奖励",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	["district.hamburg_harbor.name"] = "汉堡港",
	["district.hamburg_harbor.tagline"] = "起重机起舞，流水传说的地方。",
	["district.skybridge_bay.name"]   = "天桥梁湾",
	["district.skybridge_bay.tagline"] = "架起桥梁，拉紧绳索。",
	["district.liberty_blocks.name"]  = "自由街区",
	["district.liberty_blocks.tagline"] = "永不眠的城市。",
	["district.neo_sakura.name"]      = "新樱花",
	["district.neo_sakura.tagline"]   = "霓虹灯光，无尽代码。",
	["district.moon_bazaar.name"]     = "月亮集市",
	["district.moon_bazaar.tagline"]  = "香料、星辰、故事。",

	["npc.mira.greeting"]    = "你好！我是米拉。需要任务帮助吗？",
	["npc.tomo.greeting"]    = "旅行商人来来去去。看看我的商品！",
	["npc.werftmeister.greeting"] = "船只需要木材、风帆和耐心。你想帮忙吗？",
	["npc.kapitaen.greeting"] = "从这儿能看到整个港口。美丽，对吧？",

	["quest.hh_01.title"]       = "第一台起重机",
	["quest.hh_01.description"] = "米拉想给你展示港口起重机是怎么工作的。",
	["quest.hh_02.title"]       = "吊起货物",
	["quest.hh_02.description"] = "用起重机把一个集装箱从一个码头搬到另一个。",
	["quest.hh_03.title"]       = "一起造船",
	["quest.hh_03.description"] = "造船厂需要帮手。收集材料，帮着造一艘小船。",

	["compliance.under_13_notice"] = "你未满 13 岁——购买需要家长同意。",
}

-- ============================================================
-- Japanese (JA) — high value anime-market
-- ============================================================

Locales.ja = {
	["ui.shop.buy_button"]      = "買う",
	["ui.shop.buy_for_gold"]    = "{price} ゴールド",
	["ui.shop.buy_for_gems"]    = "{price} ジェム",
	["ui.shop.not_enough_gold"] = "ゴールドが足りません",
	["ui.shop.not_enough_gems"] = "ジェムが足りません",
	["ui.shop.vip_required"]    = "VIPパスが必要です",
	["ui.shop.compliance_notice"] = "コスメのみ — ゲーム上の利点はありません。",

	["ui.hud.welcome"]          = "ようこそ、{name}さん！",
	["ui.hud.gold"]             = "ゴールド",
	["ui.hud.gems"]             = "ジェム",
	["ui.hud.daily_bonus"]      = "デイリーボーナス",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	["district.hamburg_harbor.name"] = "ハンブルク港",
	["district.hamburg_harbor.tagline"] = "クレーンが踊り、水が物語を語る場所。",
	["district.skybridge_bay.name"]   = "スカイブリッジ湾",
	["district.skybridge_bay.tagline"] = "橋を架け、綱を張る。",
	["district.liberty_blocks.name"]  = "リバティ・ブロック",
	["district.liberty_blocks.tagline"] = "眠らない街。",
	["district.neo_sakura.name"]      = "ネオサクラ",
	["district.neo_sakura.tagline"]   = "ネオンライト、果てしないコード。",
	["district.moon_bazaar.name"]     = "ムーン・バザール",
	["district.moon_bazaar.tagline"]  = "スパイス、星、物語。",

	["npc.mira.greeting"]    = "こんにちは！ミラです。クエストで助けが必要？",
	["npc.tomo.greeting"]    = "旅する商人たちは来ては去っていく。俺の品を見てくれ！",
	["npc.werftmeister.greeting"] = "船には木と帆と忍耐がいる。手伝えるか？",
	["npc.kapitaen.greeting"] = "ここからは港全体が見える。美しいだろ？",

	["quest.hh_01.title"]       = "初めてのクレーン",
	["quest.hh_01.description"] = "ミラが港のクレーンの動かし方を見せてくれる。",
	["quest.hh_02.title"]       = "貨物を持ち上げろ",
	["quest.hh_02.description"] = "クレーンを使ってコンテナをある桟橋から別の桟橋へ運べ。",
	["quest.hh_03.title"]       = "一緒に船を造ろう",
	["quest.hh_03.description"] = "造船所には人手が必要だ。材料を集め、小さな船の建造を手伝え。",

	["compliance.under_13_notice"] = "13歳未満です — 購入には保護者の同意が必要です。",
}

-- ============================================================
-- Arabic (AR) — RTL language, MENA region (right-to-left)
-- ============================================================

Locales.ar = {
	["ui.shop.buy_button"]      = "شراء",
	["ui.shop.buy_for_gold"]    = "{price} ذهب",
	["ui.shop.buy_for_gems"]    = "{price} جواهر",
	["ui.shop.not_enough_gold"] = "ذهب غير كافٍ",
	["ui.shop.not_enough_gems"] = "جواهر غير كافية",
	["ui.shop.vip_required"]    = "يلزم اشتراك VIP",
	["ui.shop.compliance_notice"] = "تجميلي فقط — لا ميزة في اللعب.",

	["ui.hud.welcome"]          = "أهلاً بك يا {name}!",
	["ui.hud.gold"]             = "ذهب",
	["ui.hud.gems"]             = "جواهر",
	["ui.hud.daily_bonus"]      = "المكافأة اليومية",
	["ui.hud.daily_bonus_full"] = "3/3",
	["ui.hud.vip"]              = "VIP",

	["district.hamburg_harbor.name"] = "ميناء هامبورغ",
	["district.hamburg_harbor.tagline"] = "حيث ترقص الرافعات وتحكي المياه الحكايات.",
	["district.skybridge_bay.name"]   = "خليج سكاي بريدج",
	["district.skybridge_bay.tagline"] = "بناء الجسور، شد الحبال.",
	["district.liberty_blocks.name"]  = "مربعات ليبرتي",
	["district.liberty_blocks.tagline"] = "المدينة التي لا تنام.",
	["district.neo_sakura.name"]      = "نيو ساكورا",
	["district.neo_sakura.tagline"]   = "أضواء النيون، شيفرة لا تنتهي.",
	["district.moon_bazaar.name"]     = "بازار القمر",
	["district.moon_bazaar.tagline"]  = "توابل، نجوم، حكايات.",

	["npc.mira.greeting"]    = "مرحباً! أنا ميرا. هل تحتاج مساعدة في مهمة؟",
	["npc.tomo.greeting"]    = "التجار المسافرون يأتون ويذهبون. تصفح بضاعتي!",
	["npc.werftmeister.greeting"] = "القوارب تحتاج خشباً وأشرعة وصبراً. هل تساعد؟",
	["npc.kapitaen.greeting"] = "من هنا يمكنك رؤية الميناء كله. أليس جميلاً؟",

	["quest.hh_01.title"]       = "الرافعة الأولى",
	["quest.hh_01.description"] = "ميرا تريد أن تُريك كيف تعمل رافعات الميناء.",
	["quest.hh_02.title"]       = "ارفع الشحنة",
	["quest.hh_02.description"] = "استخدم رافعة لنقل حاوية من رصيف إلى آخر.",
	["quest.hh_03.title"]       = "ابني قارباً معاً",
	["quest.hh_03.description"] = "حوض السفن يحتاج أيادي. اجمع المواد وساعد في بناء قارب صغير.",

	["compliance.under_13_notice"] = "عمرك أقل من 13 سنة — الشراء يحتاج موافقة والديك.",
}

return Locales