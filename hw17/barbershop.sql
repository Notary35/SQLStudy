-- Отключаем проверку внешних ключей
PRAGMA foreign_keys = OFF;

-- Начинаем транзакцию
BEGIN TRANSACTION;

-- Удаляем таблицы, если они существуют
DROP TABLE IF EXISTS masters_services;
DROP TABLE IF EXISTS appointments_services;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS masters;

-- Создаём таблицу мастеров
CREATE TABLE IF NOT EXISTS masters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    phone TEXT NOT NULL,
    UNIQUE(first_name, last_name, middle_name, phone)
);

-- Создаём таблицу услуг
CREATE TABLE IF NOT EXISTS services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL UNIQUE,
    description TEXT,
    price REAL NOT NULL
);

-- Создаём таблицу записей
CREATE TABLE IF NOT EXISTS appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    date TEXT DEFAULT CURRENT_TIMESTAMP,
    master_id INTEGER NOT NULL,
    status TEXT NOT NULL,
    comment TEXT,
    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE
);

-- Создаём таблицу связи мастеров и услуг
CREATE TABLE IF NOT EXISTS masters_services (
    master_id INTEGER,
    service_id INTEGER,
    PRIMARY KEY (master_id, service_id),
    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

-- Создаём таблицу связи записей и услуг
CREATE TABLE IF NOT EXISTS appointments_services (
    appointment_id INTEGER,
    service_id INTEGER,
    PRIMARY KEY (appointment_id, service_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

-- Вставляем тестовые данные в таблицу мастеров
INSERT OR IGNORE INTO masters (first_name, last_name, middle_name, phone)
VALUES 
    ('Иван', 'Смирнов', 'Алексеевич', '+79001112233'),
    ('Пётр', 'Иванов', 'Сергеевич', '+79004445566');

-- Вставляем тестовые данные в таблицу услуг
INSERT OR IGNORE INTO services (title, description, price)
VALUES 
    ('Стрижка', 'Мужская классическая стрижка', 1200),
    ('Бритьё', 'Бритьё опасной бритвой', 900),
    ('Укладка', 'Моделирование и укладка волос', 800),
    ('Коррекция бороды', 'Форма и длина бороды', 1000),
    ('Комплекс', 'Стрижка + борода + укладка', 2500);

-- Вставляем тестовые данные в таблицу связи мастеров и услуг
INSERT OR IGNORE INTO masters_services (master_id, service_id)
VALUES 
    (1, 1), (1, 2), (1, 5),
    (2, 1), (2, 3), (2, 4), (2, 5);

-- Вставляем тестовые данные в таблицу записей
INSERT OR IGNORE INTO appointments (name, phone, master_id, status, comment)
VALUES 
    ('Александр Кузнецов', '+79112223344', 1, 'подтверждена', 'Хочу короткую стрижку'),
    ('Михаил Орлов', '+79223334455', 2, 'ожидает', 'Позвонить за час'),
    ('Даниил Ефимов', '+79334445566', 1, 'подтверждена', 'Добавить укладку'),
    ('Антон Воробьёв', '+79445556677', 2, 'отменена', 'Клиент передумал');

-- Вставляем тестовые данные в таблицу связи записей и услуг
INSERT OR IGNORE INTO appointments_services (appointment_id, service_id)
VALUES 
    (1, 1), (1, 5),
    (2, 3),
    (3, 2), (3, 4),
    (4, 1);

-- Создаём индексы

-- Индекс на поле phone в таблице appointments
CREATE INDEX idx_appointments_phone ON appointments(phone);

-- Индекс на поле comment в таблице appointments
CREATE INDEX idx_appointments_comment ON appointments(comment);

-- Составной индекс на master_id и date в таблице appointments
CREATE INDEX idx_appointments_master_date ON appointments(master_id, date);

-- Составной индекс на appointment_id и service_id в таблице appointments_services
CREATE INDEX idx_appointments_services ON appointments_services(appointment_id, service_id);

-- Завершаем транзакцию
COMMIT;

-- Включаем проверку внешних ключей
PRAGMA foreign_keys = ON;