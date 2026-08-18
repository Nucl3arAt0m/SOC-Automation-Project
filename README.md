# SOC Automation Project

An automated Security Operations Center (SOC) workflow that connects
**Wazuh**, **Shuffle**, **TheHive**, **VirusTotal**, **Sysmon**, and
email notifications to automate security alert handling and incident
response.

## 📌 Overview

This project demonstrates how a SOC can reduce manual alert handling by
creating an automated pipeline:

**Windows Endpoint → Sysmon → Wazuh → Shuffle → VirusTotal → TheHive →
Email Notification**

The workflow is designed so that security alerts detected by Wazuh are
automatically forwarded to Shuffle, enriched using VirusTotal, converted
into an incident/ticket in TheHive, and communicated to a security
analyst through email.

The objective is to reduce the need for continuous manual monitoring of
the Wazuh dashboard and demonstrate a practical SOAR-style incident
response workflow.

## 🏗️ Architecture

``` text
                         ┌────────────────────┐
                         │  Windows Endpoint   │
                         │                    │
                         │      Sysmon        │
                         └─────────┬──────────┘
                                   │
                                   ▼
                         ┌────────────────────┐
                         │       Wazuh        │
                         │   SIEM / HIDS      │
                         │                    │
                         │ Alert Detection    │
                         └─────────┬──────────┘
                                   │ Webhook
                                   ▼
                         ┌────────────────────┐
                         │      Shuffle       │
                         │      SOAR          │
                         │                    │
                         │ Workflow Engine    │
                         └──────┬─────┬───────┘
                                │     │
                     Hash        │     │ Incident
                     Enrichment │     │ Creation
                                ▼     ▼
                       ┌───────────┐ ┌────────────┐
                       │VirusTotal │ │  TheHive   │
                       │           │ │    SIRP    │
                       │Threat Intel│ │ Case Mgmt. │
                       └─────┬─────┘ └─────┬──────┘
                             │             │
                             └──────┬──────┘
                                    ▼
                            ┌────────────────┐
                            │ Email Alert to │
                            │ Security Analyst│
                            └────────────────┘
```

## 🎯 Project Objectives

-   Centralize endpoint security monitoring with Wazuh.
-   Collect Windows security telemetry using Sysmon.
-   Detect suspicious activity using Wazuh rules.
-   Create custom detection logic for Mimikatz.
-   Automatically forward selected Wazuh alerts to Shuffle.
-   Extract SHA-256 hashes from security alerts.
-   Enrich file hashes using VirusTotal.
-   Automatically create incidents/cases in TheHive.
-   Notify security analysts through email.
-   Demonstrate an end-to-end SOC automation and incident response
    workflow.

## 🛠️ Technologies Used

  -----------------------------------------------------------------------
  Technology                          Purpose
  ----------------------------------- -----------------------------------
  **Wazuh**                           SIEM, endpoint monitoring, log
                                      analysis and alert detection

  **Sysmon**                          Windows endpoint telemetry and
                                      process monitoring

  **Shuffle**                         SOAR workflow automation and
                                      orchestration

  **TheHive**                         Security incident response and case
                                      management

  **VirusTotal**                      Threat intelligence and hash
                                      reputation lookup

  **Docker**                          Container-based deployment support
                                      for Shuffle

  **Cassandra**                       Database dependency used by TheHive

  **Elasticsearch**                   Indexing and search functionality
                                      used by TheHive

  **Windows**                         Endpoint used for security event
                                      collection

  **Ubuntu**                          Server host used for the SOC
                                      components
  -----------------------------------------------------------------------

## 🔄 Detection & Response Workflow

### 1. Endpoint Monitoring

Sysmon is installed on the Windows endpoint to generate detailed system
telemetry, including process-related events.

The Wazuh agent collects relevant Windows and Sysmon logs and forwards
them to the Wazuh manager.

### 2. Alert Detection with Wazuh

Wazuh analyzes incoming events and generates security alerts.

A custom rule is configured to detect **Mimikatz** using the
`original_file_name` field. This allows the detection to continue
working even when the executable has been renamed.

For testing, the Mimikatz executable is renamed and executed on the
Windows endpoint. Wazuh is then used to verify that the custom detection
triggers.

### 3. Alert Forwarding to Shuffle

Shuffle is configured with a webhook trigger that receives selected
Wazuh alerts.

The Wazuh manager is configured to send matching alerts to the Shuffle
webhook.

This creates the automation bridge between the SIEM and the SOAR
platform.

### 4. Hash Extraction

The Shuffle workflow parses the alert data and extracts the SHA-256 file
hash using a regular expression.

The extracted hash becomes an input for the threat intelligence
enrichment stage.

### 5. VirusTotal Enrichment

The extracted SHA-256 hash is submitted to VirusTotal through the
Shuffle integration.

The workflow retrieves available reputation information for the file
hash, allowing the alert to be enriched with threat intelligence before
incident creation.

### 6. TheHive Incident Creation

Shuffle sends the relevant alert and enrichment information to TheHive.

TheHive is used to create and manage the security incident, providing a
central location for SOC analysts to investigate and track the alert.

### 7. Email Notification

The workflow sends an email notification to the security analyst.

The notification includes relevant information such as:

-   Detection title
-   Detection time
-   Affected host
-   Alert details
-   Enrichment information

This allows the analyst to receive the incident notification without
continuously monitoring the Wazuh dashboard.

## 🚨 Example Detection

### Mimikatz Detection

The project includes a custom Wazuh rule designed to detect Mimikatz
based on its original file name.

The test procedure demonstrates that the detection can identify the
executable even after it has been renamed.

Example test scenario:

``` text
mimikatz.exe
      │
      ├── Renamed
      ▼
you_are_awesome.exe
      │
      ├── Executed
      ▼
Sysmon Event
      │
      ▼
Wazuh Detection Rule
      │
      ▼
Shuffle Workflow
      │
      ├── Extract SHA-256
      │
      ├── VirusTotal Lookup
      │
      ├── Create TheHive Incident
      │
      └── Send Email
      ▼
SOC Analyst
```

## ⚙️ Installation Overview

The original project documentation covers the installation and
configuration process for the major components.

### Prerequisites

-   Ubuntu host/server
-   Windows endpoint
-   Docker Engine
-   Docker Compose
-   Network connectivity between the SOC components
-   Wazuh
-   Shuffle
-   TheHive
-   Cassandra
-   Elasticsearch
-   Sysmon
-   VirusTotal account/API key

### High-Level Setup

1.  Install Docker Engine and Docker Compose on the Ubuntu host.
2.  Deploy Shuffle using Docker.
3.  Install and configure Wazuh.
4.  Install Cassandra for TheHive.
5.  Install and configure Elasticsearch.
6.  Install and configure TheHive.
7.  Install Sysmon on the Windows endpoint.
8.  Install and connect the Wazuh agent.
9.  Configure Wazuh to ingest Sysmon logs.
10. Configure Wazuh to retain the required event archives.
11. Create the custom Mimikatz detection rule.
12. Create a Shuffle webhook workflow.
13. Configure Wazuh-to-Shuffle integration.
14. Add SHA-256 extraction to the Shuffle workflow.
15. Configure VirusTotal enrichment.
16. Configure TheHive integration.
17. Configure email notification.
18. Generate test alerts and validate the complete workflow.

## 🔐 Security Notes

This project is intended for **authorized lab and educational
environments**.

### Credentials and API Keys

Do **not** commit the following to GitHub:

-   TheHive passwords
-   Shuffle administrator passwords
-   VirusTotal API keys
-   TheHive API keys
-   Email credentials
-   Private IP addresses or sensitive infrastructure details

Use environment variables, secret managers, or local configuration files
instead.

If credentials are included in screenshots or documentation, redact them
before publishing the repository.

## 🧪 Testing

The workflow can be tested by generating a controlled Mimikatz detection
on the Windows lab endpoint.

A successful test should demonstrate the following sequence:

``` text
Mimikatz Execution
        ↓
Sysmon Event Generated
        ↓
Wazuh Alert
        ↓
Shuffle Webhook Triggered
        ↓
SHA-256 Extracted
        ↓
VirusTotal Lookup
        ↓
TheHive Incident Created
        ↓
Email Notification Sent
```

The final verification should confirm that the alert reaches the analyst
without requiring continuous manual monitoring of Wazuh.

## 📊 Expected Outcome

After successful configuration, the project provides an automated
alert-to-incident pipeline where a detected security event can be:

**Detected → Enriched → Ticketed → Notified**

This demonstrates core SOC concepts including:

-   SIEM
-   SOAR
-   Endpoint Monitoring
-   Detection Engineering
-   Threat Intelligence
-   Incident Response
-   Alert Enrichment
-   Security Automation

## 📁 Suggested Repository Structure

``` text
SOC-Automation/
│
├── README.md
├── wazuh/
│   ├── rules/
│   └── configuration/
│
├── shuffle/
│   └── workflows/
│
├── thehive/
│   └── configuration/
│
├── sysmon/
│   └── configuration/
│
├── screenshots/
│   ├── wazuh/
│   ├── shuffle/
│   ├── thehive/
│   └── virustotal/
│
└── docs/
    └── SOC-Automation.pdf
```

## 🧠 Key SOC Skills Demonstrated

This project demonstrates practical experience with:

-   **SIEM:** Wazuh
-   **SOAR:** Shuffle
-   **SIRP / Case Management:** TheHive
-   **Endpoint Telemetry:** Sysmon
-   **Threat Intelligence:** VirusTotal
-   **Detection Engineering:** Custom Wazuh rules
-   **Log Analysis:** Windows and Sysmon events
-   **Automation:** Webhooks and workflow orchestration
-   **Incident Response:** Automated case creation and analyst
    notification
-   **Linux Administration:** Ubuntu services and configuration
-   **Docker:** Containerized application deployment

## 📚 Documentation

The repository's project documentation contains the detailed
installation and configuration procedure, including Wazuh, Shuffle,
TheHive, Cassandra, Elasticsearch, Sysmon, custom detection rules,
integrations, and workflow testing.

## ⚠️ Disclaimer

This project is intended strictly for educational, defensive security,
and authorized laboratory use.

Do not deploy or test security tools against systems, networks,
accounts, or data without explicit authorization.

## 👤 Author

**Sahil**

Cybersecurity \| SOC Analyst \| Blue Team

------------------------------------------------------------------------

⭐ If this project helped you understand SOC automation, consider giving
the repository a star.
