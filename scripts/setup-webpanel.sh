#!/bin/bash

CNTRY=("Andorra" "United Arab Emirates" "Afghanistan" "Antigua & Barbuda" "Anguilla" "Albania" "Armenia" "Angola" "Antarctica" "Argentina" "American Samoa" "Austria" "Australia" "Aruba" "Aland Islands" "Azerbaijan"
       "Bosnia & Herzegovina" "Barbados" "Bangladesh" "Belgium" "Burkina Faso" "Bulgaria" "Bahrain" "Burundi" "Benin" "Saint Barthelemy" "Bermuda" "Brunei" "Bolivia" "Bonaire Sint Eustatius & Saba" "Brazil" "Bahamas" "Bhutan" "Bouvet Island" "Botswana" "Belarus" "Belize"
       "Canada" "Cocos Islands" "Congo DRC" "Central African Republic" "Congo" "Switzerland" "Cote dIvoire" "Cook Islands" "Chile" "Cameroon" "China" "Colombia" "Costa Rica" "Cuba" "Cape Verde" "Curacao" "Christmas Island" "Cyprus" "Czech Republic"
       "Germany" "Djibouti" "Denmark" "Dominica" "Dominican Republic" "Algeria"
       "Ecuador" "Estonia" "Egypt" "Western Sahara" "Eritrea" "Spain" "Ethiopia"
       "Finland" "Fiji" "Falkland Islands" "Micronesia" "Faroe Islands" "France"
       "Gabon" "United Kingdom" "Grenada" "Georgia" "French Guiana" "Guernsey" "Ghana" "Gibraltar" "Greenland" "Gambia" "Guinea" "Guadeloupe" "Equatorial Guinea" "Greece" "South Georgia & the South Sandwich Islands" "Guatemala" "Guam" "Guinea Bissau" "Guyana"
       "Hong Kong" "Heard Island & McDonald Islands" "Honduras" "Croatia" "Haiti" "Hungary"
       "Indonesia" "Ireland" "Israel" "Isle of Man" "India" "British Indian Ocean Territory" "Iraq" "Iran" "Iceland" "Italy"
       "Jersey" "Jamaica" "Jordan" "Japan"
       "Kenya" "Kyrgyzstan" "Cambodia" "Kiribati" "Comoros" "Saint Kitts & Nevis" "North Korea" "South Korea" "Kuwait" "Cayman Islands" "Kazakhstan"
       "Laos" "Lebanon Saint Lucia" "Liechtenstein" "Sri Lanka" "Liberia" "Lesotho" "Lithuania" "Luxembourg" "Latvia" "Libya"
       "Morocco" "Monaco" "Moldova" "Montenegro" "Saint Martin" "Madagascar" "Marshall Islands" "North Macedonia" "Mali" "Myanmar" "Mongolia" "Macao" "Northern Mariana Islands" "Martinique" "Mauritania" "Montserrat" "Malta" "Mauritius" "Maldives" "Malawi" "Mexico" "Malaysia" "Mozambique"
       "Namibia" "New Caledonia" "Niger" "Norfolk Island" "Nigeria" "Nicaragua" "Netherlands" "Norway" "Nepal" "Nauru" "Niue" "New Zealand"
       "Oman"
       "Panama" "Peru" "French Polynesia" "Papua New Guinea" "Philippines" "Pakistan" "Poland" "Saint Pierre & Miquelon" "Pitcairn" "Puerto Rico" "Palestine" "Portugal" "Palau" "Paraguay"
       "Qatar"
       "Reunion" "Romania" "Serbia" "Russia" "Rwanda"
       "Saudi Arabia" "Solomon Islands" "Seychelles" "Sudan" "Sweden" "Singapore" "Saint Helena" "Slovenia" "Svalbard & Jan Mayen" "Slovakia" "Sierra Leone" "San Marino" "Senegal" "Somalia" "Suriname" "South Sudan" "Sao Tome & Principe" "El Salvador" "Sint Maarten" "Syria" "Eswatini"
       "Turks & Caicos Islands" "Chad" "French Southern Territories" "Togo" "Thailand" "Tajikistan" "Tokelau" "Timor Leste" "Turkmenistan" "Tunisia" "Tonga" "Turkey" "Trinidad & Tobago" "Tuvalu" "Taiwan" "Tanzania"
       "Ukraine" "Uganda" "United States Minor Outlying Islands" "United States" "Uruguay" "Uzbekistan"
       "Vatican City" "Saint Vincent & the Grenadines" "Venezuela" "British Virgin Islands" "U.S. Virgin Islands" "Vietnam" "Vanuatu"
       "Wallis & Futuna" "Samoa"
       "Yemen" "Mayotte"
       "South Africa" "Zambia" "Zimbabwe"
)

CODE=("AD" "AE" "AF" "AG" "AI" "AL" "AM" "AO" "AQ" "AR" "AS" "AT" "AU" "AW" "AX" "AZ"
      "BA" "BB" "BD" "BE" "BF" "BG" "BH" "BI" "BJ" "BL" "BM" "BN" "BO" "BQ" "BR" "BS" "BT" "BV" "BW" "BY" "BZ"
      "CA" "CC" "CD" "CF" "CG" "CH" "CI" "CK" "CL" "CM" "CN" "CO" "CR" "CU" "CV" "CW" "CX" "CY" "CZ"
      "DE" "DJ" "DK" "DM" "DO" "DZ"
      "EC" "EE" "EG" "EH" "ER" "ES" "ET"
      "FI" "FJ" "FK" "FM" "FO" "FR"
      "GA" "GB" "GD" "GE" "GF" "GG" "GH" "GI" "GL" "GM" "GN" "GP" "GQ" "GR" "GS" "GT" "GU" "GW" "GY"
      "HK" "HM" "HN" "HR" "HT" "HU"
      "ID" "IE" "IL" "IM" "IN" "IO" "IQ" "IR" "IS" "IT"
      "JE" "JM" "JO" "JP"
      "KE" "KG" "KH" "KI" "KM" "KN" "KP" "KR" "KW" "KY" "KZ"
      "LA" "LB" "LC" "LI" "LK" "LR" "LS" "LT" "LU" "LV" "LY"
      "MA" "MC" "MD" "ME" "MF" "MG" "MH" "MK" "ML" "MM" "MN" "MO" "MP" "MQ" "MR" "MS" "MT" "MU" "MV" "MW" "MX" "MY" "MZ"
      "NA" "NC" "NE" "NF" "NG" "NI" "NL" "NO" "NP" "NR" "NU" "NZ"
      "OM"
      "PA" "PE" "PF" "PG" "PH" "PK" "PL" "PM" "PN" "PR" "PS" "PT" "PW" "PY"
      "QA"
      "RE" "RO" "RS" "RU" "RW"
      "SA" "SB" "SC" "SD" "SE" "SG" "SH" "SI" "SJ" "SK" "SL" "SM" "SN" "SO" "SR" "SS" "ST" "SV" "SX" "SY" "SZ"
      "TC" "TD" "TF" "TG" "TH" "TJ" "TK" "TL" "TM" "TN" "TO" "TR" "TT" "TV" "TW" "TZ"
      "UA" "UG" "UM" "US" "UY" "UZ"
      "VA" "VC" "VE" "VG" "VI" "VN" "VU"
      "WF" "WS"
      "YE" "YT"
      "ZA" "ZM" "ZW"
)

ZONE=("Europe/Andorra" "Asia/Dubai" "Asia/Kabul" "America/Antigua" "America/Anguilla" "Europe/Tirane" "Asia/Yerevan" "Africa/Luanda" "Antarctica/McMurdo" "America/Argentina/Buenos_Aires" "Pacific/Pago_Pago" "Europe/Vienna" "Australia/Sydney" "America/Aruba" "Europe/Mariehamn" "Asia/Baku"
      "Europe/Sarajevo" "America/Barbados" "Asia/Dhaka" "Europe/Brussels" "Africa/Ouagadougou" "Europe/Sofia" "Asia/Bahrain" "Africa/Bujumbura" "Africa/Porto-Novo" "America/St_Barthelemy" "Atlantic/Bermuda" "Asia/Brunei" "America/La_Paz" "America/Kralendijk" "America/Sao_Paulo" "America/Nassau" "Asia/Thimphu" "Antarctica/Troll" "Africa/Gaborone" "Europe/Minsk" "America/Belize"
      "America/Toronto" "Indian/Cocos" "Africa/Kinshasa" "Africa/Bangui" "Africa/Brazzaville" "Europe/Zurich" "Africa/Abidjan" "Pacific/Rarotonga" "America/Santiago" "Africa/Douala" "Asia/Shanghai" "America/Bogota" "America/Costa_Rica" "America/Havana" "Atlantic/Cape_Verde" "America/Curacao" "Indian/Christmas" "Asia/Nicosia" "Europe/Prague"
      "Europe/Berlin" "Africa/Djibouti" "Europe/Copenhagen" "America/Dominica" "America/Santo_Domingo" "Africa/Algiers"
      "America/Guayaquil" "Europe/Tallinn" "Africa/Cairo" "Africa/El_Aaiun" "Africa/Asmara" "Europe/Madrid" "Africa/Addis_Ababa"
      "Europe/Helsinki" "Pacific/Fiji" "Atlantic/Stanley" "Pacific/Pohnpei" "Atlantic/Faroe" "Europe/Paris"
      "Africa/Libreville" "Europe/London" "America/Grenada" "Asia/Tbilisi" "America/Cayenne" "Europe/London" "Africa/Accra" "Europe/Gibraltar" "America/Nuuk" "Africa/Banjul" "Africa/Conakry" "America/Guadeloupe" "Africa/Malabo" "Europe/Athens" "Atlantic/South_Georgia" "America/Guatemala" "Pacific/Guam" "Africa/Bissau" "America/Guyana"
      "Asia/Hong_Kong" "Antarctica/McMurdo" "America/Tegucigalpa" "Europe/Zagreb" "America/Port-au-Prince" "Europe/Budapest"
      "Asia/Jakarta" "Europe/Dublin" "Asia/Jerusalem" "Europe/Isle_of_Man" "Asia/Kolkata" "Indian/Chagos" "Asia/Baghdad" "Asia/Tehran" "Atlantic/Reykjavik" "Europe/Rome"
      "Europe/Jersey" "America/Jamaica" "Asia/Amman" "Asia/Tokyo"
      "Africa/Nairobi" "Asia/Bishkek" "Asia/Phnom_Penh" "Pacific/Tarawa" "Indian/Comoro" "America/St_Kitts" "Asia/Pyongyang" "Asia/Seoul" "Asia/Kuwait" "America/Cayman" "Asia/Almaty"
      "Asia/Vientiane" "Asia/Beirut" "America/St_Lucia" "Europe/Vaduz" "Asia/Colombo" "Africa/Monrovia" "Africa/Maseru" "Europe/Vilnius" "Europe/Luxembourg" "Europe/Riga" "Africa/Tripoli"
      "Africa/Casablanca" "Europe/Monaco" "Europe/Chisinau" "Europe/Podgorica" "America/Marigot" "Indian/Antananarivo" "Pacific/Majuro" "Europe/Skopje" "Africa/Bamako" "Asia/Yangon" "Asia/Ulaanbaatar" "Asia/Macau" "Pacific/Saipan" "America/Martinique" "Africa/Nouakchott" "America/Montserrat" "Europe/Malta" "Indian/Mauritius" "Indian/Maldives" "Africa/Blantyre" "America/Mexico_City" "Asia/Kuala_Lumpur" "Africa/Maputo"
      "Africa/Windhoek" "Pacific/Noumea" "Africa/Niamey" "Pacific/Norfolk" "Africa/Lagos" "America/Managua" "Europe/Amsterdam" "Europe/Oslo" "Asia/Kathmandu" "Pacific/Nauru" "Pacific/Niue" "Pacific/Auckland"
      "Asia/Muscat"
      "America/Panama" "America/Lima" "Pacific/Tahiti" "Pacific/Port_Moresby" "Asia/Manila" "Asia/Karachi" "Europe/Warsaw" "America/Miquelon" "Pacific/Pitcairn" "America/Puerto_Rico" "Asia/Gaza" "Europe/Lisbon" "Pacific/Palau" "America/Asuncion"
      "Asia/Qatar"
      "Indian/Reunion" "Europe/Bucharest" "Europe/Belgrade" "Europe/Moscow" "Africa/Kigali"
      "Asia/Riyadh" "Pacific/Guadalcanal" "Indian/Mahe" "Africa/Khartoum" "Europe/Stockholm" "Asia/Singapore" "Atlantic/St_Helena" "Europe/Ljubljana" "Arctic/Longyearbyen" "Europe/Bratislava" "Africa/Freetown" "Europe/San_Marino" "Africa/Dakar" "Africa/Mogadishu" "America/Paramaribo" "Africa/Juba" "Africa/Sao_Tome" "America/El_Salvador" "America/Lower_Princes" "Asia/Damascus" "Africa/Mbabane"
      "America/Grand_Turk" "Africa/Ndjamena" "Antarctica/DumontDUrville" "Africa/Lome" "Asia/Bangkok" "Asia/Dushanbe" "Pacific/Fakaofo" "Asia/Dili" "Asia/Ashgabat" "Africa/Tunis" "Pacific/Tongatapu" "Europe/Istanbul" "America/Port_of_Spain" "Pacific/Funafuti" "Asia/Taipei" "Africa/Dar_es_Salaam"
      "Europe/Kyiv" "Africa/Kampala" "Pacific/Wake" "America/New_York" "America/Montevideo" "Asia/Tashkent"
      "Europe/Vatican" "America/St_Vincent" "America/Caracas" "America/Tortola" "America/St_Thomas" "Asia/Ho_Chi_Minh" "Pacific/Efate"
      "Pacific/Wallis" "Pacific/Apia"
      "Asia/Aden" "Indian/Mayotte"
      "Africa/Johannesburg" "Africa/Lusaka" "Africa/Harare"
)

isValid() {
    local XX="${1}"
    local X

    for X in "${!CODE[@]}"; do
        if [ "${CODE[${X}]}" = "${XX}" ]; then
            echo "${X}"
            return 0
        fi
    done
    return 1
}

# Create symbolic links

IDX=$(isValid "${1^^}")
if [ -z "${IDX}" ]; then
    IDX=$(isValid "CH")
fi

/usr/bin/timedatectl set-timezone ${ZONE[${IDX}]}
/usr/bin/systemctl enable regdom@${CODE[${IDX}]}

/usr/bin/systemctl enable splash
/usr/bin/systemctl enable http
/usr/bin/systemctl disable systemd-networkd
/usr/bin/systemctl enable connman
