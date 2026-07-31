---
title: Statistiques départementales
---

```stats_by_departement
SELECT 
  departement_label,
  max("Département code") as departement_code,
  count(*) as nombre_parcs,
  sum("Surface Cloturée") as total_surface,
  sum("Puissance") as total_puissance,
  mean("Raccordement") as moyenne_distance_raccordement,
  sum("Surface Défrichée") as total_surface_defrichee,
  count(*) filter (where "Demande De Dérogation Espèces Protégées"='oui') as total_demande_derog_espro,
  count(*) filter (where "Autorisation De Défrichement"='oui') as total_autorisation_defrichement,
  count(*) filter (where "Autorisation Loi Sur L'eau"='oui') as total_autorisation_eau
FROM escosol.parcs
GROUP BY 1
order by 2
```

Plusieurs métriques sont calculées au niveau départmental :
- Nombre de parcs ;
- Surface totale occupée par les parcs (en ha);
- Puissance totale (en MWc);
- Distance moyenne de raccordement (en km);
- Surface totale défrichée (en ha).

Vous pouvez choisir la métrique à afficher dans le graphe en utilisant le sélecteur ci-dessous =
<Dropdown 
  name="metric_selector"
  title="Métrique :" 
>
    <DropdownOption valueLabel="Nombres de parcs" value="nombre_parcs"/>
    <DropdownOption valueLabel="Surface totale occupée en (ha)" value="total_surface" />
    <DropdownOption valueLabel="Puissance totale (en MWc)" value="total_puissance" />
    <DropdownOption valueLabel="Distance moyenne de raccordement (en km)" value="moyenne_distance_raccordement" />
    <DropdownOption valueLabel="Surface totale défrichée (en ha)" value="total_surface_defrichee" />
</Dropdown>

<BarChart 
    data={stats_by_departement}
    x=departement_label
    y={inputs.metric_selector.value}
    title="{inputs.metric_selector.label} par département"
    sort=false
    labels=true
    xAxisTitle='Département'
/>

# Analyse de l'usage intial des sols

```stats_by_departement_sol
SELECT 
  departement_label,
  "Usage initial" as usage,
  max("Département code") as departement_code,
  count(*) as nombre_parcs,
  sum("Surface Cloturée") as total_surface,
  sum("Puissance") as total_puissance
FROM escosol.parcs
GROUP BY 1,2
order by 3
```

<Dropdown 
  name="metric_selector_sol"
  title="Métrique :" 
>
    <DropdownOption valueLabel="Nombres de parcs" value="nombre_parcs"/>
    <DropdownOption valueLabel="Surface totale occupée en (ha)" value="total_surface" />
    <DropdownOption valueLabel="Puissance totale (en MWc)" value="total_puissance" />
</Dropdown>

<BarChart 
    data={stats_by_departement_sol}
    x=departement_label
    y={inputs.metric_selector_sol.value}
    series=usage
    title="{inputs.metric_selector.label} par département"
    sort=false
    labels=true
    stackTotalLabel=false
    colorPalette={['#C65D47', '#5BAF7A', '#4A8EBA', '#D35B85', '#E1C16D', '#6F5B9A', '#147538', '#115759']}
    xAxisTitle='Département'
/>


# Valeurs manquantes

En fonction des parcs, toutes les métriques ne sont pas disponibles pour différentes raisons. Voici un aperçu du pourcentage de valeurs manquantes pour chacun des départements :

```stats_by_departement_missing_values
SELECT 
  departement_label,
  max("Département code") as departement_code,
  1-count("Surface Cloturée")::numeric/count(*) as ratio_missing_surface,
  1-count("Puissance")::numeric/count(*) as ratio_missing_puissance,
  1-count("Raccordement")::numeric/count(*) as ratio_missing_raccordement
FROM escosol.parcs
GROUP BY 1
order by 2
```

```stats_by_departement_missing_values_long
SELECT
  departement_label,
  'Surface occupée' as metric_name,
  ratio_missing_surface as ratio_missing
from ${stats_by_departement_missing_values}
UNION ALL
SELECT
  departement_label,
  'Puissance' as metric_name,
  ratio_missing_puissance as ratio_missing
from ${stats_by_departement_missing_values}
UNION ALL
SELECT
  departement_label,
  'Distance de raccordement' as metric_name,
  ratio_missing_raccordement as ratio_missing
from ${stats_by_departement_missing_values}
```

<BarChart 
    data={stats_by_departement_missing_values_long}
    x=departement_label
    y=ratio_missing
    yFmt='pct'
    yMax=1
    xAxisTitle='Département'
    yAxisTitle='de valeurs manquantes'
    series=metric_name
    type=grouped
    title='Proportion de valeurs manquantes pour chacune des métriques'
/>
