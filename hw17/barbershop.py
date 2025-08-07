import sqlite3
from typing import List, Tuple, Optional

# Константы
DB_PATH = "hw17/barbershop.db"
SQL_PATH = "hw17/barbershop.sql"

def read_sql_file(filepath: str) -> str:
    """Читает SQL-скрипт из файла и возвращает его содержимое."""
    with open(filepath, 'r', encoding='utf-8') as file:
        return file.read()

def execute_script(conn: sqlite3.Connection, script: str) -> None:
    """Выполняет SQL-скрипт через курсор с сохранением изменений."""
    cursor = conn.cursor()
    cursor.executescript(script)
    conn.commit()
    cursor.close()

def find_appointment_by_phone(conn: sqlite3.Connection, phone: str) -> List[Tuple]:
    """Ищет записи по точному номеру телефона, возвращает человекочитаемые данные."""
    query = """
    SELECT 
        a.id,
        a.name AS client_name,
        a.phone,
        a.date,
        m.first_name || ' ' || m.last_name AS master_name,
        GROUP_CONCAT(s.title) AS services,
        a.status,
        a.comment
    FROM appointments a
    JOIN masters m ON a.master_id = m.id
    JOIN appointments_services aps ON a.id = aps.appointment_id
    JOIN services s ON aps.service_id = s.id
    WHERE a.phone = ?
    GROUP BY a.id;
    """
    cursor = conn.cursor()
    cursor.execute(query, (phone,))
    results = cursor.fetchall()
    print("Найдено записей:", len(results)) 
    return results  

def find_appointment_by_comment(conn: sqlite3.Connection, comment_part: str) -> List[Tuple]:
    """Ищет записи по части комментария, возвращает читаемые данные."""
    query = """
    SELECT 
        a.id,
        a.name AS client_name,
        a.phone,
        a.date,
        m.first_name || ' ' || m.last_name AS master_name,
        GROUP_CONCAT(s.title) AS services, 
        a.status,
        a.comment
    FROM appointments a
    JOIN masters m ON a.master_id = m.id
    JOIN appointments_services aps ON a.id = aps.appointment_id
    JOIN services s ON aps.service_id = s.id
    WHERE a.comment LIKE ?
    GROUP BY a.id;
    """
    cursor = conn.cursor()
    cursor.execute(query, (f'%{comment_part}%',))
    results = cursor.fetchall()
    cursor.close()
    return results

def create_appointment(
    conn: sqlite3.Connection,
    client_name: str,
    client_phone: str,
    master_name: str,
    services_list: List[str],
    comment: Optional[str] = None) -> int:  
    """Создаёт новую запись и возвращает её ID."""
    cursor = conn.cursor()
    
    # Ищем ID мастера по имени
    master_query = "SELECT id FROM masters WHERE first_name || ' ' || last_name = ?"
    cursor.execute(master_query, (master_name,))
    master_result = cursor.fetchone()
    if not master_result:
        cursor.close()
        raise ValueError(f"Мастер {master_name} не найден")
    master_id = master_result[0]
    
    # Создаём запись
    insert_appointment = """
    INSERT INTO appointments (name, phone, master_id, status, comment)
    VALUES (?, ?, ?, 'ожидает', ?)
    """
    cursor.execute(insert_appointment, (client_name, client_phone, master_id, comment))
    appointment_id = cursor.lastrowid
    
    # Связываем услуги
    for service in services_list:
        service_query = "SELECT id FROM services WHERE title = ?"
        cursor.execute(service_query, (service,))
        service_result = cursor.fetchone()
        if not service_result:
            conn.rollback()
            cursor.close()
            raise ValueError(f"Услуга {service} не найдена")
        service_id = service_result[0]
        
        insert_service = """
        INSERT INTO appointments_services (appointment_id, service_id)
        VALUES (?, ?)
        """
        cursor.execute(insert_service, (appointment_id, service_id))
    
    conn.commit()
    cursor.close()
    return appointment_id

# Тестовые вызовы
if __name__ == "__main__":
    with sqlite3.connect(DB_PATH) as conn:
        sql_script = read_sql_file(SQL_PATH)
        execute_script(conn,  sql_script)
        print("База данных создана")
        
        # Поиск по телефону
        print("\nПоиск по телефону +79112223344:")
        results = find_appointment_by_phone(conn, "+79112223344")
        for row in results:
            print(row)
            
        # Поиск по комментарию
        print("\nПоиск по комментарию 'укладка':")
        results = find_appointment_by_comment(conn, "укладка")
        for row in results:
            print(row)
            
        # Создание записи
        print("\nСоздание записи:")
        try:
            new_appointment_id = create_appointment(conn, "Сергей Петров", "+79556667788", "Иван Смирнов", ["Стрижка", "Укладка"], comment="Срочно нужна стрижка")
            print(f"Создана запись с ID: {new_appointment_id}")
        except ValueError as e:
            print(f"Ошибка: {e}")