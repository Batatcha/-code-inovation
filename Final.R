# Installer les bibliothèques si nécessaire
packages <- c("ncdf4", "leaflet", "dplyr", "RColorBrewer", "htmlwidgets")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

# Charger les bibliothèques
library(ncdf4)
library(leaflet)
library(dplyr)
library(RColorBrewer)
library(htmlwidgets)

# 📂 1. Ouvrir le fichier NetCDF (à adapter selon les fichiers EMODnet)
nc_file <- "D:/R_learning_projects/Chemical_data_2018-2021_superGG.nc"
nc_data <- nc_open(nc_file)

# 🔍 2. Lire les variables de base
lon <- ncvar_get(nc_data, "longitude")  # Longitude
lat <- ncvar_get(nc_data, "latitude")   # Latitude

# 🏊‍♂️ 3. Extraire les variables d'intérêt (Moyenne sur le temps)
extract_mean <- function(varname) {
  var_data <- drop(ncvar_get(nc_data, varname))  # Récupérer les valeurs
  apply(var_data, c(1,2), mean, na.rm = TRUE)   # Moyenne sur le temps
}

nitrate_mean <- extract_mean("no3")
phosphate_mean <- extract_mean("po4")
chlorophylle_mean <- extract_mean("chl")
oxygene_mean <- extract_mean("o2")

# 🔎 4. Filtrer les concentrations
seuils <- list(
  nitrate = 161.3,      # mmol/m³
  phosphate = 1.05,    # mmol/m³
  chlorophylle =0.0224 ,  # mmol/m³
  oxygene = 62.5         # mmol/m³ (hypoxie : concentration critique pour l'oxygène)
)

filter_excess <- function(data, seuil, condition = "sup") {
  if (condition == "sup") {
    return(which(data > seuil, arr.ind = TRUE))  # Valeurs supérieures au seuil
  } else {
    return(which(data < seuil, arr.ind = TRUE))  # Valeurs inférieures au seuil
  }
}

nitrate_excess <- filter_excess(nitrate_mean, seuils$nitrate, "sup")
phosphate_excess <- filter_excess(phosphate_mean, seuils$phosphate, "sup")
chlorophylle_excess <- filter_excess(chlorophylle_mean, seuils$chlorophylle, "sup")
oxygene_hypoxie <- filter_excess(oxygene_mean, seuils$oxygene, "inf")  # Hypoxie = valeurs < seuil

# 📊 5. Créer des DataFrames pour Leaflet
create_dataframe <- function(excess, mean_data) {
  data.frame(
    lon = lon[excess[,1]],
    lat = lat[excess[,2]],
    concentration = mean_data[excess]
  )
}

df_nitrate <- create_dataframe(nitrate_excess, nitrate_mean)
df_phosphate <- create_dataframe(phosphate_excess, phosphate_mean)
df_chlorophylle <- create_dataframe(chlorophylle_excess, chlorophylle_mean)
df_oxygene <- create_dataframe(oxygene_hypoxie, oxygene_mean)  # Zones d'hypoxie

# Supprimer les valeurs NA des concentrations avant de créer les palettes
df_nitrate <- df_nitrate %>% filter(!is.na(concentration))
df_phosphate <- df_phosphate %>% filter(!is.na(concentration))
df_chlorophylle <- df_chlorophylle %>% filter(!is.na(concentration))
df_oxygene <- df_oxygene %>% filter(!is.na(concentration))

# Création des palettes après nettoyage
palettes <- list(
  nitrate = colorNumeric(palette = "Reds", domain = df_nitrate$concentration),
  phosphate = colorNumeric(palette = "Blues", domain = df_phosphate$concentration),
  chlorophylle = colorNumeric(palette = "Greens", domain = df_chlorophylle$concentration),
  oxygene = colorNumeric(palette = "Purples", domain = df_oxygene$concentration)
)

# Déterminer les limites de la carte
lon_min <- min(lon, na.rm = TRUE)
lon_max <- max(lon, na.rm = TRUE)
lat_min <- min(lat, na.rm = TRUE)
lat_max <- max(lat, na.rm = TRUE)

# Création de la carte interactive avec légendes dynamiques
m <- leaflet() %>%
  addTiles() %>%
  
  # Ajouter les points pour chaque variable
  addCircleMarkers(data = df_nitrate, ~lon, ~lat, color = ~palettes$nitrate(concentration), radius = 5, fillOpacity = 0.8, group = "Excès de Nitrate", popup = ~paste("Nitrate:", round(concentration, 2), "mg/L")) %>%
  addCircleMarkers(data = df_phosphate, ~lon, ~lat, color = ~palettes$phosphate(concentration), radius = 5, fillOpacity = 0.8, group = "Excès de Phosphate", popup = ~paste("Phosphate:", round(concentration, 2), "mg/L")) %>%
  addCircleMarkers(data = df_chlorophylle, ~lon, ~lat, color = ~palettes$chlorophylle(concentration), radius = 5, fillOpacity = 0.8, group = "Excès de Chlorophylle", popup = ~paste("Chlorophylle:", round(concentration, 2), "mg/m³")) %>%
  addCircleMarkers(data = df_oxygene, ~lon, ~lat, color = ~palettes$oxygene(concentration), radius = 5, fillOpacity = 0.8, group = "Zones Hypoxiques", popup = ~paste("Oxygène:", round(concentration, 2), "mmol/m³")) %>%
  
  # Ajouter le contrôle des couches avec les légendes
  addLayersControl(
    overlayGroups = c("Excès de Nitrate", "Excès de Phosphate", "Excès de Chlorophylle", "Zones Hypoxiques"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  
  # Ajouter des légendes dynamiques pour chaque groupe de couches
  addLegend("bottomleft", pal = palettes$nitrate, values = df_nitrate$concentration, title = "Nitrate (mg/L)", opacity = 1, group = "Excès de Nitrate") %>%
  addLegend("bottomleft", pal = palettes$phosphate, values = df_phosphate$concentration, title = "Phosphate (mg/L)", opacity = 1, group = "Excès de Phosphate") %>%
  addLegend("bottomleft", pal = palettes$chlorophylle, values = df_chlorophylle$concentration, title = "Chlorophylle (mg/m³)", opacity = 1, group = "Excès de Chlorophylle") %>%
  addLegend("bottomleft", pal = palettes$oxygene, values = df_oxygene$concentration, title = "Oxygène (mmol/m³)", opacity = 1, group = "Zones Hypoxiques") %>%
  
  # Ajuster la carte pour correspondre à la zone géographique des données
  fitBounds(lon_min, lat_min, lon_max, lat_max)

# Sauvegarde de la carte interactive dans un fichier HTML
saveWidget(m, file = "carte_eutrophisation.html", selfcontained = TRUE)

# Affichage dans RStudio Viewer
m

