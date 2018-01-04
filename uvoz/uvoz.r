# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

# Funkcija, ki uvozi smučarje iz Ski-DB - 1.tabela
uvozi.smucarje1 <- function() {
  link <- "http://www.ski-db.com/worldcup.php"
  stran <- html_session(link) %>% read_html()
  tabela1 <- stran %>% html_nodes(xpath="//table[@class='primary']") %>%
    .[[4]] %>% html_table(dec = ",", fill = TRUE)
  for (i in 1:ncol(tabela1)) {
    if (is.character(tabela1[[i]])) {
      Encoding(tabela1[[i]]) <- "UTF-8"
    }
  }
  tabela1 <- tabela1[ , c(1:4, 7:9, 11:12)]
  tabela1 <- tabela1[2:52, ]
  colnames(tabela1) <- c("sezona", "moski zmagovalec", "tocke M", "starost ob zmagi M", "zenska zmagovalka",
                        "tocke Z", "starost ob zmagi Z", "drzava", "tocke")
  row.names(tabela1) <- nrow(tabela1):1
  
  return(tabela1)
}


# Funkcija, ki uvozi smučarje iz Wikipedije - 2.tabela
uvozi.smucarje2 <- function() {
  link <- "https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup"
  stran <- html_session(link) %>% read_html()
  tabela2 <- stran %>% html_nodes(xpath="//table[@class='wikitable plainrowheaders']") %>%
    .[[1]] %>% html_table(dec = ",", fill = TRUE)
  for (i in 1:ncol(tabela2)) {
    if (is.character(tabela2[[i]])) {
      Encoding(tabela2[[i]]) <- "UTF-8"
    }
  }
  tabela2 <- tabela2[ , c(1, 3:4, 6:7)]
  tabela2 <- tabela2[2:52, ]
  colnames(tabela2) <- c("sezona", "moski zmagovalec", "narodnost_M", "zenska zmagovalka", "narodnost_Z")
  tabela2[1, 1] <- "1966/67"
  tabela2[2, 1] <- "1967/68"
  row.names(tabela2) <- 1:nrow(tabela2)
  
  return(tabela2)
}


tabela1 <- uvozi.smucarje1()
tabela2 <- uvozi.smucarje2()
smucarji1 <- tabela1[ , c(1:4)]
smucarke1 <- tabela1[ , c(1, 5:7)]
smucarji2 <- tabela2[ , c(1:3)]
smucarke2 <- tabela2[ , c(1, 4:5)]
colnames(smucarke1) <- colnames(smucarji1) <- c("sezona", "priimek", "tocke", "starost")
colnames(smucarke2) <- colnames(smucarji2) <- c("sezona", "zmagovalec", "narodnost")
spoli <- c("M", "Z")
smucarji <- inner_join(smucarji1, smucarji2) %>% mutate(spol = factor("M", levels = spoli))
smucarke <- inner_join(smucarke1, smucarke2) %>% mutate(spol = factor("Z", levels = spoli))
zmagovalci <- rbind(smucarji, smucarke) %>%
  select(sezona, spol, zmagovalec, narodnost, tocke, starost) %>% arrange(sezona, spol)

zmagovalci <- zmagovalci %>% mutate(sezona = sezona %>% parse_number(),
                                    tocke = tocke %>% parse_number(),
                                    starost = starost %>% parse_number(),
                                    zmagovalec = zmagovalec %>% strapplyc("^([^(]+)") %>%
                                      unlist() %>% trimws())

drzave.slo <- c(
  "Austria" = "Avstrija",
  "Switzerland" = "Švica",
  "France" = "Francija",
  "Italy" = "Italija",
  "United States" = "ZDA",
  "Liechtenstein" = "Lihtenštajn",
  "Sweden" = "Švedska",
  "Luxembourg" = "Luksemburg",
  "Norway" = "Norveška",
  "Croatia" = "Hrvaška",
  "Germany" = "Nemčija",
  "West Germany" = "Nemčija",
  "Slovenia" = "Slovenija",
  "Canada" = "Kanada",
  "Australia" = "Avstralija",
  "Bulgaria" = "Bolgarija",
  "Soviet Union" = "Sovjetska zveza",
  "Poland" = "Poljska",
  "Czechoslovakia" = "Češkoslovaška",
  "Spain" = "Španija",
  "Finland" = "Finska",
  "New Zealand" = "Nova Zelandija",
  "Russia" = "Rusija",
  "Slovakia" = "Slovaška",
  "Czech Republic" = "Češka"
)

zmagovalci.slo <- zmagovalci %>% mutate(narodnost = drzave.slo[narodnost])



# Funkcija, ki uvozi rezultate po disciplinah M iz Wikipedije - 3.tabela
uvozi.discipline1 <- function() {
  link <- "https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup"
  stran <- html_session(link) %>% read_html()
  tabela3 <- stran %>% html_nodes(xpath="//table[@class='wikitable plainrowheaders']") %>%
    .[[6]] %>% html_table(dec = ",")
  for (i in 1:ncol(tabela3)) {
    if (is.character(tabela3[[i]])) {
      Encoding(tabela3[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela3) <- c("disciplina", "smucar", "narodnost", "naslovi")
  tabela3$spol <- "M"
  
  return(tabela3)
}

# Funkcija, ki uvozi rezultate po disciplinah Ž iz Wikipedije - 4.tabela
uvozi.discipline2 <- function() {
  link <- "https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup"
  stran <- html_session(link) %>% read_html()
  tabela4 <- stran %>% html_nodes(xpath="//table[@class='wikitable plainrowheaders']") %>%
    .[[7]] %>% html_table(dec = ",")
  for (i in 1:ncol(tabela4)) {
    if (is.character(tabela4[[i]])) {
      Encoding(tabela4[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela4) <- c("disciplina", "smucar", "narodnost", "naslovi")
  tabela4$spol <- "Z"
  
  return(tabela4)
}

tabela3 <- uvozi.discipline1()
tabela4 <- uvozi.discipline2()

#ZDRUŽENA TABELA DISCIPLINE
discipline <- rbind(tabela3, tabela4) %>%
  select(disciplina, spol, smucar, narodnost, naslovi) %>% arrange(disciplina, spol)
discipline$disciplina[discipline$disciplina == "Downhill"] <- "Smuk"
discipline$disciplina[discipline$disciplina == "Super-G"] <- "Superveleslalom"
discipline$disciplina[discipline$disciplina == "Giant Slalom"] <- "Veleslalom"
discipline$disciplina[discipline$disciplina == "Combined"] <- "Kombinacija"

dvojni <- grep("[[:lower:]][[:upper:]]", discipline$smucar)
discipline <- apply(discipline[dvojni, ], 1, . %>% as.list() %>%
{ data.frame(disciplina = .$disciplina, spol = .$spol,
             smucar = .$smucar %>%
               strapplyc("(.*[[:lower:]])([[:upper:]].*)") %>% unlist(),
             narodnost = .$narodnost %>%
               strapplyc("([[:alnum:] ]+)[^[:alnum:] ]+([[:alnum:] ]+)") %>%
               unlist(), naslovi = .$naslovi,
             stringsAsFactors = FALSE) }) %>%
  bind_rows() %>% rbind(discipline[-dvojni, ]) %>% arrange(disciplina, spol)
discipline <- discipline %>% mutate(naslovi = naslovi %>% parse_number())

discipline.slo <- discipline %>% mutate(narodnost = drzave.slo[narodnost])

#UVOZIMO ZAČETNO TABELO ZA NARODE
uvozi.narode <- function() {
  link <- "https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup"
  stran <- html_session(link) %>% read_html()
  narodi <- stran %>% html_nodes(xpath="//table[@class='wikitable plainrowheaders']") %>%
    .[[50]] %>% html_table(dec = ",", fill = TRUE)
  for (i in 1:ncol(narodi)) {
    if (is.character(narodi[[i]])) {
      Encoding(narodi[[i]]) <- "UTF-8"
    }
  }
  narodi <- narodi[c(-1, -2, -27), c(1:6)]
  row.names(narodi) <- 1:nrow(narodi)
  narodi[19, 1] <- "18"
  narodi[21, 1] <- narodi[22, 1] <- "20"
  narodi[23, 1] <- "23"
  colnames(narodi) <- c("rang", "drzava", "moski", "zenske", "ekipno", "zmage")
  
  return(narodi)
}

narodi <- uvozi.narode()
narodi <- narodi %>% mutate(rang = rang %>% parse_number())

narodi1 <- narodi[ , c(1:2, 6)]
narodi1.slo <- narodi1 %>% mutate(drzava = drzave.slo[drzava])


narodi2 <- narodi %>% select(-rang, -zmage) %>% melt(id.vars = "drzava", variable.name = "spol",
                                                     value.name = "zmage") %>%
  mutate(zmage = parse_number(zmage, na = "–")) %>% drop_na(zmage) %>%
  arrange(drzava, spol)
narodi2.slo <- narodi2 %>% mutate(drzava = drzave.slo[drzava])


#UVOZIMO ZAČETNO TABELO ZA PRIZORIŠČA
uvozi.prizorisce <- function() {
  link <- "http://www.ski-db.com/db/loc/main.php"
  stran <- html_session(link) %>% read_html()
  html_tabela <- stran %>% html_nodes(xpath="//table[@class='primary']") %>% .[[1]]
  prizorisca <- html_tabela %>% html_table(dec = ",", fill = TRUE) %>% .[-1, ]
  prizorisca[[3]] <- html_tabela %>% html_nodes(xpath=".//img") %>% html_attr("src") %>%
    strapplyc("([a-z]+)_2\\.gif$") %>% unlist()
  for (i in 1:ncol(prizorisca)) {
    if (is.character(prizorisca[[i]])) {
      Encoding(prizorisca[[i]]) <- "UTF-8"
    }
  }
  prizorisca <- prizorisca[, 1:5]
  colnames(prizorisca) <- c("prizorisce", "kratica", "drzava", "moski", "zenske")
  prizorisca <- prizorisca %>% mutate(moski = parse_number(moski),
                                      zenske = parse_number(zenske)) %>%
    filter(!is.na(moski) | !is.na(zenske))
  return(prizorisca)
}

prizorisca <- uvozi.prizorisce()

kratice.slo <- c(
  "aut" = "Avstrija",
  "sui" = "Švica",
  "fra" = "Francija",
  "ita" = "Italija",
  "usa" = "ZDA",
  "swe" = "Švedska",
  "nor" = "Norveška",
  "cro" = "Hrvaška",
  "ger" = "Nemčija",
  "and" = "Andora",
  "slo" = "Slovenija",
  "can" = "Kanada",
  "aus" = "Avstralija",
  "bul" = "Bolgarija",
  "pol" = "Poljska",
  "bih" = "Bosna in Hercegovina",
  "spa" = "Španija",
  "rus" = "Rusija",
  "svk" = "Slovaška",
  "cze" = "Češka",
  "kor" = "Južna Koreja",
  "jpn" = "Japonska",
  "arg" = "Argentina",
  "nze" = "Nova Zelandija",
  "fin" = "Finska"
)

prizorisca1 <- prizorisca[ , c(1:3)]
prizorisca1.slo <- prizorisca1 %>% mutate(drzava = kratice.slo[drzava])

prizorisca2 <- prizorisca %>% select(kratica, moski, zenske) %>%
  melt(variable.name = "spol", value.name = "tekme", na.rm = TRUE) %>%
  arrange(kratica, spol)


# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
