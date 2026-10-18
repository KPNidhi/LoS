#!/bin/bash

# ==========================================
# USB ACTIVITY & DATA LEAK RISK MONITOR
# Beginner Linux Shell Scripting Project
# ==========================================

DEVICE_FILE="devices.txt"
TRANSFER_FILE="transfers.txt"
REPORT_FILE="security_report.txt"

# Risk thresholds
LARGE_TRANSFER_MB=500

# Check whether the required input files exist
if [ ! -f "$DEVICE_FILE" ] || [ ! -f "$TRANSFER_FILE" ]; then
    echo "Error: Required data files are missing."
    echo "Please create devices.txt and transfers.txt."
    exit 1
fi


# ------------------------------------------
# Function 1: Display all device activity
# ------------------------------------------

show_activity() {
    echo ""
    echo "========== USB ACTIVITY =========="

    sed 's/|/ | /g' "$DEVICE_FILE"

    echo ""
    sed 's/|/ | /g' "$TRANSFER_FILE"
}


# ------------------------------------------
# Function 2: Find unknown devices
# ------------------------------------------

find_unknown_devices() {
    echo ""
    echo "========== UNKNOWN DEVICES =========="

    if grep -q '|UNKNOWN$' "$DEVICE_FILE"; then
        grep '|UNKNOWN$' "$DEVICE_FILE" |
            sed 's/|/ | /g'
    else
        echo "No unknown devices found."
    fi
}


# ------------------------------------------
# Function 3: Detect large transfers
# ------------------------------------------

find_large_transfers() {
    echo ""
    echo "========== LARGE TRANSFERS =========="
    echo "Threshold: ${LARGE_TRANSFER_MB} MB"

    awk -F'|' -v limit="$LARGE_TRANSFER_MB" '
        NR > 1 && $5 ~ /^[0-9]+([.][0-9]+)?$/ && $5 > limit {
            print
        }
    ' "$TRANSFER_FILE" |
        sed 's/|/ | /g'

    echo ""
    echo "Analysis complete."
}


# ------------------------------------------
# Function 4: Find sensitive file access
# ------------------------------------------

find_sensitive_files() {
    echo ""
    echo "========== SENSITIVE FILE ACTIVITY =========="

    if grep -iE '(^|[|])(confidential\.pdf|passwords\.txt|database_backup\.zip)([|]|$)' "$TRANSFER_FILE"; then
        echo ""
        echo "Review these simulated events."
    else
        echo "No matching sensitive file names found."
    fi
}


# ------------------------------------------
# Function 5: Generate security report
# ------------------------------------------

generate_report() {

    {
        echo "======================================"
        echo " USB ACTIVITY & DATA LEAK RISK REPORT"
        echo "======================================"
        echo "Generated: $(date)"
        echo ""

        echo "1. UNKNOWN DEVICES"
        echo "--------------------------------------"

        grep '|UNKNOWN$' "$DEVICE_FILE" |
            sed 's/|/ | /g'

        echo ""
        echo "2. LARGE TRANSFERS"
        echo "--------------------------------------"

        awk -F'|' -v limit="$LARGE_TRANSFER_MB" '
            NR > 1 && $5 ~ /^[0-9]+([.][0-9]+)?$/ && $5 > limit {
                print
            }
        ' "$TRANSFER_FILE" |
            sed 's/|/ | /g'

        echo ""
        echo "3. SENSITIVE FILE ACTIVITY"
        echo "--------------------------------------"

        grep -iE '(^|[|])(confidential\.pdf|passwords\.txt|database_backup\.zip)([|]|$)' "$TRANSFER_FILE" |
            sed 's/|/ | /g'

        echo ""
        echo "4. TOTAL VALID TRANSFER RECORDS"
        echo "--------------------------------------"

        awk -F'|' '
            NR > 1 &&
            NF == 6 &&
            $5 ~ /^[0-9]+([.][0-9]+)?$/ {
                count++
            }
            END {
                print count+0
            }
        ' "$TRANSFER_FILE"

        echo ""
        echo "5. TOTAL TRANSFER SIZE"
        echo "--------------------------------------"

        awk -F'|' '
            NR > 1 &&
            NF == 6 &&
            $5 ~ /^[0-9]+([.][0-9]+)?$/ {
                total += $5
            }
            END {
                printf "%.2f MB\n", total
            }
        ' "$TRANSFER_FILE"

        echo ""
        echo "======================================"
        echo "END OF REPORT"
        echo "======================================"

    } > "$REPORT_FILE"

    echo ""
    echo "Security report generated successfully."
    echo "Saved as: $REPORT_FILE"
}


# ------------------------------------------
# Main menu
# ------------------------------------------

while true
do
    echo ""
    echo "=========================================="
    echo " USB ACTIVITY & DATA LEAK RISK MONITOR"
    echo "=========================================="
    echo "1. View USB activity"
    echo "2. Detect unknown devices"
    echo "3. Detect large transfers"
    echo "4. Detect sensitive file activity"
    echo "5. Generate security report"
    echo "6. Exit"
    echo "=========================================="

    read -r -p "Enter your choice: " choice

    case "$choice" in

        1)
            show_activity
            ;;

        2)
            find_unknown_devices
            ;;

        3)
            find_large_transfers
            ;;

        4)
            find_sensitive_files
            ;;

        5)
            generate_report
            ;;

        6)
            echo "Exiting USB Risk Monitor."
            break
            ;;

        *)
            echo "Invalid choice. Enter a number from 1 to 6."
            ;;

    esac

done
