#!/usr/bin/env python3
# -*- coding: iso-8859-1 -*-

__author__ = "Kyle Gordon"
__copyright__ = "Copyright (C) Kyle Gordon"

## REF https://github.com/DaveBerkeley/iot/blob/master/mplayer/player.py
## REF https://www.bitpi.co/2015/03/18/raspberry-pi-surveillance-monitor/

import os
import logging
import signal
import socket
import time
import sys
import paho.mqtt.client as mqtt
import configparser

# Read the config file
config = configparser.RawConfigParser()
config.read("/etc/mqtt-pictureframe/mqtt-pictureframe.cfg")

# Use ConfigParser to pick out the settings
DEBUG = config.getboolean("global", "debug")
LOGFILE = config.get("global", "logfile")
MQTT_HOST = config.get("global", "mqtt_host")
MQTT_PORT = config.getint("global", "mqtt_port")
MQTT_TOPIC = "/raw/" + socket.getfqdn() + "/pictureframe"

APPNAME = "mqtt-pictureframe"
PRESENCETOPIC = "clients/" + socket.getfqdn() + "/" + APPNAME + "/state"
client_id = APPNAME + "_%d" % os.getpid()
mqttc = mqtt.Client(client_id)

LOGFORMAT = '%(asctime)-15s %(message)s'

if DEBUG:
    logging.basicConfig(filename=LOGFILE,
                        level=logging.DEBUG,
                        format=LOGFORMAT)
else:
    logging.basicConfig(filename=LOGFILE,
                        level=logging.INFO,
                        format=LOGFORMAT)

logging.info("Starting " + APPNAME)
logging.info("INFO MODE")
logging.debug("DEBUG MODE")

logging.debug("Connecting to %s:%s", MQTT_HOST, MQTT_PORT)

# All the MQTT callbacks start here


def on_publish(mqtt, obj, mid):
    """
    What to do when a message is published
    """
    logging.debug("MID " + str(mid) + " published.")


def on_subscribe(mqtt, obj, mid, qos_list):
    """
    What to do in the event of subscribing to a topic"
    """
    logging.debug("Subscribe with mid " + str(mid) + " received.")


def on_unsubscribe(mqtt, obj, mid):
    """
    What to do in the event of unsubscribing from a topic
    """
    logging.debug("Unsubscribe with mid " + str(mid) + " received.")


def on_connect(mqtt, obj, result_code):
    """
    Handle connections (or failures) to the broker.
    This is called after the client has received a CONNACK message
    from the broker in response to calling connect().
    The parameter rc is an integer giving the return code:

    0: Success
    1: Refused – unacceptable protocol version
    2: Refused – identifier rejected
    3: Refused – server unavailable
    4: Refused – bad user name or password (MQTT v3.1 broker only)
    5: Refused – not authorised (MQTT v3.1 broker only)
    """
    logging.debug("on_connect RC: " + str(result_code))
    if result_code == 0:
        logging.info("Connected to %s:%s", MQTT_HOST, MQTT_PORT)
        # Publish retained LWT as per
        # http://stackoverflow.com/q/97694
        # See also the will_set function in connect() below
        mqttc.publish(PRESENCETOPIC, "1", retain=True)
        process_connection()
    elif result_code == 1:
        logging.info("Connection refused - unacceptable protocol version")
        cleanup()
    elif result_code == 2:
        logging.info("Connection refused - identifier rejected")
        cleanup()
    elif result_code == 3:
        logging.info("Connection refused - server unavailable")
        logging.info("Retrying in 30 seconds")
        time.sleep(30)
    elif result_code == 4:
        logging.info("Connection refused - bad user name or password")
        cleanup()
    elif result_code == 5:
        logging.info("Connection refused - not authorised")
        cleanup()
    else:
        logging.warning("Something went wrong. RC:" + str(result_code))
        cleanup()


def on_disconnect(mqtt, obj, result_code):
    """
    Handle disconnections from the broker
    """
    if result_code == 0:
        logging.info("Clean disconnection")
    else:
        logging.info("Unexpected disconnection! Reconnecting in 5 seconds")
        logging.debug("Result code: %s", result_code)
        time.sleep(5)


def on_message(mqtt, obj, msg):
    """
    What to do when the client recieves a message from the broker
    """
    logging.debug("Received: " + msg.payload +
                  " received on topic " + msg.topic +
                  " with QoS " + str(msg.qos))
    process_message(msg)


def on_log(mqtt, obj, level, string):
    """
    What to do with debug log output from the MQTT library
    """
    logging.debug(string)

# End of MQTT callbacks


def cleanup(signum, frame):
    """
    Signal handler to ensure we disconnect cleanly
    in the event of a SIGTERM or SIGINT.
    """
    logging.info("Disconnecting from broker")
    # Publish a retained message to state that this client is offline
    mqttc.publish(PRESENCETOPIC, "0", retain=True)
    mqttc.disconnect()
    #mqttc.loop_stop()
    logging.info("Exiting on signal %d", signum)
    sys.exit(signum)


def connect():
    """
    Connect to the broker, define the callbacks, and subscribe
    This will also set the Last Will and Testament (LWT)
    The LWT will be published in the event of an unclean or
    unexpected disconnection.
    """
    logging.debug("Connecting to %s:%s", MQTT_HOST, MQTT_PORT)
    # Set the Last Will and Testament (LWT) *before* connecting
    mqttc.will_set(PRESENCETOPIC, "0", qos=0, retain=True)
    result = mqttc.connect(MQTT_HOST, MQTT_PORT, 60, True)
    if result != 0:
        logging.info("Connection failed with error code %s. Retrying", result)
        time.sleep(10)
        connect()

    # Define the callbacks
    mqttc.on_connect = on_connect
    mqttc.on_disconnect = on_disconnect
    mqttc.on_publish = on_publish
    mqttc.on_subscribe = on_subscribe
    mqttc.on_unsubscribe = on_unsubscribe
    mqttc.on_message = on_message
    if DEBUG:
        mqttc.on_log = on_log

    mqttc.loop_start()


def process_connection():
    """
    What to do when a new connection is established
    """
    logging.debug("Processing connection")
    mqttc.subscribe(MQTT_TOPIC + "/#", 2)
    logging.debug("Subscribed to " + MQTT_TOPIC + "/#")


def process_message(msg):
    """
    What to do with the message that's arrived
    """
    logging.debug("Received: %s", msg.topic)
    topic, sep, RelayID = msg.topic.rpartition("/")
    logging.info("Received state for relay %s", RelayID)
    logging.info("Setting relay %s state to %s", RelayID, msg.payload)

def display_on():
    """
    Turn on the HDMI display
    """
    logging.info("Turning on display")
    pass

def display_off():
    """
    Turn off the HDMI display
    """
    logging.info("Turning off display")
    pass

def spawn_mplayer(url):
    """
    Start mplayer with the requisite stream URL
    """
    logging.info("Starting mplayer")
    pass

def main_loop():
    """
    The main loop in which we read the serial port
    and handle the incoming data
    """
    logging.info("Starting mplayer")

    pass

# Use the signal module to handle signals
signal.signal(signal.SIGTERM, cleanup)
signal.signal(signal.SIGINT, cleanup)

# Try to start the main loop
try:
    mqttc.loop_forever()
    #main_loop()
except KeyboardInterrupt:
    logging.info("Interrupted by keypress")
    sys.exit(0)
