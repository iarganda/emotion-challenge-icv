%CREATETRAININGMAT creates a Matlab cellarray to store the training data.
% [faces] = createTrainingMat( TRAININGFILENAME, IMAGESPATH, EXTENSION )
% returns a cellarray containing one cell per training image. Each cell
% stores the file name, path, sample number, photo number, label, dominant
% emotion (label2) and secondary emotion (label1). The list of images is
% given in a file defined by TRAININGFILENAME, which references the images
% contained in the folder IMAGESPATH. All images have extension EXTENSION.
%
% Example:
%        [faces] = createTrainingMat( 'training.txt',
%        '/home/iarganda/data/emotion-challenge/Faces/Training/', 'JPG' );
%
% Author: Ignacio Arganda-Carreras (ignacio.arganda@ehu.eus)
% License: GPL-3.
function [faces] = createTrainingMat( trainingFileName, imagesPath, extension )

% read training labels
fileID = fopen( trainingFileName );
labels = textscan( fileID,'%s' );
fclose(fileID);

imageList = dir( strcat( imagesPath, '*', extension ) );

faces = cell( length( imageList ), 1 );

for j=1:length( imageList )   
   
    P = imageList(j).name;
   
    k = strfind( P, '_' ); 
    k2 = strfind( P, '.' ); 
    
    faces{j}.sample = P(k(1)+1:k(2)-1);
    faces{j}.photo = P(k(2)+1:k2-1);
    aux = labels{ 1 }( j );
    faces{j}.label = aux{1};
    faces{j}.filename = imageList(j).name;
    faces{j}.path = imagesPath;
    
    faces{j}.label1 = faces{j}.label(1);
    faces{j}.label2 = faces{j}.label(3);
   
end