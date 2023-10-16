#!/bin/bash

# Function to check if a command is available
check_command() {
  if ! command -v $1 &>/dev/null; then
    return 1
  fi
}

# Check for dependencies and install them if missing
dependencies=("wget" "unzip" "gawk" "sqlite3")
missing_dependencies=()

for dep in "${dependencies[@]}"; do
  if ! check_command "$dep"; then
    missing_dependencies+=("$dep")
  fi
done

if [ "${#missing_dependencies[@]}" -gt 0 ]; then
  echo "The following dependencies are missing and will be installed: ${missing_dependencies[@]}"
  if [ -f "/etc/os-release" ]; then
    source /etc/os-release
    if [ "$ID" == "ubuntu" ] || [ "$ID" == "debian" ]; then
      sudo apt-get update
      sudo apt-get install -y "${missing_dependencies[@]}"
    elif [ "$ID" == "fedora" ] || [ "$ID" == "centos" ]; then
      sudo dnf install -y "${missing_dependencies[@]}"
    elif [ "$ID" == "arch" ]; then
      sudo pacman -S --noconfirm "${missing_dependencies[@]}"
    else
      echo "Unsupported Linux distribution. Please install the following dependencies manually: ${missing_dependencies[@]}"
      exit 1
    fi
  else
    echo "Unsupported Linux distribution. Please install the following dependencies manually: ${missing_dependencies[@]}"
    exit 1
  fi
fi

# Prompt the user for a working directory with sufficient free space
default_directory="$HOME/Documents/Data"
while true; do
  read -p "Enter a working directory (default: $default_directory): " working_directory
  working_directory="${working_directory:-$default_directory}"
  
  if [ ! -d "$working_directory" ]; then
    read -p "The selected directory does not exist. Do you want to create it? (y/n): " create_directory
    if [ "$create_directory" == "y" ]; then
      mkdir -p "$working_directory"
    else
      echo "Please choose another location or create the directory manually."
      continue
    fi
  fi
  
  # Check if the directory has at least 50 GB of free space
  free_space=$(df -k --output=avail "$working_directory" | tail -n 1)
  required_space=$((50 * 1024 * 1024)) # 50 GB in kilobytes
  if [ "$free_space" -ge "$required_space" ]; then
    break
  else
    echo "The selected directory does not have at least 50 GB of free space. Please choose another location."
  fi
done

cd "$working_directory" ;
wget http://www.doc.state.nc.us/offenders/PublicTables.pdf ;
mkdir Offender_Profile ;
cd "$working_directory/Offender_Profile/" ;
wget http://www.doc.state.nc.us/offenders/OFNT3AA1.zip ;
unzip OFNT3AA1.zip ;
rm OFNT3AA1.zip ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > OFNT3AA1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm OFNT3AA1.des ;
rm OFNT3AA1.dat ;

cd "$working_directory" ;
mkdir Probation_and_Parole_Client_Profile ;
cd "$working_directory/Probation_and_Parole_Client_Profile/" ;
wget http://www.doc.state.nc.us/offenders/APPT7AA1.zip ;
unzip APPT7AA1.zip ;
rm APPT7AA1.zip ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > APPT7AA1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm APPT7AA1.dat ;
rm APPT7AA1.des ;

cd "$working_directory" ;
mkdir Impact_Scheduling_Request ;
cd "$working_directory/Impact_Scheduling_Request/" ;
wget http://www.doc.state.nc.us/offenders/APPT9BJ1.zip ;
unzip APPT9BJ1.zip ;
rm APPT9BJ1.zip ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > APPT9BJ1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm APPT9BJ1.des;
rm APPT9BJ1.dat;


cd "$working_directory" ;
mkdir Inmate_Profile ;
cd "$working_directory/Inmate_Profile/" ;
wget http://www.doc.state.nc.us/offenders/INMT4AA1.zip ;
unzip INMT4AA1.zip ;
rm INMT4AA1.zip ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > INMT4AA1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm INMT4AA1.des;
rm INMT4AA1.dat;

cd "$working_directory" ;
mkdir Sentence_Computations ;
cd "$working_directory/Sentence_Computations/" ;
wget http://www.doc.state.nc.us/offenders/INMT4BB1.zip ;
unzip INMT4BB1.zip ;
rm INMT4BB1.zip ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > INMT4BB1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm INMT4BB1.des;
rm INMT4BB1.dat;

cd "$working_directory" ;
mkdir Parole_Analyst_Review ;
cd "$working_directory/Parole_Analyst_Review/" ;
wget http://www.doc.state.nc.us/offenders/INMT4CA1.zip ;
unzip INMT4CA1.zip ;
rm INMT4CA1.zip ;
sed -i 's/PCSPCON1      SPECIAL COND. (PAROLE ANAL.)       CHAR      24      30/PCSPCON1      SPECIAL COND1. (PAROLE ANAL.)      CHAR      24      30/' INMT4CA1.des ;
sed -i 's/PCSPCON2      SPECIAL COND. (PAROLE ANAL.)       CHAR      54      30/PCSPCON2      SPECIAL COND2. (PAROLE ANAL.)      CHAR      54      30/' INMT4CA1.des ;  
sed -i 's/PCSPCON3      SPECIAL COND. (PAROLE ANAL.)       CHAR      84      30/PCSPCON3      SPECIAL COND3. (PAROLE ANAL.)      CHAR      84      30/' INMT4CA1.des ;  
sed -i 's/PCSPCON4      SPECIAL COND. (PAROLE ANAL.)       CHAR      114     30/PCSPCON4      SPECIAL COND4. (PAROLE ANAL.)      CHAR      114     30/' INMT4CA1.des ;  
sed -i 's/PCSPCON5      SPECIAL COND. (PAROLE ANAL.)       CHAR      144     30/PCSPCON5      SPECIAL COND5. (PAROLE ANAL.)      CHAR      144     30/' INMT4CA1.des ;  
sed -i 's/PCSPCON6      SPECIAL COND. (PAROLE ANAL.)       CHAR      174     30/PCSPCON6      SPECIAL COND6. (PAROLE ANAL.)      CHAR      174     30/' INMT4CA1.des ;  
sed -i 's/PCSPCON7      SPECIAL COND. (PAROLE ANAL.)       CHAR      204     30/PCSPCON7      SPECIAL COND7. (PAROLE ANAL.)      CHAR      204     30/' INMT4CA1.des ;  
sed -i 's/PCSPCON8      SPECIAL COND. (PAROLE ANAL.)       CHAR      234     30/PCSPCON8      SPECIAL COND8. (PAROLE ANAL.)      CHAR      234     30/' INMT4CA1.des ;  
sed -i 's/PCSPCON9      SPECIAL COND. (PAROLE ANAL.)       CHAR      264     30/PCSPCON9      SPECIAL COND9. (PAROLE ANAL.)      CHAR      264     30/' INMT4CA1.des ;  
sed -i 's/PCSPCON10     SPECIAL COND. (PAROLE ANAL.)       CHAR      294     30/PCSPCON10     SPECIAL COND10. (PAROLE ANAL.)     CHAR      294     30/' INMT4CA1.des ;  
sed -i 's/PCSPCON11     SPECIAL COND. (PAROLE ANAL.)       CHAR      324     30/PCSPCON11     SPECIAL COND11. (PAROLE ANAL.)     CHAR      324     30/' INMT4CA1.des ;  
sed -i 's/PCSPCON12     SPECIAL COND. (PAROLE ANAL.)       CHAR      354     30/PCSPCON12     SPECIAL COND12. (PAROLE ANAL.)     CHAR      354     30/' INMT4CA1.des ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > INMT4CA1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm INMT4CA1.des;
rm INMT4CA1.dat;

cd "$working_directory" ;
mkdir Disciplinary_Infractions ;
cd "$working_directory/Disciplinary_Infractions/" ;
wget http://www.doc.state.nc.us/offenders/INMT9CF1.zip ;
unzip INMT9CF1.zip ;
rm INMT9CF1.zip ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > INMT9CF1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm INMT9CF1.des;
rm INMT9CF1.dat;

cd "$working_directory" ;
mkdir Financial_Obligation ;
cd "$working_directory/Financial_Obligation/" ;
wget http://www.doc.state.nc.us/offenders/OFNT1BA1.zip ;
unzip OFNT1BA1.zip ;
rm OFNT1BA1.zip ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > OFNT1BA1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm OFNT1BA1.des;
rm OFNT1BA1.dat;

cd "$working_directory" ;
mkdir Court_Commmitment ;
cd "$working_directory/Court_Commmitment/" ;
wget http://www.doc.state.nc.us/offenders/OFNT3BB1.zip ;
unzip OFNT3BB1.zip ;
rm OFNT3BB1.zip ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > OFNT3BB1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm OFNT3BB1.des;
rm OFNT3BB1.dat;

cd "$working_directory" ;
mkdir Sentence_Component ;
cd "$working_directory/Sentence_Component/" ;
wget http://www.doc.state.nc.us/offenders/OFNT3CE1.zip ;
unzip OFNT3CE1.zip ;
rm OFNT3CE1.zip ;

sed -i 's/CMSNTYPE      SENTENCE TYPE CODE                 CHAR      471     30/CMSNTYPE      SENTENCE TYPE CODE1                CHAR      471     30/' OFNT3CE1.des ;
sed -i 's/CMSNTYP2      SENTENCE TYPE CODE                 CHAR      501     30/CMSNTYPE      SENTENCE TYPE CODE2                CHAR      501     30/' OFNT3CE1.des ;
sed -i 's/CMSNTYP3      SENTENCE TYPE CODE                 CHAR      531     30/CMSNTYPE      SENTENCE TYPE CODE3                CHAR      531     30/' OFNT3CE1.des ;
sed -i 's/CMSNTYP4      SENTENCE TYPE CODE                 CHAR      561     30/CMSNTYPE      SENTENCE TYPE CODE4                CHAR      561     30/' OFNT3CE1.des ;
sed -i 's/CMSNTYP5      SENTENCE TYPE CODE                 CHAR      591     30/CMSNTYPE      SENTENCE TYPE CODE5                CHAR      591     30/' OFNT3CE1.des ;
sed -i 's/CMSNTYP6      SENTENCE TYPE CODE                 CHAR      621     30/CMSNTYPE      SENTENCE TYPE CODE6                CHAR      621     30/' OFNT3CE1.des ;

variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > OFNT3CE1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm OFNT3CE1.des;
rm OFNT3CE1.dat;

cd "$working_directory" ;
mkdir Special_Conditions_and_Sanctions ;
cd "$working_directory/Special_Conditions_and_Sanctions/" ;
wget http://www.doc.state.nc.us/offenders/OFNT3DE1.zip ;
unzip OFNT3DE1.zip ;
rm OFNT3DE1.zip ;
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > OFNT3DE1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm OFNT3DE1.des;
rm OFNT3DE1.dat;

cd "$working_directory" ;
mkdir Warrant_Issued ;
cd "$working_directory/Warrant_Issued/" ;
wget http://www.doc.state.nc.us/offenders/OFNT9BE1.zip ;
unzip OFNT9BE1.zip ;
rm OFNT9BE1.zip
variable=$(cut -c68,69 *.des | tr -s [:space:] ' ' | tr -d 'a-z' | tr -d 'A-Z' | awk '{$1=$1};1') ;
gawk '$1=$1' OFS=, FIELDWIDTHS="$variable" *.dat > OFNT9BE1.csv ;
variable=$(sed '0,/Name/{/Name/d;}' *.des | cut -c15-48 | awk '{$1=$1};1' | sed '$!s/$/,/' | awk 'BEGIN { ORS = "" } { print }') ;
sed -i 1i"$variable" *.csv;
rm OFNT9BE1.des;
rm OFNT9BE1.dat;

cd "$working_directory";
echo -e "\n.mode csv" "\n.import ${working_directory}/Court_Commmitment/OFNT3BB1.csv Court_Commitment" "\n.import ${working_directory}/Disciplinary_Infractions/INMT9CF1.csv Disciplinary_Infractions" "\n.import ${working_directory}/Financial_Obligation/OFNT1BA1.csv Financial_Obligation" "\n.import ${working_directory}/Impact_Scheduling_Request/APPT9BJ1.csv Impact_Scheduling_Request" "\n.import ${working_directory}/Inmate_Profile/INMT4AA1.csv Inmate_Profile" "\n.import ${working_directory}/Offender_Profile/OFNT3AA1.csv Offender_Profile" "\n.import ${working_directory}/Parole_Analyst_Review/INMT4CA1.csv Parole_Analyst_Review" "\n.import ${working_directory}/Probation_and_Parole_Client_Profile/APPT7AA1.csv Probation_and_Parole_Client_Profile" "\n.import ${working_directory}/Sentence_Component/OFNT3CE1.csv Sentence_Component" "\n.import ${working_directory}/Sentence_Computations/INMT4BB1.csv Sentence_Computations" "\n.import ${working_directory}/Special_Conditions_and_Sanctions/OFNT3DE1.csv Special_Conditions_and_Sanctions" "\n.import ${working_directory}/Warrant_Issued/OFNT9BE1.csv Warrant_Issued" | sqlite3 DATABASE.db ;
find "$working_directory" -mindepth 1 -maxdepth 1 -type d -exec rm -r {} \;