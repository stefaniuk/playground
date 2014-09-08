
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `search_dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_dataset` (
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Search item ID, e.g. node ID for nodes.',
  `type` varchar(16) NOT NULL COMMENT 'Type of item, e.g. node.',
  `data` longtext NOT NULL COMMENT 'List of space-separated words from the item.',
  `reindex` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Set to force node reindexing.',
  PRIMARY KEY (`sid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores items that will be searched.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `search_dataset` WRITE;
/*!40000 ALTER TABLE `search_dataset` DISABLE KEYS */;
INSERT INTO `search_dataset` VALUES (1,'node',' anonimowi otwierają anontune osoby podające się za członków anonymous stają na przeciw gigantom muzycznym ich celem jest utworzenie serwisu dzięki któremu będziemy mogli słuchać muzyki za darmo strona demonstracyjna jest dostępna pod adresem http anontunecom demo   odbywałoby się to na zasadzie przeszukiwania wszystkich innych serwisów muzycznych i udostępnienie wyników w jednym miejscu dzięki temu serwis nie łamałby prawa ponieważ nie udostępnia bezpośrednio plików a wykorzystuje pośrednie strony jak na razie projekt ukończony został w jakiś 20 czekamy zatem na odpowiedź innych wytwórni bo zapewne wywoła to niemałe zamieszanie w świecie muzycznym zerodaypl anonymous file sharing ',0);
INSERT INTO `search_dataset` VALUES (2,'node',' anonymous atakuje oficjalna stronę f1 w piątek wieczorem grupie anonimowych hakerów udało się zablokować stronę formuły 1 atak na stronę zbiegł się w czasie z demonstracją odbywającą się na autostradzie do manamy stolicy bahrajnu podczas gdy strona została zablokowana wyświetlał się napis formula none i adnotacja dlaczego grand prix bahrajnu nie powinno się odbywać zerodaypl anonymous hacking ',0);
INSERT INTO `search_dataset` VALUES (3,'node',' poważna luka w php w trybie cgi serwery www z interpreterami php są zagrożone czasem parametry url mogą zostać przekazane do php i zinterpretowane jako argumenty linii poleceń jeżeli dodanie parametru s do dowolnego adresu url spowoduje pojawienie się kodu źródłowego php tzn że nasz serwer jest zagrożony luka została wyeliminowana w aktualizacjach do wersji php 5312 i 542 autorzy odkrycia piszą że atak pozwala na bezpośrednie wstrzyknięcie i uruchomienie wrogiego kodu co może pociągnąć za sobą katastrofalne skutki powyższa dziura dotyczy serwerów z php pracujących w trybie cgi instalacje fastcgi php nie są podatne na ten atak zerodaypl php luka serwer zagrożenie ',0);
INSERT INTO `search_dataset` VALUES (4,'node',' igprs odzyskuje hasła truecrypta iphone a i sieci wifi dzięki programowi igprs ang ivan golubev s password recovery suite można łamać hasła do backupów z telefonów apple blackberry oraz wolumenów truecrypta i sieci wifi dzięki igprs złamiemy hasła do backupów ios 4x i 5x hasła do backupów blackberry 5x i 6x hasła do wolumenów truecrypt handshake do sieci wpa wpa2 igprs korzysta z instrukcji optymalizujących dla procesorów dzięki czemu jest wydajniejszy niż inne tego typu programy igprs wspiera procesory gpu takie jak od ati hd4xxx do hd7xxx oraz od nvidia gt8600 do gtx590 program można ściągnąć z tej strony zerodaypl igprs backup ios blackberry truecrypt wpa wpa2 łamanie haseł ',0);
INSERT INTO `search_dataset` VALUES (5,'node',' dziurawy skype odkryta luka w oprogramowaniu która ujrzała światło dzienne pozwala na uzyskanie dowolnego adresu ip użytkownika skype dzięki odpowiednio zmanipulowanemu klientowi skype jesteśmy w stanie poznać zarówno zewnętrzne jak i wewnętrzne ip dowolnej osoby po wykryciu luki powstała strona ipfindertk która całą pracę wykonywała za nas oczywiście strona została już zamknięta jednak można pobrać skrypty napisane przez twórce w w witryny w pythonie znajdujące się na githubie  które pozwalają na samodzielne działanie zerodaypl skype ip ',0);
INSERT INTO `search_dataset` VALUES (6,'node',' anonimowi atakuja rządową strone putina hakerzy z grupy anonymous zaatakowali strony rządowe w celu poparcia opozycji hakerzy zamieścili na youtube filmik w którym informują że rosyjska strona rządowa będzie poddana atakom ddos 6 maja a 7 maja stanie się to samo ze stroną premiera następnie hakerzy napisali instrukcje dla każdego kto chciałby się dołączyć do ataku putin wygrał w marcu wybory prezydenckie na 6 lat pomimo fali protestu opozycji która twierdzi iż miało miejsce oszustko wyborcze na wielką skalę anonimowy żądają aby władze były bardziej stanowcze w walce z korupcją oraz są przeciwni ruchu ograniczającemu wolność w internecie film znajdziemy tu zerodaypl anonimowi anonymous ddos ',0);
INSERT INTO `search_dataset` VALUES (7,'node',' 55000 haseł twittera wyciekło na pastebinie zostało opublikowane 55  loginów i haseł do kont na twitterze zostały one opublikowane na 6 osobnych wklejkach okoliczności w jakich hasła zostały wykradzione nie są znane twitter twierdzi że podjął już odpowiednie kroki aby chronić użytkowników zerodaypl twitter hasła login ',0);
INSERT INTO `search_dataset` VALUES (8,'node',' strona north las vegas police department nlvpd zhakowana oficjalna strona nlvpd  http wwwjoinnlvpdcom   została zablokowana przez grupę zhc blackone haxor zcompany hacking crew zhc jako przyczynę ataku hakerzy wskazują ataki na pakistan w centralnej części strony umieścili napis stop nato attacks on pakistan zhc jest pakistańską grupą hakerów która już po raz 2 zablokowała stronę policji z las vegas zerodaypl zhc nlvpd hakerzy ',0);
INSERT INTO `search_dataset` VALUES (9,'node',' pirate pay blokuje torrenty pirate pay otrzymało od microsoftu rok temu 100 tyś dolarów na rozwój firmy pirate pay chwali się że ich pomysł blokowania stron okazał się bardzo skuteczny i zablokował dziesiątki tysięcy transferów pomysł pirate pay powstał trzy lata temu podczas prac nad systemem zarządzania ruchem sieciowym dla operatorów internetowych okazało się że technologię można wykorzystać do atakowania sieci torrent i jeśli okazałaby się skuteczna będzie sporo warta dokładnego mechanizmu nie ujawniono ale podejrzewa się że serwery pirate pay udają klienckie końcówki torrentowe i łącząc się z innymi użytkownikami zalewają ich komputery fałszywymi danymi zerodaypl pirate pay microsoft torrent ',0);
INSERT INTO `search_dataset` VALUES (10,'node',' domena najwyższego poziomu secure firma artemis należąca do ncc group przedstawiła propozycję rejestracji domeny secure cały pomysł polega na tym aby utworzyć przestrzeń dla usług w których bezpieczeństwo jest najważniejszym priorytetem każdy z serwerów umieszczonych w domenie secure będzie musiał posiadać wymuszać i wspierać połączenia https tls ssl podpisywać strefy dns dnssec wspierać dkim i tls dla protokołu smtp przejść przez proces ręcznej weryfikacji autentyczności przy rejestracji przejść regularne skany pod kątem obecności malware u phishingu według autorów ich pomysł rozwiązuje problem cybersquattingu oraz phishingu zerodaypl domena secure artemis ',0);
INSERT INTO `search_dataset` VALUES (11,'node',' nvidia geforce grid chmura przyspiesza nvidia zapowiada sprzętowe rozwiązanie polepszające jakość gry procesory geforce grid mają znacznie zredukować opóźnienia na linii serwer klient dzięki czemu nasza rozgrywka stanie się bardzo płynna oferta skierowana jest do dostawców treści z chmury nvidia geforce grid ponoć zapewnia wrażenia zbliżone do konsol tzn że używanie przycisków na kontrolerze praktycznie natychmiast przekłada się na to co obserwujemy na ekranie czy w dobie gdy mówi się o ograniczeniach przepustowości taki projekt będzie mieć sens czas pokaże zerodaypl nvidia grid chmura ',0);
INSERT INTO `search_dataset` VALUES (12,'node',' 7 polskich stron rządowych bezpieczna według raportu rządowego certu za pierwszy kwartał 2012 aż 7 serwisów z domeny govpl ma poziom bezpieczeństwa na poziomie tylko akceptowalnym nieakceptowalny poziom ma 18 stron z domeny govpl z raportu certu wynika także że 15 polskich instytucji rządowych ma plan awaryjny na wypadek ataków internetowych cert dodaje wśród podatności o wysokim lub bardzo wysokim poziomie zagrożenia przeważają błędy typu cross site scripting oraz blind sql injection sql injection istotnym problemem jest również wykorzystywanie w serwerach produkcyjnych nieaktualnych wersji oprogramowania wykryte podatności mające znaczący wpływ na bezpieczeństwo witryn administracji państwowej o bardzo wysokim lub wysokim poziomie zagrożeń w takiej ilości świadczą o utrzymującym się w dalszym ciągu nieakceptowanym poziomie bezpieczeństwa systemów teleinformatycznych mających połączenie z internetem  zerodaypl cert govpl ',0);
INSERT INTO `search_dataset` VALUES (13,'node',' oficjalna strona eurowizji 2012 zhakowana grupa hakerów nazywających siebie cyberwarriors for freedom zaatakowała w czwartek oficjalną stronę internetową konkursu eurowizji 2012 która odbywa się w azejberdżanie domagali się aby odwołać odbywające się w przyszłym tygodniu konkurs finał imprezy został zaplanowany na 26 maja azejberdżan wygrał prawo do organizacji konkursu wygrywając zeszłoroczną imprezę rok temu w niemczach jest to okazja do zaprezentowania kraju na świecie którą kraj chciał wykorzystać zerodaypl eurowizja azejberdżan cyberwarriors for freedom ',0);
INSERT INTO `search_dataset` VALUES (14,'node',' trojan w patch u call of duty człowiek odpowiedzialny rozpowszechniał trojana pod postacią patach a został skazany na półtora roku więzienia lewys martin dwudziestolatek mieszkający w deal w hrabstwie kent używał złośliwego oprogramowania do zbierania informacji o danych logowania w banku danych kart kredytowych i haseł internetowych zerodaypl call of duty malware trojan ',0);
INSERT INTO `search_dataset` VALUES (15,'node',' strony liberalnej partii quebec i ministerstwa edukacji wyłączone dwie rządowe strony usa liberalnej parti quebec i ministerstwa edukacji zostały wyłączone wcześnie rano w sobotę do ataku nie przyznała się żadna organizacja ale na twitterze aż wrzało na temat kim mogli być potencjalni hakerzy kłopoty pojawiły się zaraz po wprowadzeniu nowej ustawy bill 78 która przeszła na zgromadzeniu narodowym anonimowi hakerzy grozili że zamkną stronę należącą do zgromadzenia narodowego grupa oświadczyła że reguła 78 musi umrzeć rzecznik liberalnej partii quebecu powiedział że witryna została zhakowana takie ataki są dość powszechne powiedział michel rochette mówiąc dalej byliśmy kolejnymi ofiarami cyberataków w ciągu ostatnich kilku tygodni  zerodaypl bill 78 government websites ',0);
INSERT INTO `search_dataset` VALUES (16,'node',' płać albo giń jak donosi forum wht wiele polskich firm zostało zaszantażowany ubiegłej nocy że mają 2 opcje albo zapłacą 25btc miesiąc za ochronę przed ddosem albo zostaną zaatakowani większość firm dostała emaila następującej treści witam reprezentuję grupę osób która wspólnie od kilku lat zaangażowana jest w tworzenie jednej z większych sieci botnet o zasięgu globalnym obecnie posiadmy na całym świecie spore zasoby systemowe do naszej dyspozycji wam jako firmie hostingowej nie muszę tłumaczyć co możemy zrobić mając do dyspozycji taki potencjał jednym ze sposobów w jaki pieniężymy naszą pracę jest wszelkiego rodzaju ddos od małych stron po duże korporacje jak ktoś płaci to dla nas nie ma problemu żeby puścić ddos na serwer i go rozłożyć do tej pory odmawialiśmy klientom chcącym atakować strony utrzymywane przez polskie firmy hostingowe taki mały patriotyzm i sentyment jako że ostatnio otrzymujemy coraz więcej ofert dotyczących ddosu między innymi na serwery utrzymywane przez was to postanowiliśmy zmienić naszą politykę botnet został stworzony żeby zarabiał pieniądze więc nie możemy dłużej odmawiać klientom polacy chyba wreszcie odkryli że można ddos zakupić i teraz to wykorzystują do niszczenia konkurencji w związku z tym postanowiliśmy zrezygnować z ochrony polskich firm hostingowych i chętnym firmom oferujemy abonament za kwotę 25 btc miesięcznie macie od nas spokój przy obecnym kursie to są dla was grosze my gwarantujemy że z naszej strony nie będą następować żadne ataki trzeba tylko przesłać nam listę pulę adresów ip które do was należą nie jest to potrzebne jeżeli macie ustawione revdnsy we własnej domenie można również zapłacić za pół roku 150 btc lub za cały rok z góry 300btc zawsze przesyłamy przypomnienia o kończącym się abonamencie próbkę naszych możliwości postanowiliśmy przedstawić dzisiaj na przykładzie jednej z czołowych firm tutaj znajduje się komunikat w tej sprawie  http komunikatynazwapl 20120521 oficjalnykomunikatwsprawieawarii  powiedzieli że nie chcą naszego abonamentu i woleli straszyć policja bitch please d dzisiaj już zmienili zdanie tylko że stawkę mają większą dużo większą no ale teraz możemy żądać więcej bo już wiedzą że i tak się nie obronią było nie zaczynać tylko przyjąć od razu nasze warunki swoją drogą to byliśmy zszokowani że tak szybko polegli bo mieliśmy jeszcze spory zapas jeżeli nie są państwo zainteresowani współpracą to oczywiście nie ma problemu będziemy wtedy przyjmować zlecenia poszczególnych ataków na serwery bo chcemy zarabiać na tym co stworzyliśmy proszę nie brać tego osobiście dla nas to zwykły biznes kwotę już i tak daliśmy mega niską jest to cena promocyjna obowiązująca tylko teraz później ceny będą już dużo wyższe minimum dziesięciokrotnie a doskonale wiemy że się odezwiecie jak będziecie codziennie walczyć z atakami hmm tylko jak tu walczyć wyciąć cały internet współczuję branży strona nie działa raptem przez kilka minut i już telefony z pretensjami od klientów znam to doskonale z czasów gdy pracowałem w jednej z takich firm atak ddos przez cały dzień roboczy i klienci już pewnie szukają nowej firmy hostingowej bo nie mają jak pracować bez poczty i dostępu do swojej strony internetowej klienci nie rozumieją że to jest niezależne od hostingu oni winią firmę hostingową i przenoszą się gdzie indziej proszę się zastanowić czy warto ryzykować utratę klientów dla tych kilku groszy oczywiście nic nie stoi na przeszkodzie żeby państwo również korzystali z naszych usług w polsce zalecamy ataki w godzinach 923 jest wtedy największy ruch na stronach i najbardziej się ludzie wkurzają gdy strony nie działają można w ten sposób nieźle zaszkodzić konkurencji już sporo polskich firm hostingowych zakupiło abonament więc może być z tym ciężko ale proszę pytać to damy znać czy jest możliwe zaatakowanie danego serwera jeśli tak to potrzebujemy jedynie adres ip i patrzymy jak serwer przestaje odpowiadać tylko małe firemki sądzą na początku że nie potrzebują naszego abonamentu a potem wracają na kolanach i muszą płacić więcej prosimy o odpowiedź maksymalnie do końca tego tygodnia czy są państwo zainteresowani współpracą bo jeśli nie to nie będziemy już dalej zwodzić klientów i po prostu przyjmiemy przesłane zlecenia brak odpowiedzi również uznajemy za rezygnację z naszych usług w razie zainteresowania prześlemy wam adres bitcoin na który należy dokonać opłaty pozdrawiamy niektóre firmy zapowiedziały że skierują sprawę na policję zobaczymy co przyniesie przyszłość zerodaypl hosting ddos ',0);
INSERT INTO `search_dataset` VALUES (17,'node',' flame najbardziej zaawansowany robak na świecie  flame bo tak nazywa się nowo odkryty robak przez firmę kaspersky lab został nazwany najbardziej zaawansowanym robakiem na świecie przebijając dobrze nam znane stuxnet oraz duqu co jest w nim tak nadzwyczajnego pierwsza rzucająca się rzecz to rozmiar flame waży 20mb znajdziemy w nim paczki modułów wirtualną maszynę dla języka skryptowego lua i biblioteki umożliwiające kompresję i operacje na bazach danych logika napisana została w lua ma ponad 3 tysiące linii kodu moduły napisano w c dochodzą do tego zagnieżdżone zapytania sql kompresja szyfrowanie skrypty windows management instrumentation i inne robak został tak skonstruowany aby wykradać dane na wiele sposobów potrafi włączyć mikrofon bez wiedzy użytkownika i nagrywać rozmowy odbywające się w otoczeniu zbiera także informacje urządzeniach bluetooth znajdujących się w pobliżu znaleziono go na komputerach w libanie iranie izraelu sudanie syrii arabii saudyjskiej oraz egipcie na świecie mogą być tysiące zarażonych komputerów do tej pory żadna organizacja ani państwo nie przyznało się do wypuszczenia robaka zerodaypl flame robak stuxnet duqu ',0);
INSERT INTO `search_dataset` VALUES (18,'node',' certyfikat ssl złamany irańska grupa hakerów o pseudonimie cyber warriors team poinformowała o udanym złamaniu zabezpieczeń certyfikatu ssl uzyskali oni dostęp do informacji o osobach współpracujących z agencją certyfikat ten należy do nasa całego przedsięwzięcia dokonano dzięki wykrytym luką w systemie logowania na stronie nasa które odkryto przy pomocy specjalnego skanera protokołu https to już kolejny udany atak na nasa w połowie lutego 2012 hakerzy z grup r00tw00rm i inj3ct0r zaatakowali serwery agencji na skutek ataku wyciekło 6 gb danych identyfikatory emaile oraz hasła użytkowników zerodaypl nasa ssl certyfikat ',0);
INSERT INTO `search_dataset` VALUES (19,'node',' używasz pirackiego oprogramowania  według raportu opublikowanego przez business software alliance bsa wynika że ponad połowa komputerów na świecie korzystała z pirackiego oprogramowania w badaniu wzięło udział 14700 komputerów z 33 krajów z całego świata głównie rozwijających się do wykorzystywania nielegalnego oprogramowania przyznało się 57 użytkowników rok wcześniej odsetek ten wynosił 42 bsa szacuje że producenci oprogramowania ponieśli w roku poprzednim straty na poziomie 634 miliarda dolarów największy odsetek piractwa zanotowano co zresztą nie powinno dziwić w chinach pełen raport odnajdziemy na oficjalnej stronie zerodaypl bsa raport oprogramowanie ',0);
INSERT INTO `search_dataset` VALUES (20,'node',' za stuxnetem stoją usa i izrael pewien interesujący artykuł możemy znaleźć w new york times który opisuje wywiady z bliskimi współpracownikami prezydenta usa barack a obamy w którym odnajdziemy informacje o tym iż to sam prezydent wydał nakaz ataku komputerowego na iran tym sposobem stworzono stuxneta autorem artykułu jest david sanger według przeprowadzonych przez niego wywiadów to usa wespół z izraelem stworzyły stuxneta jego zadaniem było włamanie się do irańskiej elektrowni i sparaliżowanie jej pracy powodem stworzenia stuxnet a było opóźnienie iranu w pracach nad bronią nuklearną oraz uniknięcie ataku zbrojnego izraela na iran zerodaypl stuxnet usa izrael ',0);
INSERT INTO `search_dataset` VALUES (21,'node',' captcha googla złamana jak się okazało mechanizm zabezpieczający captcha który należy do google można było złamać ze skutecznością sięgającą 99 narzędzie służące do łamania pokazano na konferencji layerone na chwilę obecną sposób ten już jest nieskuteczny ponieważ google wprowadziło zmiany w mechanizimie captachy na godzinę przed oficjalną prezentacją tego rozwiązania captcha została złamana poprzez analizę dźwięku zerodaypl captcha google ',0);
INSERT INTO `search_dataset` VALUES (22,'node',' rozrusznik serca na celowniku hakerów  wydaje się nie ma żadnych urządzeń które byłyby bezpieczne przed atakiem hakerów na dłużej od bankomatów samochodów smartfonów do urządzeń medycznych choć może to brzmieć co najmniej dziwnie poważne badania i eksperymenty wykazały że implanty medyczne takie jak rozruszniki serca pompy insulinowe są podatne na cyberataki które mogą stanowić zagrożenie dla życia ich użytkowników zgodnie z ustaleniami opublikowanymi w gazecie rozruszniki i defibrylatory serca urządzenia wszczepiane do wnętrza ludzkiego ciała wykorzystują wbudowane komputery i bezprzewodowe radio narażając osobę na atak hakera urządzenia te korzystają z wbudowanych komputerów do monitorowania np chorób przewlekłych zerodaypl rozrusznika serca defibrylator cyberatak ',0);
INSERT INTO `search_dataset` VALUES (23,'node',' 6 czerwca ipv6 day jutro tj 6 czerwca 2012 będzie dniem włączenia na całym świecie protokołu internetowego następnej generacji jak nazwał ipv6 google w swoim blogu rok temu nastąpił test zakończony sukcesem w którym wzięło udział ponad 400 firm i organizacji po tej akcji wybrano termin wprowadzenia nowego protokołu 06062012r jak zapewnia internet society która sponsoruje dzień ipv6 większość ludzi i firm nie odczuje żadnego wpływu przesiadki na nowy protokół dzięki temu zostanie wykonany kolejny krok naprzód dla internetu który jest na skraju wyczerpania obecnego protokołu ipv4 zerodaypl ipv6 protokół ',0);
INSERT INTO `search_dataset` VALUES (24,'node',' 65 miliona hashy haseł z linkedin ujawnionych dwa dni temu na rosyjskim forum opublikowano 65 miliona hashy haseł które prawdopodobnie mogą należeć do użytkowników korzystających z serwisu linkedin po złamaniu wielu tysięcy haseł bardzo często pojawiała się fraza linkedin co może sugerować że pochodzą one właśnie z tego serwisu w którym znajduje się ok 150 milionów cv w polsce również linkedin cienko przędzie jego odpowiednik goldenlinepl miał spore kłopoty wchodząc na serwis po każdym kliknięciu byliśmy zalogowani jako inne osoby przez taki błąd tj krzyżowanie się sesji możliwe było podglądanie kont oraz wiadomości innych użytkowników z powodu tego błędu część użytkowników dostała pustego emaila zerodaypl linkedin goldenline ',0);
INSERT INTO `search_dataset` VALUES (25,'node',' gogle ostrzega użytkowników gmaila przed sponsorowanymi atakami google rozpoczęło dziś ostrzeganie użytkowników gmaila ponieważ jak twierdzą są podejrzenia by twierdzić że mogą być celami sponsorowanymi przez państwo ataków to już drugi alert w ciągu ostatnich 2 tygodni takie ostrzeżenie dostała tylko pewna grupa osób widoczne było ono górze panelu google można zapytać skąd wiemy że ta działalność jest sponsorowana przez państwo powiedział eric grosse wiceprezes google ds bezpieczeństwa we wtorek na blogu dodał nie możemy zagłębiać się w szczegóły które byłyby pomocne dla tych złych aktorów  hitborg google gmail ',0);
INSERT INTO `search_dataset` VALUES (26,'node',' anonymous polują na pedofilów na twitterze grupa anonimowych jest w trakcie kampanii mającej na celu zdemaskowanie podejrzanych pedofilów działających na twitterze którzy nękają i polują na małoletnie dzieci operacja twitterpedoring została rozpoczęta przedwczoraj tj 4 czerwca a już są rzuty danych setek kont na twitterze podejrzanych o pedofilię na pastbin osoba podająca się za anonimowego napisała to jest lista pedofilów którą twitter nie uznał za ważną aby usunąć ich konta mimo ich powiązań ze sobą ujawniamy te dane mając nadzieję że twitter będzie współpracował z lea aby złapać i zatrzymać tych drani  hitborg anonymous twitter ',0);
/*!40000 ALTER TABLE `search_dataset` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

