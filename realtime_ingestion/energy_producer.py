
import json
import random
import time
import uuid
from datetime import datetime, timezone

from kafka import KafkaProducer

KAFKA_SERVER = "localhost:9092"
KAFKA_TOPIC = "energy_readings"

producer = KafkaProducer(
    bootstrap_servers=KAFKA_SERVER,
    key_serializer=lambda key: key.encode("utf-8"),
    value_serializer=lambda value: json.dumps(value).encode("utf-8"),
    acks="all",
    retries=5
)

meters = ["MTR001", "MTR002", "MTR003", "MTR004", "MTR005"]

try:
    print("Energy data producer started.")

    while True:
        meter_id = random.choice(meters)

        reading = {
            "event_id": str(uuid.uuid4()),
            "meter_id": meter_id,
            "voltage": round(random.uniform(215, 245), 2),
            "frequency": round(random.uniform(49.8, 50.2), 3),
            "power_kw": round(random.uniform(0.5, 15.0), 3),
            "energy_kwh": round(random.uniform(0.01, 2.0), 4),
            "signal_strength": random.randint(-90, -30),
            "event_timestamp": datetime.now(timezone.utc).isoformat()
        }

        future = producer.send(
            KAFKA_TOPIC,
            key=meter_id,
            value=reading
        )

        metadata = future.get(timeout=10)

        print("Published:", json.dumps(reading))
        print(
            f"Topic={metadata.topic}, "
            f"Partition={metadata.partition}, "
            f"Offset={metadata.offset}"
        )

        time.sleep(random.randint(30, 60))

except KeyboardInterrupt:
    print("Producer stopped.")

finally:
    producer.flush()
    producer.close()
