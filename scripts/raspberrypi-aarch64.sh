#!/bin/bash

# Raspberry Pi aarch64
# Author: Bogachenko Vyacheslav <bogachenkove@gmail.com>
# License: MIT license <https://raw.githubusercontent.com/bogachenko/lib/master/LICENSE.md>
# Last update: January 2026

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
MAX_RETRIES=3
RETRY_DELAY=5
PING_TARGET="1.1.1.1"

# Log function for consistent output
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Optimized function to check internet connectivity
check_internet_connection() {
    local timeout=3
    local count=2
    
    if ping -c $count -W $timeout $PING_TARGET > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Function to wait for internet reconnection
wait_for_internet() {
    local retries=0
    
    while [[ $retries -lt $MAX_RETRIES ]]; do
        if check_internet_connection; then
            log_info "Internet connection restored"
            return 0
        fi
        
        log_warning "No internet connection. Retrying in ${RETRY_DELAY} seconds... (Attempt $((retries + 1))/$MAX_RETRIES)"
        sleep $RETRY_DELAY
        ((retries++))
    done
    
    log_error "Failed to restore internet connection after $MAX_RETRIES attempts"
    return 1
}

# Function to check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
    log_info "Root privileges confirmed"
}

# Function to check internet connectivity (initial)
check_internet() {
    if ! check_internet_connection; then
        log_error "No internet connection detected (ping $PING_TARGET failed)"
        exit 1
    fi
    log_info "Internet connection confirmed (ping $PING_TARGET successful)"
}

# Function to backup and update journald configuration
update_journald_config() {
    local config_file="/etc/systemd/journald.conf"
    local backup_file="/etc/systemd/journald.conf.backup"
    
    log_info "Updating journald configuration..."
    
    # Backup existing configuration
    if [[ -f "$config_file" ]]; then
        cp "$config_file" "$backup_file"
        if [[ $? -ne 0 ]]; then
            log_error "Failed to backup $config_file"
            return 1
        fi
        log_info "Backup created at $backup_file"
    else
        log_warning "Original config file not found, creating new one"
    fi
    
    # Create new configuration
    cat > "$config_file" << 'EOF'
[Journal]
Storage=volatile
Compress=yes
Seal=yes
SplitMode=uid
SyncIntervalSec=5m
RateLimitIntervalSec=30s
RateLimitBurst=10000
RuntimeMaxUse=50M
MaxFileSec=3day
EOF
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to create new journald configuration"
        return 1
    fi
    
    # Restart journald service
    log_info "Restarting systemd-journald service..."
    systemctl restart systemd-journald
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to restart systemd-journald"
        return 1
    fi
    
    log_info "Journald configuration updated successfully"
    return 0
}

# Function to configure APT package manager
configure_apt() {
    log_info "Configuring APT package manager..."
    
    local apt_conf_file="/etc/apt/apt.conf.d/00-apt-conf"
    
    # Create APT configuration
    sh -c 'printf "APT::Install-Suggests \"0\";\nAPT::Install-Recommends \"0\";" > /etc/apt/apt.conf.d/00-apt-conf'
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to configure APT package manager"
        return 1
    fi
    
    log_info "APT configuration created at $apt_conf_file"
    
    # Verify the configuration file
    if [[ -f "$apt_conf_file" ]]; then
        log_info "APT configuration content:"
        cat "$apt_conf_file"
    else
        log_error "APT configuration file was not created"
        return 1
    fi
    
    log_info "APT package manager configured successfully"
    return 0
}

# Function to configure system localization
configure_locale() {
    log_info "Configuring system localization..."
    
    local locale_gen_file="/etc/locale.gen"
    local locale_gen_backup="/etc/locale.gen.backup"
    local default_locale_file="/etc/default/locale"
    local environment_file="/etc/environment"
    
    # Backup and update locale.gen
    if [[ -f "$locale_gen_file" ]]; then
        cp "$locale_gen_file" "$locale_gen_backup"
        if [[ $? -ne 0 ]]; then
            log_error "Failed to backup $locale_gen_file"
            return 1
        fi
        log_info "Backup created at $locale_gen_backup"
    else
        log_warning "Original locale.gen file not found"
    fi
    
    # Create new locale.gen file
    echo "en_US.UTF-8 UTF-8" > "$locale_gen_file"
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to create $locale_gen_file"
        return 1
    fi
    
    # Generate locales
    log_info "Generating locales..."
    locale-gen
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to generate locales"
        return 1
    fi
    
    # Create /etc/default/locale file
    echo "LANG=en_US.UTF-8" > "$default_locale_file"
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to create $default_locale_file"
        return 1
    fi
    
    # Create /etc/environment file
    cat > "$environment_file" << 'EOF'
LANG=en_US.UTF-8
EOF
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to create $environment_file"
        return 1
    fi
    
    # Set environment variables for current session
    export LANG=en_US.UTF-8
    
    log_info "Localization configured successfully"
    log_info "LANG=$LANG"
    
    return 0
}

# Function to update package database with retry on internet failure
update_package_db() {
    log_info "Updating package database..."
    
    local retries=0
    local success=false
    
    while [[ $retries -lt $MAX_RETRIES && $success == false ]]; do
        apt update --yes
        
        if [[ $? -eq 0 ]]; then
            success=true
            log_info "Package database updated successfully"
        else
            ((retries++))
            if [[ $retries -lt $MAX_RETRIES ]]; then
                log_warning "Package update failed. Checking internet connection..."
                
                if ! check_internet_connection; then
                    log_warning "Internet disconnected. Waiting for reconnection..."
                    if ! wait_for_internet; then
                        log_error "Cannot restore internet connection"
                        return 1
                    fi
                fi
                
                log_info "Retrying package database update... (Attempt $((retries + 1))/$MAX_RETRIES)"
            fi
        fi
    done
    
    if [[ $success == false ]]; then
        log_error "Package database update failed after $MAX_RETRIES attempts"
        return 1
    fi
    
    return 0
}

# Function to upgrade packages with retry on internet failure
upgrade_system() {
    log_info "Starting system upgrade..."
    
    local retries=0
    local success=false
    
    while [[ $retries -lt $MAX_RETRIES && $success == false ]]; do
        apt upgrade --yes
        
        if [[ $? -eq 0 ]]; then
            success=true
            log_info "System upgrade completed successfully"
        else
            ((retries++))
            if [[ $retries -lt $MAX_RETRIES ]]; then
                log_warning "System upgrade failed. Checking internet connection..."
                
                if ! check_internet_connection; then
                    log_warning "Internet disconnected. Waiting for reconnection..."
                    if ! wait_for_internet; then
                        log_error "Cannot restore internet connection"
                        return 1
                    fi
                fi
                
                log_info "Retrying system upgrade... (Attempt $((retries + 1))/$MAX_RETRIES)"
            fi
        fi
    done
    
    if [[ $success == false ]]; then
        log_error "System upgrade failed after $MAX_RETRIES attempts"
        return 1
    fi
    
    return 0
}

# Function to install main packages with retry on internet failure
install_main_packages() {
    local packages=(
        "plymouth"
        "apparmor"
        "dnsutils"
        "dnsmasq"
        "hostapd"
        "encfs"
        "cryfs"
        "lshw"
        "whois"
        "lsof"
        "iptables"
        "iptables-persistent"
    )
    
    log_info "Installing main packages..."
    log_info "Package list: ${packages[*]}"
    
    local retries=0
    local success=false
    
    while [[ $retries -lt $MAX_RETRIES && $success == false ]]; do
        apt install --yes "${packages[@]}"
        
        if [[ $? -eq 0 ]]; then
            success=true
            log_info "Main packages installed successfully"
            
            # Save iptables rules
            log_info "Saving iptables rules for persistence..."
            
            # Create iptables directory if it doesn't exist
            local iptables_dir="/etc/iptables"
            if [[ ! -d "$iptables_dir" ]]; then
                log_info "Creating directory $iptables_dir"
                mkdir -p "$iptables_dir"
            fi
            
            # Save current iptables rules
            iptables-save > "$iptables_dir/iptables.rules"
            ip6tables-save > "$iptables_dir/ip6tables.rules"
            
            if [[ $? -eq 0 ]]; then
                log_info "Iptables rules saved successfully"
                
                # Save rules for netfilter-persistent
                if command -v netfilter-persistent &> /dev/null; then
                    log_info "Saving rules with netfilter-persistent..."
                    netfilter-persistent save
                    
                    if [[ $? -eq 0 ]]; then
                        log_info "Netfilter-persistent rules saved successfully"
                    else
                        log_warning "Failed to save netfilter-persistent rules"
                    fi
                else
                    log_warning "netfilter-persistent command not found"
                fi
            else
                log_warning "Failed to save iptables rules"
            fi
            
        else
            ((retries++))
            if [[ $retries -lt $MAX_RETRIES ]]; then
                log_warning "Main packages installation failed. Checking internet connection..."
                
                if ! check_internet_connection; then
                    log_warning "Internet disconnected. Waiting for reconnection..."
                    if ! wait_for_internet; then
                        log_error "Cannot restore internet connection"
                        return 1
                    fi
                fi
                
                # Update package list before retrying
                log_info "Updating package list before retry..."
                apt update --yes
                
                log_info "Retrying main packages installation... (Attempt $((retries + 1))/$MAX_RETRIES)"
            fi
        fi
    done
    
    if [[ $success == false ]]; then
        log_error "Main packages installation failed after $MAX_RETRIES attempts"
        return 1
    fi
    
    return 0
}

# Function to install semi-main packages with retry on internet failure
install_semi_main_packages() {
    local packages=(
        "vim"
        "git"
        "wget"
        "curl"
        "python3"
        "python3-pip"
        "perl"
        "php"
        "gpm"
    )
    
    log_info "Installing semi-main packages..."
    log_info "Package list: ${packages[*]}"
    
    local retries=0
    local success=false
    
    while [[ $retries -lt $MAX_RETRIES && $success == false ]]; do
        apt install --yes "${packages[@]}"
        
        if [[ $? -eq 0 ]]; then
            success=true
            log_info "Semi-main packages installed successfully"
        else
            ((retries++))
            if [[ $retries -lt $MAX_RETRIES ]]; then
                log_warning "Semi-main packages installation failed. Checking internet connection..."
                
                if ! check_internet_connection; then
                    log_warning "Internet disconnected. Waiting for reconnection..."
                    if ! wait_for_internet; then
                        log_error "Cannot restore internet connection"
                        return 1
                    fi
                fi
                
                # Update package list before retrying
                log_info "Updating package list before retry..."
                apt update --yes
                
                log_info "Retrying semi-main packages installation... (Attempt $((retries + 1))/$MAX_RETRIES)"
            fi
        fi
    done
    
    if [[ $success == false ]]; then
        log_error "Semi-main packages installation failed after $MAX_RETRIES attempts"
        return 1
    fi
    
    return 0
}

# Function to install additional packages with retry on internet failure
install_additional_packages() {
    local packages=(
        "tmux"
        "profanity"
        "yt-dlp"
        "tor"
        "obfs4proxy"
        "privoxy"
        "i2pd"
        "cups"
        "bluetooth"
        "apache2"
    )
    
    log_info "Installing additional packages..."
    log_info "Package list: ${packages[*]}"
    
    local retries=0
    local success=false
    
    while [[ $retries -lt $MAX_RETRIES && $success == false ]]; do
        apt install --yes "${packages[@]}"
        
        if [[ $? -eq 0 ]]; then
            success=true
            log_info "Additional packages installed successfully"
        else
            ((retries++))
            if [[ $retries -lt $MAX_RETRIES ]]; then
                log_warning "Additional packages installation failed. Checking internet connection..."
                
                if ! check_internet_connection; then
                    log_warning "Internet disconnected. Waiting for reconnection..."
                    if ! wait_for_internet; then
                        log_error "Cannot restore internet connection"
                        return 1
                    fi
                fi
                
                # Update package list before retrying
                log_info "Updating package list before retry..."
                apt update --yes
                
                log_info "Retrying additional packages installation... (Attempt $((retries + 1))/$MAX_RETRIES)"
            fi
        fi
    done
    
    if [[ $success == false ]]; then
        log_error "Additional packages installation failed after $MAX_RETRIES attempts"
        return 1
    fi
    
    # Install AdGuardHome
    log_info "Installing AdGuardHome..."
    local adguard_retries=0
    local adguard_success=false
    
    while [[ $adguard_retries -lt $MAX_RETRIES && $adguard_success == false ]]; do
        # Check internet before attempting installation
        if ! check_internet_connection; then
            log_warning "No internet connection for AdGuardHome installation. Waiting for reconnection..."
            if ! wait_for_internet; then
                log_error "Cannot restore internet connection for AdGuardHome"
                return 1
            fi
        fi
        
        # Install AdGuardHome using official script
        curl -fsSL https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
        
        if [[ $? -eq 0 ]]; then
            adguard_success=true
            log_info "AdGuardHome installed successfully"
            
            # Configure DNS for AdGuardHome
            log_info "Configuring DNS for AdGuardHome..."
            
            local resolved_conf_dir="/etc/systemd/resolved.conf.d"
            local adguard_conf_file="$resolved_conf_dir/adguardhome.conf"
            local resolv_conf_backup="/etc/resolv.conf.backup"
            
            # Create resolved.conf.d directory if it doesn't exist
            if [[ ! -d "$resolved_conf_dir" ]]; then
                log_info "Creating directory $resolved_conf_dir"
                mkdir -p "$resolved_conf_dir"
                
                if [[ $? -ne 0 ]]; then
                    log_error "Failed to create directory $resolved_conf_dir"
                    return 1
                fi
            fi
            
            # Create AdGuardHome DNS configuration
            cat > "$adguard_conf_file" << 'EOF'
[Resolve]
DNS=127.0.0.1
DNSStubListener=no
EOF
            
            if [[ $? -ne 0 ]]; then
                log_error "Failed to create AdGuardHome DNS configuration"
                return 1
            fi
            
            log_info "AdGuardHome DNS configuration created at $adguard_conf_file"
            
            # Backup existing resolv.conf
            if [[ -f "/etc/resolv.conf" ]]; then
                mv "/etc/resolv.conf" "$resolv_conf_backup"
                
                if [[ $? -ne 0 ]]; then
                    log_error "Failed to backup /etc/resolv.conf"
                    return 1
                fi
                
                log_info "Backup created at $resolv_conf_backup"
            else
                log_warning "/etc/resolv.conf not found, skipping backup"
            fi
            
            # Create symlink to systemd-resolved resolv.conf
            ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
            
            if [[ $? -ne 0 ]]; then
                log_error "Failed to create symlink for /etc/resolv.conf"
                return 1
            fi
            
            log_info "Created symlink /etc/resolv.conf -> /run/systemd/resolve/resolv.conf"
            
            # Restart systemd-resolved service
            log_info "Restarting systemd-resolved service..."
            systemctl restart systemd-resolved
            
            if [[ $? -ne 0 ]]; then
                log_error "Failed to restart systemd-resolved service"
                return 1
            fi
            
            # Verify configuration
            log_info "Verifying DNS configuration..."
            log_info "Current /etc/resolv.conf:"
            cat /etc/resolv.conf
            
            log_info "AdGuardHome DNS configuration applied successfully"
            
        else
            ((adguard_retries++))
            if [[ $adguard_retries -lt $MAX_RETRIES ]]; then
                log_warning "AdGuardHome installation failed. Retrying in ${RETRY_DELAY} seconds... (Attempt $((adguard_retries + 1))/$MAX_RETRIES)"
                sleep $RETRY_DELAY
            fi
        fi
    done
    
    if [[ $adguard_success == false ]]; then
        log_warning "AdGuardHome installation failed after $MAX_RETRIES attempts, continuing..."
    fi
    
    # Install AdGuardVPN CLI
    log_info "Installing AdGuardVPN CLI..."
    local adguard_vpn_retries=0
    local adguard_vpn_success=false
    
    while [[ $adguard_vpn_retries -lt $MAX_RETRIES && $adguard_vpn_success == false ]]; do
        # Check internet before attempting installation
        if ! check_internet_connection; then
            log_warning "No internet connection for AdGuardVPN CLI installation. Waiting for reconnection..."
            if ! wait_for_internet; then
                log_error "Cannot restore internet connection for AdGuardVPN CLI"
                return 1
            fi
        fi
        
        # Install AdGuardVPN CLI using official script
        curl -fsSL https://raw.githubusercontent.com/AdguardTeam/AdGuardVPNCLI/HEAD/scripts/release/install.sh | sh -s -- -v
        
        if [[ $? -eq 0 ]]; then
            adguard_vpn_success=true
            log_info "AdGuardVPN CLI installed successfully"
        else
            ((adguard_vpn_retries++))
            if [[ $adguard_vpn_retries -lt $MAX_RETRIES ]]; then
                log_warning "AdGuardVPN CLI installation failed. Retrying in ${RETRY_DELAY} seconds... (Attempt $((adguard_vpn_retries + 1))/$MAX_RETRIES)"
                sleep $RETRY_DELAY
            fi
        fi
    done
    
    if [[ $adguard_vpn_success == false ]]; then
        log_warning "AdGuardVPN CLI installation failed after $MAX_RETRIES attempts, continuing..."
    fi
    
    return 0
}

# Function to configure firewall
configure_firewall() {
    log_info "Configuring firewall..."
    
    # TCP ports configuration
    declare -A tcp_ports=(
        ["22"]="SSH"
        ["443"]="HTTPS/DNSCrypt"
        ["465"]="SMTP"
        ["53"]="DNS"
        ["631"]="Internet Printing Protocol"
        ["80"]="HTTP"
        ["8080"]="Apache"
        ["853"]="DoT/DoQ"
        ["9050"]="TOR"
        ["8118"]="Privoxy"
        ["993"]="IMAPS"
        ["5900"]="VNC"
        ["5222"]="XMPP"
        ["5269"]="XMPP alternative"
        ["51413"]="Transmission"
    )
    
    # UDP ports configuration
    declare -A udp_ports=(
        ["53"]="DNS"
        ["67"]="DHCP server v4"
        ["68"]="DHCP client v4"
        ["80"]="HTTP"
        ["443"]="HTTPS/DNSCrypt"
        ["465"]="SMTP"
        ["8080"]="Apache"
        ["853"]="DoT/DoQ"
        ["993"]="IMAPS"
        ["547"]="DHCP server v6"
        ["546"]="DHCP client v6"
    )
    
    # Flush existing rules and delete user-defined chains
    log_info "Flushing existing iptables rules and deleting user-defined chains..."
    iptables -F
    iptables -X
    iptables -t nat -F
    iptables -t nat -X
    iptables -t mangle -F
    iptables -t mangle -X
    
    ip6tables -F
    ip6tables -X
    ip6tables -t nat -F
    ip6tables -t nat -X
    ip6tables -t mangle -F
    ip6tables -t mangle -X
    
    # Allow loopback interface
    log_info "Configuring loopback interface rules..."
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    
    ip6tables -A INPUT -i lo -j ACCEPT
    ip6tables -A OUTPUT -o lo -j ACCEPT
    
    # Allow established connections
    log_info "Allowing established connections..."
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    
    ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    ip6tables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    
    # Configure TCP ports
    log_info "Configuring TCP ports..."
    for port in "${!tcp_ports[@]}"; do
        local description="${tcp_ports[$port]}"
        log_info "Opening TCP port $port ($description)"
        iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
        ip6tables -A INPUT -p tcp --dport "$port" -j ACCEPT
    done
    
    # Configure UDP ports
    log_info "Configuring UDP ports..."
    for port in "${!udp_ports[@]}"; do
        local description="${udp_ports[$port]}"
        log_info "Opening UDP port $port ($description)"
        iptables -A INPUT -p udp --dport "$port" -j ACCEPT
        ip6tables -A INPUT -p udp --dport "$port" -j ACCEPT
    done
    
    # Set default policies
    log_info "Setting default policies..."
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT
    
    ip6tables -P INPUT DROP
    ip6tables -P FORWARD DROP
    ip6tables -P OUTPUT ACCEPT
    
    # Create iptables directory if it doesn't exist
    local iptables_dir="/etc/iptables"
    if [[ ! -d "$iptables_dir" ]]; then
        log_info "Creating directory $iptables_dir"
        mkdir -p "$iptables_dir"
    fi
    
    # Save IPv4 rules
    log_info "Saving IPv4 firewall rules..."
    iptables-save > "$iptables_dir/iptables.rules"
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to save IPv4 firewall rules"
        return 1
    fi
    
    # Save IPv6 rules
    log_info "Saving IPv6 firewall rules..."
    ip6tables-save > "$iptables_dir/ip6tables.rules"
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to save IPv6 firewall rules"
        return 1
    fi
    
    # Save rules with netfilter-persistent
    log_info "Saving rules with netfilter-persistent..."
    if command -v netfilter-persistent &> /dev/null; then
        netfilter-persistent save
        
        if [[ $? -eq 0 ]]; then
            log_info "Netfilter-persistent rules saved successfully"
        else
            log_warning "Failed to save netfilter-persistent rules"
        fi
    else
        log_warning "netfilter-persistent command not found"
    fi
    
    # Display summary
    log_info "Firewall configuration summary:"
    log_info "TCP ports opened: ${!tcp_ports[@]}"
    log_info "UDP ports opened: ${!udp_ports[@]}"
    
    log_info "Current IPv4 rules:"
    iptables -L -n --line-numbers
    
    log_info "Current IPv6 rules:"
    ip6tables -L -n --line-numbers
    
    log_info "Firewall configured successfully"
    return 0
}

# Main execution flow
main() {
    log_info "Starting system configuration script"
    
    # Initial checks
    check_root
    check_internet
    
    # Update journald configuration
    update_journald_config
    if [[ $? -ne 0 ]]; then
        log_warning "Journald update encountered issues, continuing..."
    fi
    
    # Configure APT package manager
    configure_apt
    if [[ $? -ne 0 ]]; then
        log_error "APT configuration failed, aborting"
        exit 1
    fi
    
    # Configure localization
    configure_locale
    if [[ $? -ne 0 ]]; then
        log_error "Localization configuration failed, aborting"
        exit 1
    fi
    
    # Update package database
    update_package_db
    if [[ $? -ne 0 ]]; then
        log_error "Package update failed, aborting"
        exit 1
    fi
    
    # Upgrade system
    upgrade_system
    if [[ $? -ne 0 ]]; then
        log_error "System upgrade failed, aborting"
        exit 1
    fi
    
    # Install main packages
    install_main_packages
    if [[ $? -ne 0 ]]; then
        log_error "Main packages installation failed, aborting"
        exit 1
    fi
    
    # Install semi-main packages
    install_semi_main_packages
    if [[ $? -ne 0 ]]; then
        log_error "Semi-main packages installation failed, aborting"
        exit 1
    fi
    
    # Install additional packages
    install_additional_packages
    if [[ $? -ne 0 ]]; then
        log_error "Additional packages installation failed, aborting"
        exit 1
    fi
    
    # Configure firewall
    configure_firewall
    if [[ $? -ne 0 ]]; then
        log_error "Firewall configuration failed, aborting"
        exit 1
    fi
    
    log_info "All operations completed successfully"
    exit 0
}

# Handle script termination
trap 'log_error "Script interrupted by user"; exit 1' INT TERM

# Execute main function
main
