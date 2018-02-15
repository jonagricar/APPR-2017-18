# Analiza podatkov s programom R, 2017/18

Avtor: Jona Gričar

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Analiza svetovnega pokala v alpskem smučanju

Za temo projekta sem si izbrala svetovni pokal v alpskem smučanju, saj ta šport spremljam že od malih nog in bi ga rada predstavila ter približala tudi ostalim. Podatke sem pridobila iz štirih spletnih strani - od tega eno tabelo kot CSV:
* https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup
* http://www.ski-db.com/worldcup.php
* http://www.ski-db.com/db/loc/main.php
* http://appsso.eurostat.ec.europa.eu/nui/show.do?query=BOOKMARK_DS-471197_QID_-361F748D_UID_-3F171EB0&layout=TIME%2CC%2CX%2C0%3BGEO%2CL%2CY%2C0%3BUNIT%2CL%2CZ%2C0%3BSECTOR%2CL%2CZ%2C1%3BCOFOG99%2CL%2CZ%2C2%3BNA_ITEM%2CL%2CZ%2C3%3BINDICATORS%2CC%2CZ%2C4%3B&zSelection=DS-471197INDICATORS%2COBS_FLAG%3BDS-471197UNIT%2CPC_TOT%3BDS-471197SECTOR%2CS13%3BDS-471197COFOG99%2CGF08%3BDS-471197NA_ITEM%2CTE%3B&rankName1=UNIT_1_2_-1_2&rankName2=SECTOR_1_2_-1_2&rankName3=INDICATORS_1_2_-1_2&rankName4=NA-ITEM_1_2_-1_2&rankName5=COFOG99_1_2_-1_2&rankName6=TIME_1_0_0_0&rankName7=GEO_1_2_0_1&sortC=ASC_-1_FIRST&rStp=&cStp=&rDCh=&cDCh=&rDM=true&cDM=true&footnes=false&empty=false&wai=false&time_mode=FIXED&time_most_recent=false&lang=en&cfo=%23%23%23%2C%23%23%23.%23%23%23%20

Projekt vsebuje 6 tabel in sicer (po stolpcih):

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

6.TABELA(bdp.slo) - izdatki države (delež BDP) za področje športa po državah
* leto
* drzava
* delez

Poleg tabel projekt vsebuje še 4 grafe in 3 zemljevide in sicer:
* graf1 - Število zmag po državah glede na spol
* graf2 - Število točk zmagovalcev na sezono glede na spol
* graf3 - Starost zmagovalcev glede na spol
* graf4 - Število naslovov po disciplinah glede na spol
* zem.zmagovalci - Število zmagovalcev svetovnega pokala
* zem.prizorisca - Prizorišča tekem svetovnega pokala
* zem.bdp - Delež bdp za področje športa leta 2015

Namen projekta je, da analiziram zmagovalce svetovnega pokala in sicer: katere države imajo največ zmagovalcev, spreminjanje skupnega seštevka, koliko so bili stari ob zmagah (da vidim, če starost vpliva na fizično pripravljenost). Poleg tega ob tem primerjam tudi razliko v uspešnosti med moškimi in ženskami. To pa se nadaljuje tudi glede malih globusov. Uspešnost države bom ugotovila iz tabele števila zmag in to spet pregledala glede na spol in ekipe. Na koncu pa še na splošno pogledam, kje se sploh odvijajo tekme in izluščim, kje je smučanje bolj popularno oziroma kje so primerni pogoji. S pomočjo tega in podatkov o izdatkih, namenjenih za šport bom pogledala, ali obstaja povezava med enim in drugim.

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
