# UD 08 - Otras herramientas

[UD08 1a. Faker](<./UD 08 - Otras herramientas fffe913de6c481f3a815ca61f406ba9e/UD08 1a Faker fffe913de6c481a3ba13f25e6ccb4ef5.md>)

[UD08 1b. Faker (SOLUCIONES)](<../3b.kafkaSOL.md>)

[UD08 2. Kafka](<../3.kafka.md>)

[UD08 3. Kafka II](<./UD 08 - Otras herramientas fffe913de6c481f3a815ca61f406ba9e/UD08 3 Kafka II fffe913de6c4813e82abcf00fa8f7c76.md>)

[UD08 3. Mosquitto (mqtt)](<../4.mqtt.md>)

[UD08 4. Databricks](<../5.databricks.md>)

Nifi docker

```docker
docker run --platform linux/amd64 --name nifi -e NIFI_WEB_HTTP_PORT='8080' -p 8080:8080 -d apache/nifi:1.18.0 --restart=always
```
