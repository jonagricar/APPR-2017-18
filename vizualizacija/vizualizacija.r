# 3. faza: Vizualizacija podatkov

#GRAFI
graf1 <- ggplot(narodi1.slo, aes(x = drzava, y = zmage, fill = spol)) +
  geom_bar(stat = "identity") +
  xlab("Država") + ylab("Število zmag") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), 
        panel.grid.major = element_line(linetype = "dotted"), 
        panel.grid.minor = element_line(linetype = "dotted")) +
  ggtitle("Število zmag po državah glede na spol")
print(graf1)

graf2 <- ggplot(zmagovalci.slo, aes(x = sezona, y = tocke, color = spol)) +
  geom_line(size = 1) +
  geom_point(size = 1.5) +
  xlab("Sezona") + ylab("Število točk") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), 
        panel.grid.major = element_line(linetype = "dotted"), 
        panel.grid.minor = element_line(linetype = "dotted")) + 
  ggtitle("Število točk zmagovalcev na sezono glede na spol")
print(graf2)

graf3 <- ggplot(zmagovalci.slo, aes(x = sezona, y = starost, color = spol)) +
  geom_line(size = 1) +
  geom_point(size = 1.5) +
  xlab("Sezona") + ylab("Starost ob zmagi") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), 
        panel.grid.major = element_line(linetype = "dotted"), 
        panel.grid.minor = element_line(linetype = "dotted")) + 
  ggtitle("Starost zmagovalcev glede na spol")
print(graf3)

graf4 <- ggplot(discipline.slo, aes(x = disciplina, y = naslovi, fill = spol)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Disciplina") + ylab("Število naslovov") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), 
        panel.grid.major = element_line(linetype = "dotted"), 
        panel.grid.minor = element_line(linetype = "dotted")) +
  ggtitle("Število naslovov po disciplinah glede na spol")
print(graf4)


# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(CONTINENT %in% c("Europe", "North America"))


zem.zmagovalci <- ggplot() + geom_polygon(data = zmagovalci %>% group_by(narodnost) %>%
                                            summarise(stevilo = n()) %>%
                                            right_join(zemljevid, by = c("narodnost" = "NAME_LONG")),
                                          aes(x = long, y = lat, group = group, fill = stevilo)) +
  coord_cartesian(xlim = c(-80, 22), ylim = c(37, 70))

zemljevid1 <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", encoding = "UTF-8")

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje = sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
