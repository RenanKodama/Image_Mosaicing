function [H, inlier_ind] = ransac_est_homography(y1, x1, y2, x2, thresh, iter, im1, im2, verbose)
% RANSAC_EST_HOMOGRAPHY estimates the homography between two corresponding
% feature points through RANSAC. im2 is the source and im1 is the destination.

% INPUT
% y1,x1,y2,x2 = corresponding point coordinate vectors Nx1
% thresh      = threshold on distance to see if transformed points agree
% iter        = iteration number for multiple image stitching
% im1, im2    = images

% OUTPUT
% H           = the 3x3 matrix computed in final step of RANSAC
% inlier_ind  = nx1 vector with indices of points that were inliers


% original feature matches

if nargin < 9
   verbose = false; 
end

#Inicializacao das variaveis
N = size(y1, 1);  #Variavel para gerar pontos aleatorios
iteracoes = 1000; #Numero de iteracoes
score = zeros(iteracoes, 1); #Vetor para guardar os scores
possiveisPontos = cell(iteracoes, 1); #Armazenar a a diferenca das distancias
homografias = cell(iteracoes, 1);     #Armazenar as homografias estimadas

#Init iteration
for t = 1 : iteracoes
    # Selecionar aleatoriamente os pontos 
    subsets = randperm(N, 4);
    
    #Estimar Homografia
    homografias{t} = est_homography(x1(subsets),y1(subsets),x2(subsets),y2(subsets));
    
    #Aplicando a Homografia 
    [x1Est, y1Est] = apply_homography(homografias{t}, x2, y2);
    
    #calcula a diferença das distancias ao quadrado, se for menor que o tresh, armazena no vetor inliers
    possiveisPontos{t} = ((x1 - x1Est).^2 + (y1 - y1Est).^2) <= thresh^2;
    
    #calcula a soma de quantidade de matches no inlier
    score(t) = sum(possiveisPontos{t}) ;
end

#Selecionar o melhor Score(Matches inLaier)
[~, best]  = max(score);
possiveisPontos = possiveisPontos{best};
inlier_ind = find(possiveisPontos)';
homografias = est_homography(x1(possiveisPontos),y1(possiveisPontos),x2(possiveisPontos),y2(possiveisPontos));
H = homografias;

#Plot the verbose details
if ~verbose
    return
end

dh1 = max(size(im2,1)-size(im1,1),0);
dh2 = max(size(im1,1)-size(im2,1),0);

h = figure(1); 

#Combinacoes originais
subplot(2,1,1);
imshow([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]);
delta = size(im1,2);
line([x1'; x2' + delta], [y1'; y2']);
title(sprintf('%d Original matches', N));
axis image off;

#Pontos InLaier
subplot(2,1,2);
imshow([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]);
delta = size(im1,2);
line([x1(inlier_ind)'; x2(inlier_ind)' + delta], [y1(inlier_ind)'; y2(inlier_ind)']);
title(sprintf('%d (%.2f%%) inliner matches out of %d', sum(possiveisPontos), 100*sum(possiveisPontos)/N, N));
axis image off;
drawnow;

#Salvar figuras
p = mfilename('fullpath');
funcDir = fileparts(p);
outputDir = fullfile(funcDir, '/results');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
fileString = fullfile(outputDir, ['matches', num2str(iter,'%02d')]);
fig_save(h, fileString, 'png');
end
