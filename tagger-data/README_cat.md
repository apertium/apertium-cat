[In English](README.md)

# Corpus per a l'entrenament del tagger

Aquesta carpeta conté els corpus necessaris per a entrenar el tagger estadístic. Estan agrupats en dues carpetes, `tagged` i `crp`.

## tagged

Corpus per a l'[entrenament supervisat](https://wiki.apertium.org/wiki/Supervised_tagger_training). Els fitxers han de tenir l'extensió `.tagged` i a cada línia hi ha d'haver una unitat lèxica d'Apertium desambiguada, en [format de flux d'Apertium](https://wiki.apertium.org/wiki/Apertium_stream_format). Per exemple:

```
^Un/Un<det><ind><m><sg>$
^centenar/centenar<n><m><sg>$
^de/de<pr>$
^famílies/família<n><f><pl>$
^reclamen/reclamar<vblex><pri><p3><pl>$
^indemnitzacions/indemnització<n><f><pl>$
^./.<sent>$
```

Abans de l'entrenament, els fitxers de la carpeta es combinen en el fitxer `cat.tagged`.

## crp

Corpus per a l'[entrenament no supervisat](https://wiki.apertium.org/wiki/Unsupervised_tagger_training). Els fitxers han de tenir l'extensió `.txt` i han de contenir text **sense format**.

Abans de l'entrenament, els fitxers de la carpeta es combinen en el fitxer `cat.crp.txt`.
