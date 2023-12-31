carDealer.waitingColors = carDealer.waitingColors or {}
local waiting = carDealer.waitingColors

hook.Add('car-dealer.bought', 'car-dealer.firstColor', function(class, ply, price, id)
	local cdData = carDealer.vehicles[class]
	if not cdData or cdData.default and cdData.default.col then return end

	local colors = {}
	colors[1] = {'Белый', 255, 255, 255}
	for _, v in ipairs(carDealer.carColorBounds) do
		colors[#colors + 1] = carDealer.defaultCarColors[math.random(unpack(v))]
	end
	waiting[ply:SteamID()] = {id, colors}
	netstream.Start(ply, 'car-dealer.firstColor', id, colors)
end)

hook.Add('PlayerDisconnected', 'car-dealer.firstColor', function(ply)
	waiting[ply:SteamID()] = nil
end)

netstream.Hook('car-dealer.firstColor', function(ply, id, colorNum)
	if not (isnumber(id) and isnumber(colorNum)) then return end
	local sid = ply:SteamID()
	local asked = waiting[sid]
	if not (istable(asked) and asked[1] == id and octolib.math.inRange(colorNum, 1, #asked[2])) then return end
	waiting[sid] = nil
	if colorNum == 1 then return end -- we don't need to change color to white
	local colData = asked[2][colorNum]
	local col = Color(colData[2], colData[3], colData[4])
	carDealer.updateVehData(id, { col = { col, col, Color(0,0,0), col } }, function()
		if IsValid(ply) then
			ply:Notify('Твой автомобиль был покрашен в ' .. utf8.lower(colData[1]) .. '!')
			carDealer.sync(ply)
		end
	end)
end)

carDealer.carColorBounds = {
	{1, 45},
	{46, 102},
	{103, 203},
	{204, 241},
	{242, 328},
	{329, 562},
	{563, 1017},
}

carDealer.defaultCarColors = {
	{'Черный',0,0,0},
	{'Графитно-черный',28,28,28},
	{'Цвет мокрого асфальта',80,80,80},
	{'Транспортный черный',30,30,30},
	{'Сигнальный черный',40,40,40},
	{'Черно-коричневый',33,33,33},
	{'Черный янтарь',10,10,10},
	{'Серый коричневый',64,58,58},
	{'Почти черный',19,19,19},
	{'Темно-серый',73,66,61},
	{'Зеленовато-черный',24,21,19},
	{'Серая умбра',51,47,44},
	{'Темный синевато-черный',70,69,68},
	{'Коричнево-оливковый',37,34,27},
	{'Коричнево-зеленый',57,53,42},
	{'Серый оливковый',62,59,50},
	{'Темный зеленовато-серый',69,67,59},
	{'Коричневый серый',70,69,49},
	{'Черно-оливковый',59,60,54},
	{'Оливково-зеленый',66,70,50},
	{'Винтовочный зеленый',65,72,51},
	{'Пихтовый зеленый',49,55,43},
	{'Черновато-зеленый',20,22,19},
	{'Брезентово-серый',76,81,74},
	{'Темный зеленовато-желто-зеленый',49,56,48},
	{'Зеленоватый мокрый асфальт',78,84,82},
	{'Космос',65,74,76},
	{'Черно-зеленый',52,62,64},
	{'Антрацитово-серый',41,49,51},
	{'Железно-серый',67,75,77},
	{'Темный серо-синий',44,51,55},
	{'Черно-серый',35,40,43},
	{'Синий серый',71,75,78},
	{'Синевато-черный',21,23,25},
	{'Черновато-синий',22,26,30},
	{'Гранитовый серый (Гранитный)',47,53,59},
	{'Сланцево-серый',67,71,80},
	{'Графитовый серый',71,74,81},
	{'Серый синий',38,37,45},
	{'Антрацитовый',70,68,81},
	{'Серовато-пурпурно-синий',65,61,81},
	{'Черно-синий',24,23,28},
	{'Серовато-фиолетовый',70,57,75},
	{'Стальной синий',35,26,36},
	{'Ливерный',83,75,79},
	{'Перламутровый темно-серый',130,130,130},
	{'Перламутровый светло-серый',156,156,156},
	{'Бело-алюминиевый',165,165,165},
	{'Тусклый серый',105,105,105},
	{'Телегрей',144,144,144},
	{'Серый',128,128,128},
	{'Блошиный (Красновато-коричневый)',117,90,87},
	{'Пурпурно-серый',136,112,107},
	{'Красновато-серый',139,108,98},
	{'Бобровый',159,129,112},
	{'Средний серый',129,112,102},
	{'Синевато-серый',125,116,109},
	{'Серый Крайола',149,145,140},
	{'Перламутрово-бежевый',106,93,77},
	{'Перламутровый мышино-серый',137,129,118},
	{'Кварцевый',153,149,140},
	{'Бежево-серый',109,101,82},
	{'Кварцевый серый',108,105,96},
	{'Зеленовато-серый',122,118,102},
	{'Желто-серый',143,139,102},
	{'Каменно-серый',139,140,122},
	{'Бледно-зелено-серый',141,145,122},
	{'Серый мох',108,112,89},
	{'Тростниково-зеленый',108,113,86},
	{'Серый бетон',104,108,94},
	{'Цементно-серый (Цементный)',125,132,113},
	{'Сигнальный серый',150,153,146},
	{'Серовато-зеленый',87,94,78},
	{'Защитный хаки (Камуфляжный)',120,134,107},
	{'Зелено-серый',77,86,69},
	{'Мышино-серый',100,107,99},
	{'Серая спаржа',70,89,69},
	{'Пыльно-серый',125,127,125},
	{'Транспортный серый',141,148,141},
	{'Лягушка в обмороке',123,145,123},
	{'Фельдграу',77,93,83},
	{'Базальтово-серый',78,87,84},
	{'Серебристо-серый',138,149,151},
	{'Серая белка',120,133,139},
	{'Серовато-синий',74,84,92},
	{'Темный телегрей',130,137,143},
	{'Светлый аспидно-серый',119,136,153},
	{'Серый шифер, аспидно-серый',112,128,144},
	{'Маренго',76,88,102},
	{'Бледный синий',145,145,146},
	{'Серый нейтральный',160,160,164},
	{'Светлый пурпурно-синий',131,125,162},
	{'Перламутрово-ежевичный',108,104,116},
	{'Перламутрово-фиолетовый',134,115,161},
	{'Светло-фиолетовый',135,108,153},
	{'Бледный пурпурно-синий',138,127,142},
	{'Бледно-фиолетовый',149,123,141},
	{'Розовый Маунтбэттена',153,122,141},
	{'Пастельно-фиолетовый',161,133,148},
	{'Баклажановый Крайола',110,81,96},
	{'Платиново-серый',127,118,121},
	{'Серовато-пурпурный',114,82,92},
	{'Темный пурпурно-серый',86,64,66},
	{'Розово-коричневый',188,143,143},
	{'Серебряный',192,192,192},
	{'Гейнсборо',220,220,220},
	{'Дымчато-белый',245,245,245},
	{'Светло-серый',187,187,187},
	{'Светлый телегрей',208,208,208},
	{'Светлый серый',215,215,215},
	{'Бороды Абдель-Керима',213,213,213},
	{'Бледный пурпурно-розовый',253,189,186},
	{'Дыня Крайола',253,188,180},
	{'Светлый пурпурно-серый',200,169,158},
	{'Серебряный Крайола',205,197,194},
	{'Розовато-серый',200,166,150},
	{'Циннвальдит',235,194,175},
	{'Светло-серебристый',201,192,187},
	{'Синевато-белый',249,223,207},
	{'Пурпурно-белый',250,219,200},
	{'Песок пустыни',239,205,184},
	{'Бледно-песочный',218,189,171},
	{'Абрикосовый',251,206,177},
	{'Светлый синевато-серый',190,173,161},
	{'Серовато-оранжевый',194,168,148},
	{'Крайоловый Абрикос',253,213,177},
	{'Льняной',250,240,230},
	{'Миндаль Крайола',239,222,205},
	{'Абрикосовый Крайола',253,217,181},
	{'Сливочно-кремовый',242,221,198},
	{'Лесной волк',219,215,210},
	{'Белый антик',250,235,215},
	{'Бедра испуганной нимфы',250,238,221},
	{'Кремовый хаки',195,176,145},
	{'Зеленовато-белый',245,230,203},
	{'Старое кружево',253,245,230},
	{'Кремовый',253,244,227},
	{'Экрю',205,184,145},
	{'Пшеничный',245,222,179},
	{'Светлый зеленовато-белый',186,175,150},
	{'Бананомания',250,231,181},
	{'Сливочный',242,232,201},
	{'Серый шелк',202,196,176},
	{'Жемчужно-белый',234,230,202},
	{'Бледно-золотистый',238,232,170},
	{'Весенне-зеленый Крайола',236,234,190},
	{'Бледный весенний бутон',236,235,189},
	{'Галечный серый',184,183,153},
	{'Цвет шампанского',252,252,238},
	{'Бежевый',245,245,220},
	{'Светло-желтый золотистый',250,250,210},
	{'Очень бледный зеленый',216,222,186},
	{'Болотный',172,183,142},
	{'Агатовый серый',181,184,177},
	{'Серый зеленый чай',202,218,186},
	{'Зеленый чай',208,240,192},
	{'Темный зеленый чай',186,219,173},
	{'Бабушкины яблоки',168,228,160},
	{'Бело-зеленый',189,236,182},
	{'Очень светлый зеленый',152,199,147},
	{'Зеленый лишайник, мох (Цвет зеленого мха)',173,223,173},
	{'Умеренно зеленый',192,220,192},
	{'Темное зеленое море',143,188,143},
	{'Селадон',172,225,175},
	{'Очень светлый синевато-зеленый',160,214,180},
	{'Морской зеленый Крайола',159,226,191},
	{'Магическая мята',170,240,209},
	{'Гридеперлевый',199,208,204},
	{'Панг',199,252,236},
	{'Очень светлый зеленовато-синий',163,198,192},
	{'Пастельно-бирюзовый',127,181,181},
	{'Очень бледный синий',193,202,202},
	{'Бледно-синий',175,238,238},
	{'Пыльный голубой',176,224,230},
	{'Снежно-синий',172,229,238},
	{'Светлый синий',173,216,230},
	{'Бледно-васильковый',171,205,239},
	{'Очень светлый синий',166,189,215},
	{'Светлый стальной синий',176,196,222},
	{'Ниагара',157,177,204},
	{'Барвинок Крайола',197,208,230},
	{'Кадетский синий Крайола',176,183,198},
	{'Серое окно',157,161,170},
	{'Дикий синий Крайола',162,173,208},
	{'Ламантин',151,154,170},
	{'Голубой колокольчик Крайола',162,162,208},
	{'Лаванда (Лавандовый)',230,230,250},
	{'Очень светлый пурпурно-синий',186,172,199},
	{'Глициния (Глициниевый)',201,160,220},
	{'Глициния Крайола',205,164,222},
	{'Очень светлый фиолетовый',238,190,241},
	{'Чертополох',216,191,216},
	{'Светлая слива',221,160,221},
	{'Сиреневый',200,162,200},
	{'Розовый кварц',170,152,169},
	{'Орхидея Крайола',230,168,215},
	{'Оперный розовато-лиловый',183,132,167},
	{'Чертополох Крайола',235,199,223},
	{'Очень бледный пурпурно-синий',203,186,197},
	{'Лавандовый Крайола',252,180,213},
	{'Очень светло-пурпурный',227,169,190},
	{'Очень бледный фиолетовый',216,177,191},
	{'Розовый поросенок',253,221,230},
	{'Тусклый пурпурный',174,132,139},
	{'Тускло-амарантово-розовый',221,190,195},
	{'Очень бледно-пурпурный',230,187,193},
	{'Бледно-розовый',250,218,221},
	{'Бледно-каштановый',221,173,175},
	{'Серовато-пурпурно-розовый',204,146,147},
	{'Белоснежный',255,250,250},
	{'Белый',255,255,255},
	{'Тускло-розовый',255,228,225},
	{'Циннвальдитово-розовый',255,203,187},
	{'Цвет морской раковины (Морская пена)',255,245,238},
	{'Темно-персиковый',255,218,185},
	{'Бисквитный',255,228,196},
	{'Желтовато-белый',255,226,183},
	{'Очищенный миндаль',255,235,205},
	{'Побег папайи',255,239,213},
	{'Мокасиновый',255,228,181},
	{'Персиковый',255,229,180},
	{'Цветочный белый',255,250,240},
	{'Космические сливки',255,248,231},
	{'Цвет шелковистых нитевидных пестиков початков неспелой кукурузы',255,248,220},
	{'Лимонно-кремовый',255,250,205},
	{'Цвет слоновой кости (Айвори)',255,253,223},
	{'Кремово-желтый',255,253,208},
	{'Слоновая кость',255,255,240},
	{'Светло-желтый',255,255,224},
	{'Медовая роса',240,255,240},
	{'Мятно-кремовый',245,255,250},
	{'Светлый циан',224,255,255},
	{'Небесная лазурь',240,255,255},
	{'Синяя Элис',240,248,255},
	{'Барвинок, перванш',204,204,255},
	{'Призрачно-белый',248,248,255},
	{'Светлая мальва (Светло-розовато-лиловый)',220,208,255},
	{'Магнолия',248,244,255},
	{'Сладкая вата',255,188,217},
	{'Розово-лавандовый',255,240,245},
	{'Бледно-розоватый',255,203,219},
	{'Пастельно-розовый',255,209,220},
	{'Розовый',255,192,203},
	{'Светло-розовый',255,182,193},
	{'Темный серо-красный',72,42,42},
	{'Ивово-коричневый',50,20,20},
	{'Темный серо-красно-коричневый',55,31,28},
	{'Шоколадно-коричневый',69,50,46},
	{'Цвет блошиного брюшка',78,22,9},
	{'Махагон коричневый',76,47,39},
	{'Темный красно-серый',82,60,54},
	{'Кофейный',68,45,37},
	{'Темный Коричневый',53,23,12},
	{'Глубокий коричневый',77,34,14},
	{'Коричневато-серый',80,61,51},
	{'Темный терракотовый',78,59,49},
	{'Темный серо-коричневый',50,34,26},
	{'Бистр',61,43,31},
	{'Темный желтовато-коричневый',63,37,18},
	{'Коричневато-черный',20,15,11},
	{'Темно-серо-коричневый',72,60,50},
	{'Темный оливково-коричневый',48,33,18},
	{'Сепия коричневый',56,44,30},
	{'Оливковый серый',77,66,52},
	{'Серовато-оливковый',82,68,44},
	{'Очень темный хаки',76,60,24},
	{'Темный серо-оливковый',43,37,23},
	{'Желто-оливковый',71,64,46},
	{'Очень темный оливковый',54,44,18},
	{'Сероватый оливково-зеленый',72,68,45},
	{'Темный серо-оливково-зеленый',39,38,26},
	{'Умеренный оливково-зеленый',67,75,27},
	{'Бутылочно-зеленый',52,59,41},
	{'Темный оливково-зеленый',35,44,22},
	{'Глубокий оливково-зеленый',20,35,0},
	{'Хромовый зеленый',46,58,35},
	{'Темный желтовато-зеленый',48,75,38},
	{'Оливково-черный',18,25,16},
	{'Насыщенный оливково-зеленый',10,69,0},
	{'Миртовый',33,66,30},
	{'Очень темный желто-зеленый',19,39,18},
	{'Очень глубокий желто-зеленый',0,40,0},
	{'Темный зеленый',32,58,39},
	{'Перламутрово-зеленый',28,84,45},
	{'Глубокий желтовато-зеленый',0,84,31},
	{'Зеленый мох',47,69,56},
	{'Очень темный зеленый',22,37,28},
	{'Фталоцианиновый зеленый',18,53,36},
	{'Глубокий зеленый',0,69,36},
	{'Темно-зеленый',1,50,32},
	{'Цвет Красного моря',31,64,55},
	{'Глубокий синевато-зеленый',0,56,43},
	{'Очень темный синевато-зеленый',0,29,24},
	{'Темный синевато-зеленый',1,58,51},
	{'Аспидно-серый',47,79,79},
	{'Перламутровый опаловый',25,55,55},
	{'Сине-зеленый',31,58,61},
	{'Зеленый орел',0,73,83},
	{'Темный зеленовато-синий',0,56,65},
	{'Зелено-синий',31,52,56},
	{'Очень темный зеленовато-синий',2,32,39},
	{'Темно-синий',0,33,55},
	{'Берлинская лазурь',0,49,83},
	{'Океанская синь',29,51,74},
	{'Горечавково-синий',14,41,75},
	{'Перламутровый ночной',16,44,84},
	{'Кобальтово-синий',30,33,61},
	{'Ночной синий',37,40,80},
	{'Сапфирово-синий',29,30,51},
	{'Ультрамариново-синий',32,33,79},
	{'Глубокий пурпурно-синий',26,21,63},
	{'Темный пурпурно-синий',26,22,42},
	{'Глубокий фиолетово-черный',36,9,53},
	{'Очень глубокий пурпурный',50,11,53},
	{'Глубокий пурпурный',83,26,80},
	{'Очень темно-пурпурный',35,13,33},
	{'Очень глубокий красно-пурпурный',71,7,54},
	{'Темно-пурпурный',71,42,63},
	{'Очень темный красно-пурпурный',39,10,31},
	{'Черновато-пурпурный',29,16,24},
	{'Очень темный пурпурно-красный',40,7,26},
	{'Очень глубокий пурпурно-красный',71,0,39},
	{'Пурпурно-черный',27,17,22},
	{'Темный красно-пурпурный',79,39,58},
	{'Пурпурно-фиолетовый',74,25,44},
	{'Очень темный красный',50,10,24},
	{'Темный черновато-пурпурный',69,45,53},
	{'Очень глубокий красный',79,0,20},
	{'Черновато-красный',31,14,17},
	{'Черно-красный',65,34,39},
	{'Бурый',69,22,28},
	{'Глубокий красно-коричневый',73,0,5},
	{'Красновато-черный',30,17,18},
	{'Темный красно-коричневый',50,16,17},
	{'Болгарский розовый',72,6,7},
	{'Коричнево-бордовый',165,42,42},
	{'Оксид красный',100,36,36},
	{'Фалунский красный',128,24,24},
	{'Коричнево-малиновый',128,0,0},
	{'Розово-серо-коричневый',144,93,93},
	{'Медно-розовый (Бледный розовато-лиловый)',153,102,102},
	{'Темно-красный',139,0,0},
	{'Сигнальный красный',165,32,25},
	{'Карминно-красный',162,35,29},
	{'Красно-коричневый',89,35,33},
	{'Серовато-красный',140,71,67},
	{'Коричнево-красный',120,31,25},
	{'Розово-эбонитовый',103,72,70},
	{'Глубокий красно-оранжевый',169,29,17},
	{'Насыщенный красно-коричневый',127,24,13},
	{'Каштаново-коричневый',99,58,52},
	{'Темный красно-оранжевый',155,47,31},
	{'Золотисто-каштановый',113,47,38},
	{'Томатно-красный',161,35,18},
	{'Известковая глина',121,68,59},
	{'Умбра жженая',138,51,36},
	{'Темно-каштановый',152,105,96},
	{'Умеренный серо-коричневый',103,76,71},
	{'Серовато-красно-коричневый',94,56,48},
	{'Бисмарк-фуриозо',165,38,10},
	{'Кирпичный',136,69,53},
	{'Медно-коричневый',142,64,42},
	{'Перламутровый медный',118,60,40},
	{'Сигнальный коричневый',108,59,42},
	{'Терракотовый',144,77,48},
	{'Сепия Крайола',165,105,79},
	{'Светлый серо-красно-коричневый',150,106,87},
	{'Серовато-коричневый',90,61,48},
	{'Сиена',160,82,45},
	{'Насыщенный коричневый',117,51,19},
	{'Умеренный коричневый',103,57,35},
	{'Орехово-коричневый',91,58,41},
	{'Светлый коричневато-серый',139,109,92},
	{'Светлый серо-коричневый',148,107,84},
	{'Светлый коричневый',168,101,64},
	{'Олень коричневый',89,53,31},
	{'Глиняный коричневый',115,66,34},
	{'Бежево-коричневый',121,85,61},
	{'Оранжево-коричневый',166,94,46},
	{'Коричневый цвета кожанного седла для лошади',139,69,19},
	{'Серовато-желто-коричневый',120,88,64},
	{'Красно-желто-коричневый',128,70,27},
	{'Глубокий желто-коричневый',89,51,21},
	{'Камелопардовый',162,95,42},
	{'Бледно-коричневый',117,92,72},
	{'Умеренный желто-коричневый',125,81,45},
	{'Цвет медвежьего ушка',131,77,24},
	{'Насыщенный желто-коричневый',149,80,12},
	{'Коричнево-бежевый',138,102,66},
	{'Перламутрово-золотой',112,83,53},
	{'Коричневый',150,75,0},
	{'Сырая умбра',113,75,35},
	{'Сепия (Каракатица)',112,66,20},
	{'Светло-коричневый',152,118,84},
	{'Темно-коричневый',101,67,33},
	{'Коричный',123,63,0},
	{'Охра коричневая',149,95,32},
	{'Оливково-коричневый',111,79,40},
	{'Светлый оливковый серый',136,115,89},
	{'Натуральная умбра',115,74,18},
	{'Темный серо-желтый',164,124,69},
	{'В меру оливково-коричневый',100,64,15},
	{'Светлый оливково-коричневый',148,93,11},
	{'Светлый серо-оливковый',139,115,75},
	{'Полумрак Крайола',138,121,93},
	{'Шамуа',160,128,64},
	{'Песочный серо-коричневый',150,113,23},
	{'Зелено-коричневый',130,108,52},
	{'Умеренно-оливковый',94,73,15},
	{'Светло-оливковый',132,106,32},
	{'Темный желто-коричневый',145,129,81},
	{'Медово-желтый',169,131,7},
	{'Хаки',128,107,42},
	{'Серовато-желто-зеленый',144,132,91},
	{'Темный зеленовато-желтый',155,129,39},
	{'Серый хаки',106,95,49},
	{'Глубокий зеленовато-желтый',159,130,0},
	{'Серо-бежевый',158,151,100},
	{'Желтый карри',157,145,1},
	{'Умеренный желто-зеленый',139,137,64},
	{'Оливковый',128,128,0},
	{'Оливково-желтый',153,153,80},
	{'Насыщенный желто-зеленый',127,143,24},
	{'Нежно-оливковый',107,142,35},
	{'Темно-оливковый',85,104,50},
	{'Глубокий желтый зеленый',66,94,23},
	{'Умеренный желтовато-зеленый',101,127,75},
	{'Спаржа',123,160,91},
	{'Кленовый зеленый',80,125,42},
	{'Спаржа Крайола',135,169,107},
	{'Цвет елки',42,92,3},
	{'Резедово-зеленый',88,114,70},
	{'Травяной',93,161,48},
	{'Папоротниково-зеленый',61,100,45},
	{'Темный желто-зеленый',87,166,57},
	{'Насыщенный желтовато-зеленый',71,132,48},
	{'Зеленый папоротник',79,121,66},
	{'Майский зеленый',76,145,65},
	{'Травяной зеленый',53,104,45},
	{'Индийский зеленый',19,136,8},
	{'Лиственно-зеленый',45,87,44},
	{'Лесной зеленый',34,139,34},
	{'Зеленый',0,128,0},
	{'Травяной (Очень темный лимонный зеленый)',0,100,0},
	{'Мусульманский зеленый',0,153,0},
	{'Арлекин',68,148,74},
	{'Охотничий зеленый',53,94,59},
	{'Изумрудно-зеленый',40,114,51},
	{'Сигнальный зеленый',49,127,67},
	{'Транспортный зеленый',48,132,70},
	{'Умеренный зеленый',56,102,70},
	{'Блестящий зеленый',71,167,106},
	{'Яркий зеленый',0,125,52},
	{'Зеленое море',46,139,87},
	{'Мятно-зеленый',32,96,61},
	{'Пигментный зеленый',0,165,80},
	{'Зеленый Мичиганского университета',0,102,51},
	{'Темный весенне-зеленый',23,114,69},
	{'Светлый синевато-зеленый',102,158,133},
	{'Насыщенный зеленый',0,107,60},
	{'Дартмутский зеленый',0,105,62},
	{'Патиново-зеленый',49,102,80},
	{'Сосновый зеленый',44,85,69},
	{'Нефритовый',0,168,107},
	{'Зеленый трилистник',0,154,99},
	{'Бирюзово-зеленый',30,89,69},
	{'Ядовито-зеленый',64,130,109},
	{'Умеренный синевато-зеленый',47,101,86},
	{'Блестящий синевато-зеленый',0,155,118},
	{'Изумруд',0,155,119},
	{'Мокрый тропический лес',23,128,109},
	{'Мятно-бирюзовый',73,126,118},
	{'Насыщенный синевато-зеленый',0,109,91},
	{'Яркий синевато-зеленый',0,131,110},
	{'Опаловый зеленый',1,93,82},
	{'Персидский зеленый',0,166,147},
	{'Зеленая сосна',1,121,111},
	{'Зеленая сосна Крайола',21,128,120},
	{'Пастельно-синий',93,155,155},
	{'Темный циан',0,139,139},
	{'Цвет окраски птицы чирок (Сине-зеленый)',0,128,128},
	{'Темно-бирюзовый',17,96,98},
	{'Кадетский синий',95,158,160},
	{'Мурена',28,107,114},
	{'Светлый зеленовато-синий',100,154,158},
	{'Бирюзово-синий',63,136,143},
	{'Блестящий зеленовато-синий',42,141,156},
	{'Водная синь',37,109,123},
	{'Умеренный зеленовато-синий',48,98,107},
	{'Насыщенный зеленовато-синий',0,103,126},
	{'Лазурно-синий',2,86,105},
	{'Лазурно-серый (Зеленовато-синий)',0,123,167},
	{'Перламутровый горечавково-синий',42,100,120},
	{'Средний персидский синий',0,103,165},
	{'Мертвенный индиго',0,65,106},
	{'Насыщенный синий',0,83,138},
	{'Капри синий',27,85,131},
	{'Глубокий синий',0,47,85},
	{'Темно-лазурный',8,69,126},
	{'Полуночно-синий',0,51,102},
	{'Полуночный синий Крайола',26,72,118},
	{'Цвет ВКонтакте',77,113,152},
	{'Умеренный синий',57,87,120},
	{'Транспортный синий',6,57,113},
	{'Отдаленно-синий',73,103,141},
	{'Бриллиантово-синий',62,95,138},
	{'Цвет Черного моря',26,71,128},
	{'Фиолетово-синий',53,77,115},
	{'Синяя пыль',0,51,153},
	{'Голубино-синий',96,110,140},
	{'Цвет Фейсбука',59,89,152},
	{'Сапфировый',8,37,103},
	{'Сигнальный синий',30,36,96},
	{'Блестящий пурпурно-синий',98,99,155},
	{'Полуночный черный',25,25,112},
	{'Темный ультрамариновый',0,0,139},
	{'Темно-синий (Цвет формы морских офицеров)',0,0,128},
	{'Ультрамариновый',18,10,143},
	{'Насыщенный пурпурно-синий',71,67,137},
	{'Темный аспидно-синий',72,61,139},
	{'Пурпурно-синий',32,21,94},
	{'Умеренный пурпурно-синий',66,60,99},
	{'Глубокий фиолетовый',66,49,137},
	{'Персидский индиго',50,18,122},
	{'Блестящий фиолетовый',117,93,154},
	{'Насыщенный фиолетовый',83,55,122},
	{'Королевский пурпурный Крайола',120,81,169},
	{'Темный индиго',49,0,98},
	{'Индиго',75,0,130},
	{'Умеренный фиолетовый',84,57,100},
	{'Серобуромалиновый',115,81,132},
	{'Темный пурпурно-фиолетовый',102,0,153},
	{'Сине-сиреневый',108,70,117},
	{'Яркий фиолетовый Крайола',143,80,157},
	{'Сливовый',102,0,102},
	{'Темный маджента',139,0,139},
	{'Фиолетово-баклажанный',153,17,153},
	{'Пурпурный',128,0,128},
	{'Яркий пурпурный',148,51,145},
	{'Сливовый Крайола',142,69,133},
	{'Византия',112,41,99},
	{'Умеренно-темный пурпурный',128,62,117},
	{'Темная Византия',93,57,84},
	{'Умеренный пурпурный',127,72,112},
	{'Яркий красно-пурпурный',126,0,89},
	{'Сигнальный фиолетовый',146,78,125},
	{'Баклажановый',153,0,102},
	{'Глубокий красно-пурпурный',100,19,73},
	{'Красно-сиреневый',109,63,91},
	{'Транспортный пурпурный',160,52,114},
	{'Амарантовый глубоко-пурпурный',159,43,104},
	{'Насыщенный красно-пурпурный',154,54,107},
	{'Баклажанный Крайола',97,64,81},
	{'Мальва (Розовато-лиловый)',153,51,102},
	{'Глубокий пурпурно-красный',111,0,53},
	{'Умеренный красно-пурпурный',140,69,102},
	{'Бордово-фиолетовый',100,28,52},
	{'Серовато-красно-пурпурный',125,77,93},
	{'Вишневый (Вишня)',145,30,66},
	{'Темный пурпурно-красный',91,30,49},
	{'Темно-серая мальва (Розовато-лилово-серый)',145,95,109},
	{'Очень темный алый',86,3,25},
	{'Умеренный пурпурно-красный',167,56,83},
	{'Бургундский',144,0,32},
	{'Глубокий карминный',169,32,62},
	{'Глубокий красный',123,0,28},
	{'Красно-фиолетовый',146,43,62},
	{'Кармин',150,0,24},
	{'Перламутрово-рубиновый',114,20,34},
	{'Серовато-пурпурно-красный',140,72,82},
	{'Винно-красный',94,33,41},
	{'Розовый лес',101,0,11},
	{'Пурпурно-красный',117,21,30},
	{'Темный красный',104,28,35},
	{'Рубиново-красный',155,17,30},
	{'Кордованский',137,63,69},
	{'Сангина',146,0,10},
	{'Бордовый',155,45,48},
	{'Транспортный красный',204,6,5},
	{'Индийский красный, каштановый',205,92,92},
	{'Люминесцентный красный',248,0,0},
	{'Персидский красный',204,51,51},
	{'Бордо (Красно-бордовый)',176,0,0},
	{'Фузи-вузи',204,102,102},
	{'Светлый серо-пурпурно-красный',178,112,112},
	{'Глубокий желто-розовый',246,74,70},
	{'Темный розовый',199,104,100},
	{'Светлый карминово-розовый',230,103,97},
	{'Темно-алый',203,40,33},
	{'Кораллово-красный',179,40,33},
	{'Карминно-розовый',235,76,66},
	{'Сочный каштановый Крайола',185,78,72},
	{'Каштановый Крайола',188,93,88},
	{'Оранжевая заря',253,94,83},
	{'Бледно-карминный',176,63,53},
	{'Марсала',173,101,95},
	{'Китайский красный (Киноварь)',227,66,52},
	{'Перламутрово-розовый',180,76,67},
	{'Средний карминный',175,64,53},
	{'Огненно-красный',175,43,30},
	{'Горько-сладкий',253,124,110},
	{'Умеренный розовый',238,144,134},
	{'Шапка Деда Мороза',202,58,39},
	{'Шапка Санта-Клауса',237,72,48},
	{'Мандариновое танго',225,82,61},
	{'Транспортный оранжевый',245,64,33},
	{'Темный желто-розовый',204,108,92},
	{'Светлый серо-красный',177,114,103},
	{'Лососево-оранжевый',229,81,55},
	{'Темно-коралловый',205,91,69},
	{'Красно-оранжевый',201,60,32},
	{'Гранатовый',243,71,35},
	{'Умеренный красно-оранжевый',211,83,57},
	{'Яркий красно-оранжевый',241,58,19},
	{'Серовато-розовый',207,155,143},
	{'Лососево-красный',217,80,48},
	{'Серовато-красно-оранжевый',184,93,67},
	{'Сиена жженая',233,116,81},
	{'Огненная сиенна Крайола',234,126,93},
	{'Светло-тициановый',216,75,32},
	{'Светлый красно-коричневый',170,102,81},
	{'Темно-лососевый',233,150,122},
	{'Умеренный желто-розовый',238,147,116},
	{'Коричневый Крайола',180,103,77},
	{'Тициановый',213,62,7},
	{'Серовато-желто-розовый',211,155,133},
	{'Пылкий красно-оранжевый',247,94,37},
	{'Перламутрово-оранжевый',195,88,49},
	{'Медный Крайола',221,148,117},
	{'Ржаво-коричневый',183,65,14},
	{'Морковный',243,98,35},
	{'Коричневато-оранжевый',177,81,36},
	{'Бежево-красный',193,135,107},
	{'Ванильный',213,113,63},
	{'Красное дерево',192,64,0},
	{'Умеренный оранжевый',232,121,62},
	{'Античная латунь',205,149,117},
	{'Сомон',239,175,140},
	{'Глубокий оранжевый',195,77,10},
	{'Коричневато-розовый',205,154,123},
	{'Перекати-поле',222,170,136},
	{'Сырая охра',214,138,89},
	{'Цвет загара Крайола',250,167,108},
	{'Красно-буро-оранжевый',205,87,0},
	{'Бледный серо-коричневый',188,152,126},
	{'Жженый апельсин (Выгоревший оранжевый)',204,85,0},
	{'Шоколадный',210,105,30},
	{'Светлый серо-желто-коричневый',180,135,100},
	{'Насыщенный оранжевый',236,124,38},
	{'Рыжий',215,125,49},
	{'Красный песок',244,164,96},
	{'Желто-оранжевый',237,118,14},
	{'Умеренный оранжево-желтый',247,148,60},
	{'Медный',184,115,51},
	{'Бронзовый',205,127,50},
	{'Перу',205,133,63},
	{'Желтовато-серый',202,168,133},
	{'Глубокий оранжево-желтый',215,110,0},
	{'Охра',204,119,34},
	{'Темный оранжево-желтый',195,118,41},
	{'Темный мандарин',234,117,0},
	{'Светло-морковный',237,145,33},
	{'Коричнево-желтый цвета увядших листьев',193,154,107},
	{'Тусклый мандарин',242,133,0},
	{'Светлый желто-коричневый',187,139,84},
	{'Пастельно-желтый',239,169,74},
	{'Цвет загара (Желто-коричневый)',210,180,140},
	{'Золотой Крайола',231,198,151},
	{'Серовато-желтый',206,162,98},
	{'Солнечно-желтый',243,159,24},
	{'Темно-желтый',176,125,43},
	{'Светлая Сиена (Почти чистый оранжевый)',226,139,0},
	{'Умеренный желтый',215,157,65},
	{'Насыщенный желтый',229,158,31},
	{'Желто-персиковый',250,223,173},
	{'Гуммигут',228,155,15},
	{'Маисовый',237,209,156},
	{'Кукурузно-желтый',228,160,16},
	{'Глубокий желтый',181,121,0},
	{'Георгиново-желтый',243,165,5},
	{'Песочно-желтый',198,166,100},
	{'Дынно-желтый',244,169,0},
	{'Серовато-зеленовато-желтый',196,165,95},
	{'Медовый',254,229,172},
	{'Золотисто-березовый',218,165,32},
	{'Темный золотарник (Темно-золотой)',184,134,11},
	{'Нарциссово-желтый',220,157,0},
	{'Бледный желто-зеленый',240,214,152},
	{'Желто-золотой',205,164,52},
	{'Золотарник Крайола',252,217,117},
	{'Одуванчиковый',253,219,109},
	{'Умеренный зеленовато-желтый',196,164,61},
	{'Шафрановый',244,196,48},
	{'Оранжево-желтый Крайола',248,213,104},
	{'Темно-грушевый',216,169,3},
	{'Светло-песочный',253,234,168},
	{'Песочный',252,221,118},
	{'Насыщенный зеленовато-желтый',204,168,23},
	{'Желтый ракитник',214,174,1},
	{'Светлая слоновая кость',230,214,144},
	{'Шафраново-желтый',245,208,51},
	{'Старое золото',207,181,59},
	{'Кожа буйвола (Палевый)',240,220,130},
	{'Яркий зеленовато-желтый',244,200,0},
	{'Старый лен',238,220,130},
	{'Сигнальный желтый',229,190,1},
	{'Желтый Крайола',252,232,131},
	{'Транспортно-желтый',250,210,1},
	{'Лимонно-желтый',199,180,70},
	{'Охра желтая',174,160,75},
	{'Грушевый',239,211,52},
	{'Желтая слоновая кость',225,204,79},
	{'Латунный',181,166,66},
	{'Рапсово-желтый',243,218,11},
	{'Цвет пергидрольной блондинки',238,230,163},
	{'Светлый хаки',240,230,140},
	{'Зелено-желтый Крайола',240,232,145},
	{'Лимонный',253,233,16},
	{'Кукурузный',251,236,93},
	{'Темный хаки',189,183,107},
	{'Светлый желто-зеленый',220,211,106},
	{'Цвет детской неожиданности',247,242,26},
	{'Цинково-желтый',248,243,43},
	{'Оливково-зеленый Крайола',186,184,108},
	{'Вердепешевый',218,216,113},
	{'Зелено-бежевый',190,189,127},
	{'Лазерный лимон',254,254,34},
	{'Блестящий желто-зеленый',206,210,58},
	{'Грушево-зеленый',209,226,49},
	{'Яркий желто-зеленый',147,170,0},
	{'Июньский бутон',189,218,87},
	{'Обычный весенний бутон',201,220,135},
	{'Желто-зеленый Крайола',197,227,132},
	{'Очень светлый желто-зеленый',198,223,144},
	{'Желто-зеленый',154,205,50},
	{'Весенний бутон',167,252,0},
	{'Гусеница',178,236,93},
	{'Фисташковый',190,245,116},
	{'Зеленая лужайка',124,252,0},
	{'Блестящий желтовато-зеленый',140,203,94},
	{'Бледно-зеленый',137,172,118},
	{'Ирландский зеленый',76,187,23},
	{'Вердепомовый',52,201,36},
	{'Лаймово-зеленый',50,205,50},
	{'Бледный зеленый',152,251,152},
	{'Светло-зеленый',144,238,144},
	{'Цвет влюбленной жабы',60,170,60},
	{'Пастельно-зеленый',119,221,119},
	{'Папоротник Крайола',113,188,120},
	{'Темный пастельно-зеленый',3,192,60},
	{'Лиственный зеленый Крайола',109,174,129},
	{'Малахитовый',11,218,81},
	{'Изумрудный',80,200,120},
	{'Умеренно-зеленое море',60,179,113},
	{'Умеренный весенний зеленый',0,250,154},
	{'Мятный',62,180,137},
	{'Зеленый Крайола',28,172,120},
	{'Умеренный аквамариновый',102,205,170},
	{'Трилистник Крайола',69,206,162},
	{'Горный луг',48,186,143},
	{'Зеленые джунгли Крайола',59,176,143},
	{'Карибский зеленый',28,211,162},
	{'Зеленые джунгли Крайола 90-го года',41,171,135},
	{'Светло-бирюзовый',64,224,208},
	{'Бирюзовый',48,213,200},
	{'Светлый серо-синий',132,195,190},
	{'Светлое зеленое море',32,178,170},
	{'Ярко-бирюзовый',8,232,222},
	{'Умеренно-бирюзовый',72,209,204},
	{'Тиффани',10,186,181},
	{'Синий цвета яиц странствующего дрозда',31,206,203},
	{'Цвет яйца дрозда',0,204,204},
	{'Аквамариновый Крайола',120,219,226},
	{'Бирюзово-голубой Крайола',119,221,231},
	{'Синий чирок',24,167,181},
	{'Голубой Крайола',128,218,235},
	{'Воды пляжа Бонди',0,149,182},
	{'Сине-зеленый Крайола',13,152,186},
	{'Тихоокеанский синий',28,169,201},
	{'Лазурный Крайола',29,172,214},
	{'Ярко-синий',0,124,173},
	{'Цвет Твиттера',31,174,233},
	{'Городское небо (Пасмурно-небесный)',135,206,235},
	{'Цвет Хабрахабра',120,162,183},
	{'Васильковый Крайола',154,206,235},
	{'Светло-голубой',135,206,250},
	{'Блестящий синий',66,133,180},
	{'Цвет морской волны (Аква)',0,140,240},
	{'Светлый сине-серый',108,146,175},
	{'Синий-синий иней',175,218,252},
	{'Темно-голубой',59,131,189},
	{'Сизый',121,160,193},
	{'Небесно-синий',34,113,179},
	{'Синяя сталь',70,130,180},
	{'Зелено-синий Крайола',17,100,180},
	{'Сине-серый Крайола',102,153,204},
	{'Темно-синий Крайола',25,116,210},
	{'Светло-синий',166,202,240},
	{'Джинсовый синий',21,96,189},
	{'Светлый джинсовый',43,108,196},
	{'Синий Клейна',58,117,196},
	{'Кобальт синий (Кобальтовый)',0,71,171},
	{'Синий Крайола',31,117,254},
	{'Васильковый',100,149,237},
	{'Синяя лазурь (Лазурно-голубой)',42,82,190},
	{'Королевский синий',65,105,225},
	{'Индиго Крайола',93,118,203},
	{'Синий экран смерти',18,47,170},
	{'Фиолетово-синий Крайола',50,74,178},
	{'Умеренный аспидно-синий',123,104,238},
	{'Сине-фиолетовый Крайола',115,102,189},
	{'Аспидно-синий',106,90,205},
	{'Средний пурпурный',147,112,216},
	{'Пурпурное сердце',116,66,200},
	{'Пурпурное горное величие',157,129,186},
	{'Аметистовый',153,102,204},
	{'Сине-лиловый',138,43,226},
	{'Фиолетовый Крайола (Пурпурный)',146,110,174},
	{'Темная орхидея',153,50,204},
	{'Темно-фиолетовый',148,0,211},
	{'Умеренный цвет орхидеи',186,85,211},
	{'Фиалковый',234,141,247},
	{'Фуксия Крайола',195,100,197},
	{'Розовый фламинго',252,116,253},
	{'Шокирующий розовый Крайола',251,126,253},
	{'Глубокая фуксия Крайола',193,84,193},
	{'Розово-фиолетовый',238,130,238},
	{'Ярко-фиолетовый',205,0,205},
	{'Орхидея',218,112,214},
	{'Светло-розовая фуксия',249,132,239},
	{'Фуксия (Фуксин)',247,84,225},
	{'Византийский',189,51,164},
	{'Блестящий пурпурный',221,128,204},
	{'Сияющая орхидея',181,101,167},
	{'Бледно-пурпурный',249,132,229},
	{'Амарантовый маджента',237,60,202},
	{'Ярко-розовый',252,15,192},
	{'Лавандовый розовый',251,160,227},
	{'Модная фуксия',244,0,161},
	{'Королевская фуксия',202,44,146},
	{'Мовеин (Анилиновый пурпур)',239,0,151},
	{'Умеренный фиолетово-красный',199,21,133},
	{'Красно-фиолетовый Крайола',192,68,143},
	{'Светло-пурпурный',186,127,162},
	{'Персидский розовый',254,40,162},
	{'Амарантовый светло-вишневый',205,38,130},
	{'Фанданго',181,84,137},
	{'Шелковица Крайола',197,75,140},
	{'Светло-вишневый Крайола',221,68,146},
	{'Маджента Крайола',246,100,175},
	{'Телемагента',207,52,118},
	{'Вересково-фиолетовый',222,76,138},
	{'Грузинский розовый',215,24,104},
	{'Фиолетово-красный Крайола',247,83,148},
	{'Светлый красно-пурпурный',187,108,138},
	{'Цвет суеты',227,37,107},
	{'Французский розовый',246,74,138},
	{'Амарантово-розовый',241,156,187},
	{'Малиново-розовый',179,68,108},
	{'Бледный фиолетово-красный',216,112,147},
	{'Лиловый',219,112,147},
	{'Жимолость',203,101,134},
	{'Джазовый джем',202,55,103},
	{'Глубокий пурпурно-розовый',235,82,132},
	{'Розовый (Пощекочи меня)',252,137,172},
	{'Амарантово-пурпурный',171,39,79},
	{'Яркий пурпурно-красный',213,38,91},
	{'Румянец',222,93,131},
	{'Темно-розовый',231,84,128},
	{'Насыщенный пурпурно-красный',179,40,81},
	{'Светлая вишня',222,49,99},
	{'Коричнево-малиновый Крайола',200,56,90},
	{'Пюсовый',204,136,153},
	{'Красный Крайола',238,32,77},
	{'Розовый щербет',247,143,167},
	{'Турецкий розовый',181,114,129},
	{'Розовато-лиловый Крайола',239,152,170},
	{'Насыщенный пурпурно-розовый',246,118,142},
	{'Малиновый',220,20,60},
	{'Бледный красно-пурпурный',172,117,128},
	{'Крутой розовый Крайола',251,96,127},
	{'Амарантовый',229,43,80},
	{'Кардинал',196,30,58},
	{'Дикий арбуз Крайола',252,108,133},
	{'Пламенная маджента Крайола',248,23,62},
	{'Светлый розово-лиловый',234,137,154},
	{'Яркий красный',193,0,32},
	{'Умеренный пурпурно-розовый',226,128,144},
	{'Темный пурпурно-розовый',199,101,116},
	{'Розово-золотой',183,110,121},
	{'Скарлет',252,40,71},
	{'Кирпично-красный',203,65,84},
	{'Малиново-красный',197,29,52},
	{'Насыщенный красный',191,34,51},
	{'Терракота',204,78,92},
	{'Ализариновый красный',227,38,54},
	{'Светлый малиново-красный',230,50,68},
	{'Умеренный красный',171,52,58},
	{'Цвет пожарной машины',206,32,41},
	{'Розовая долина',171,78,82},
	{'Глубокий карминно-розовый',239,48,56},
	{'Розовый антик',211,110,112},
	{'Ориент красный',179,36,40},
	{'Красное дерево Крайола',205,74,76},
	{'Насыщенный розовый',253,123,124},
	{'Старинный розовый',192,128,129},
	{'Клубнично-красный',213,48,50},
	{'Глубокий коралловый',255,64,64},
	{'Оранжево-красный Крайола',255,43,43},
	{'Красный',255,0,0},
	{'Красно-оранжевый Крайола',255,83,73},
	{'Алый',255,36,0},
	{'Томатный',255,99,71},
	{'Светло-коралловый',255,188,173},
	{'Насыщенный желто-розовый',255,122,92},
	{'Скандальный оранжевый',255,110,74},
	{'Ярко-мандариновый',255,160,137},
	{'Яркий желто-розовый',255,132,92},
	{'Лососевый',255,140,105},
	{'Коралловый',255,127,80},
	{'Огненный оранжевый',255,127,73},
	{'Киноварь',255,77,0},
	{'Международный оранжевый (Сигнальный)',255,79,0},
	{'Оранжевый Крайола',255,117,56},
	{'Цвет маленького мандарина',255,164,116},
	{'Оранжево-розовый',255,153,102},
	{'Светлый желто-розовый',255,178,139},
	{'Манго-танго',255,130,67},
	{'Бледный желто-розовый',255,200,168},
	{'Пастельно-оранжевый',255,117,20},
	{'Светлый оранжевый',255,161,97},
	{'Тыква (Тыквенный)',255,117,24},
	{'Яркий оранжевый',255,104,0},
	{'Персиковый Крайола',255,207,171},
	{'Макароны и сыр',255,189,136},
	{'Темный янтарь',255,126,0},
	{'Неоново-морковный',255,163,67},
	{'Оранжево-персиковый',255,204,153},
	{'Насыщенный оранжево-желтый',255,142,13},
	{'Последний вздох Жако',255,146,24},
	{'Мандариновый',255,136,0},
	{'Темно-оранжевый',255,140,0},
	{'Яркий оранжево-желтый',255,142,0},
	{'Бледный оранжево-желтый',255,202,134},
	{'Насыщенный красно-оранжевый',255,185,97},
	{'Желто-оранжевый Крайола',255,174,66},
	{'Люминесцентный ярко-оранжевый',255,164,32},
	{'Белый навахо',255,222,173},
	{'Сигнальный оранжевый',255,153,0},
	{'Темно-мандариновый',255,168,18},
	{'Кожура апельсина',255,160,0},
	{'Блестящий оранжевый',255,184,65},
	{'Бриллиантовый оранжево-желтый',255,176,46},
	{'Желто-розовый',255,228,178},
	{'Оранжевый',255,165,0},
	{'Бледно-желтый',255,219,139},
	{'Ярко-желтый',255,179,0},
	{'Светлый глубокий желтый',255,211,95},
	{'Отборный желтый',255,186,0},
	{'Янтарный',255,191,0},
	{'Бледный зеленовато-желтый',255,223,132},
	{'Блестящий желтый',255,207,64},
	{'Восход солнца',255,207,72},
	{'Горчичный',255,219,88},
	{'Светлый зеленовато-желтый',255,222,90},
	{'Цвет Яндекса',255,204,0},
	{'Блестящий зеленовато-желтый',255,220,51},
	{'Золотой (Золотистый)',255,215,0},
	{'Цвет желтого школьного автобуса',255,216,0},
	{'Светло-золотистый',255,236,139},
	{'Лимонно-желтый Крайола',255,244,79},
	{'Канареечный (Ярко-желтый)',255,255,153},
	{'Желтый',255,255,0},
	{'Незрелый желтый',255,255,102},
	{'Желтая сера',237,255,33},
	{'Электрик лайм (Лаймовый)',204,255,0},
	{'Электрик лайм Крайола',206,255,29},
	{'Зелено-лаймовый',191,255,0},
	{'Зелено-желтый',173,255,47},
	{'Шартрез, Ядовито-зеленый',127,255,0},
	{'Ярко-зеленый',102,255,0},
	{'Лайм',0,255,0},
	{'Салатовый',153,255,153},
	{'Мята (Цвет зеленой мяты)',152,255,152},
	{'Кричащий зеленый',118,255,122},
	{'Морской зеленый',84,255,159},
	{'Весенне-зеленый (Зеленая весна)',0,255,127},
	{'Аквамариновый',127,255,212},
	{'Циан, Цвет морской волны',0,255,255},
	{'Электрик',125,249,255},
	{'Голубой (Морозное небо)',0,191,255},
	{'Небесный',127,199,255},
	{'Голубой',66,170,255},
	{'Защитно-синий',30,144,255},
	{'Лазурный, Азур',0,127,255},
	{'Синий Градуса',0,125,255},
	{'Синий',0,0,255},
	{'Персидский синий',102,0,255},
	{'Фиолетово-сизый',128,0,255},
	{'Фиолетовый',139,0,255},
	{'Ярко-сиреневый',224,176,255},
	{'Гелиотроп (Гелиотроповый)',223,115,255},
	{'Розовая фуксия',255,119,255},
	{'Маджента, Фуксия (Пурпурный)',255,0,255},
	{'Пурпурная пицца',255,0,204},
	{'Экстравагантный розовый Крайола',255,51,204},
	{'Звезды в шоке',255,71,202},
	{'Глубокий розовый',255,20,147},
	{'Дикая клубника Крайола',255,67,164},
	{'Розовая гвоздика',255,170,204},
	{'Блестящий пурпурно-розовый',255,151,187},
	{'Американский розовый',255,3,62},
	{'Радикальный красный',255,73,108},
	{'Карминово-красный',255,0,51},
	{'Пылкий розовый',255,126,147},
	{'Лососевый Крайола',255,155,170},
	{'Светлый пурпурно-розовый',255,168,175},
}
