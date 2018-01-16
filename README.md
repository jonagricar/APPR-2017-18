# Analiza podatkov s programom R, 2017/18

Avtor: Jona Gričar

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Tematika

Za temo projekta sem si izbrala svetovni pokal v alpskem smučanju, saj ta šport spremljam že od malih nog in bi ga rada predstavila ter približala tudi ostalim. Podatke sem pridobila iz dveh spletnih strani:
* https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup
* http://www.ski-db.com/worldcup.php

Projekt vsebuje 5 tabel in sicer(po stolpcih):

1.TABELA(zmagovalci.slo) - zmagovalci od leta 1966 do leta 2016:
* sezona
* spol
* zmagovalec
* spol
* narodnost
* točke
* starost

2.TABELA(discipline.slo) - smučarji z največ malimi globusi po disciplinah
* disciplina
* spol
* smučar
* narodnost
* naslovi

3.TABELA(narodi1.slo) - število zmag posamezne države
* država
* spol
* zmage

4.TABELA(prizorisca1.slo) - prizorišča svetovnega pokala
* prizorišče
* kratica
* država

5.TABELA(prizorisca2) - število tekem na posameznem prizorišču
* kratica
* spol
* tekme

Poleg tabel projekt vsebuje še 4 grafe in 2 zemljevida in sicer:
* graf1 - Število zmag po državah glede na spol
* graf2 - Število točk zmagovalcev na sezono glede na spol
* graf3 - Starost zmagovalcev glede na spol
* graf4 - Število naslovov po disciplinah glede na spol
* zem.zmagovalci - Število zmagovalcev svetovnega pokala
* zem.prizorisca - Prizorišča tekem svetovnega pokala

Namen projekta je, da analiziram zmagovalce svetovnega pokala in sicer: katere države imajo največ zmagovalcev, spreminjanje skupnega seštevka, koliko so bili stari ob zmagah(da vidim, če starost vpliva na fizično pripravljenost). Poleg tega ob tem primerjam tudi razliko v uspešnosti med moškimi in ženskami. To pa se nadaljuje tudi glede malih globusov. Uspešnost države bom ugotovila iz tabele števila zmag in to spet pregledala glede na spol in ekipe. Na koncu pa še na splošno pogledam kje se sploh odvijajo tekme in izluščim kje je smučanje bolj popularno oziroma kje so primerni pogoji.

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
