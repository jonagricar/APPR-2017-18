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
  row.names(tabela1) <- nrow(tabela1):1
  
  return(tabela1)
}

smucarji1 <- tabela1[ , c(1:4)]
smucarke1 <- tabela1[ , c(1, 5:7)]
smucarji2 <- tabela2[ , c(1:3)]
smucarke2 <- tabela2[ , c(1, 4:5)]


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
  row.names(tabela2) <- 1:nrow(tabela2)
  
  return(tabela2)
}

# Funkcija, ki uvozi rezultate po disciplinah M iz Wikipedije - 3.tabela
uvozi.discipline1 <- function() {
  link <- "https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup"
  stran <- html_session(link) %>% read_html()
  tabela3 <- stran %>% html_nodes(xpath="//table[@class='wikitable plainrowheaders']") %>%
    .[[6]] %>% html_table(dec = ",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela3) <- c("DISCIPLINA", "SMUČAR/-KA", "DRŽAVA", "ŠTEVILO NASLOVOV")
  tabela3[2, 2] <- "Hermann Maier / Aksel Lund Svindal"
  tabela3[2, 3] <- "Avstrija / Norveška"
  tabela3$SPOL <- "M"
  tabela3 <- tabela3[ , c("DISCIPLINA", "SPOL", "SMUČAR/-KA", "DRŽAVA", "ŠTEVILO NASLOVOV")]
  
  return(tabela3)
}

# Funkcija, ki uvozi rezultate po disciplinah Ž iz Wikipedije - 4.tabela
uvozi.discipline2 <- function() {
  link <- "https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup"
  stran <- html_session(link) %>% read_html()
  tabela4 <- stran %>% html_nodes(xpath="//table[@class='wikitable plainrowheaders']") %>%
    .[[7]] %>% html_table(dec = ",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela4) <- c("DISCIPLINA", "SMUČAR/-KA", "DRŽAVA", "ŠTEVILO NASLOVOV")
  tabela4[5, 2] <- "Brigitte Örtli / Janica Kostelić"
  tabela4[5, 3] <- "Švica / Hrvaška"
  tabela4[2, 2] <- "Katja Seizinger / Lindsey Vonn"
  tabela4[2, 3] <- "Nemčija / ZDA"
  tabela4$SPOL <- "Ž"
  tabela4 <- tabela4[ , c("DISCIPLINA", "SPOL", "SMUČAR/-KA", "DRŽAVA", "ŠTEVILO NASLOVOV")]
  
  return(tabela4)
}

# Funkcija, ki združi 3. in 4. tabelo v DISCIPLINE
discipline_naslovi <- rbind(tabela3, tabela4)
discipline_naslovi$DISCIPLINA[discipline_naslovi$DISCIPLINA == "Downhill"] <- "Smuk"
discipline_naslovi$DISCIPLINA[discipline_naslovi$DISCIPLINA == "Super-G"] <- "Superveleslalom"
discipline_naslovi$DISCIPLINA[discipline_naslovi$DISCIPLINA == "Giant Slalom"] <- "Veleslalom"
discipline_naslovi$DISCIPLINA[discipline_naslovi$DISCIPLINA == "Combined"] <- "Kombinacija"
discipline_naslovi <- discipline_naslovi[c("1", "6", "2", "7", "3", "8", "4", "9", "5", "10"), ]
discipline_naslovi$DRŽAVA[discipline_naslovi$DRŽAVA == "Austria"] <- "Avstrija"
discipline_naslovi$DRŽAVA[discipline_naslovi$DRŽAVA == "Switzerland"] <- "Švica"
discipline_naslovi$DRŽAVA[discipline_naslovi$DRŽAVA == "United States"] <- "ZDA"
discipline_naslovi$DRŽAVA[discipline_naslovi$DRŽAVA == "Sweden"] <- "Švedska"
discipline_naslovi$DRŽAVA[discipline_naslovi$DRŽAVA == "Norway"] <- "Norveška"


# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
