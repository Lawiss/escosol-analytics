---
title: Escosol - Analyse statistique
---

Analyses basées sur le fichier manuellement annoté par Mélinda.
L'ensemble des parcs disponibles dans le fichier est affiché dans le tableau ci-dessous :
```parcs
  select
      *
  from escosol.parcs
```

Pour faciliter le travail d'analyse, avoir l'ensemble des données sur un même fichier est plus pratique. De plus ça aide à éviter les noms de colonnes qui peuvent légèrement différé ou des valeurs de colonnes qui ne respectent pas une nomenclature commune (par exemple "OUI"/"Oui"/"oui").

<DataTable data={parcs} />

## Localisation des parcs

```parcs_filtered_for_map
  select
      *
  from escosol.parcs
  where "Longitude" is not null and "Latitude" is not null
```

<PointMap 
    data={parcs_filtered_for_map} 
    lat='Latitude' 
    long='Longitude' 
    pointName="Commune"
    value='Usage initial'  
    height=500
    size=7
    tooltip={[
        {id: 'commune_label', showColumnName: false, valueClass: 'text-xl font-semibold'},
        {id: 'Surface cloturée', title: 'Surface du parc :', fmt: '#,##0 "ha"'},
        {id: 'Puissance', title: 'Puissance installée :', fmt: '#,##0 "MWc"'},
        {id: 'Usage initial', title: 'Usage initial des sols :'},
        {id: 'Demande de dérogation espèces protégées', title: 'Demande de dérogation espèces protégées :'},
        {id: `Autorisation loi sur l'eau`, title: `Autorisation loi sur l'eau :`},
        {id: 'Autorisation de défrichement', title: 'Autorisation de défrichement :'},
        {id: 'Surface défrichée', title: 'Surface défrichée :'}
    ]}
    colorPalette={['#C65D47', '#5BAF7A', '#4A8EBA', '#D35B85', '#E1C16D', '#6F5B9A', '#147538', '#115759']}
    basemap={`https://tile.openstreetmap.org/{z}/{x}/{y}.png`}
    attribution='© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
/>

# Statistiques sur l'ensemble des données

```stats_global
SELECT 
  count(*) as nombre_parcs,
  sum("Surface Cloturée") as total_surface,
  sum("Puissance") as total_puissance,
  mean("Raccordement") as moyenne_distance_raccordement,
  sum("Surface Défrichée") as total_surface_defrichee,
  count(*) filter (where "Demande De Dérogation Espèces Protégées"='oui') as total_demande_derog_espro,
  count(*) filter (where "Autorisation De Défrichement"='oui') as total_autorisation_defrichement,
  count(*) filter (where "Autorisation Loi Sur L'eau"='oui') as total_autorisation_eau
FROM escosol.parcs
```


<BigValue 
  data={stats_global} 
  value=nombre_parcs
  title="Nombre de parcs au total",
  minWidth=3O%
/>
<BigValue 
  data={stats_global} 
  value=total_surface
  title="Surface totale occupée",
  minWidth=30%,
  fmt='#,##0 "ha"'
/>
<BigValue 
  data={stats_global} 
  value=total_puissance
  title="Puissance totale installée",
  minWidth=30%,
  fmt='#,##0 "MWc"'
/>

Parmi ces projets :
- **<Value data={stats_global} column=total_demande_derog_espro />** ont demandé une **dérogation "Espèces Protégées"** ;
- **<Value data={stats_global} column=total_autorisation_defrichement />** ont demandé une **autorisation de défrichement** ;
- **<Value data={stats_global} column=total_autorisation_eau />** ont demandé une **dérogation au titre de la loi sur l'eau**.
