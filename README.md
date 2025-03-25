# -code-inovation
Creation of an interactive map for detecting potential areas with excess nutrients that could cause eutrophication




# Install libraries if necessary

df_nitrate <- create_dataframe(nitrate_excess, nitrate_mean)
df_phosphate <- create_dataframe(phosphate_excess, phosphate_mean)
df_chlorophylle <- create_dataframe(chlorophylle_excess, chlorophylle_mean)
df_oxygene <- create_dataframe(oxygene_hypoxie, oxygene_mean)  # Hypoxia zones

# Remove NA values from concentrations before creating palettes
df_nitrate <- df_nitrate %>% filter(!is.na(concentration))
df_phosphate <- df_phosphate %>% filter(!is.na(concentration))
df_chlorophylle <- df_chlorophylle %>% filter(!is.na(concentration))
df_oxygene <- df_oxygene %>% filter(!is.na(concentration))

# Creating palettes after cleaning
palettes <- list(
  nitrate = colorNumeric(palette = "Reds", domain = df_nitrate$concentration),
  phosphate = colorNumeric(palette = "Blues", domain = df_phosphate$concentration),
  chlorophylle = colorNumeric(palette = "Greens", domain = df_chlorophylle$concentration),
  oxygene = colorNumeric(palette = "Purples", domain = df_oxygene$concentration)
)

# Determine map limits
lon_min <- min(lon, na.rm = TRUE)
lon_max <- max(lon, na.rm = TRUE)
lat_min <- min(lat, na.rm = TRUE)
lat_max <- max(lat, na.rm = TRUE)

# Create the interactive map with dynamic legends
m <- leaflet() %>%
  addTiles() %>%
  
  # Add points for each variable
  addCircleMarkers(data = df_nitrate, ~lon, ~lat, color = ~palettes$nitrate(concentration), radius = 5, fillOpacity = 0.8, group = "Nitrate Excess", popup = ~paste("Nitrate:", round(concentration, 2), "mg/L")) %>%
  addCircleMarkers(data = df_phosphate, ~lon, ~lat, color = ~palettes$phosphate(concentration), radius = 5, fillOpacity = 0.8, group = "Phosphate Excess", popup = ~paste("Phosphate:", round(concentration, 2), "mg/L")) %>%
  addCircleMarkers(data = df_chlorophylle, ~lon, ~lat, color = ~palettes$chlorophylle(concentration), radius = 5, fillOpacity = 0.8, group = "Chlorophyll Excess", popup = ~paste("Chlorophyll:", round(concentration, 2), "mg/m³")) %>%
  addCircleMarkers(data = df_oxygene, ~lon, ~lat, color = ~palettes$oxygene(concentration), radius = 5, fillOpacity = 0.8, group = "Hypoxic Zones", popup = ~paste("Oxygen:", round(concentration, 2), "mmol/m³")) %>%
  
  # Add layer control with legends
  addLayersControl(
    overlayGroups = c("Nitrate Excess", "Phosphate Excess", "Chlorophyll Excess", "Hypoxic Zones"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  
  # Add dynamic legends for each layer group
  addLegend("bottomleft", pal = palettes$nitrate, values = df_nitrate$concentration, title = "Nitrate (mg/L)", opacity = 1, group = "Nitrate Excess") %>%
  addLegend("bottomleft", pal = palettes$phosphate, values = df_phosphate$concentration, title = "Phosphate (mg/L)", opacity = 1, group = "Phosphate Excess") %>%
  addLegend("bottomleft", pal = palettes$chlorophylle, values = df_chlorophylle$concentration, title = "Chlorophyll (mg/m³)", opacity = 1, group = "Chlorophyll Excess") %>%
  addLegend("bottomleft", pal = palettes$oxygene, values = df_oxygene$concentration, title = "Oxygen (mmol/m³)", opacity = 1, group = "Hypoxic Zones") %>%
  
  # Adjust the map to match the geographic area of the data
  fitBounds(lon_min, lat_min, lon_max, lat_max)

# Save the interactive map to an HTML file
saveWidget(m, file = "carte_eutrophisation.html", selfcontained = TRUE)

# Display in RStudio Viewer
m

