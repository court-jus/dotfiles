BEGIN {
    print "debut fichier"
    RS="[\n]+"
    patient_encours=0
    }
$0 ~ "^H" {
    print "bloc entete", $0
    FS=substr($0, 2, 1)
    print "nouveau FS :",FS
    }
$0 ~ "^P" {
    print "bloc patient", patient_encours
    patients[patient_encours]=$6
    patient_encours++
    }
$0 ~ "^OBR" {
    print "bloc OBR", $1
    }
$0 ~ "^OBX" {
    print "bloc OBX", $1
    }
$0 ~ "^L" {
    print "bloc fin", $1
    }
END {
    print "fin du fichier",length(patients),"patients traités"
    }
