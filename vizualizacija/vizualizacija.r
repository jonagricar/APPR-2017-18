# 3. faza: Vizualizacija podatkov

#GRAFI
graf1 <- ggplot(narodi1.slo, aes(x = drzava, y = zmage, fill = spol)) +
  geom_bar(stat = "identity") +
  xlab("Država") + ylab("Število zmag") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), 
        panel.grid.major = element_line(linetype = "dotted"), 
        panel.grid.minor = element_line(linetype = "dotted")) +
  ggtitle("Število zmag po državah glede na spol")

graf2 <- ggplot(zmagovalci.slo, aes(x = sezona, y = tocke, color = spol)) +
  geom_line(size = 1) +
  geom_point(size = 1.5) +
  xlab("Sezona") + ylab("Število točk") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), 
        panel.grid.major = element_line(linetype = "dotted"), 
        panel.grid.minor = element_line(linetype = "dotted")) + 
  ggtitle("Število točk zmagovalcev na sezono glede na spol")

graf3 <- ggplot(zmagovalci.slo, aes(x = sezona, y = starost, color = spol)) +
  geom_line(size = 1) +
  geom_point(size = 1.5) +
  xlab("Sezona") + ylab("Starost ob zmagi") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), 
        panel.grid.major = element_line(linetype = "dotted"), 
        panel.grid.minor = element_line(linetype = "dotted")) + 
  ggtitle("Starost zmagovalcev glede na spol")

graf4 <- ggplot(discipline.slo, aes(x = disciplina, y = naslovi, fill = spol)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Disciplina") + ylab("Število naslovov") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), 
        panel.grid.major = element_line(linetype = "dotted"), 
        panel.grid.minor = element_line(linetype = "dotted")) +
  ggtitle("Število naslovov po disciplinah glede na spol")


# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(CONTINENT %in% c("Europe", "North America"))


zem.zmagovalci <- ggplot() + geom_polygon(data = zmagovalci %>% group_by(narodnost) %>%
                                            summarise(stevilo = n()) %>%
                                            right_join(zemljevid, by = c("narodnost" = "NAME_LONG")),
                                          aes(x = long, y = lat, group = group, fill = stevilo)) +
  ggtitle("Število zmagovalcev svetovnega pokala") +
  coord_cartesian(xlim = c(-80, 22), ylim = c(37, 70))

svet <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(lat > -60)

zem.prizorisca <- ggplot() +
  geom_polygon(data = prizorisca1.eng %>% group_by(drzava) %>% summarise(stevilo = n()) %>%
                 right_join(svet, by = c("drzava" = "NAME_LONG")),
               aes(x = long, y = lat, group = group, fill = stevilo)) +
  ggtitle("Prizorišča tekem svetovnega pokala")

delez <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                         "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(REGION_WB %in% c("Europe & Central Asia","Middle East & North Africa"))

zem.bdp <- ggplot() +
  geom_polygon(data = bdp %>% filter(leto == 2015) %>%
                 right_join(delez, by = c("drzava" = "NAME_LONG")),
               aes(x = long, y = lat, group = group, fill = delez)) +
  coord_cartesian(xlim = c(-22, 34), ylim = c(34, 70)) +
  ggtitle("Zemljevid deleža bdp za področje športa leta 2015")
