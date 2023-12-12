-- средние величины
SELECT
    a.area_id,
    a.name,
    AVG(v.compenstation_from) as avg_compensation_from,
    AVG(v.compensation_to) as avg_compensation_to,
    AVG((v.compenstation_from + v.compensation_to) / 2) as avg
FROM hh.vacancy_areas va
INNER JOIN hh.vacancy v ON va.vacancy_id = v.vacancy_id
INNER JOIN hh.area a ON va.area_id = a.area_id
GROUP BY a.area_id
ORDER BY a.area_id;


-- месяц с наибольшим количеством вакансий и месяц с наибольшим количеством резюме
(
  SELECT 'cvs' as type, DATE_PART('month', create_datetime) AS month, COUNT(*) AS amount
  FROM hh.vacancy
  GROUP BY month
  ORDER BY amount DESC
  LIMIT 1
)
UNION
(
  SELECT 'vacancies' as type, DATE_PART('month', create_datetime) AS month, COUNT(*) AS amount
  FROM hh.cv
  GROUP BY month
  ORDER BY amount DESC
  LIMIT 1
);


-- запрос для получения id и title вакансий, которые собрали больше 5 откликов в первую неделю после публикации
SELECT
  v.vacancy_id,
  v.title,
  COUNT(*) AS amount
FROM hh.vacancy v
INNER JOIN hh.response r ON v.vacancy_id = r.vacancy_id
WHERE v.create_datetime - r.create_datetime < INTERVAL '1 week'
GROUP BY v.vacancy_id
HAVING COUNT(*) > 5
ORDER BY v.vacancy_id;
