<#
.SYNOPSIS
   Identifie le type d'encodage d'un fichier texte.

.DESCRIPTION
   Retourne le type d'encodage d'un fichier texte en se basant sur le BOM s'il existe.
   BOM = Byte Order Mark

.EXAMPLE
   ./Get-FileTypeEncoding.ps1 -Path C:\temp\test.ps1

.NOTES
   Version 1.0, par Arnaud PETITJEAN - Start-Scripting.io
#>

Param (
    [parameter(Mandatory)]
    [string]$Path
)

# définition des variables et constantes
Set-Variable -Name UTF8    -Value 'EFBBBF'   -Option constant
Set-Variable -Name UTF16LE -Value 'FFFE'     -Option constant
Set-Variable -Name UTF16BE -Value 'FEFF'     -Option constant
Set-Variable -Name UTF32LE -Value 'FFFE0000' -Option constant
Set-Variable -Name UTF32BE -Value '0000FEFF' -Option constant

$fic = Get-Content -Path $Path -Encoding byte -First 4
# Mise en forme des octets lus sur 2 car. et conversion en Hexa
# ex : 0 -> 00, ou 10 -> 0A au lieu de A
# et concaténation des octets dans une chaîne pour effectuer la
#comparaison
[string]$strLue = [string]('{0:x}' -f $fic[0]).PadLeft(2, '0') +
                  [string]('{0:x}' -f $fic[1]).PadLeft(2, '0') +
                  [string]('{0:x}' -f $fic[2]).PadLeft(2, '0') +
                  [string]('{0:x}' -f $fic[3]).PadLeft(2, '0')
Switch -regex ($strLue){
       "^$UTF32LE"  {'Unicode UTF32LE'; break}
       "^$UTF32BE"  {'Unicode UTF32BE'; break}
       "^$UTF8"     {'Unicode UTF8   '; break}
       "^$UTF16LE"  {'Unicode UTF16LE'; break}
       "^$UTF16BE"  {'Unicode UTF16BE'; break}
       default # le fichier n'est pas encodé en Unicode,
       {     # on approfondit l'examen du fichier...
          # Recherche d'un octet dont la valeur est > 127
          $fic = Get-Content -Path $path -Encoding byte
          if ($fic -gt 127) {
            'ANSI'
          }
          else {
             'ASCII'
          }              
       } #fin default
} #fin switch