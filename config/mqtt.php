<?php
/**
 * Konfigurasi & Utilitas MQTT ChickGuard
 */
define('MQTT_BROKER_HOST', 'broker.emqx.io');
define('MQTT_BROKER_PORT', 1883);
define('MQTT_TOPIC_SENSOR', 'chickguard/sensor');
define('MQTT_TOPIC_CMD', 'chickguard/cmd');

/**
 * Kirim pesan MQTT secara instan (non-blocking / safe-fail)
 */
function cg_mqtt_publish(string $topic, array $payload): bool
{
    $autoload = __DIR__ . '/../vendor/autoload.php';
    if (!file_exists($autoload)) {
        return false;
    }
    require_once $autoload;

    if (!class_exists(\PhpMqtt\Client\MqttClient::class)) {
        return false;
    }

    try {
        $clientId = 'cg_web_' . bin2hex(random_bytes(4));
        $settings = (new \PhpMqtt\Client\ConnectionSettings)
            ->setConnectTimeout(2)
            ->setSocketTimeout(2);

        $client = new \PhpMqtt\Client\MqttClient(MQTT_BROKER_HOST, MQTT_BROKER_PORT, $clientId);
        $client->connect($settings, true);
        $client->publish($topic, json_encode($payload), 0);
        $client->disconnect();
        return true;
    } catch (\Throwable $e) {
        error_log('[MQTT PUBLISH ERROR] ' . $e->getMessage());
        return false;
    }
}
