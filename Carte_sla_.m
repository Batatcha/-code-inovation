%%
clear; close all; clc;
addpath D:\Documents\m_map
%cd D:\Documents\m_map

%% Nitrate
% Charger les données
ncdisp('Monthly maps of Absolute Sea Level data-2020.nc')

sla = ncread('Monthly maps of Absolute Sea Level data-2020.nc', 'sla');                                                                                                                                
lon = ncread('Monthly maps of Absolute Sea Level data-2020.nc', 'longitude');
lat = ncread('Monthly maps of Absolute Sea Level data-2020.nc', 'latitude');
time = ncread('Monthly maps of Absolute Sea Level data-2020.nc', 'time');
cmin=0;
cmax=0.15;
cint=0.02;
[X, Y] = meshgrid(lon, lat);
Sla = squeeze(sla(:,:,1:12));
Sla_mean = squeeze(nanmean(Sla,3));

% Animation des Cartes Temporelles
figure(1);
m_proj('miller', 'lat', [-33 31], 'lon', [-22 25]);
hold on;

% Tracer les continents 
m_gshhs_h('patch', [0.8 0.8 0.8]); % Terre en gris clair
m_coast('line', 'color', 'k', 'linewidth', 2); % Contour noir

% Ajouter la grille et améliorer l'affichage
m_grid('box','on','tickdir','in','xtick',(-22:7:25),'ytick',...
(-33:7:31),'fontsize',7,'fontweight','bold');
axis equal tight

colormap(jet);
hold on;
    
% Initialiser l'enregistrement vidéo
videoFile = 'sla_Animation.mp4';
v = VideoWriter(videoFile, 'MPEG-4');
v.FrameRate = 1; % Modifier selon la vitesse souhaitée
open(v);

for t = 1:size(sla,3)

    % Tracer les frontières des pays 
    g_w = shaperead('countries.shp');
    for k = 1:length(g_w)
        long = g_w(k).X;
        lati = g_w(k).Y;
        m_line(long, lati, 'color', 'k', 'LineWidth', 1);
    end

    m_pcolor(lon, lat, squeeze(sla(:,:,t))');

    % Ajouter une barre de couleur avec un titre
    cb = colorbar('xtick', cmin:cint:cmax,'xticklabel' ,cmin:cint:cmax);
    caxis([cmin cmax]);
    set(get(cb, 'label'), 'string', 'm', 'FontSize', 12, ...
        'FontName', 'Times New Roman', 'FontWeight', 'Bold');
    xlabel('Longitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
    ylabel('Latitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
    title(['Concentration of sla - Month ', num2str(t)]);
    
    % Capturer et enregistrer le frame
    frame = getframe(gcf);
    writeVideo(v, frame);
    
    pause(0.1);
        delete title 
end

% Ajouter le titre final
hold on;
title('SEA LEVEL 2020', 'FontSize', 13, 'FontName', 'Times News Roman', 'FontWeight', 'Bold');

% Fermer l'enregistrement vidéo
close(v);

disp(['Vidéo enregistrée sous : ', videoFile]);