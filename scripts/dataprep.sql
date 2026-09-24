--assocaite HIN segments and binning from OTIS with crash points from 2021-2025
create table crash_phila_hin as(
SELECT
    c.*,
    r.final_cate as hin_bin,
    r.hin_id,
    r.distance_to_segment
FROM crash_phila c
CROSS JOIN LATERAL (
    SELECT
        p.hin_id,
        p.final_cate,
        ST_Distance(
            c.shape::geography, p.geometry::geography
        ) AS distance_to_segment
    FROM phila_hin_binned p
    WHERE ST_DWithin(
        c.shape::geography, p.geometry::geography,
        30.48
    )
    ORDER BY c.shape::geography <-> p.geometry::geography
    LIMIT 1
) r
WHERE c.shape IS NOT null
);