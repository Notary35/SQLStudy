-- 1. Лысые злодеи 90-х годов
SELECT name,
    Year AS first_appearance,
    APPEARANCES
FROM MarvelCharacters
WHERE HAIR = 'Bald'
    AND align = 'Bad Characters'
    AND Year BETWEEN 1990 AND 1999;
-- 2. Герои с тайной идентичностью и необычными глазами
SELECT name,
    Year AS first_appearance,
    EYE AS eye_color
FROM MarvelCharacters
WHERE identify = 'Secret Identity'
    AND EYE NOT IN ('Blue Eyes', 'Brown Eyes', 'Green Eyes')
    AND Year IS NOT NULL;
-- 3. Персонажи с изменяющимся цветом волос
SELECT name,
    HAIR AS hair_color
FROM MarvelCharacters
WHERE HAIR = 'Variable Hair';
-- 4. Женские персонажи с редким цветом глаз
SELECT name,
    EYE AS eye_color
FROM MarvelCharacters
WHERE SEX = 'Female Characters'
    AND EYE IN ('Gold Eyes', 'Amber Eyes');
-- 5. Персонажи без двойной идентичности, сортировка по году появления (сначала новые)
SELECT name,
    Year AS first_appearance
FROM MarvelCharacters
WHERE identify = 'No Dual Identity'
ORDER BY Year DESC;
-- 6. Герои и злодеи с необычными прическами
SELECT name,
    align,
    HAIR AS hair_color
FROM MarvelCharacters
WHERE HAIR NOT IN (
        'Brown Hair',
        'Black Hair',
        'Blond Hair',
        'Red Hair'
    )
    AND align IN ('Good Characters', 'Bad Characters');
-- 7. Персонажи, появившиеся в 1960-е годы
SELECT name,
    Year AS first_appearance
FROM MarvelCharacters
WHERE Year BETWEEN 1960 AND 1969;
-- 8. Персонажи с сочетанием глаз Yellow и волос Red
SELECT name,
    EYE AS eye_color,
    HAIR AS hair_color
FROM MarvelCharacters
WHERE EYE = 'Yellow Eyes'
    AND HAIR = 'Red Hair';
-- 9. Персонажи с количеством появлений < 10
SELECT name,
    APPEARANCES
FROM MarvelCharacters
WHERE APPEARANCES < 10;
-- 10. Персонажи с наибольшим количеством появлений (топ‑5)
SELECT name,
    APPEARANCES
FROM MarvelCharacters
ORDER BY APPEARANCES DESC
LIMIT 5;