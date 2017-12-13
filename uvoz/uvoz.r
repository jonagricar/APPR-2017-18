# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

# Funkcija, ki uvozi občine iz Ski-DB - 1.tabela
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
  tabela2 <- tabela2[ , c(1, 3, 5, 6:7)]
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
  "West Germany" = "Zahodna Nemčija",
  "Slovenia" = "Slovenija",
  "Canada" = "Kanada"
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

# Funkcija, ki združi 3. in 4. tabelo v DISCIPLINE
discipline <- rbind(tabela3, tabela4) %>%
  select(disciplina, spol, smucar, narodnost, naslovi) %>% arrange(disciplina, spol)
discipline$disciplina[discipline$disciplina == "Downhill"] <- "Smuk"
discipline$disciplina[discipline$disciplina == "Super-G"] <- "Superveleslalom"
discipline$disciplina[discipline$disciplina == "Giant Slalom"] <- "Veleslalom"
discipline$disciplina[discipline$disciplina == "Combined"] <- "Kombinacija"
discipline$narodnost[discipline$narodnost == "Austria"] <- "Avstrija"
discipline$narodnost[discipline$narodnost == "Switzerland"] <- "Švica"
discipline$narodnost[discipline$narodnost == "United States"] <- "ZDA"
discipline$narodnost[discipline$narodnost == "Sweden"] <- "Švedska"
discipline$narodnost[discipline$narodnost == "Norway"] <- "Norveška"


# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
