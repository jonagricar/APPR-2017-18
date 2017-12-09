# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

# Funkcija, ki uvozi občine iz Ski-DB - 1.tabela
uvozi.smucarje1 <- function() {
  link <- "http://www.ski-db.com/worldcup.php"
  stran <- html_session(link) %>% read_html()
  tabela1 <- stran %>% html_nodes(xpath="//table[@class='primary']") %>%
    .[[4]] %>% html_table(dec = ",", fill = TRUE)
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  tabela1 <- tabela1[ , c(1:4, 7:9, 11:12)]
  tabela1 <- tabela1[2:52, ]
  colnames(tabela1) <- c("sezona", "moški zmagovalec", "točke M", "starost ob zmagi M", "ženska zmagovalka",
                        "točke Ž", "starost ob zmagi Ž", "država", "točke")
  tabela1$država[tabela1$država == "Austria"] <- "Avstrija"
  tabela1$država[tabela1$država == "Switzerland"] <- "Švica"
  tabela1$država[tabela1$država == "France"] <- "Francija"
  
  return(tabela)
}

# Funkcija, ki uvozi smučarje iz Wikipedije - 2.tabela
uvozi.smucarje2 <- function() {
  link <- "https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup"
  stran <- html_session(link) %>% read_html()
  tabela2 <- stran %>% html_nodes(xpath="//table[@class='wikitable plainrowheaders']") %>%
    .[[1]] %>% html_table(dec = ",", fill = TRUE)
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  tabela2 <- tabela2[ , c(1, 3, 5, 6:7)]
  tabela2 <- tabela2[2:52, ]
  colnames(tabela2) <- c("sezona", "moški zmagovalec", "narodnost_M", "ženska zmagovalka", "narodnost_Ž")
  tabela2[1, 1] <- "1966/67"
  tabela2[2, 1] <- "1967/68"
  tabela2$narodnost_M[tabela2$narodnost_M == "Austria"] <- "Avstrija"
  tabela2$narodnost_M[tabela2$narodnost_M == "Switzerland"] <- "Švica"
  tabela2$narodnost_M[tabela2$narodnost_M == "France"] <- "Francija"
  tabela2$narodnost_M[tabela2$narodnost_M == "Italy"] <- "Italija"
  tabela2$narodnost_M[tabela2$narodnost_M == "United States"] <- "ZDA"
  tabela2$narodnost_M[tabela2$narodnost_M == "Liechtenstein"] <- "Lihtenštajn"
  tabela2$narodnost_M[tabela2$narodnost_M == "Sweden"] <- "Švedska"
  tabela2$narodnost_M[tabela2$narodnost_M == "Luxembourg"] <- "Luksemburg"
  tabela2$narodnost_M[tabela2$narodnost_M == "Norway"] <- "Norveška"
  tabela2$narodnost_M[tabela2$narodnost_M == "Croatia"] <- "Hrvaška"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Germany"] <- "Nemčija"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Slovenia"] <- "Slovenija"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Canada"] <- "Kanada"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "West Germany"] <- "Zahodna Nemčija"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Austria"] <- "Avstrija"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "France"] <- "Francija"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Italy"] <- "Italija"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "United States"] <- "ZDA"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Liechtenstein"] <- "Lihtenštajn"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Sweden"] <- "Švedska"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Croatia"] <- "Hrvaška"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Slovenia"] <- "Slovenija"
  tabela2$narodnost_Ž[tabela2$narodnost_Ž == "Switzerland"] <- "Švica"
  
  return(tabela)
}

# Funkcija, ki uvozi občine iz Wikipedije
uvozi.obcine <- function() {
  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec = ",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    tabela[[col]] <- parse_number(tabela[[col]], na = "-", locale = sl)
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}

# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
