
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
DROP TABLE IF EXISTS `field_revision_body`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `field_revision_body` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `body_value` longtext,
  `body_summary` longtext,
  `body_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `body_format` (`body_format`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 2 (body)';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `field_revision_body` WRITE;
/*!40000 ALTER TABLE `field_revision_body` DISABLE KEYS */;
INSERT INTO `field_revision_body` VALUES ('node','news',0,1,1,'und',0,'Osoby podające się za członków Anonymous stają na przeciw gigantom muzycznym. Ich celem jest utworzenie serwisu dzięki któremu będziemy mogli słuchać muzyki za darmo. Strona demonstracyjna jest dostępna pod adresem http://anontune.com/demo/. Odbywałoby się to na zasadzie przeszukiwania wszystkich innych serwisów muzycznych i udostępnienie wyników w jednym miejscu. Dzięki temu serwis nie łamałby prawa, ponieważ nie udostępnia bezpośrednio plików, a wykorzystuje pośrednie strony. Jak na razie projekt ukończony został w jakiś 20%. Czekamy zatem na odpowiedź innych wytwórni, bo zapewne wywoła to niemałe zamieszanie w świecie muzycznym.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,2,2,'und',0,'W piątek wieczorem grupie Anonimowych hakerów udało się zablokować stronę Formuły 1. Atak na stronę zbiegł się w czasie z demonstracją odbywającą się na autostradzie do Manamy, stolicy Bahrajnu. Podczas, gdy strona została zablokowana wyświetlał się napis Formula None i adnotacja dlaczego Grand Prix Bahrajnu nie powinno się odbywać.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,3,3,'und',0,'Serwery WWW z interpreterami PHP są zagrożone. Czasem parametry URL mogą zostać przekazane do PHP i zinterpretowane jako argumenty linii poleceń. Jeżeli dodanie parametru “?-s” do dowolnego adresu URL spowoduje pojawienie się kodu źródłowego PHP tzn, że  nasz serwer jest zagrożony. Luka została wyeliminowana w aktualizacjach do wersji PHP 5.3.12 i 5.4.2\r\n\r\nAutorzy odkrycia piszą, że atak pozwala na bezpośrednie wstrzyknięcie i uruchomienie wrogiego kodu, co może pociągnąć za sobą katastrofalne skutki. Powyższa dziura dotyczy serwerów z PHP pracujących w trybie CGI, instalacje FastCGI PHP nie są podatne na ten atak.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,4,4,'und',0,'Dzięki programowi IGPRS (ang. Ivan Golubev\'s Password Recovery Suite) można łamać hasła do backupów z telefonów Apple, BlackBerry oraz wolumenów TrueCrypta i sieci Wi-Fi. Dzięki IGPRS złamiemy:\r\n\r\n    - hasła do backupów iOS 4.x i 5.x\r\n    - hasła do backupów BlackBerry 5.x i 6.x\r\n    - hasła do wolumenów TrueCrypt\r\n    - handshake do sieci WPA/WPA2\r\n\r\nIGPRS korzysta z instrukcji optymalizujących dla procesorów, dzięki czemu jest wydajniejszy niż inne tego typu programy. IGPRS wspiera procesory GPU takie jak od ATI HD4xxx do HD7xxx oraz od NVIDIA GT8600 do GTX590.\r\n\r\nProgram można ściągnąć z <a href=\"http://www.golubev.com/igprs/\">tej</a> strony','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,5,5,'und',0,'Odkryta luka w oprogramowaniu, która ujrzała światło dzienne pozwala na uzyskanie dowolnego adresu IP użytkownika Skype. Dzięki odpowiednio zmanipulowanemu klientowi Skype jesteśmy w stanie poznać zarówno zewnętrzne jak i wewnętrzne IP dowolnej osoby.\r\n\r\nPo wykryciu luki powstała strona ip-finder.tk, która całą pracę wykonywała za nas. Oczywiście strona została już zamknięta. Jednak można pobrać skrypty napisane przez twórce w/w witryny w Pythonie znajdujące się na <a href=\"https://github.com/zhovner/Skype-iplookup\">Githubie</a>, które pozwalają na samodzielne działanie.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,6,6,'und',0,'Hakerzy z grupy Anonymous zaatakowali strony rządowe w celu poparcia opozycji. Hakerzy zamieścili na YouTube filmik w którym informują, że rosyjska strona rządowa będzie poddana atakom DDOS 6 maja, a 7 maja stanie się to samo ze stroną premiera.\r\n\r\nNastępnie hakerzy napisali instrukcje dla każdego, kto chciałby się dołączyć do ataku. Putin wygrał w marcu wybory prezydenckie na 6 lat, pomimo fali protestu opozycji, która twierdzi, iż miało miejsce oszustko wyborcze na wielką skalę.\r\n\r\nAnonimowy żądają, aby władze były bardziej stanowcze w walce z korupcją oraz są przeciwni ruchu ograniczającemu wolność w internecie.\r\n\r\nFilm znajdziemy <a href=\"http://www.youtube.com/watch?feature=player_embedded&v=s-MZ-xQjIwE\">tu.</a>','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,7,7,'und',0,'Na Pastebinie zostało opublikowane 55 000 loginów i haseł do kont na Twitterze. Zostały one opublikowane na 6 osobnych wklejkach. Okoliczności w jakich hasła zostały wykradzione nie są znane. \r\n\r\nTwitter twierdzi, że podjął już odpowiednie kroki, aby chronić użytkowników.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,8,8,'und',0,'Oficjalna strona NLVPD (http://www.joinnlvpd.com/) została zablokowana przez grupę ZHC BlackOne HaXor - ZCompany Hacking Crew - [ZHC]\r\n\r\nJako przyczynę ataku hakerzy wskazują ataki na Pakistan. W centralnej części strony umieścili napis: \"Stop Nato Attacks on Pakistan!\"\r\n\r\nZHC jest Pakistańską grupą hakerów, która już po raz 2 zablokowała stronę policji z Las Vegas','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,9,9,'und',0,'Pirate Pay otrzymało od Microsoftu rok temu 100 tyś. dolarów na rozwój firmy. Pirate Pay chwali się, że ich pomysł blokowania stron okazał się bardzo skuteczny i zablokował dziesiątki tysięcy transferów.\r\n\r\nPomysł Pirate Pay powstał trzy lata temu podczas prac nad systemem zarządzania ruchem sieciowym dla operatorów internetowych. Okazało się, że technologię można wykorzystać do atakowania sieci torrent i jeśli okazałaby się skuteczna, będzie sporo warta. \r\n\r\nDokładnego mechanizmu nie ujawniono, ale podejrzewa się, że serwery Pirate Pay udają klienckie końcówki torrentowe i łącząc się z innymi użytkownikami zalewają ich komputery fałszywymi danymi.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,10,10,'und',0,'Firma Artemis należąca do NCC Group przedstawiła propozycję rejestracji domeny .secure. Cały pomysł polega na tym, aby utworzyć przestrzeń dla usług w których bezpieczeństwo jest najważniejszym priorytetem.\r\n\r\nKażdy z serwerów umieszczonych w domenie .secure będzie musiał posiadać:\r\n\r\n*wymuszać i wspierać połączenia HTTPS (TLS/SSL)\r\n*podpisywać strefy DNS (DNSSEC)\r\n*wspierać DKIM i TLS dla protokołu SMTP\r\n*przejść przez proces ręcznej weryfikacji autentyczności (przy rejestracji)\r\n*przejść regularne skany pod kątem obecności malware’u/phishingu\r\n\r\nWedług autorów ich pomysł rozwiązuje problem cybersquattingu oraz phishingu.\r\n','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,11,11,'und',0,'NVIDIA zapowiada sprzętowe rozwiązanie, polepszające jakość gry. Procesory GeForce GRID mają znacznie zredukować opóźnienia na linii serwer — klient, dzięki czemu nasza rozgrywka stanie się bardzo płynna.\r\n\r\nOferta skierowana jest do dostawców treści z chmury. NVIDIA GeForce GRID ponoć zapewnia wrażenia zbliżone do konsol tzn, że używanie przycisków na kontrolerze praktycznie natychmiast przekłada się na to co obserwujemy na ekranie.\r\n\r\nCzy w dobie, gdy mówi się o ograniczeniach przepustowości taki projekt będzie mieć sens? Czas pokaże.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,12,12,'und',0,'Według raportu rządowego CERT-u za pierwszy kwartał 2012, aż 7% serwisów z domeny gov.pl ma poziom bezpieczeństwa na poziomie TYLKO akceptowalnym. Nieakceptowalny poziom ma 18% stron z domeny gov.pl\r\nZ raportu CERT-u wynika także, że 1/5 polskich instytucji rządowych ma plan “awaryjny” na wypadek ataków internetowych. CERT dodaje:\r\n\r\n\"Wśród podatności o wysokim lub bardzo wysokim poziomie zagrożenia przeważają błędy typu Cross Site Scripting oraz Blind SQL Injection/SQL Injection. Istotnym problemem jest również wykorzystywanie w serwerach produkcyjnych nieaktualnych wersji oprogramowania. Wykryte podatności mające znaczący wpływ na bezpieczeństwo witryn administracji państwowej o bardzo wysokim lub wysokim poziomie zagrożeń w takiej ilości, świadczą o utrzymującym się w dalszym ciągu nieakceptowanym poziomie bezpieczeństwa systemów teleinformatycznych mających połączenie z Internetem.\"','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,13,13,'und',0,'Grupa hakerów nazywających siebie \"Cyberwarriors for Freedom\" zaatakowała w czwartek oficjalną stronę internetową konkursu Eurowizji 2012, która odbywa się w Azejberdżanie. Domagali się, aby odwołać odbywające się w przyszłym tygodniu konkurs. Finał imprezy został zaplanowany na 26 maja.\r\n\r\nAzejberdżan wygrał prawo do organizacji konkursu , wygrywając zeszłoroczną imprezę rok temu w Niemczach. Jest to okazja do zaprezentowania kraju na świecie, którą kraj chciał wykorzystać.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,14,14,'und',0,'Człowiek odpowiedzialny rozpowszechniał trojana pod postacią patach\'a został skazany na półtora roku więzienia.\r\n\r\nLewys Martin, dwudziestolatek, mieszkający w Deal w hrabstwie Kent,używał złośliwego oprogramowania do zbierania informacji o danych logowania w banku, danych kart kredytowych i haseł internetowych.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,15,15,'und',0,'Dwie rządowe strony USA Liberalnej Parti Quebec i Ministerstwa Edukacji zostały wyłączone wcześnie rano w sobotę. Do ataku nie przyznała się żadna organizacja, ale na Twitterze, aż wrzało na temat kim mogli być potencjalni hakerzy. \r\n\r\nKłopoty pojawiły się zaraz po wprowadzeniu nowej ustawy \"Bill 78\", która przeszła na Zgromadzeniu Narodowym.\r\nAnonimowi hakerzy grozili, że zamkną stronę należącą do Zgromadzenia Narodowego. Grupa oświadczyła, że ​​\"Reguła 78 musi umrzeć\".\r\n\r\nRzecznik Liberalnej Partii Quebecu powiedział, że witryna została zhakowana. \"Takie ataki, są dość powszechne\", powiedział Michel Rochette, mówiąc dalej \"Byliśmy kolejnymi ofiarami cyberataków w ciągu ostatnich kilku tygodni\".','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,16,16,'und',0,'Jak donosi forum WHT, wiele polskich firm zostało zaszantażowany ubiegłej nocy, że mają 2 opcje, albo zapłacą 25BTC/Miesiąc za ochronę przed DDoS-em, albo zostaną zaatakowani. Większość firm dostała emaila następującej treści:\r\n\r\n    Witam!\r\n\r\n    Reprezentuję grupę osób, która wspólnie od kilku lat zaangażowana jest\r\n    w tworzenie jednej z większych sieci botnet o zasięgu globalnym. Obecnie\r\n    posiadmy na całym świecie spore zasoby systemowe do naszej dyspozycji.\r\n    Wam, jako firmie hostingowej, nie muszę tłumaczyć co możemy zrobić mając\r\n    do dyspozycji taki potencjał￼ Jednym ze sposobów w jaki pieniężymy\r\n    naszą pracę jest wszelkiego rodzaju DDOS. Od małych stron, po duże\r\n    korporacje. Jak ktoś płaci, to dla nas nie ma problemu żeby puścić ddos\r\n    na serwer i go rozłożyć. Do tej pory odmawialiśmy klientom chcącym\r\n    atakować strony utrzymywane przez polskie firmy hostingowe (taki mały\r\n    patriotyzm i sentyment:)). Jako, że ostatnio otrzymujemy coraz więcej\r\n    ofert dotyczących ddosu między innymi na serwery utrzymywane przez Was,\r\n    to postanowiliśmy zmienić naszą politykę. Botnet został stworzony żeby\r\n    zarabiał pieniądze, więc nie możemy dłużej odmawiać klientom. Polacy\r\n    chyba wreszcie odkryli, że można ddos zakupić i teraz to wykorzystują do\r\n    niszczenia konkurencji:)\r\n\r\n    W związku z tym postanowiliśmy zrezygnować z ochrony polskich firm\r\n    hostingowych i chętnym firmom oferujemy abonament. Za kwotę 25 BTC\r\n    miesięcznie macie od nas spokój ( przy obecnym kursie, to są dla Was\r\n    grosze ). My gwarantujemy, że z naszej strony nie będą następować żadne\r\n    ataki ( trzeba tylko przesłać nam listę/pulę adresów IP, które do Was\r\n    należą – nie jest to potrzebne jeżeli macie ustawione revdnsy we własnej\r\n    domenie ). Można również zapłacić za pół roku ( 150 BTC ) lub za cały\r\n    rok z góry ( 300BTC ). Zawsze przesyłamy przypomnienia o kończącym się\r\n    abonamencie.\r\n\r\n    Próbkę naszych możliwości postanowiliśmy przedstawić dzisiaj na\r\n    przykładzie jednej z czołowych firm. Tutaj znajduje się komunikat w tej\r\n    sprawie:\r\n    http://komunikaty.nazwa.pl/2012/05/21/oficjalny-komunikat-w-sprawie-awarii/\r\n    Powiedzieli, że nie chcą naszego abonamentu i woleli straszyć\r\n    policja…bitch, please:D…dzisiaj już zmienili zdanie, tylko że stawkę\r\n    mają większą, dużo większą￼ No ale teraz możemy żądać więcej, bo już\r\n    wiedzą, że i tak się nie obronią…było nie zaczynać tylko przyjąć od\r\n    razu nasze warunki;)\r\n    Swoją drogą, to byliśmy zszokowani, że tak szybko polegli, bo mieliśmy\r\n    jeszcze spory zapas.\r\n\r\n    Jeżeli nie są Państwo zainteresowani współpracą, to oczywiście nie ma\r\n    problemu, będziemy wtedy przyjmować zlecenia poszczególnych ataków na\r\n    serwery, bo chcemy zarabiać na tym co stworzyliśmy:) Proszę nie brać\r\n    tego osobiście, dla nas to zwykły biznes. Kwotę już i tak daliśmy mega\r\n    niską. Jest to cena promocyjna obowiązująca tylko teraz. Później ceny\r\n    będą już dużo wyższe ( minimum dziesięciokrotnie ), a doskonale wiemy,\r\n    że się odezwiecie jak będziecie codziennie walczyć z atakami ( hmm tylko\r\n    jak tu walczyć? Wyciąć cały internet?￼ ).\r\n\r\n    Współczuję branży…strona nie działa raptem przez kilka minut i już\r\n    telefony z pretensjami od klientów:/ Znam to doskonale z czasów gdy\r\n    pracowałem w jednej z takich firm;) Atak DDOS przez cały dzień roboczy i\r\n    klienci już pewnie szukają nowej firmy hostingowej, bo nie mają jak\r\n    pracować bez poczty i dostępu do swojej strony internetowej. Klienci nie\r\n    rozumieją, że to jest niezależne od hostingu, oni winią firmę hostingową\r\n    i przenoszą się gdzie indziej. Proszę się zastanowić czy warto ryzykować\r\n    utratę klientów dla tych kilku groszy.\r\n\r\n    Oczywiście nic nie stoi na przeszkodzie żeby Państwo również korzystali\r\n    z naszych usług. W Polsce zalecamy ataki w godzinach 9-23. Jest wtedy\r\n    największy ruch na stronach i najbardziej się ludzie wkurzają gdy strony\r\n    nie działają￼ Można w ten sposób nieźle zaszkodzić konkurencji. Już\r\n    sporo polskich firm hostingowych zakupiło abonament, więc może być z tym\r\n    ciężko, ale proszę pytać to damy znać czy jest możliwe zaatakowanie\r\n    danego serwera. Jeśli tak, to potrzebujemy jedynie adres IP i patrzymy\r\n    jak serwer przestaje odpowiadać￼ Tylko małe firemki sądzą na początku,\r\n    że nie potrzebują naszego abonamentu, a potem wracają na kolanach i\r\n    muszą płacić więcej.\r\n\r\n    Prosimy o odpowiedź maksymalnie do końca tego tygodnia czy są Państwo\r\n    zainteresowani współpracą, bo jeśli nie, to nie będziemy już dalej\r\n    zwodzić klientów i po prostu przyjmiemy przesłane zlecenia. Brak\r\n    odpowiedzi również uznajemy za rezygnację z naszych usług.\r\n    W razie zainteresowania prześlemy Wam adres bitcoin, na który należy\r\n    dokonać opłaty.\r\n\r\n    Pozdrawiamy!\r\n\r\nNiektóre firmy zapowiedziały, że skierują sprawę na policję. Zobaczymy co przyniesie przyszłość.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,17,17,'und',0,'Flame, bo tak nazywa się nowo odkryty robak przez firmę Kaspersky Lab został nazwany najbardziej zaawansowanym robakiem na świecie, przebijając dobrze nam znane Stuxnet oraz Duqu. \r\n\r\nCo jest w nim tak nadzwyczajnego?\r\n\r\nPierwsza rzucająca się rzecz to rozmiar. Flame waży 20MB. Znajdziemy w nim paczki modułów, wirtualną maszynę dla języka skryptowego Lua i biblioteki umożliwiające kompresję i operacje na bazach danych. Logika napisana została w Lua ma ponad 3 tysiące linii kodu, moduły napisano w C, dochodzą do tego zagnieżdżone zapytania SQL, kompresja, szyfrowanie, skrypty Windows Management Instrumentation i inne.\r\n\r\nRobak został tak skonstruowany, aby wykradać dane na wiele sposobów. Potrafi włączyć mikrofon bez wiedzy użytkownika i nagrywać rozmowy odbywające się w otoczeniu, zbiera także informacje urządzeniach Bluetooth znajdujących się w pobliżu. \r\n\r\nZnaleziono go na komputerach w Libanie, Iranie, Izraelu, Sudanie, Syrii, Arabii Saudyjskiej oraz Egipcie. Na świecie mogą być tysiące zarażonych komputerów. Do tej pory żadna organizacja, ani państwo nie przyznało się do wypuszczenia robaka.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,18,18,'und',0,'Irańska grupa hakerów o pseudonimie \"Cyber Warriors Team\" poinformowała o udanym złamaniu zabezpieczeń certyfikatu SSL. Uzyskali oni dostęp do informacji o osobach współpracujących z agencją (certyfikat ten należy do NASA).\r\n\r\nCałego przedsięwzięcia dokonano dzięki wykrytym luką w systemie logowania na stronie NASA, które odkryto przy pomocy specjalnego skanera protokołu HTTPS.\r\n\r\nTo już kolejny udany atak na NASA. W połowie lutego 2012 hakerzy z grup r00tw00rm i inj3ct0r zaatakowali serwery agencji, na skutek ataku wyciekło 6 GB danych - identyfikatory, e-maile oraz hasła użytkowników. ','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,19,19,'und',0,'Według raportu opublikowanego przez Business Software Alliance (BSA) wynika, że ponad połowa komputerów na świecie korzystała z pirackiego oprogramowania.\r\n\r\nW badaniu wzięło udział 14,700 komputerów z 33 krajów z całego świata, głównie rozwijających się. Do wykorzystywania nielegalnego oprogramowania przyznało się 57% użytkowników. Rok wcześniej odsetek ten wynosił 42%.\r\n\r\nBSA szacuje, że producenci oprogramowania ponieśli w roku poprzednim straty na poziomie 63,4 miliarda dolarów. Największy odsetek piractwa zanotowano, co zresztą nie powinno dziwić w Chinach.\r\n\r\nPełen raport odnajdziemy na oficjalnej <a href=\"http://portal.bsa.org/globalpiracy2011/\">stronie</a>','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,20,20,'und',0,'Pewien interesujący artykuł możemy znaleźć w New York Times, który opisuje wywiady z bliskimi współpracownikami prezydenta USA Barack\'a Obamy, w którym odnajdziemy informacje o tym, iż to sam prezydent wydał nakaz ataku komputerowego na Iran. Tym sposobem stworzono Stuxneta.\r\n\r\nAutorem artykułu jest David Sanger. Według przeprowadzonych przez niego wywiadów to USA wespół z Izraelem stworzyły Stuxneta. Jego zadaniem było włamanie się do Irańskiej elektrowni i sparaliżowanie jej pracy.\r\n\r\nPowodem stworzenia Stuxnet\'a było opóźnienie Iranu w pracach nad bronią nuklearną oraz uniknięcie ataku zbrojnego Izraela na Iran.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,21,21,'und',0,'Jak się okazało mechanizm zabezpieczający CAPTCHA, który należy do Google można było złamać ze skutecznością sięgającą 99% !!! Narzędzie służące do łamania pokazano na konferencji LayerOne.\r\n\r\nNa chwilę obecną sposób ten już jest nieskuteczny, ponieważ Google wprowadziło zmiany w mechanizimie CAPTACHY na godzinę przed oficjalną prezentacją tego rozwiązania.\r\n\r\nCAPTCHA została złamana poprzez analizę dźwięku.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,22,22,'und',0,'Wydaje się, nie ma żadnych urządzeń, które byłyby bezpieczne przed atakiem hakerów na dłużej - od bankomatów, samochodów, smartfonów do urządzeń medycznych. Choć może to brzmieć co najmniej dziwnie, poważne badania i eksperymenty wykazały, że implanty medyczne, takie jak - rozruszniki serca, pompy insulinowe są podatne na cyberataki, które mogą stanowić zagrożenie dla życia ich użytkowników.\r\n\r\nZgodnie z ustaleniami opublikowanymi w gazecie, rozruszniki i defibrylatory serca - urządzenia wszczepiane do wnętrza ludzkiego ciała - wykorzystują wbudowane komputery i bezprzewodowe radio narażając osobę na atak hakera. Urządzenia te korzystają z wbudowanych komputerów do monitorowania np. chorób przewlekłych.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,23,23,'und',0,'Jutro tj. 6 czerwca 2012 będzie dniem włączenia na całym świecie protokołu internetowego następnej generacji, jak nazwał IPv6 Google w swoim blogu.\r\n\r\nRok temu nastąpił test zakończony sukcesem, w którym wzięło udział ponad 400 firm i organizacji. Po tej akcji wybrano termin wprowadzenia nowego protokołu 06.06.2012r.\r\n\r\nJak zapewnia Internet Society, która sponsoruje \"Dzień IPv6\", większość ludzi i firm nie odczuje żadnego wpływu przesiadki na nowy protokół. Dzięki temu zostanie wykonany kolejny krok naprzód dla internetu, który jest na skraju wyczerpania obecnego protokołu IPv4.','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,24,24,'und',0,'Dwa dni temu na rosyjskim forum opublikowano 6,5 miliona hashy haseł, które prawdopodobnie mogą należeć do użytkowników korzystających z serwisu LinkedIn. \r\n\r\nPo złamaniu wielu tysięcy haseł bardzo często pojawiała się fraza \"LinkedIn\", co może sugerować, że pochodzą one właśnie z tego serwisu w którym znajduje się ok 150 milionów CV.\r\n\r\nW Polsce również LinkedIn cienko przędzie. Jego odpowiednik GoldenLine.pl miał spore kłopoty. Wchodząc na serwis po każdym kliknięciu byliśmy zalogowani jako inne osoby. Przez taki błąd tj. krzyżowanie się sesji możliwe było podglądanie kont oraz wiadomości innych użytkowników. Z powodu tego błędu część użytkowników dostała pustego emaila.\r\n','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,25,25,'und',0,'Google rozpoczęło dziś ostrzeganie użytkowników Gmaila, ponieważ jak twierdzą są podejrzenia by twierdzić, że mogą być celami \"sponsorowanymi przez państwo\" ataków.\r\n\r\nTo już drugi alert w ciągu ostatnich 2 tygodni. Takie ostrzeżenie dostała tylko pewna grupa osób, widoczne było ono górze panelu Google. \"Można zapytać, skąd wiemy, że ta działalność jest sponsorowana przez państwo?\", powiedział Eric Grosse, wiceprezes Google ds. bezpieczeństwa we wtorek na blogu. Dodał: \"nie możemy zagłębiać się w szczegóły, które byłyby pomocne dla tych \'złych aktorów\'\".','','filtered_html');
INSERT INTO `field_revision_body` VALUES ('node','news',0,26,26,'und',0,'Grupa \"Anonimowych\" jest w trakcie kampanii mającej na celu zdemaskowanie podejrzanych pedofilów działających na Twitterze, którzy nękają i polują na małoletnie dzieci.\r\n\r\nOperacja \"TwitterPedoRing\" została rozpoczęta przedwczoraj tj. 4 czerwca, a już są rzuty danych setek kont na Twitterze podejrzanych o pedofilię.\r\n\r\nNa Pastbin osoba podająca się za \"Anonimowego\" napisała: \"To jest lista pedofilów, którą Twitter nie uznał za ważną, aby usunąć ich konta mimo ich powiązań ze sobą. Ujawniamy te dane mając nadzieję, że Twitter będzie współpracował z LEA, aby złapać i zatrzymać tych drani\"','','filtered_html');
/*!40000 ALTER TABLE `field_revision_body` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

