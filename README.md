# Analiza podatkov s programom R, 2017/18

Avtor: Jona Gričar

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Tematika

Za temo projekta sem si izbrala svetovni pokal v alpskem smučanju, saj ta šport spremljam že od malih nog in bi ga rada predstavila ter približala tudi ostalim. Podatke sem pridobila iz dveh spletnih strani:
* https://en.wikipedia.org/wiki/FIS_Alpine_Ski_World_Cup
* http://www.ski-db.com/worldcup.php

V prvi tabeli bom zajela skupne zmagovalce svetovnega pokala glede na spol in sezono(vrstice, od sezone 1966/1967 do danes); vsak/-a smučar/-ka pa bo imel/-a tudi podatek o tem, koliko točk je dosegel/-la v zmagovalni sezoni, starost ob pridobitvi naslova ter narodnost.

V drugi tabeli bom hierarhično predstavila naslove smučarjev in smučark glede na disiplino ali drugače rečeno: prvih nekaj večkratnih dobitnikov malih globusov v vseh 5 disciplinah. Pri vsakem športniku bo še podatek o narodnosti in številu osvojenih malih globusov v določeni disciplini.

V tretji tabeli pa bodo zbrani skupni rezultati svetovnega pokala po državah (vrstice), v stolpcih pa bo prikazano skupno število zmag glede na spol in disciplino. Ker nekatere države ne obstajajo več in tabela predstavlja vse države, katere športniki so kadarkoli zmagali v svetovnem pokalu, bosta v tej skupni tabeli navadeni obe državi, "stara" in "nova".

Zadnja tabela bo pokazala, v katerih državah so potekale tekme svetovnega pokala doslej in iz tega bom potem naredila tudi zemljevid.

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
