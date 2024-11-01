#!/bin/bash

URL=$1

ORANGE='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if the URL starts with http:// or https://
if [[ ! $URL =~ ^https?:// ]]; then
    # If not, prepend http:// and https:// to the URL for checks
    urls_to_check=("http://$URL" "https://$URL")
else
    # If it does, use the provided URL
    urls_to_check=("$URL")
fi

# Function to perform checks on a given URL
check_url() {
    local url=$1
    local content=$(curl -s "$url")

    tld_whitelist="(com|net|org|biz|info|io|gov|edu|co|us|uk|de|jp|cn|fr|nl|ru|br|au|in|ch|it|es|mil|tv|cc|me|xyz|club|online|site|tech|store|blog|app|dev|ai|cloud)"
    subdomain_pattern='\b([a-zA-Z0-9_-]+\.)+[a-zA-Z]{2,6}\b'
    whitelist_pattern="\.$tld_whitelist$"
    exclude_extensions='(html|js|css|php|json|xml|png|jpg|svg|gif|ico)$'

    subdomains=$(echo "$content" | grep -oE "$subdomain_pattern" | grep -E "$whitelist_pattern" | grep -vE "$exclude_extensions" | sort -u)
    if [[ -n "$subdomains" ]]; then
        echo -e "${ORANGE}Subdomains found on main page:${NC} ${RED}$url${NC}"
        echo "$subdomains"
    fi

    ip_addresses=$(echo "$content" | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | sort -u)
    if [[ -n "$ip_addresses" ]]; then
        echo -e "${ORANGE}IP addresses found on main page:${NC} ${RED}$url${NC}"
        echo "$ip_addresses"
    fi

    js_files=$(echo "$content" | grep -oE 'src="[^"]+\.js"' | sed 's/src="//; s/"$//')

    for js_file in $js_files; do
        if [[ $js_file != http* ]]; then
            js_file="$url/$js_file"
        fi

        js_content=$(curl -s "$js_file")

        js_subdomains=$(echo "$js_content" | grep -oE "$subdomain_pattern" | grep -E "$whitelist_pattern" | grep -vE "$exclude_extensions" | sort -u)
        js_ip_addresses=$(echo "$js_content" | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | sort -u)

        if [[ -n "$js_subdomains" || -n "$js_ip_addresses" ]]; then
            echo -e "${ORANGE}Subdomains found in:${NC} ${RED}$js_file:${NC}"
            
            if [[ -n "$js_subdomains" ]]; then
                echo "$js_subdomains"
            fi
            
            if [[ -n "$js_ip_addresses" ]]; then
                echo -e "${ORANGE}IP addresses found in:${NC} ${RED}$js_file:${NC}"
                echo "$js_ip_addresses"
            fi
        fi
    done
}

# Check each URL in the array
for url in "${urls_to_check[@]}"; do
    check_url "$url"
done
