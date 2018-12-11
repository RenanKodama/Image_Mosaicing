# Universidade Federal do Paraná
### Visão Computacional - Image Mosaicing using RANSAC to Robustly Estimate Homographies

##### Objetivo
    O objetivo deste trabalho é desenvolver um algoritmo que receba um conjunto de imagens, para 
    gerar um mosaico (panorâmica) de imagens semelhantes. Na qual, este mosaico é composto por 
    combinações de várias imagens semelhantes, entretanto com pontos focais distintos. Após a 
    execução do código, é gerado uma única imagem maior e completa, contendo a melhor combinação das 
    imagens de uma mesma cena. Para isto é necessário estimar uma matriz de homografia que relaciona 
    os pontos das imagens entre os planos, por meio das correspondências geradas pelas funções SIFT e 
    RANSAC.

### Ferrmanetas
    Octave (statistics, vlfeat)

### Compilação
    Defina como diretório principal, a pasta "Image_Mosaicing/code". Após isso, certifique-se de 
    adicionar o caminho dos arquivos .bin para o vlfeat, pelo comando addpath(""). Para executar 
    o código, basta iniciar o arquivo "Image_Mosaicing/code/proj5.m".
