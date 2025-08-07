-- Очистка таблиц (если они уже существуют)
DROP TABLE IF EXISTS masters_services;
DROP TABLE IF EXISTS appointments_services;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS masters;

-- Создание таблицы мастеров с уникальным ограничением
CREATE TABLE IF NOT EXISTS masters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    phone TEXT NOT NULL,
    UNIQUE(first_name, last_name, middle_name, phone)
);

-- Создание таблицы услуг
CREATE TABLE IF NOT EXISTS services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL UNIQUE,
    description TEXT,
    price REAL NOT NULL
);

-- Создание таблицы записи на услуги
CREATE TABLE IF NOT EXISTS appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    date TEXT DEFAULT CURRENT_TIMESTAMP,
    master_id INTEGER NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE
);

-- Создание таблицы связи между мастерами и услугами
CREATE TABLE IF NOT EXISTS masters_services (
    master_id INTEGER,
    service_id INTEGER,
    PRIMARY KEY (master_id, service_id),
    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

-- Создание таблицы связи между записями и услугами
CREATE TABLE IF NOT EXISTS appointments_services (
    appointment_id INTEGER,
    service_id INTEGER,
    PRIMARY KEY (appointment_id, service_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

-- Вставка данных в таблицу мастеров (игнорируем дубликаты)
INSERT OR IGNORE INTO masters (first_name, last_name, middle_name, phone)
VALUES 
('Иван', 'Смирнов', 'Алексеевич', '+79001112233'),
('Пётр', 'Иванов', 'Сергеевич', '+79004445566');

-- Вставка данных в таблицу услуг (игнорируем дубликаты)
INSERT OR IGNORE INTO services (title, description, price)
VALUES 
('Стрижка', 'Мужская классическая стрижка', 1200),
('Бритьё', 'Бритьё опасной бритвой', 900),
('Укладка', 'Моделирование и укладка волос', 800),
('Коррекция бороды', 'Форма и длина бороды', 1000),
('Комплекс', 'Стрижка + борода + укладка', 2500);

-- Связывание мастеров и услуг (игнорируем дубликаты)
INSERT OR IGNORE INTO masters_services (master_id, service_id)
VALUES 
(1, 1), (1, 2), (1, 5),
(2, 1), (2, 3), (2, 4), (2, 5);

-- Добавление записей клиентов (игнорируем дубликаты)
INSERT OR IGNORE INTO appointments (name, phone, master_id, status)
VALUES 
('Александр Кузнецов', '+79112223344', 1, 'подтверждена'),
('Михаил Орлов', '+79223334455', 2, 'ожидает'),
('Даниил Ефимов', '+79334445566', 1, 'подтверждена'),
('Антон Воробьёв', '+79445556677', 2, 'отменена');

-- Связь записей с услугами игнорируем дубликаты
INSERT OR IGNORE INTO appointments_services (appointment_id, service_id)
VALUES 
(1, 1), (1, 5),  -- Александр: стрижка + комплекс
(2, 3),          -- Михаил: укладка
(3, 2), (3, 4),  -- Даниил: бритьё + борода
(4, 1);          -- Антон: стрижка


-- Добавил для каждого запроса "OR IGNORE" для предотвращения дубликатов

-- Проверяем каждую таблицу
SELECT * FROM masters;
SELECT * FROM services;
SELECT * FROM masters_services;
SELECT * FROM appointments;
SELECT * FROM appointments_services;

