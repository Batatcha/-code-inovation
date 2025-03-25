#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 25 00:05:20 2025

@author: fred
"""

# Packages 
import xarray as xr
import pandas as pd 
import numpy as np 
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
# Donnée
data = xr.open_dataset('/home/fred/Bureau/HACKATON Sea lab /chemical2020.nc')
print(data)

# Dimension et variables 
lon = data['longitude']
lat = data['latitude']
no3 = data['no3']
o2 = data['o2']
po4 = data['po4']
si = data['si']
chl = data['chl']

# Moyene - suivi de suppression de la dim 1x1(depth)
no3_sq = np.squeeze(no3, axis=1)
no3_mean = no3_sq.mean(dim='time')

o2_sq = np.squeeze(o2, axis=1)
o2_mean = o2_sq.mean(dim='time')

po4_sq = np.squeeze(po4, axis=1)
po4_mean = po4_sq.mean(dim='time')

si_sq = np.squeeze(si, axis=1)
si_mean = si_sq.mean(dim='time')

chl_sq = np.squeeze(chl, axis=1)
chl_mean = chl_sq.mean(dim='time')


# Cartes 
fig, axes = plt.subplots(nrows=2, ncols=2,figsize = (14,13))
# premier
m = Basemap(projection = 'merc',
            llcrnrlon = -22,
            llcrnrlat = -33,
            urcrnrlon = 25,
            urcrnrlat = 31,
            resolution = 'i', ax = axes[0,0])

# tracé les éléments de la carte
m.drawcoastlines(linewidth = 1.5, linestyle = 'solid', color = 'k')
m.fillcontinents()
m.drawcountries(linewidth = 1.5, linestyle = 'solid', color = 'k')
m.drawmapboundary(color = 'k', linewidth=0.5)
m.drawmeridians(range(-22,20,8), labels=[1,1,0,0], fontsize = 20)
m.drawparallels(range(-33,31,8), labels = [1,0,0,0], fontsize= 20)
#m.drawmapboundary(fill_color = '0.2')
m.drawrivers(linewidth = 0.5, color = 'b')
# convertion des donnee et traçage des donnee
x, y = m(*np.meshgrid(lon,lat))
vmin, vmax = 0, 7
c_scheme= m.pcolor(x, y, no3_mean, cmap = plt.cm.jet, shading = 'auto',
                   vmin=vmin, vmax=vmax)
# barre de couleur
cbar = m.colorbar(c_scheme, location = 'right', pad = '2%')
cbar.set_label('mmol/m3',fontsize = 20, fontweight = 'bold', color = 'black')
cbar.ax.tick_params(labelsize = 25)
for label in cbar.ax.get_yticklabels():
    label.set_fontweight('bold')

# titre
axes[0,0].set_title("NO3 2020", fontdict={'fontsize': 24, 'weight': 'bold'})
#axes[0,0].set_ylabel('Latitude',fontweight = 'bold', fontsize = 24,color = 'black')

# Deuxième
m = Basemap(projection = 'merc',
            llcrnrlon = -22,
            llcrnrlat = -33,
            urcrnrlon = 25,
            urcrnrlat = 31,
            resolution = 'i', ax = axes[0,1])

# tracé les éléments de la carte
m.drawcoastlines(linewidth = 1.5, linestyle = 'solid', color = 'k')
m.fillcontinents()
m.drawcountries(linewidth = 1.5, linestyle = 'solid', color = 'k')
m.drawmapboundary(color = 'k', linewidth=0.5)
m.drawmeridians(range(-22,20,8), labels=[1,1,0,0], fontsize = 20)
m.drawparallels(range(-33,31,8), labels = [0,0,0,0], fontsize= 20)
#m.drawmapboundary(fill_color = '0.2')
m.drawrivers(linewidth = 0.5, color = 'b')
# convertion des donnee et traçage des donnee
x, y = m(*np.meshgrid(lon,lat))
vmin, vmax = 0, 1
c_scheme= m.pcolor(x, y, po4_mean, cmap = plt.cm.jet, shading = 'auto',
                   vmin=vmin, vmax=vmax)
# barre de couleur
cbar = m.colorbar(c_scheme, location = 'right', pad = '2%')
cbar.set_label('mmol/m3',fontsize = 20, fontweight = 'bold', color = 'black')
cbar.ax.tick_params(labelsize = 25)
for label in cbar.ax.get_yticklabels():
    label.set_fontweight('bold')

# titre
axes[0,1].set_title("PO4 2020", fontdict={'fontsize': 24, 'weight': 'bold'})

# Troisième
m = Basemap(projection = 'merc',
            llcrnrlon = -22,
            llcrnrlat = -33,
            urcrnrlon = 25,
            urcrnrlat = 31,
            resolution = 'i', ax = axes[1,0])

# tracé les éléments de la carte
m.drawcoastlines(linewidth = 1.5, linestyle = 'solid', color = 'k')
m.fillcontinents()
m.drawcountries(linewidth = 1.5, linestyle = 'solid', color = 'k')
m.drawmapboundary(color = 'k', linewidth=0.5)
m.drawmeridians(range(-22,20,8), labels=[1,0,0,1], fontsize = 20)
m.drawparallels(range(-33,31,8), labels = [1,0,0,1], fontsize= 20)
#m.drawmapboundary(fill_color = '0.2')
m.drawrivers(linewidth = 0.5, color = 'b')
# convertion des donnee et traçage des donnee
x, y = m(*np.meshgrid(lon,lat))
vmin, vmax = 0, 8
c_scheme= m.pcolor(x, y, si_mean, cmap = plt.cm.jet, shading = 'auto',
                   vmin=vmin, vmax=vmax)
# barre de couleur
cbar = m.colorbar(c_scheme, location = 'right', pad = '2%')
cbar.set_label('mmol/m3',fontsize = 20, fontweight = 'bold', color = 'black')
cbar.ax.tick_params(labelsize = 25)
for label in cbar.ax.get_yticklabels():
    label.set_fontweight('bold')

# titre
axes[1,0].set_title("SI 2020", fontdict={'fontsize': 24, 'weight': 'bold'})
#axes[1,0].set_xlabel('Longitude',fontweight = 'bold', fontsize = 24,color = 'black')
#axes[1,0].set_ylabel('Latitude',fontweight = 'bold', fontsize = 24,color = 'black')

# Quatrième
m = Basemap(projection = 'merc',
            llcrnrlon = -22,
            llcrnrlat = -33,
            urcrnrlon = 25,
            urcrnrlat = 31,
            resolution = 'i', ax = axes[1,1])

# tracé les éléments de la carte
m.drawcoastlines(linewidth = 1.5, linestyle = 'solid', color = 'k')
m.fillcontinents()
m.drawcountries(linewidth = 1.5, linestyle = 'solid', color = 'k')
m.drawmapboundary(color = 'k', linewidth=0.5)
m.drawmeridians(range(-22,20,8), labels=[1,0,0,1], fontsize = 20)
m.drawparallels(range(-33,31,8), labels = [0,0,0,0], fontsize= 20)
#m.drawmapboundary(fill_color = '0.2')
m.drawrivers(linewidth = 0.5, color = 'b')
# convertion des donnee et traçage des donnee
x, y = m(*np.meshgrid(lon,lat))
vmin, vmax = 0, 1
c_scheme= m.pcolor(x, y, chl_mean, cmap = plt.cm.jet, shading = 'auto',
                   vmin=vmin, vmax=vmax)
# barre de couleur
cbar = m.colorbar(c_scheme, location = 'right', pad = '2%')
cbar.set_label('mg/m3',fontsize = 20, fontweight = 'bold', color = 'black')
cbar.ax.tick_params(labelsize = 25)
for label in cbar.ax.get_yticklabels():
    label.set_fontweight('bold')

# titre
axes[1,1].set_title("CHL 2020", fontdict={'fontsize': 24, 'weight': 'bold'})
#axes[1,1].set_xlabel('Longitude',fontweight = 'bold', fontsize = 24,color = 'black')

# sauver
output_path = '/home/fred/Bureau/HACKATON Sea lab /Figures/No3_Po4_Si_Chl-2020.png'
plt.tight_layout()
plt.savefig(output_path, dpi = 500, bbox_inches = 'tight')
