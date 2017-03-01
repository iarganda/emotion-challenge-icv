%CREATEVALIDATIONMAT creates a Matlab cellarray to store the validation data.
% [faces] = createValidationMat( VALIDATIONFILENAME, IMAGESPATH, EXTENSION )
% returns a cellarray containing one cell per training image. Each cell
% stores the file name, path, sample number and photo number. The list of
% images is given in a file defined by VALICATIONFILENAME, which references
% the images contained in the folder IMAGESPATH.
%
% Example:
%        [faces] = createValidationMat( 'order_of_validation.txt',
%        '/home/iarganda/data/emotion-challenge/Faces/Validation/');
%
% Author: Ignacio Arganda-Carreras (ignacio.arganda@ehu.eus)
% License: GPL-3.
function [faces] = createValidationMat( validationFileName, imagesPath)

fileID = fopen( validationFileName );
valNames = textscan(fileID,'%s');
fclose(fileID);
valNames = valNames{1};

faces = cell( length( valNames ), 1 );

for j=1:length( valNames )
   
    P = valNames{j};
   
    k = strfind( P, '_' ); 
    k2 = strfind( P, '.' ); 
    
    faces{j}.sample = P(k(1)+1:k(2)-1);
    faces{j}.photo = P(k(2)+1:k2-1);

    faces{j}.filename = P;
    faces{j}.path = imagesPath;
   
end