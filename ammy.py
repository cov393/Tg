import socket
import re
import os
from datetime import datetime
from azure.identity import DefaultAzureCredential
from azure.monitor.ingestion import LogsIngestionClient

# Regular expression to filter ONTAP logs
ONTAP_REGEX = re.compile(r"(47776|48690|49691|53556|51262)lf*")

# Function to process incoming syslog messages
def process_syslog_message(message):
    if ONTAP_REGEX.search(message):
        print(f"Valid ONTAP log: {message}")
        # Send to Azure Monitor or another logging system
        send_to_azure_monitor(message)
    else:
        print(f"Ignored log: {message}")

# Setup syslog listener to receive syslog messages
def setup_syslog_listener(host='0.0.0.0', port=514):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((host, port))
    print(f"Listening for syslog messages on {host}:{port}")
    while True:
        data, addr = sock.recvfrom(1024)
        message = data.decode('utf-8')
        process_syslog_message(message)

# Function to send filtered logs to Azure Monitor (through DCR)
def send_to_azure_monitor(log_message):
    # Initialize client for Azure Monitor
    credential = DefaultAzureCredential()
    logs_client = LogsIngestionClient(credential)

    # Prepare current timestamp and log data for ingestion
    current_time = datetime.utcnow().isoformat() + 'Z'  # ISO 8601 UTC timestamp
    log_data = {
        "time": current_time,  # Current time
        "message": log_message
    }

    # Send log data to Azure Monitor (replace "DCR_ENDPOINT" with your actual DCR endpoint)
    logs_client.upload("DCR_ENDPOINT", log_data)
    print(f"Log sent to Azure Monitor: {log_message} at {current_time}")

if __name__ == "__main__":
    try:
        setup_syslog_listener()
    except KeyboardInterrupt:
        print("Shutting down syslog listener.")


# --------------------------------------

Syslog
| where Computer == "VM1" or Computer == "VM2"
| where Facility == "auth" or Facility == "daemon" // Optional: Filter by syslog facility types
| order by TimeGenerated desc
| take 10

