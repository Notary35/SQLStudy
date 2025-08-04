-- 1. Общее количество персонажей по статусу
SELECT
    ALIVE,
    COUNT(*) AS total
FROM
    MarvelCharacters
GROUP BY
    ALIVE;

-- 2. Среднее количество появлений по цвету глаз
SELECT
    EYE AS color,
    AVG(APPEARANCES) AS avg_appearances
FROM
    MarvelCharacters
GROUP BY
    EYE;

-- 3. Максимальное количество появлений по цвету волос
SELECT
    HAIR AS color,
    MAX(APPEARANCES) AS max_appearances
FROM
    MarvelCharacters
GROUP BY
    HAIR;

-- 4. Минимальное количество появлений (Public Identity)
SELECT
    identify AS identity,
    MIN(APPEARANCES) AS min_appearances
FROM
    MarvelCharacters
WHERE
    identify = 'Public Identity'
GROUP BY
    identify;

-- 5. Общее количество персонажей по полу
SELECT
    SEX,
    COUNT(*) AS total
FROM
    MarvelCharacters
GROUP BY
    SEX;

-- 6. Средний год первого появления по типу личности
SELECT
    identify AS identity,
    AVG(Year) AS avg_year
FROM
    MarvelCharacters
GROUP BY
    identify;

-- 7. Количество живых персонажей по цвету глаз
SELECT
    EYE AS color,
    COUNT(*) AS total_alive
FROM
    MarvelCharacters
WHERE
    ALIVE = 'Living Characters'
GROUP BY
    EYE;

-- 8. Макс и мин количество появлений по цвету волос
SELECT
    HAIR AS color,
    MAX(APPEARANCES) AS max_app,
    MIN(APPEARANCES) AS min_app
FROM
    MarvelCharacters
GROUP BY
    HAIR;

-- 9. Количество умерших персонажей по типу личности
SELECT
    identify AS identity,
    COUNT(*) AS total_dead
FROM
    MarvelCharacters
WHERE
    ALIVE = 'Deceased Characters'
GROUP BY
    identify;

-- 10. Средний год первого появления по цвету глаз
SELECT
    EYE AS color,
    AVG(Year) AS avg_year
FROM
    MarvelCharacters
GROUP BY
    EYE;

-- 11. Персонаж с наибольшим количеством появлений
SELECT
    name,
    APPEARANCES
FROM
    MarvelCharacters
WHERE
    APPEARANCES = (
        SELECT
            MAX(APPEARANCES)
        FROM
            MarvelCharacters
    );

-- 12. Персонажи, впервые появившиеся в том же году, что и рекордсмен по появлениям
SELECT
    name,
    Year
FROM
    MarvelCharacters
WHERE
    Year = (
        SELECT
            Year
        FROM
            MarvelCharacters
        WHERE
            APPEARANCES = (
                SELECT
                    MAX(APPEARANCES)
                FROM
                    MarvelCharacters
            )
    );

-- 13. Живые персонажи с наименьшим количеством появлений
SELECT
    name,
    APPEARANCES
FROM
    MarvelCharacters
WHERE
    ALIVE = 'Living Characters'
    AND APPEARANCES = (
        SELECT
            MIN(APPEARANCES)
        FROM
            MarvelCharacters
        WHERE
            ALIVE = 'Living Characters'
    );

-- 14. Персонажи с цветом волос 'Blond Hair' и максимальными появлениями среди них
SELECT
    name,
    HAIR AS color,
    APPEARANCES
FROM
    MarvelCharacters mc
WHERE
    HAIR = 'Blond Hair'
    AND APPEARANCES = (
        SELECT
            MAX(APPEARANCES)
        FROM
            MarvelCharacters
        WHERE
            HAIR = mc.HAIR
    );

-- 15. Публичная личность с минимальным количеством появлений
SELECT
    name,
    identify AS identity,
    APPEARANCES
FROM
    MarvelCharacters
WHERE
    identify = 'Public Identity'
    AND APPEARANCES = (
        SELECT
            MIN(APPEARANCES)
        FROM
            MarvelCharacters
        WHERE
            identify = 'Public Identity'
    );