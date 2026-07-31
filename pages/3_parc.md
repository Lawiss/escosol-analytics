---
title: Statistiques au niveau d'un parc
---

```commune_values
SELECT 
    distinct commune_label
from escosol.parcs
    
```

Sélectionner votre commune :
<Dropdown 
    data={commune_values} 
    name=commune_selector 
    value=commune_label 
    title="Commune :" 
/>




```parcs_filtered_for_map
  select
      *,
      coalesce("Usage initial",'Usage inconnu') as "Usage initial du sol"
  from escosol.parcs
  where "Longitude" is not null and "Latitude" is not null
  and commune_label='${inputs.commune_selector.value}'
  ORDER BY "Usage initial"
```

<PointMap 
    data={parcs_filtered_for_map} 
    lat='Latitude' 
    long='Longitude' 
    pointName="Commune"
    value="Usage initial du sol"  
    height=500
    size=10
    tooltip={[
        {id: 'commune_label', showColumnName: false, valueClass: 'text-xl font-semibold'},
        {id: 'Surface cloturée', title: 'Surface du parc :', fmt: '#,##0 "ha"'},
        {id: 'Puissance', title: 'Puissance installée :', fmt: '#,##0 "MWc"'},
        {id: 'usage_clean', title: 'Usage initial des sols :'},
        {id: 'Demande de dérogation espèces protégées', title: 'Demande de dérogation espèces protégées :'},
        {id: `Autorisation loi sur l'eau`, title: `Autorisation loi sur l'eau :`},
        {id: 'Autorisation de défrichement', title: 'Autorisation de défrichement :'},
        {id: 'Surface défrichée', title: 'Surface défrichée :'}
    ]}
    colorPalette={['#C65D47', '#5BAF7A', '#4A8EBA', '#D35B85', '#E1C16D', '#6F5B9A', '#147538', '#115759']}
    basemap={`https://tile.openstreetmap.org/{z}/{x}/{y}.png`}
    attribution='© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
 
/>

Dans la commune de **{inputs.commune_selector.value}** :

```stats_global_commune
SELECT 
  count(*) as nombre_parcs,
  sum("Surface Cloturée") as total_surface,
  100-100*count("Surface Cloturée")::numeric/count(*) as ratio_missing_surface,
  sum("Puissance") as total_puissance,
  100-100*count("Puissance")::numeric/count(*) as ratio_missing_puissance,
  mean("Raccordement") as moyenne_distance_raccordement,
  100-100*count("Raccordement")::numeric/count(*) as ratio_missing_raccordement,
  sum("Surface Défrichée") as total_surface_defrichee,
  count(*) filter (where "Demande De Dérogation Espèces Protégées"='oui') as total_demande_derog_espro,
  count(*) filter (where "Autorisation De Défrichement"='oui') as total_autorisation_defrichement,
  count(*) filter (where "Autorisation Loi Sur L'eau"='oui') as total_autorisation_eau
FROM escosol.parcs
where commune_label='${inputs.commune_selector.value}'
```

<BigValue 
  data={stats_global_commune} 
  value=total_surface
  title="Surface totale occupée"
  fmt='#,##0 "ha"'
  minWidth='20%'
/>
<BigValue 
  data={stats_global_commune} 
  value=total_puissance
  title="Puissance totale installée"
  fmt='#,##0 "MWc"'
  minWidth='30%'
/>


<BigValue 
  data={stats_global_commune} 
  value=total_surface_defrichee
  title="Surface totale défrichée"
  fmt='#,##0 "ha"'
/>
<BigValue 
  data={stats_global_commune} 
  value=moyenne_distance_raccordement
  title="Distance moyenne de raccordement"
  fmt='#,##0 "km"'
/>

```usage_sol_surface
SELECT
  coalesce("Usage initial",'Usage inconnu') as name,
  sum("Surface Cloturée") as value
  FROM escosol.parcs
where commune_label='${inputs.commune_selector.value}'
GROUP BY 1
ORDER BY 1
```
