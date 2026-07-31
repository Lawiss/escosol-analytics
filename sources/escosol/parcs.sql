SELECT
    *,
    CASE
        WHEN "Département code"='53' THEN 'Mayenne (53)'
        WHEN "Département code"='85' THEN 'Vendée (85)'
        WHEN "Département code"='44' THEN 'Loire-Atlantique (44)'
        WHEN "Département code"='72' THEN 'Sarthe (72)'
        WHEN "Département code"='48' THEN 'Lozère (48)'
        WHEN "Département code"='49' THEN 'Maine-et-Loire (49)'
        ELSE 'Département inconnu'
    END  as departement_label,
    CASE
        WHEN contains("Commune",'[') then "Commune"[3:-3]
        else "Commune"
    END as commune_label
from parcs
