%%
clear; close all; clc;
addpath D:\Documents\m_map
%cd D:\Documents\m_map

%% Nitrate
% Charger les données
ncdisp('Chemical_data_2020_superGG.nc')

no3 = ncread('Chemical_data_2020_superGG.nc', 'no3');                                                                                                                               
lon = ncread('Chemical_data_2020_superGG.nc', 'longitude');
lat = ncread('Chemical_data_2020_superGG.nc', 'latitude');
time = ncread('Chemical_data_2020_superGG.nc', 'time');
cmin=0;
cmax=7;
cint=1;
[X, Y] = meshgrid(lon, lat);
nit = squeeze(no3(:,:,1:12));
nit_mean = squeeze(nanmean(nit,3));

% Animation des Cartes Temporelles
figure(1);
m_proj('miller', 'lat', [-31 33], 'lon', [-22 25]);
hold on;

        % Tracer les continents 
m_gshhs_h('patch', [0.8 0.8 0.8]); % Terre en gris clair
m_coast('line', 'color', 'k', 'linewidth', 2); % Contour noir

  % Ajouter la grille et améliorer l'affichage
m_grid('box','on','tickdir','in','xtick',(-22:7:25),'ytick',...
(-31:7:33),'fontsize',7,'fontweight','bold');
axis equal tight

colormap(jet);
hold on;

% Initialiser l'enregistrement vidéo
videoFile = 'NO3_Animation.mp4';
v = VideoWriter(videoFile, 'MPEG-4');
v.FrameRate = 1; % Modifier selon la vitesse souhaitée
open(v);

 for t = 1:size(no3,4)
     
     % Tracer les frontières des pays 
g_w = shaperead('countries.shp');
 for k = 1:length(g_w)
    long = g_w(k).X;
    lati = g_w(k).Y;
    m_line(long, lati, 'color', 'k', 'LineWidth', 1);
 end

     m_pcolor(lon, lat, squeeze(no3(:,:,t))');



         % Ajouter une barre de couleur avec un titre
         
 cb=colorbar('xtick',cmin:cint:cmax,'xticklabel',cmin:cint:cmax);
 caxis([cmin cmax])
set(get(cb, 'label'), 'string', 'mmol/m^3', 'FontSize', 12, ...
    'FontName', 'Times New Roman', 'FontWeight', 'Bold'); 
xlabel('Longitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
ylabel('Latitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
        title(['Concentration of NO3 - Month ', num2str(t)]);
        
            % Capturer et enregistrer le frame
    frame = getframe(gcf);
    writeVideo(v, frame);
    
    pause(.1);
   delete title 
 end

 hold on;
title('NITRATE ','FontSize',13,'FontName','Times News Roman',...
'FontWeight','Bold')

% Fermer l'enregistrement vidéo
close(v);

disp(['Vidéo enregistrée sous : ', videoFile]);
%% Chlorophyll
% Charger les données

chl = ncread('Chemical_data_2020_superGG.nc', 'chl');
cmin=0.0;
cmax=1.0;
cint=0.2;
%[X, Y] = meshgrid(lon, lat);
Chlo = squeeze(chl(:,:,1:12));
Chlo_mean = squeeze(nanmean(Chlo,3));

% Animation des Cartes Temporelles
figure(2);
m_proj('miller', 'lat', [-31 33], 'lon', [-22 25]);
hold on;

        % Tracer les continents 
m_gshhs_h('patch', [0.8 0.8 0.8]); % Terre en gris clair
m_coast('line', 'color', 'k', 'linewidth', 2); % Contour noir

% Ajouter la grille et améliorer l'affichage
m_grid('box','on','tickdir','in','xtick',(-22:7:25),'ytick',...
(-31:7:33),'fontsize',7,'fontweight','bold');
axis equal tight

colormap(jet);
hold on;

% Initialiser l'enregistrement vidéo
videoFile = 'CHL_Animation.mp4';
v = VideoWriter(videoFile, 'MPEG-4');
v.FrameRate = 1; % Modifier selon la vitesse souhaitée
open(v);

 for t = 1:size(chl,4)
     
     % Tracer les frontières des pays 
g_w = shaperead('countries.shp');
 for k = 1:length(g_w)
    long = g_w(k).X;
    lati = g_w(k).Y;
    m_line(long, lati, 'color', 'k', 'LineWidth', 1);
 end
     m_pcolor(lon, lat, squeeze(chl(:,:,t))');

         % Ajouter une barre de couleur avec un titre
 cb=colorbar('xtick',cmin:cint:cmax,'xticklabel',cmin:cint:cmax);
 caxis([cmin cmax])
set(get(cb, 'label'), 'string', 'mg/m^3', 'FontSize', 12, ...
    'FontName', 'Times New Roman', 'FontWeight', 'Bold'); 
xlabel('Longitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
ylabel('Latitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
        title(['Concentration of CHL - Month ', num2str(t)]);
            
    % Capturer et enregistrer le frame
    frame = getframe(gcf);
    writeVideo(v, frame);
    
        pause(.1);
   delete title 
 end

 hold on;
title('Chlorophyll ','FontSize',13,'FontName','Times News Roman',...
'FontWeight','Bold')

% Fermer l'enregistrement vidéo
close(v);

disp(['Vidéo enregistrée sous : ', videoFile]);
%% Phosphate
% Charger les données

po4 = ncread('Chemical_data_2020_superGG.nc', 'po4');
cmin=0.0;
cmax=1.0;
cint=0.2;
%[X, Y] = meshgrid(lon, lat);
PO4 = squeeze(po4(:,:,1:12));
PO4_mean = squeeze(nanmean(PO4,3));

% Animation des Cartes Temporelles
figure(3);
m_proj('miller', 'lat', [-31 33], 'lon', [-22 25]);
hold on;

        % Tracer les continents 
m_gshhs_h('patch', [0.8 0.8 0.8]); % Terre en gris clair
m_coast('line', 'color', 'k', 'linewidth', 2); % Contour noir

% Ajouter la grille et améliorer l'affichage
m_grid('box','on','tickdir','in','xtick',(-22:7:25),'ytick',...
(-31:7:33),'fontsize',7,'fontweight','bold');
axis equal tight

colormap(jet);
hold on;
    
% Initialiser l'enregistrement vidéo
videoFile = 'PO4_Animation.mp4';
v = VideoWriter(videoFile, 'MPEG-4');
v.FrameRate = 1; % Modifier selon la vitesse souhaitée
open(v);

 for t = 1:size(po4,4)
     
     % Tracer les frontières des pays 
g_w = shaperead('countries.shp');
 for k = 1:length(g_w)
    long = g_w(k).X;
    lati = g_w(k).Y;
    m_line(long, lati, 'color', 'k', 'LineWidth', 1);
 end
     m_pcolor(lon, lat, squeeze(po4(:,:,t))');

         % Ajouter une barre de couleur avec un titre
  cb=colorbar('xtick',cmin:cint:cmax,'xticklabel',cmin:cint:cmax);
 caxis([cmin cmax])
set(get(cb, 'label'), 'string', 'mmol/m^3', 'FontSize', 12, ...
    'FontName', 'Times New Roman', 'FontWeight', 'Bold'); 
xlabel('Longitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
ylabel('Latitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
        title(['Concentration of po4 - Month ', num2str(t)]);
            
    % Capturer et enregistrer le frame
    frame = getframe(gcf);
    writeVideo(v, frame);
    
        pause(.1);
 delete title 
 end

 hold on;
title('Phosphate ','FontSize',13,'FontName','Times News Roman',...
'FontWeight','Bold')

% Fermer l'enregistrement vidéo
close(v);

disp(['Vidéo enregistrée sous : ', videoFile]);
%% Silicate
% Charger les données

si = ncread('Chemical_data_2020_superGG.nc', 'si');
cmin=0;
cmax=8;
cint=1;
%[X, Y] = meshgrid(lon, lat);
Si= squeeze(si(:,:,1:12));
Si_mean = squeeze(nanmean(Si,3));

% Animation des Cartes Temporelles
figure(4);
m_proj('miller', 'lat', [-31 33], 'lon', [-22 25]);
hold on;

        % Tracer les continents 
m_gshhs_h('patch', [0.8 0.8 0.8]); % Terre en gris clair
m_coast('line', 'color', 'k', 'linewidth', 2); % Contour noir

% Ajouter la grille et améliorer l'affichage
m_grid('box','on','tickdir','in','xtick',(-22:7:25),'ytick',...
(-31:7:33),'fontsize',7,'fontweight','bold');
axis equal tight

colormap(jet);
hold on;
    
% Initialiser l'enregistrement vidéo
videoFile = 'SI_Animation.mp4';
v = VideoWriter(videoFile, 'MPEG-4');
v.FrameRate = 1; % Modifier selon la vitesse souhaitée
open(v);

 for t = 1:size(po4,4)
     
     % Tracer les frontières des pays 
g_w = shaperead('countries.shp');
 for k = 1:length(g_w)
    long = g_w(k).X;
    lati = g_w(k).Y;
    m_line(long, lati, 'color', 'k', 'LineWidth', 1);
 end
     m_pcolor(lon, lat, squeeze(si(:,:,t))');

         % Ajouter une barre de couleur avec un titre
 
   cb=colorbar('xtick',cmin:cint:cmax,'xticklabel',cmin:cint:cmax);
 caxis([cmin cmax])
set(get(cb, 'label'), 'string', 'mmol/m^3', 'FontSize', 12, ...
    'FontName', 'Times New Roman', 'FontWeight', 'Bold'); 
xlabel('Longitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
ylabel('Latitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
        title(['Concentration of Si - Month ', num2str(t)]);
     
    % Capturer et enregistrer le frame
    frame = getframe(gcf);
    writeVideo(v, frame);
           
        pause(.1);
        delete title  
 end

 hold on;
title('Silicate ','FontSize',13,'FontName','Times News Roman',...
'FontWeight','Bold')

% Fermer l'enregistrement vidéo
close(v);

disp(['Vidéo enregistrée sous : ', videoFile]);
%% Oxygen
% Charger les données

 o2 = ncread('Chemical_data_2020_superGG.nc', 'o2');
cmin=210;
cmax=270;
cint=10;
O2= squeeze(o2(:,:,1:12));
O2_mean = squeeze(nanmean(O2,3));

% Animation des Cartes Temporelles
figure(5);
m_proj('miller', 'lat', [-31 33], 'lon', [-22 25]);
hold on;

        % Tracer les continents 
m_gshhs_h('patch', [0.8 0.8 0.8]); % Terre en gris clair
m_coast('line', 'color', 'k', 'linewidth', 2); % Contour noir

% Ajouter la grille et améliorer l'affichage
m_grid('box','on','tickdir','in','xtick',(-22:7:25),'ytick',...
(-31:7:33),'fontsize',7,'fontweight','bold');
axis equal tight

colormap(jet);
hold on;
    
% Initialiser l'enregistrement vidéo
videoFile = 'O2_Animation.mp4';
v = VideoWriter(videoFile, 'MPEG-4');
v.FrameRate = 1; % Modifier selon la vitesse souhaitée
open(v);

 for t = 1:size(o2,4)
     
     % Tracer les frontières des pays 
g_w = shaperead('countries.shp');
 for k = 1:length(g_w)
    long = g_w(k).X;
    lati = g_w(k).Y;
    m_line(long, lati, 'color', 'k', 'LineWidth', 1);
 end
     m_pcolor(lon, lat, squeeze(o2(:,:,t))');

         % Ajouter une barre de couleur avec un titre
 
   cb=colorbar('xtick',cmin:cint:cmax,'xticklabel',cmin:cint:cmax);
 caxis([cmin cmax])
set(get(cb, 'label'), 'string', 'mmol/m^3', 'FontSize', 12, ...
    'FontName', 'Times New Roman', 'FontWeight', 'Bold'); 
xlabel('Longitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
ylabel('Latitude', 'FontSize', 13, 'FontName', 'Times New Roman', 'FontWeight', 'Bold');
        title(['Concentration of o2 - Month ', num2str(t)]);
            
    % Capturer et enregistrer le frame
    frame = getframe(gcf);
    writeVideo(v, frame);
    
        pause(.1);
        delete title  
 end

 hold on;
title('Oxygen','FontSize',13,'FontName','Times News Roman',...
'FontWeight','Bold')

% Fermer l'enregistrement vidéo
close(v);

disp(['Vidéo enregistrée sous : ', videoFile]);