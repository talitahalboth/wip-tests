#!/bin/bash

echo "=============================================="
echo "Firewall and Network Diagnostics & Fixes"
echo "=============================================="
echo

# Function to test connectivity
test_connectivity() {
    local host=$1
    local port=${2:-80}
    echo "Testing connectivity to $host:$port..."
    
    if command -v nc >/dev/null 2>&1; then
        if timeout 5 nc -z "$host" "$port" 2>/dev/null; then
            echo "  ✓ Connection to $host:$port successful"
            return 0
        else
            echo "  ✗ Connection to $host:$port failed"
            return 1
        fi
    elif command -v telnet >/dev/null 2>&1; then
        if timeout 5 telnet "$host" "$port" </dev/null 2>/dev/null | grep -q "Connected"; then
            echo "  ✓ Connection to $host:$port successful"
            return 0
        else
            echo "  ✗ Connection to $host:$port failed"
            return 1
        fi
    else
        echo "  ! No network testing tools available (nc/telnet)"
        return 2
    fi
}

# Function to check DNS resolution
check_dns() {
    local host=$1
    echo "Checking DNS resolution for $host..."
    
    if command -v nslookup >/dev/null 2>&1; then
        if nslookup "$host" >/dev/null 2>&1; then
            echo "  ✓ DNS resolution for $host successful"
            nslookup "$host" | grep "Address:" | head -2 | sed 's/^/    /'
        else
            echo "  ✗ DNS resolution for $host failed"
        fi
    elif command -v dig >/dev/null 2>&1; then
        if dig "$host" +short >/dev/null 2>&1; then
            echo "  ✓ DNS resolution for $host successful"
            dig "$host" +short | sed 's/^/    /'
        else
            echo "  ✗ DNS resolution for $host failed"
        fi
    else
        echo "  ! No DNS tools available"
    fi
}

echo "1. System Information:"
echo "   User: $(whoami)"
echo "   UID/GID: $(id)"
echo "   Container: $([ -f /.dockerenv ] && echo "Yes" || echo "No")"
echo "   OS: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || echo "Unknown")"
echo

echo "2. Network Interface Information:"
if command -v ip >/dev/null 2>&1; then
    echo "   Interfaces:"
    ip addr show | grep -E "^[0-9]+:|inet " | sed 's/^/     /'
else
    echo "   Network interfaces:"
    ifconfig 2>/dev/null | grep -E "^[a-z]|inet " | sed 's/^/     /' || echo "     ifconfig not available"
fi
echo

echo "3. Routing Information:"
if command -v ip >/dev/null 2>&1; then
    echo "   Default route:"
    ip route show default | sed 's/^/     /' 2>/dev/null || echo "     No default route found"
    echo "   All routes:"
    ip route show | head -5 | sed 's/^/     /'
else
    echo "   Routes:"
    route -n 2>/dev/null | head -5 | sed 's/^/     /' || echo "     route command not available"
fi
echo

echo "4. DNS Configuration:"
if [ -f /etc/resolv.conf ]; then
    echo "   DNS servers from /etc/resolv.conf:"
    grep "^nameserver" /etc/resolv.conf | sed 's/^/     /' || echo "     No nameserver entries found"
else
    echo "   /etc/resolv.conf not found"
fi
echo

echo "5. Firewall Status:"
# Check iptables
if command -v iptables >/dev/null 2>&1; then
    echo "   iptables rules (INPUT):"
    iptables -L INPUT -n 2>/dev/null | head -10 | sed 's/^/     /' || echo "     Cannot read iptables rules"
    echo "   iptables rules (OUTPUT):"
    iptables -L OUTPUT -n 2>/dev/null | head -10 | sed 's/^/     /' || echo "     Cannot read iptables rules"
else
    echo "   iptables not available"
fi

# Check ufw
if command -v ufw >/dev/null 2>&1; then
    echo "   UFW status:"
    ufw status 2>/dev/null | sed 's/^/     /' || echo "     Cannot check UFW status"
else
    echo "   UFW not available"
fi
echo

echo "6. Container Network Configuration:"
if [ -f /.dockerenv ]; then
    echo "   Running in Docker container"
    echo "   Docker network interfaces:"
    ip addr show | grep -E "docker|veth|br-" | sed 's/^/     /' || echo "     No Docker interfaces found"
else
    echo "   Not running in Docker container"
fi
echo

echo "7. DNS Resolution Tests:"
for host in google.com github.com 8.8.8.8; do
    check_dns "$host"
done
echo

echo "8. Connectivity Tests:"
echo "   Testing common ports and services..."

# Test common services
test_connectivity "8.8.8.8" "53"          # Google DNS
test_connectivity "1.1.1.1" "53"          # Cloudflare DNS
test_connectivity "google.com" "80"       # HTTP
test_connectivity "google.com" "443"      # HTTPS
test_connectivity "github.com" "443"      # GitHub HTTPS
test_connectivity "github.com" "22"       # GitHub SSH

echo

echo "9. Common Firewall Fixes:"
echo "   Available fix commands (run manually if needed):"
echo

# Suggest fixes based on environment
if command -v iptables >/dev/null 2>&1; then
    echo "   # Allow outbound HTTP/HTTPS traffic:"
    echo "   sudo iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT"
    echo "   sudo iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT"
    echo
    echo "   # Allow DNS queries:"
    echo "   sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT"
    echo "   sudo iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT"
    echo
    echo "   # Allow all outbound traffic (if safe):"
    echo "   sudo iptables -P OUTPUT ACCEPT"
    echo
fi

if command -v ufw >/dev/null 2>&1; then
    echo "   # UFW fixes:"
    echo "   sudo ufw allow out 80/tcp"
    echo "   sudo ufw allow out 443/tcp"
    echo "   sudo ufw allow out 53"
    echo "   sudo ufw --force enable"
    echo
fi

echo "   # DNS fixes:"
echo "   echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf"
echo "   echo 'nameserver 1.1.1.1' | sudo tee -a /etc/resolv.conf"
echo

echo "10. Attempting Automatic Fixes:"
echo "    (These will only work if you have appropriate permissions)"
echo

# Try some automatic fixes
if [ "$EUID" -eq 0 ]; then
    echo "   Running as root, attempting fixes..."
    
    # Try to allow outbound traffic
    if command -v iptables >/dev/null 2>&1; then
        echo "   Setting permissive iptables OUTPUT policy..."
        iptables -P OUTPUT ACCEPT 2>/dev/null && echo "   ✓ iptables OUTPUT policy set to ACCEPT" || echo "   ✗ Failed to set iptables policy"
    fi
    
    # Try to fix DNS
    if [ -w /etc/resolv.conf ]; then
        echo "   Updating DNS configuration..."
        {
            echo "nameserver 8.8.8.8"
            echo "nameserver 1.1.1.1"
            echo "nameserver 1.0.0.1"
        } > /etc/resolv.conf 2>/dev/null && echo "   ✓ DNS configuration updated" || echo "   ✗ Failed to update DNS"
    fi
else
    echo "   Not running as root, skipping automatic fixes"
    echo "   Run with sudo or as root to attempt automatic fixes"
fi

echo
echo "11. Final Connectivity Test:"
echo "   Testing connectivity after potential fixes..."
test_connectivity "google.com" "80"
test_connectivity "8.8.8.8" "53"

echo
echo "=============================================="
echo "Firewall Diagnostics Complete"
echo "=============================================="
echo
echo "If issues persist:"
echo "1. Check container/VM network configuration"
echo "2. Verify host firewall settings"
echo "3. Check proxy/VPN settings"
echo "4. Contact system administrator"
echo