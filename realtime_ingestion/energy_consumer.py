
import json
import os

import psycopg2
from kafka import KafkaConsumer

KAFKA_SERVER = "localhost:9092"
KAFKA_TOPIC = "energy_readings"

DB_CONFIG = {
    "host": os.environ["PGHOST"],
    "port": int(os.environ["PGPORT"]),
    "dbname": os.environ["PGDATABASE"],
    "user": os.environ["PGUSER"],
    "password": os.environ["PGPASSWORD"]
}

INSERT_SQL = """
INSERT INTO real_time_energy_readings (
    event_id,
    meter_id,
    voltage,
    frequency,
    power_kw,
    energy_kwh,
    signal_strength,
    event_timestamp
)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
ON CONFLICT (event_id) DO NOTHING;
"""

consumer = KafkaConsumer(
    KAFKA_TOPIC,
    bootstrap_servers=KAFKA_SERVER,
    group_id="energy-postgres-consumer",
    enable_auto_commit=False,
    auto_offset_reset="earliest",
    value_deserializer=lambda value: json.loads(value.decode("utf-8"))
)

connection = None

try:
    connection = psycopg2.connect(**DB_CONFIG)
    connection.autocommit = False

    print("Connected to Kafka and PostgreSQL.")

    for message in consumer:
        reading = message.value

        try:
            with connection.cursor() as cursor:
                cursor.execute(
                    INSERT_SQL,
                    (
                        reading["event_id"],
                        reading["meter_id"],
                        reading["voltage"],
                        reading["frequency"],
                        reading["power_kw"],
                        reading["energy_kwh"],
                        reading["signal_strength"],
                        reading["event_timestamp"]
                    )
                )

            connection.commit()

            # Acknowledge the Kafka message only after DB success.
            consumer.commit()

            print(
                f"Stored meter={reading['meter_id']}, "
                f"event_id={reading['event_id']}, "
                f"partition={message.partition}, "
                f"offset={message.offset}"
            )

        except Exception:
            connection.rollback()
            raise

except KeyboardInterrupt:
    print("Consumer stopped.")

finally:
    consumer.close()

    if connection is not None:
        connection.close()
