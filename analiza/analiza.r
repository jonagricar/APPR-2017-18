# 4. faza: Analiza podatkov

delez <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                         "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(REGION_WB %in% c("Europe & Central Asia","Middle East & North Africa"))

zem.bdp <- ggplot() +
  geom_polygon(data = bdp %>% filter(leto == 2015) %>%
                 right_join(delez, by = c("drzava" = "NAME_LONG")),
               aes(x = long, y = lat, group = group, fill = delez)) +
  coord_cartesian(xlim = c(-22, 34), ylim = c(34, 70)) +
  ggtitle("Zemljevid deleža bdp za področje športa leta 2015")
