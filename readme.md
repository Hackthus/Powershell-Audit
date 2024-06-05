# Audit système Windows

Ce script PowerShell permet de réaliser un audit du système Windows pour collecter diverses informations sur le système d'exploitation, le matériel, les utilisateurs locaux, les logiciels installés, le stockage, la RAM et la carte graphique.

## Comment utiliser le script

1. Assurez-vous que PowerShell est installé sur votre système.
2. Téléchargez le script https://github.com/Hackthus/Powershell-Audit.git sur votre ordinateur.
3. Ouvrez une fenêtre PowerShell en tant qu'administrateur.
4. Accédez au répertoire contenant le script téléchargé.
5. Exécutez le script en utilisant la commande suivante :

   .\powershell-audit.ps1

    Les résultats de l'audit seront affichés dans la console et enregistrés dans un fichier audit_results.txt.

## Contenu du rapport d'audit

Le rapport d'audit contient les informations suivantes :

    Informations sur le système d'exploitation (nom, version, architecture, etc.).
    Informations sur le matériel (fabricant du PC, modèle, nombre de processeurs, etc.).
    Informations sur la RAM (modules de RAM, capacité, vitesse, etc.).
    Informations sur la carte graphique (nom, mémoire vidéo, processeur vidéo, etc.).
    Utilisateurs locaux et leurs rôles.
    Logiciels installés.
    Informations sur le stockage (lecteurs, taille, espace libre, etc.).

## Configuration supplémentaire

    Vous pouvez personnaliser le script en fonction de vos besoins en ajoutant ou en supprimant des fonctionnalités.
    Assurez-vous d'exécuter le script en tant qu'administrateur pour accéder à toutes les informations.

## Avertissement

Ce script est fourni tel quel, sans garantie d'aucune sorte. Assurez-vous de comprendre ce que fait le script avant de l'exécuter sur votre système.

## Contributions

Les contributions sous forme de suggestions, de rapports de bogues ou de nouvelles fonctionnalités sont les bienvenues. N'hésitez pas à créer une issue ou à ouvrir une pull request.

Auteur : H@ckthus
 

 

