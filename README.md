# Subdomain and IP Finder Script

This is a Bash script that scans a given URL for subdomains and IP addresses found in the main HTML page and its linked JavaScript files. It filters results based on a predefined whitelist of top-level domains (TLDs) and excludes common file types.

## Features

- Extracts subdomains and IP addresses from the main page of the provided URL.
- Scans all JavaScript files linked in the HTML for additional subdomains and IP addresses.
- Uses a configurable whitelist of TLDs to focus the search.

## Prerequisites

- Bash shell
- `curl` utility installed on your system
- Basic familiarity with running scripts in the terminal

## Usage

Make the script executable:

```
chmod +x ispider.sh
```
Run the script with a URL as an argument:
```
./ispider.sh http://example.com
```
Replace http://example.com with the URL you want to scan.


## Output
The script will output:

Subdomains found on the main page.
IP addresses found on the main page.
Subdomains and IP addresses found in linked JavaScript files.

Example Output:
```
Subdomains found on main page: http://192.168.1.12
api.example.com
sub1.example.com
sub2.example.com
sub3.example.com
test.example.com
Subdomains found in: http://192.168.1.12/ips.js:
IP addresses found in http://192.168.1.12/ips.js:
10.0.0.1
172.16.0.1
192.168.1.1
198.51.100.1
203.0.113.1
```
Color Codes:
- Orange: Section headers
- Red: Highlighted URLs

License
This project is licensed under the MIT License - see the LICENSE file for details.