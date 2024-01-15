create schema hh;

set schema 'hh';

CREATE TABLE hh.person (
    person_id BIGSERIAL NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    second_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    birth TIMESTAMP NOT NULL,
    email VARCHAR(50),
    phone VARCHAR(30) NOT NULL,
    sex CHAR(1) NOT NULL
);

CREATE TABLE hh.post (
    post_id BIGSERIAL NOT NULL PRIMARY KEY,
    post_name VARCHAR(50) NOT NULL
);

CREATE TABLE hh.company (
    company_id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE hh.experience (
    experience_id BIGSERIAL NOT NULL PRIMARY KEY,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    post_id BIGINT,
    company_id BIGINT,
    description TEXT NOT NULL,
    FOREIGN KEY (company_id) REFERENCES hh.company(company_id),
    FOREIGN KEY (post_id) REFERENCES hh.post(post_id)
);

CREATE TABLE hh.cv (
    cv_id BIGSERIAL NOT NULL PRIMARY KEY,
    compenstation_from NUMERIC(10, 2),
    compensation_to NUMERIC(10, 2),
    person_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL, -- open|closed
    create_datetime TIMESTAMP NOT NULL,
    FOREIGN KEY (person_id) REFERENCES hh.person(person_id)
);

CREATE TABLE hh.vacancy (
    vacancy_id BIGSERIAL NOT NULL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    compenstation_from NUMERIC(10, 2),
    compensation_to NUMERIC(10, 2),
    create_datetime TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL, -- open|closed
    company_id BIGINT NOT NULL,
    FOREIGN KEY (company_id) REFERENCES hh.company(company_id)
);

-- связь опыта и резюме
CREATE TABLE hh.cv_experience (
    cv_id BIGINT NOT NULL,
    experience_id BIGINT NOT NULL,
    PRIMARY KEY (cv_id, experience_id),
    FOREIGN KEY (cv_id) REFERENCES hh.cv(cv_id),
    FOREIGN KEY (experience_id) REFERENCES hh.experience(experience_id)
);

-- связь должностей и резюме
CREATE TABLE hh.cv_posts (
    cv_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,
    PRIMARY KEY (cv_id, post_id),
    FOREIGN KEY (cv_id) REFERENCES hh.cv(cv_id),
    FOREIGN KEY (post_id) REFERENCES hh.post(post_id)
);

-- связь вакансий и резюме
-- спорно что может быть несколько должностей в вакансии. Считаем, что могут быть похожие должности. Программист, разработчик и т.д.
CREATE TABLE hh.vacancy_posts (
    vacancy_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,
    PRIMARY KEY (vacancy_id, post_id),
    FOREIGN KEY (vacancy_id) REFERENCES hh.vacancy(vacancy_id),
    FOREIGN KEY (post_id) REFERENCES hh.post(post_id)
);

CREATE TABLE hh.area (
    area_id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- свзь областей и резюме
-- спорно, что у резюме может быть несколько областей. Считаем, что такое возможно благодаря дистанту или если человек готов переехать.
CREATE TABLE hh.cv_areas (
    cv_id BIGINT NOT NULL,
    area_id BIGINT NOT NULL,
    PRIMARY KEY (cv_id, area_id),
    FOREIGN KEY (cv_id) REFERENCES hh.cv(cv_id),
    FOREIGN KEY (area_id) REFERENCES hh.area(area_id)
);

-- свзь областей и вакансии
-- спорно, что у вакансии может быть несколько областей. Считаем, что такое возможно благодаря дистанту
CREATE TABLE hh.vacancy_areas (
    vacancy_id BIGINT NOT NULL,
    area_id BIGINT NOT NULL,
    PRIMARY KEY (vacancy_id, area_id),
    FOREIGN KEY (vacancy_id) REFERENCES hh.vacancy(vacancy_id),
    FOREIGN KEY (area_id) REFERENCES hh.area(area_id)
);

CREATE TABLE hh.response (
    cv_id BIGINT NOT NULL,
    vacancy_id BIGINT NOT NULL,
    create_datetime TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL, -- open|closed
    FOREIGN KEY (cv_id) REFERENCES hh.cv(cv_id),
    FOREIGN KEY (vacancy_id) REFERENCES hh.vacancy(vacancy_id)
);

-- Создаем индексы для столбцов по которым будет происходить поиск, фильтрация или сортировка
-- Индексы по датам полезны т.к. пользователи захотят сортировать по дате чтобы получать более свежие вакансии.
-- Пользователи захотят сортировать и ограничивать вакансии по уровню зарплаты.
-- Закрытые вакансии и резюме показывать не стоит, поэтому эта колонка будет часто в фильтре. Добавляем индекс.

create index cv_status_idx on hh.cv(status); -- индекс для фильтрации по статусу

create index cv_time_idx on hh.cv(create_datetime); -- индекс для сортировки по времени

create index vacancy_c_from_idx on hh.vacancy(compenstation_from); -- индекс для сортировки/фильтрации по зарплате

create index vacancy_c_to_idx on hh.vacancy(compensation_to); -- индекс для сортировки/фильтрации по зарплате

create index vacancy_time_idx on hh.vacancy(create_datetime); -- индекс для сортировки по времени

create index vacancy_status_idx on hh.vacancy(status); -- индекс для фильтрации по статусу

create index response_time_idx on hh.response(create_datetime); -- индекс для сортировки по времени

create index response_status_idx on hh.response(status); -- индекс для фильтрации по статусу


INSERT INTO hh.company VALUES
    (1, 'Акварельная техника'),
    (2, 'Проектное управление'),
    (3, 'Компьютерные игры'),
    (4, 'Звуковые документы'),
    (5, 'Веб-разработка'),
    (6, 'Управление ресурсами'),
    (7, 'Аналитическое исследование'),
    (8, 'Экологический проект'),
    (9, 'Управление персоналом'),
    (10, 'Инвестиции'),
    (11, 'Туристическое агентство'),
    (12, 'Здравоохранение'),
    (13, 'Военное оборудование'),
    (14, 'Образовательные курсы'),
    (15, 'Финансовый анализ'),
    (16, 'Программное обеспечение'),
    (17, 'Телекоммуникации'),
    (18, 'Энергетика'),
    (19, 'Строительство'),
    (20, 'Фармацевтика');

INSERT INTO hh.post (post_id, post_name) VALUES
    (1, 'Руководитель проекта'),
    (2, 'Специалист по программному обеспечению'),
    (3, 'Менеджер продукта'),
    (4, 'Разработчик веб-приложений'),
    (5, 'Веб-дизайнер'),
    (6, 'Аналитик'),
    (7, 'Специалист по мобильным приложениям'),
    (8, 'Баззы данных'),
    (9, 'Администратор серверов'),
    (10, 'Разработчик игр'),
    (11, 'Фельовец'),
    (12, 'Менеджер ресурсов'),
    (13, 'Редактор'),
    (14, 'Видеорежиссер'),
    (15, 'Звуковой режиссер'),
    (16, 'Менеджер продаж'),
    (17, 'Экономист'),
    (18, 'Специалист по маркетингу'),
    (19, 'Социальный медиа-менеджер'),
    (20, 'Правовой адвокат'),
    (21, 'Консультант'),
    (22, 'Инженер'),
    (23, 'Архитектор'),
    (24, 'Дизайнер интерьера'),
    (25, 'Визуальный дизайнер'),
    (26, 'Культурный аналитик'),
    (27, 'Программист'),
    (28, 'Операционный аналитик'),
    (29, 'Специалист по внедрению систем'),
    (30, 'Научный редактор'),
    (31, 'Программист-аналитик'),
    (32, 'Специалист по обработке данных'),
    (33, 'Сеоларист'),
    (34, 'Программист-администратор'),
    (35, 'Специалист по веб-разработке'),
    (36, 'Сайт-администратор'),
    (37, 'Специалист по аналитике данных'),
    (38, 'Сеоциальный медиа-специалист'),
    (39, 'Системный администратор'),
    (40, 'Технический писатель'),
    (41, 'Специалист по тестированию'),
    (42, 'Специалист по информационной безопасности'),
    (43, 'Специалист по автоматизации тестирования'),
    (44, 'Специалист по управлении проектами'),
    (45, 'Специалист по технической поддержке'),
    (46, 'Специалист по администрированию баз данных'),
    (47, 'Специалист по разработке мобильных приложений'),
    (48, 'Специалист по разработке игр'),
    (49, 'Специалист по разработке веб-сайтов'),
    (50, 'Специалист по анализу данных');
   

INSERT INTO hh.person (person_id, first_name, second_name, last_name, birth, email, phone, sex)
SELECT 
  i,
  'First name ' || i,
  'Second name ' || i,
  'Last name ' || i,
  TIMESTAMP '1970-01-01 00:00:00' + (random() * (now() - '1970-01-01 00:00:00')::interval),
  'email' || i || '@example.com',
  '+1-555-555-' || lpad(i::text, 4, '0'),
  CASE WHEN random() < 0.5 THEN 'м' ELSE 'ж' END
FROM generate_series(1, 100000) AS i;

INSERT INTO hh.vacancy (vacancy_id, title, description, compenstation_from, compensation_to, create_datetime, status, company_id)
SELECT 
  i,
  'title ' || i,
  'Description ' || i,
  (random() * 100000)::numeric(10, 2),
  (random() * 200000)::numeric(10, 2),
  TIMESTAMP '2023-11-01 00:00:00' + (random() * (now() - '2023-11-01 00:00:00')::interval),
  CASE WHEN random() < 0.5 THEN 'open' ELSE 'closed' END,
  (1+random() * 19)::bigint
FROM generate_series(1, 10000) AS i;

INSERT INTO hh.cv (cv_id, compenstation_from, compensation_to, person_id, status, create_datetime)
SELECT 
  i,
  (random() * 100000)::numeric(10, 2),
  (random() * 200000)::numeric(10, 2),
  (1 + random() * 99999)::bigint,
  CASE WHEN random() < 0.5 THEN 'open' ELSE 'closed' END,
  TIMESTAMP '2023-11-01 00:00:00' + (random() * (now() - '2023-11-01 00:00:00')::interval)
FROM generate_series(1, 1000000) AS i;

INSERT INTO hh.area (name)
SELECT 'Area ' || generate_series
FROM generate_series(1, 50);

INSERT INTO area VALUES (51, 'Москва');

INSERT INTO hh.cv_areas (cv_id, area_id)
SELECT
  i,
  (1 + random() * 49)::bigint
FROM generate_series(1, 1000000) AS i;

INSERT INTO hh.vacancy_areas
SELECT 
  i,
  (1 + random() * 49)::bigint
FROM
  generate_series(1, 10000) AS i;

INSERT INTO hh.vacancy_areas
SELECT i, 51
FROM generate_series(1, 100) AS i;

INSERT INTO hh.response
SELECT
  (1 + random() * 99999)::bigint,
  i,
  TIMESTAMP '2023-11-01 00:00:00' + (random() * (now() - '2023-11-01 00:00:00')::interval),
  CASE WHEN random() < 0.5 THEN 'open' ELSE 'closed' END
FROM generate_series(1, 10000) AS i;

DO $$
BEGIN
  FOR j IN 1..20 LOOP
    INSERT INTO hh.response
	SELECT
	  (1 + random() * 99999)::bigint,
	  i,
	  TIMESTAMP '2023-11-01 00:00:00' + (random() * (now() - '2023-11-01 00:00:00')::interval),
	  CASE WHEN random() < 0.5 THEN 'open' ELSE 'closed' END
	FROM generate_series(1, 100) AS i;
  END LOOP;
END $$;
